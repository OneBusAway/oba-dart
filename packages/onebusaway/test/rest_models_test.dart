import 'dart:convert';

import 'package:onebusaway/onebusaway.dart';
import 'package:onebusaway/src/core/json.dart';
import 'package:test/test.dart';

import 'support/fixtures.dart';

DateTime _ms(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

JsonMap _arrival(Map<String, Object?> overrides) => {
  'routeId': 'R',
  'tripId': 'T',
  'serviceDate': 1540278000000,
  'stopId': 'S',
  'stopSequence': 2,
  ...overrides,
};

void main() {
  group('RouteType', () {
    test('maps 0..7 and unknown values', () {
      expect(RouteType.fromValue(0), RouteType.lightRail);
      expect(RouteType.fromValue(4), RouteType.ferry);
      expect(RouteType.fromValue(7), RouteType.funicular);
      expect(RouteType.fromValue(999), RouteType.unknown);
      expect(RouteType.fromValue(715), RouteType.unknown);
      expect(RouteType.fromValue(null), RouteType.unknown);
    });
  });

  group('Stop', () {
    test('location type, wheelchair boarding, direction', () {
      final s = Stop.fromJson({
        'id': 'X',
        'name': 'N',
        'lat': 1,
        'lon': 2,
        'locationType': 1,
        'wheelchairBoarding': 'NOT_ACCESSIBLE',
        'direction': 'ne',
        'parent': '',
      });
      expect(s.locationType, StopLocationType.station);
      expect(s.wheelchairBoardingStatus, WheelchairBoarding.notAccessible);
      expect(s.compassDirection, StopDirection.ne);
      expect(s.parent, isNull);
      expect(
        Stop.fromJson({'id': 'X', 'name': 'N', 'lat': 1, 'lon': 2})
            .locationType,
        StopLocationType.stop,
      );
      expect(
        Stop.fromJson({
          'id': 'X',
          'name': 'N',
          'lat': 1,
          'lon': 2,
          'locationType': 9,
        }).locationType,
        StopLocationType.unknown,
      );
      expect(
        WheelchairBoarding.parse('ACCESSIBLE'),
        WheelchairBoarding.accessible,
      );
      expect(
        WheelchairBoarding.parse('accessible'),
        WheelchairBoarding.accessible,
      );
      expect(StopDirection.parse(''), StopDirection.unknown);
      expect(StopDirection.parse('unknown'), StopDirection.unknown);
    });
  });

  group('ArrivalAndDeparture', () {
    test('predicted time 0 or implausibly early means no prediction', () {
      expect(
        ArrivalAndDeparture.fromJson(_arrival({'predictedArrivalTime': 0}))
            .predictedArrivalTime,
        isNull,
      );
      expect(
        ArrivalAndDeparture.fromJson(_arrival({'predictedDepartureTime': 1000}))
            .predictedDepartureTime,
        isNull,
      );
      expect(
        ArrivalAndDeparture.fromJson(
          _arrival({'predictedArrivalTime': 1540350600000}),
        ).predictedArrivalTime,
        _ms(1540350600000),
      );
    });

    test('occupancy', () {
      final a = ArrivalAndDeparture.fromJson(
        _arrival({
          'occupancyStatus': 'FEW_SEATS_AVAILABLE',
          'historicalOccupancy': '',
        }),
      );
      expect(a.occupancyStatus, OccupancyStatus.fewSeatsAvailable);
      expect(a.historicalOccupancyStatus, OccupancyStatus.unknown);
      expect(OccupancyStatus.parse('SOMETHING_NEW'), OccupancyStatus.unknown);
      expect(OccupancyStatus.parse(null), isNull);
    });

    test('stop position helpers', () {
      final a = ArrivalAndDeparture.fromJson(
        _arrival({'stopSequence': 11, 'totalStopsInTrip': 12}),
      );
      expect(a.isLastStopOnTrip, isTrue);
      expect(a.isDeparture, isFalse);
      expect(
        ArrivalAndDeparture.fromJson(_arrival({'stopSequence': 0})).isDeparture,
        isTrue,
      );
      expect(
        ArrivalAndDeparture.fromJson(_arrival({})).isLastStopOnTrip,
        isNull,
      );
    });
  });

  group('TripStatus', () {
    test('status modifier is case-insensitive', () {
      expect(
        const TripStatus(status: 'canceled').statusModifier,
        TripStatusModifier.canceled,
      );
      expect(
        const TripStatus(status: 'ADDED').statusModifier,
        TripStatusModifier.other,
      );
      expect(const TripStatus().statusModifier, TripStatusModifier.other);
    });
  });

  group('Situation', () {
    test('window timestamps: > 1e10 is ms, otherwise seconds', () {
      final seconds = TimeWindow.fromJson({
        'from': 1474434000,
        'to': 1474646400,
      });
      final ms = TimeWindow.fromJson({
        'from': 1474434000000,
        'to': 1474646400000,
      });
      expect(seconds.from, ms.from);
      expect(seconds.to, ms.to);
      expect(seconds.from, _ms(1474434000000));
    });

    test('open-ended and inverted windows', () {
      final open = TimeWindow.fromJson({'from': 100});
      expect(open.to, isNull);
      expect(open.contains(_ms(1 << 40)), isTrue);
      expect(open.contains(_ms(99000)), isFalse);
      final inverted = TimeWindow(from: _ms(5000), to: _ms(1000));
      expect(inverted.contains(_ms(5000)), isTrue);
      expect(inverted.contains(_ms(6000)), isFalse);
      expect(() => TimeWindow.fromJson({}), throwsA(isA<ObaFormatException>()));
    });

    test('isActiveAt', () {
      const always = Situation(id: 'a');
      expect(always.isActiveAt(_ms(0)), isTrue);
      final windowed = Situation(
        id: 'b',
        activeWindows: [TimeWindow(from: _ms(1000), to: _ms(2000))],
      );
      expect(windowed.isActiveAt(_ms(1500)), isTrue);
      expect(windowed.isActiveAt(_ms(2500)), isFalse);
    });

    test('indexed in References from a real response', () {
      final data =
          (jsonDecode(
                fixture(
                  'arrivals_and_departures_for_stop_mts_11670_route_alerts.json',
                ),
              ) as JsonMap)['data']
              as JsonMap;
      final refs = References.fromJson(data['references'] as JsonMap);
      expect(refs.situations, hasLength(7));
      final alert = refs.situation('MTS_38')!;
      expect(alert.reason, 'CONSTRUCTION');
      expect(alert.severity, isNull); // "" -> null
      expect(alert.summary!.value, contains('Concrete Pour'));
      expect(alert.summary!.lang, 'en');
      expect(
        alert.url!.value,
        'http://www.sdmts.com/Planning/alerts_detours.asp',
      );
      expect(alert.creationTime, _ms(1474527588415));
      expect(alert.allAffects.map((e) => e.routeId), [
        'MTS_11',
        'MTS_901',
        'MTS_929',
      ]);
      expect(alert.consequences.single.condition, 'detour');
      expect(alert.consequences.single.conditionDetails, isNull);
      expect(alert.publicationWindows, isEmpty);
      expect(
        refs.situationsWithIds(['MTS_11', 'nope', 'MTS_38']).map((s) => s.id),
        ['MTS_11', 'MTS_38'],
      );
    });
  });

  test('TripStopTime dates are seconds after the service date', () {
    const st = TripStopTime(
      stopId: 'S',
      arrivalTime: 90000,
      departureTime: 90060,
    );
    final service = _ms(1343631600000);
    expect(st.arrivalDate(service), _ms(1343631600000 + 90000000));
    expect(st.departureDate(service), _ms(1343631600000 + 90060000));
  });

  test('formatServiceDate pads fields', () {
    expect(
      SchedulesResource.formatServiceDate(DateTime(987, 3, 4)),
      '0987-03-04',
    );
  });

  test('References.withStop adds or replaces a stop', () {
    const stop = Stop(id: 'S', name: 'N', lat: 1, lon: 2);
    final refs = References.empty.withStop(stop);
    expect(refs.stop('S'), same(stop));
    expect(References.empty.stops, isEmpty);
  });
}
