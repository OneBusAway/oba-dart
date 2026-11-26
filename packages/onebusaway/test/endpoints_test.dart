import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';
import 'package:test/test.dart';

import 'support/fixtures.dart';

/// A client whose every request is recorded in [requests] and answered by
/// [respond] (by default, the fixture [name]).
class _Harness {
  _Harness(String name)
    : this.responding((_) => http.Response(fixture(name), 200));

  _Harness.responding(http.Response Function(http.Request) respond) {
    client = OneBusAwayClient(
      baseUrl: Uri.parse('https://api.example.org/'),
      apiKey: 'k',
      httpClient: MockClient((request) async {
        requests.add(request.url);
        return respond(request);
      }),
    );
  }

  late final OneBusAwayClient client;
  final requests = <Uri>[];

  Uri get url => requests.single;
}

DateTime _ms(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

void main() {
  test('currentTime.get', () async {
    final h = _Harness('current_time.json');
    final r = await h.client.currentTime.get();
    expect(h.url.path, '/api/where/current-time.json');
    expect(h.url.queryParameters, {'key': 'k'});
    expect(r.entry.time, _ms(1343587068277));
    expect(r.entry.readableTime, '2012-07-29T11:37:48-07:00');
  });

  group('stops.forLocation', () {
    test('point + query + clamped radius', () async {
      final h = _Harness('stops_for_location_query.json');
      final r = await h.client.stops.forLocation(
        const Coordinate(47.159439, -122.505051),
        radius: 20000,
        query: '26',
      );
      expect(h.url.path, '/api/where/stops-for-location.json');
      expect(h.url.queryParameters, {
        'key': 'k',
        'lat': '47.159439',
        'lon': '-122.505051',
        'radius': '15000',
        'query': '26',
      });
      final stop = r.list.single;
      expect(stop.id, '3_26');
      expect(stop.locationType, StopLocationType.stop);
      expect(stop.compassDirection, StopDirection.w);
      expect(stop.wheelchairBoardingStatus, WheelchairBoarding.unknown);
      expect(r.references.route('3_204')!.routeType, RouteType.bus);
      expect(r.outOfRange, isFalse);
    });

    test('radius below 1 is clamped to 1; spans are sent as is', () async {
      final h = _Harness('stops_for_location_query.json');
      await h.client.stops.forLocation(const Coordinate(1, 2), radius: 0.2);
      expect(h.url.queryParameters['radius'], '1');

      final h2 = _Harness('stops_for_location_query.json');
      await h2.client.stops.forLocation(
        const Coordinate(47.5, -122.25),
        latSpan: 0.01,
        lonSpan: 0.02,
      );
      expect(h2.url.queryParameters, {
        'key': 'k',
        'lat': '47.5',
        'lon': '-122.25',
        'latSpan': '0.01',
        'lonSpan': '0.02',
      });
    });

    test('out of range', () async {
      final h = _Harness('stops_for_location_outofrange.json');
      final r = await h.client.stops.forLocation(const Coordinate(0, 0));
      expect(r.outOfRange, isTrue);
      expect(r.list, isEmpty);
    });
  });

  test('stops.byId', () async {
    final h = _Harness('stop_1_1121.json');
    final r = await h.client.stops.byId('1_1121');
    expect(h.url.path, '/api/where/stop/1_1121.json');
    expect(r.entry.name, 'Westlake Station - Bay A');
    expect(r.entry.coordinate, const Coordinate(47.611759, -122.335785));
    expect(r.references.route('40_100479')!.routeType, RouteType.lightRail);
    final agency = r.references.agency('40')!;
    expect(agency.fareUrl, 'http://www.soundtransit.org/Fares-and-Passes.xml');
    expect(agency.language, 'EN');
    expect(agency.email, isNull);
    expect(agency.privateService, isFalse);
  });

  test('stops.forRoute', () async {
    final h = _Harness('stops_for_route_1_44.json');
    final r = await h.client.stops.forRoute('1_44');
    expect(h.url.path, '/api/where/stops-for-route/1_44.json');
    expect(r.entry.routeId, '1_44');
    expect(r.entry.stopIds, hasLength(63));
    expect(r.entry.polylines, hasLength(4));
    expect(r.entry.polylines.first, startsWith('ctxaH`rniV'));
    final grouping = r.entry.stopGroupings.single;
    expect(grouping.ordered, isTrue);
    expect(grouping.type, 'direction');
    final group = grouping.stopGroups[1];
    expect(group.id, '1');
    expect(group.name, 'UNIVERSITY OF WASHINGTON MEDICAL CENTER WALLINGFORD');
    expect(group.nameType, 'destination');
    expect(group.stopIds, hasLength(32));
    expect(group.polylines, hasLength(1));
    expect(
      r.references.stopsWithIds(group.stopIds).first.id,
      group.stopIds.first,
    );
  });

  group('arrivalsAndDepartures.forTripAtStop', () {
    test('sends trip, service date, vehicle and a positive sequence', () async {
      final h = _Harness('arrival-and-departure-for-stop-MTS_11589.json');
      final r = await h.client.arrivalsAndDepartures.forTripAtStop(
        'MTS_11589',
        tripId: 'MTS_13405160',
        serviceDate: _ms(1540278000000),
        vehicleId: 'MTS_806',
        stopSequence: 1,
      );
      expect(
        h.url.path,
        '/api/where/arrival-and-departure-for-stop/MTS_11589.json',
      );
      expect(h.url.queryParameters, {
        'key': 'k',
        'tripId': 'MTS_13405160',
        'serviceDate': '1540278000000',
        'vehicleId': 'MTS_806',
        'stopSequence': '1',
      });
      final a = r.entry;
      expect(a.situationIds, ['MTS_RTA:11638227']);
      expect(a.lastUpdateTime, _ms(1540350822000));
      expect(a.predictedArrivalTime, _ms(1540350600000));
      expect(a.occupancyStatus, isNull);
      final s = a.tripStatus!;
      expect(s.closestStopId, 'MTS_13353');
      expect(s.closestStopTimeOffset, -32);
      expect(s.nextStopId, 'MTS_10452');
      expect(s.nextStopTimeOffset, 268);
      expect(s.phase, isNull); // "" -> null
      expect(s.statusModifier, TripStatusModifier.defaultStatus);
      expect(
        s.position,
        const Coordinate(32.74422696885996, -117.1805692625683),
      );
      expect(s.lastKnownLocation, const Coordinate(32.740211, -117.184502));
      expect(s.lastKnownDistanceAlongTrip, isNull); // 0 -> null
      expect(s.orientation, closeTo(54.69, 0.01));
      expect(s.totalDistanceAlongTrip, closeTo(14427.92, 0.01));
      expect(s.situationIds, ['MTS_RTA:11638227']);

      final alert = r.references.situation('MTS_RTA:11638227')!;
      expect(alert.activeWindows.single.from, _ms(1539781200000)); // seconds
      final details = alert.consequences.single.conditionDetails!;
      expect(details.diversionStopIds, ['1_9972', '1_9974']);
      expect(details.diversionPath, startsWith('ue}aH'));
      expect(alert.allAffects.single.routeId, 'MTS_10');
      expect(alert.allAffects.single.stopId, isNull);
    });

    test('omits vehicle and a zero stop sequence', () async {
      final h = _Harness('arrival-and-departure-for-stop-MTS_11589.json');
      await h.client.arrivalsAndDepartures.forTripAtStop(
        'MTS_11589',
        tripId: 'T',
        serviceDate: _ms(1000),
      );
      expect(h.url.queryParameters, {
        'key': 'k',
        'tripId': 'T',
        'serviceDate': '1000',
      });
    });
  });

  group('arrivalsAndDepartures.forStop with a null body', () {
    const nullBody = 'null';
    test('stop exists: no arrivals, stop in references', () async {
      final h = _Harness.responding(
        (req) => http.Response(
          req.url.path.contains('arrivals')
              ? nullBody
              : fixture('stop_1_1121.json'),
          200,
        ),
      );
      final r = await h.client.arrivalsAndDepartures.forStop('1_1121');
      expect(h.requests.map((u) => u.path), [
        '/api/where/arrivals-and-departures-for-stop/1_1121.json',
        '/api/where/stop/1_1121.json',
      ]);
      expect(r.entry.stopId, '1_1121');
      expect(r.entry.arrivalsAndDepartures, isEmpty);
      expect(r.references.stop('1_1121')!.name, 'Westlake Station - Bay A');
      expect(r.references.route('40_100479'), isNotNull);
      expect(r.currentTime, _ms(1589553377215));
    });

    Future<Object?> errorWhenStopAnswers(http.Response stop) async {
      final h = _Harness.responding(
        (req) => req.url.path.contains('arrivals')
            ? http.Response(nullBody, 200)
            : stop,
      );
      try {
        await h.client.arrivalsAndDepartures.forStop('X');
        return null;
      } catch (e) {
        return e;
      }
    }

    final isNullBodyError = isA<ObaApiException>()
        .having((e) => e.kind, 'kind', ObaApiErrorKind.emptyResponse)
        .having((e) => e.isNullBody, 'isNullBody', isTrue);

    test('stop is missing (null, HTTP 404, envelope 404, no entry): '
        'the null-body error', () async {
      expect(
        await errorWhenStopAnswers(http.Response('null', 200)),
        isNullBodyError,
      );
      expect(
        await errorWhenStopAnswers(http.Response('<html>404</html>', 404)),
        isNullBodyError,
      );
      expect(
        await errorWhenStopAnswers(
          http.Response(
            '{"code":404,"currentTime":1,"text":"no","version":2}',
            200,
          ),
        ),
        isNullBodyError,
      );
      expect(
        await errorWhenStopAnswers(
          http.Response(
            '{"code":200,"currentTime":1,"version":2,"data":{}}',
            200,
          ),
        ),
        isNullBodyError,
      );
    });

    test('stop request fails otherwise: that error', () async {
      expect(
        await errorWhenStopAnswers(http.Response('', 200)),
        isA<ObaApiException>()
            .having((e) => e.kind, 'kind', ObaApiErrorKind.emptyResponse)
            .having((e) => e.isNullBody, 'isNullBody', isFalse),
      );
      expect(
        await errorWhenStopAnswers(http.Response('<html>portal</html>', 200)),
        isA<ObaFormatException>(),
      );
      expect(
        await errorWhenStopAnswers(http.Response('oops', 500)),
        isA<ObaApiException>().having((e) => e.code, 'code', 500),
      );
    });

    test('a blank arrivals body does not fall back', () async {
      final h = _Harness.responding((_) => http.Response('', 200));
      await expectLater(
        h.client.arrivalsAndDepartures.forStop('X'),
        throwsA(isA<ObaApiException>()),
      );
      expect(h.requests, hasLength(1));
    });
  });

  group('trips', () {
    test('details with service date and vehicle', () async {
      final h = _Harness('trip_details_1_18196913.json');
      final r = await h.client.trips.details(
        '1_18196913',
        serviceDate: _ms(1343631600000),
        vehicleId: '1_1234',
      );
      expect(h.url.path, '/api/where/trip-details/1_18196913.json');
      expect(h.url.queryParameters, {
        'key': 'k',
        'serviceDate': '1343631600000',
        'vehicleId': '1_1234',
      });
      final d = r.entry;
      expect(d.tripId, '1_18196913');
      expect(d.status, isNull);
      expect(d.schedule!.timeZone, 'America/Los_Angeles');
      expect(d.schedule!.previousTripId, '1_18196851');
      expect(d.schedule!.nextTripId, '1_18196555');
      expect(d.stopTimes, hasLength(53));
      final last = d.stopTimes.last;
      expect(last.stopId, '1_76680');
      expect(last.arrivalTime, 61847);
      expect(last.stopHeadsign, isNull);
      expect(d.arrivalDate(last), _ms(1343631600000 + 61847 * 1000));
      final trip = r.references.trip('1_18196913')!;
      expect(trip.tripShortName, 'LOCAL');
      expect(trip.routeShortName, isNull);
      expect(trip.timeZone, isNull);
    });

    test('details without options sends only the key', () async {
      final h = _Harness('trip_details_1_18196913.json');
      await h.client.trips.details('1_18196913');
      expect(h.url.queryParameters, {'key': 'k'});
    });

    test('forVehicle: null schedule, full status', () async {
      final h = _Harness('trip-for-vehicle-1_2799.json');
      final r = await h.client.trips.forVehicle('1_2799');
      expect(h.url.path, '/api/where/trip-for-vehicle/1_2799.json');
      expect(r.entry.schedule, isNull);
      expect(r.entry.stopTimes, isEmpty);
      final s = r.entry.status!;
      expect(s.activeTripId, '1_40956737');
      expect(s.vehicleId, '1_2799');
      expect(s.scheduleDeviation, 345);
      expect(s.statusModifier, TripStatusModifier.scheduled);
      expect(s.lastLocationUpdateTime, _ms(1539906465000));
    });
  });

  test('vehicles.byId', () async {
    final h = _Harness('vehicle_for_id_4011.json');
    final r = await h.client.vehicles.byId('40_11');
    expect(h.url.path, '/api/where/vehicle/40_11.json');
    final v = r.entry;
    expect(v.vehicleId, '40_11');
    expect(v.lastLocationUpdateTime, isNull); // 0 -> null
    expect(v.lastUpdateTime, _ms(1538584269000));
    expect(v.location, const Coordinate(47.608246, -122.336166));
    expect(v.tripId, '40_40804394');
    expect(v.phase, 'in_progress');
    expect(v.status, 'SCHEDULED');
    expect(v.tripStatus!.lastKnownLocation, isNull);
    expect(v.tripStatus!.frequency, isNull);
  });

  test('routes.forLocation sends radius of at least 40 km', () async {
    final h = _Harness('routes_for_location_query.json');
    final r = await h.client.routes.forLocation(
      const Coordinate(47.25, -122.5),
      query: '11',
      radius: 1000,
    );
    expect(h.url.path, '/api/where/routes-for-location.json');
    expect(h.url.queryParameters, {
      'key': 'k',
      'lat': '47.25',
      'lon': '-122.5',
      'query': '11',
      'radius': '40000.0',
    });
    expect(r.list.single.longName, 'Pt. Defiance');
    expect(r.references.agency('3')!.disclaimer, contains('Pierce Transit'));

    final h2 = _Harness('routes_for_location_query.json');
    await h2.client.routes.forLocation(
      const Coordinate(0, 0),
      query: 'x',
      radius: 50000,
    );
    expect(h2.url.queryParameters['radius'], '50000.0');
  });

  test('shapes.byId', () async {
    final h = _Harness('shape_1_20010002.json');
    final r = await h.client.shapes.byId('1_20010002');
    expect(h.url.path, '/api/where/shape/1_20010002.json');
    expect(r.entry.length, 65);
    expect(r.entry.levels, isNull);
    expect(r.entry.points, startsWith('afvaHbdpiV'));
  });

  test('agencies.withCoverage', () async {
    final h = _Harness('2_agencies_with_coverage.json');
    final r = await h.client.agencies.withCoverage();
    expect(h.url.path, '/api/where/agencies-with-coverage.json');
    expect(r.list.map((a) => a.agencyId), ['98', '1']);
    expect(r.list[1].center, const Coordinate(47.560728, -122.09015249999999));
    expect(r.list[1].latSpan, closeTo(0.7432, 0.0001));
    expect(r.references.agency('1')!.name, 'Metro Transit');
  });

  group('schedules', () {
    test('forStop with a date', () async {
      final h = _Harness('schedule-for-stop_1_75403.json');
      final r = await h.client.schedules.forStop(
        '1_75403',
        date: DateTime(2025, 12, 6),
      );
      expect(h.url.path, '/api/where/schedule-for-stop/1_75403.json');
      expect(h.url.queryParameters, {'key': 'k', 'date': '2025-12-06'});
      final e = r.entry;
      expect(e.stopId, '1_75403');
      expect(e.date, _ms(1765065104024));
      expect(e.stopRouteSchedules, hasLength(3));
      final dir = e.stopRouteSchedules.first.stopRouteDirectionSchedules.first;
      expect(e.stopRouteSchedules.first.routeId, '1_100225');
      expect(dir.tripHeadsign, 'Loyal Heights Greenwood');
      expect(dir.scheduleStopTimes, hasLength(67));
      final first = dir.scheduleStopTimes.first;
      expect(first.arrivalTime, _ms(1765029720000));
      expect(first.serviceId, '1_21436');
      expect(first.stopHeadsign, isNull);
      expect(first.arrivalEnabled, isTrue);
    });

    test('forStop without a date sends no date', () async {
      final h = _Harness('schedule-for-stop_1_75403.json');
      await h.client.schedules.forStop('1_75403');
      expect(h.url.queryParameters, {'key': 'k'});
    });

    test('forRoute', () async {
      final h = _Harness('schedule-for-route_1_100223.json');
      final r = await h.client.schedules.forRoute(
        '1_100223',
        date: DateTime.utc(2025, 1, 2),
      );
      expect(h.url.path, '/api/where/schedule-for-route/1_100223.json');
      expect(h.url.queryParameters['date'], '2025-01-02');
      final e = r.entry;
      expect(e.scheduleDate, _ms(1765008000000));
      expect(e.serviceIds, ['1_21436']);
      expect(e.stopTripGroupings, hasLength(2));
      final g = e.stopTripGroupings[1];
      expect(g.directionId, '1');
      expect(g.tripIds, hasLength(9));
      final firstTime =
          e.stopTripGroupings[0].tripsWithStopTimes[0].stopTimes[0];
      expect(firstTime.arrivalTime, 31500); // seconds since midnight
      expect(firstTime.stopId, '1_41902');
      expect(firstTime.serviceId, isNull); // "" -> null
    });
  });

  group('config', () {
    test('maglev', () async {
      final h = _Harness('config-maglev.json');
      final r = await h.client.config.get();
      expect(h.url.path, '/api/where/config.json');
      expect(r.entry.isMaglev, isTrue);
      expect(r.entry.name, 'OneBusAway Go');
      expect(r.entry.gitProperties['git.build.version'], '0.1.1-2457-g2401ee3');
    });

    test('java', () async {
      final r = await _Harness('config-java.json').client.config.get();
      expect(r.entry.id, isNull);
      expect(r.entry.isMaglev, isFalse);
      expect(r.entry.gitProperties, {'git.build.version': '2.7.1'});
    });
  });

  group('problemReports', () {
    test('reportStop', () async {
      final h = _Harness('report_stop_problem.json');
      await h.client.problemReports.reportStop(
        '1_1121',
        code: StopProblemCode.locationWrong,
        comment: 'Moved & renamed',
        userLocation: const Coordinate(47.5, -122.5),
        userLocationAccuracy: 12.5,
      );
      expect(h.url.path, '/api/where/report-problem-with-stop/1_1121.json');
      expect(h.url.queryParameters, {
        'key': 'k',
        'code': 'stop_location_wrong',
        'userComment': 'Moved & renamed',
        'userLat': '47.5',
        'userLon': '-122.5',
        'userLocationAccuracy': '12.5',
      });
    });

    test('reportTrip', () async {
      final h = _Harness('report_trip_problem.json');
      await h.client.problemReports.reportTrip(
        tripId: '1_18196913',
        serviceDate: _ms(1343631600000),
        code: TripProblemCode.neverCame,
        userOnVehicle: false,
        vehicleId: '1_1234',
        stopId: '1_1121',
      );
      expect(h.url.path, '/api/where/report-problem-with-trip.json');
      expect(h.url.queryParameters, {
        'key': 'k',
        'tripId': '1_18196913',
        'serviceDate': '1343631600000',
        'code': 'vehicle_never_came',
        'userOnVehicle': 'false',
        'vehicleId': '1_1234',
        'stopId': '1_1121',
      });
    });

    test('envelope errors are thrown', () async {
      final h = _Harness('error_envelope.json');
      await expectLater(
        h.client.problemReports.reportStop('X', code: StopProblemCode.other),
        throwsA(isA<ObaApiException>()),
      );
    });

    test('wire values', () {
      expect(StopProblemCode.values.map((c) => c.wireValue), [
        'stop_name_wrong',
        'stop_number_wrong',
        'stop_location_wrong',
        'route_or_trip_missing',
        'other',
      ]);
      expect(TripProblemCode.values.map((c) => c.wireValue), [
        'vehicle_never_came',
        'vehicle_came_early',
        'vehicle_came_late',
        'wrong_headsign',
        'vehicle_does_not_stop_here',
        'other',
      ]);
    });
  });
}
