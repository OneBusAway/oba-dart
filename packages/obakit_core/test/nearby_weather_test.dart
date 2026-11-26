import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

Stop _stop(String id, double lat, double lon, {String? direction}) =>
    Stop(id: id, name: 'Stop $id', lat: lat, lon: lon, direction: direction);

void main() {
  final now = DateTime.utc(2024, 1, 1, 12);

  group('NearbyDepartures.rows', () {
    final a = _stop('1_1', 47.6, -122.3);
    final b = _stop('1_2', 47.601, -122.3);

    test('a stop without loaded arrivals is a stop row', () {
      final rows = NearbyDepartures.rows(
        stops: [a, b],
        arrivals: {
          'x': [arrival()],
        },
        now: now,
      );
      expect(rows.map((r) => r.runtimeType), [
        NearbyStopOnlyRow,
        NearbyStopOnlyRow,
      ]);
    });

    test('soonest departure per route and headsign, capped per stop', () {
      final rows = NearbyDepartures.rows(
        stops: [a, b],
        arrivals: {
          a.id: [
            arrival(
              tripId: 't2',
              scheduled: now.add(const Duration(minutes: 9)),
            ),
            arrival(
              tripId: 't1',
              scheduled: now.add(const Duration(minutes: 3)),
            ),
            arrival(
              routeId: '1_44',
              routeShortName: '44',
              tripId: 't3',
              scheduled: now.add(const Duration(minutes: 5)),
            ),
            arrival(
              routeId: '1_49',
              routeShortName: '49',
              tripId: 't4',
              scheduled: now.add(const Duration(minutes: 1)),
            ),
            // Gone: never listed.
            arrival(
              routeId: '1_70',
              tripId: 't5',
              scheduled: now.subtract(const Duration(minutes: 2)),
            ),
          ],
          b.id: [
            arrival(
              tripId: 't6',
              scheduled: now.add(const Duration(minutes: 4)),
            ),
          ],
        },
        now: now,
      );
      final departures = rows.cast<NearbyDepartureRow>();
      expect(departures.map((r) => r.arrival.tripId), ['t4', 't1', 't6']);
      expect(departures.last.stop, b);
    });

    test('excluded keys are skipped; nothing leaving lists the stops', () {
      final x = arrival(scheduled: now.add(const Duration(minutes: 2)));
      final rows = NearbyDepartures.rows(
        stops: [a],
        arrivals: {
          a.id: [x],
        },
        now: now,
        excluding: {TripBookmarkKey.fromArrival(x)},
      );
      expect(rows.single, isA<NearbyStopOnlyRow>());
    });

    test('row limit', () {
      final rows = NearbyDepartures.rows(
        stops: [for (var i = 0; i < 6; i++) _stop('s$i', 47.6, -122.3)],
        arrivals: const {},
        now: now,
      );
      expect(rows, hasLength(NearbyDepartures.rowLimit));
    });
  });

  group('groupNearbyStopsByDirection', () {
    test('groups by direction, nearest group first, unknown last', () {
      const center = Coordinate(47.6, -122.3);
      final groups = groupNearbyStopsByDirection([
        _stop('far-n', 47.61, -122.3, direction: 'N'),
        _stop('none', 47.6001, -122.3),
        _stop('near-s', 47.6005, -122.3, direction: 'S'),
        _stop('near-n', 47.602, -122.3, direction: 'N'),
      ], center);
      expect(groups.map((g) => g.direction), [
        StopDirection.s,
        StopDirection.n,
        StopDirection.unknown,
      ]);
      expect(groups[1].stops.map((s) => s.stop.id), ['near-n', 'far-n']);
      expect(groups[0].stops.single.distanceMeters, closeTo(55.6, 1));
    });
  });

  group('weather', () {
    test('conditions from icon keys', () {
      expect(
        WeatherCondition.fromIconKey('partly-cloudy-night'),
        WeatherCondition.partlyCloudy,
      );
      expect(WeatherCondition.fromIconKey('tornado'), WeatherCondition.unknown);
      expect(isNightWeatherIcon('clear-night'), isTrue);
    });

    test('units by locale and source', () {
      expect(
        WeatherUnits.forLocale(languageCode: 'en', countryCode: 'US'),
        const WeatherUnits(TemperatureUnit.fahrenheit, SpeedUnit.milesPerHour),
      );
      expect(
        WeatherUnits.forLocale(languageCode: 'en'),
        const WeatherUnits(TemperatureUnit.fahrenheit, SpeedUnit.milesPerHour),
      );
      expect(
        WeatherUnits.forLocale(languageCode: 'en', countryCode: 'GB'),
        const WeatherUnits(TemperatureUnit.celsius, SpeedUnit.milesPerHour),
      );
      expect(
        WeatherUnits.forLocale(languageCode: 'de', countryCode: 'DE'),
        const WeatherUnits(
          TemperatureUnit.celsius,
          SpeedUnit.kilometersPerHour,
        ),
      );
      expect(
        WeatherUnits.ofSource('us').temperature,
        TemperatureUnit.fahrenheit,
      );
      expect(WeatherUnits.ofSource('si').speed, SpeedUnit.metersPerSecond);
    });

    test('conversions', () {
      expect(
        convertTemperature(
          212,
          from: TemperatureUnit.fahrenheit,
          to: TemperatureUnit.celsius,
        ),
        closeTo(100, 1e-9),
      );
      expect(
        convertSpeed(
          10,
          from: SpeedUnit.metersPerSecond,
          to: SpeedUnit.kilometersPerHour,
        ),
        closeTo(36, 1e-9),
      );
      expect(
        convertSpeed(
          1,
          from: SpeedUnit.milesPerHour,
          to: SpeedUnit.kilometersPerHour,
        ),
        closeTo(1.609344, 1e-9),
      );
    });

    test('upcoming hourly window and high/low', () {
      final forecast = WeatherForecast.fromJson(
        jsonDecode(fixture('pugetsound-weather.json')) as Map<String, dynamic>,
      );
      // 22:30 UTC on the forecast day: the 22:00 hour stays, 21:00 goes.
      final at = DateTime.utc(2018, 10, 17, 22, 30);
      final window = upcomingHourly(forecast.hourlyForecasts, now: at);
      expect(window.first.time, DateTime.utc(2018, 10, 17, 22));
      expect(window, hasLength(lessThanOrEqualTo(24)));
      for (var i = 1; i < window.length; i++) {
        expect(window[i].time.isAfter(window[i - 1].time), isTrue);
      }
      final hl = weatherHighLow(window)!;
      expect(hl.high, greaterThanOrEqualTo(hl.low));
      expect(weatherHighLow(const []), isNull);
    });
  });

  group('WeatherService', () {
    late FakeHttp http;
    late ObacoClient client;

    setUp(() {
      http = FakeHttp({
        'weather.json': (200, fixture('pugetsound-weather.json')),
      });
      client = ObacoClient(
        baseUrl: Uri.parse('https://onebusaway.co'),
        regionId: 1,
        httpClient: http.client,
      );
    });

    test('caches for the ttl and shares in-flight requests', () async {
      var time = DateTime.utc(2024);
      await withClock(Clock(() => time), () async {
        final service = WeatherService(obaco: () => client);
        final results = await Future.wait([service.load(), service.load()]);
        expect(results.first, isNotNull);
        expect(http.requests, hasLength(1));
        await service.load();
        expect(http.requests, hasLength(1));
        time = time.add(const Duration(minutes: 16));
        expect(service.isFresh, isFalse);
        await service.load();
        expect(http.requests, hasLength(2));
      });
    });

    test('failure backs off and keeps the error', () async {
      final failing = FakeHttp({'weather.json': (500, 'boom')});
      final c = ObacoClient(
        baseUrl: Uri.parse('https://onebusaway.co'),
        regionId: 1,
        httpClient: failing.client,
      );
      final service = WeatherService(obaco: () => c);
      expect(await service.load(), isNull);
      expect(service.error, isNotNull);
      await service.load();
      expect(failing.requests, hasLength(1));
      await service.load(force: true);
      expect(failing.requests, hasLength(2));
    });

    test('no server: null and unavailable', () async {
      final service = WeatherService(obaco: () => null);
      expect(service.isAvailable, isFalse);
      expect(await service.load(), isNull);
    });
  });
}
