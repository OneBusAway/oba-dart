import 'package:flutter_test/flutter_test.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

import '../support/fixtures.dart';

void main() {
  group('REST (OTP 1.x)', () {
    test('parses the real SDMTS capture', () {
      final plan = sdPlan();
      expect(plan.source, OtpApiFlavor.rest);
      expect(plan.itineraries, hasLength(6));

      final itinerary = plan.itineraries.first;
      expect(itinerary.duration, 2482);
      expect(itinerary.startTime, DateTime(2026, 11, 25, 9, 4, 55));
      expect(itinerary.transfers, 0);
      expect(itinerary.walkDistance, closeTo(629.6, 0.1));
      expect(
        itinerary.fare,
        const Money(cents: 0, currencyCode: 'USD', symbol: r'$'),
      );
      expect(itinerary.legs.map((l) => l.mode), ['WALK', 'TRAM', 'WALK']);

      final walk = itinerary.legs.first;
      expect(walk.routeShortName, isNull, reason: 'OTP 1.x sends "" for walks');
      expect(walk.steps.first.relativeDirection, 'DEPART');
      expect(walk.steps.first.streetName, 'Matthews Lane');

      final tram = itinerary.legs[1];
      expect(tram.legMode, LegMode.tram);
      expect(tram.routeShortName, 'Blue');
      expect(tram.routeLongName, 'San Ysidro - UTC');
      expect(tram.headsign, 'San Ysidro');
      expect(tram.routeColor, '0000FF');
      expect(tram.routeTextColor, 'FFFFFF');
      expect(tram.agencyName, 'MTS');
      expect(tram.transitLeg, isTrue);
      expect(tram.realTime, isFalse);
      expect(tram.from.name, 'UCSD Central Campus Station');
      expect(tram.from.stopId, '2:77781');
      expect(tram.intermediateStops, hasLength(12));
      expect(tram.geometry, hasLength(213));
      // Decoded once and reused.
      expect(identical(tram.geometry, tram.geometry), isTrue);
      final copy = tram.copyWith(encodedGeometry: '');
      expect(copy.geometry, [copy.from.point, copy.to.point]);
    });

    test('parses the OTPKit success fixture', () {
      final plan = parseRestPlanResponse(
        fixtureJson('rest/otp_response_success.json'),
      );
      final legs = plan.itineraries.single.legs;
      expect(legs.map((l) => (l.mode, l.routeShortName, l.duration)), [
        ('WALK', null, 300),
        ('BUS', '62', 480),
        ('WALK', null, 420),
      ]);
      expect(plan.itineraries.single.fare, isNull);
    });

    test('parses the OTPKit basic case', () {
      final plan = parseRestPlanResponse(
        fixtureJson('rest/plan_basic_case.json'),
      );
      expect(plan.itineraries, isNotEmpty);
    });

    test('an empty itinerary list is a plan, not an error', () {
      final plan = parseRestPlanResponse(
        fixtureJson('rest/otp_response_empty.json'),
      );
      expect(plan.itineraries, isEmpty);
    });

    test('an error object throws OtpPlannerException with its code', () {
      expect(
        () =>
            parseRestPlanResponse(fixtureJson('rest/otp_response_error.json')),
        throwsA(
          isA<OtpPlannerException>()
              .having((e) => e.code, 'code', PlannerErrorCode.pathNotFound)
              .having((e) => e.id, 'id', 404)
              .having((e) => e.message, 'message', 'Trip not found')
              .having((e) => e.triggersFallback, 'fallback', isFalse),
        ),
      );
    });

    test('an unknown error key maps to unknown', () {
      expect(
        () => parseRestPlanResponse(
          fixtureJson('rest/otp_response_unknown_error.json'),
        ),
        throwsA(
          isA<OtpPlannerException>().having(
            (e) => e.code,
            'code',
            PlannerErrorCode.unknown,
          ),
        ),
      );
    });

    test('a response with neither plan nor error is a format error', () {
      expect(
        () => parseRestPlanResponse({'requestParameters': {}}),
        throwsA(isA<OtpFormatException>()),
      );
    });
  });

  group('GraphQL (OTP 2.x)', () {
    test('parses the real Sound Transit capture', () {
      final plan = stPlan();
      expect(plan.source, OtpApiFlavor.graphql);
      expect(plan.itineraries, hasLength(3));

      final itinerary = plan.itineraries.first;
      expect(itinerary.duration, 1040);
      expect(itinerary.startTime, DateTime(2026, 11, 25, 9, 0, 31));
      expect(itinerary.fare, isNull);

      final rail = itinerary.legs[1];
      expect(rail.legMode, LegMode.tram);
      expect(rail.routeShortName, '1 Line');
      expect(rail.routeLongName, 'Lynnwood - Federal Way');
      expect(rail.routeColor, '28813F');
      expect(rail.agencyName, 'Sound Transit');
      expect(rail.routeType, RouteType.tram);
      expect(rail.headsign, 'Lynnwood City Center');
      expect(rail.from.stopId, '40:1121');
      expect(rail.intermediateStops.map((s) => s.name), [
        'Capitol Hill',
        'Univ of Washington',
      ]);
      expect(rail.geometry, hasLength(166));
      expect(itinerary.legs.first.steps.first.streetName, '6th Avenue');
    });

    test('parses the OTPKit success fixture and derives transit time', () {
      final plan = parseGraphQLPlanResponse(
        fixtureJson('graphql/graphql_plan_success.json'),
      );
      final itinerary = plan.itineraries.first;
      expect(itinerary.legs[1].routeShortName, 'Monorail');
      expect(itinerary.legs[1].legMode, LegMode.monorail);
      expect(
        itinerary.transitTime,
        itinerary.duration - itinerary.walkTime - itinerary.waitingTime,
      );
    });

    test('parses rental legs', () {
      final plan = parseGraphQLPlanResponse(
        fixtureJson('graphql/graphql_plan_rental.json'),
      );
      final legs = plan.itineraries.first.legs;
      expect(legs.map((l) => (l.mode, l.rentedBike)), [
        ('WALK', false),
        ('BICYCLE', true),
      ]);
      expect(LegKind.of(legs[1]), LegKind.rentalBike);
    });

    test('routing errors on an empty plan throw OtpPlannerException', () {
      expect(
        () => parseGraphQLPlanResponse(
          fixtureJson('graphql/graphql_plan_routing_error.json'),
        ),
        throwsA(
          isA<OtpPlannerException>()
              .having((e) => e.code, 'code', PlannerErrorCode.outsideBounds)
              .having((e) => e.id, 'id', isNull),
        ),
      );
    });

    test('WALKING_BETTER_THAN_TRANSIT is advisory', () {
      final json = fixtureJson('graphql/graphql_plan_routing_error.json');
      ((json['data'] as Map)['plan'] as Map)['routingErrors'] = [
        {'code': 'WALKING_BETTER_THAN_TRANSIT', 'description': 'Walk'},
      ];
      expect(parseGraphQLPlanResponse(json).itineraries, isEmpty);
    });

    test('routing error codes map like OTPKit', () {
      expect(
        PlannerErrorCode.fromGraphQLRoutingError('NO_TRANSIT_CONNECTION'),
        PlannerErrorCode.pathNotFound,
      );
      expect(
        PlannerErrorCode.fromGraphQLRoutingError('OUTSIDE_SERVICE_PERIOD'),
        PlannerErrorCode.noTransitTimes,
      );
      expect(
        PlannerErrorCode.fromGraphQLRoutingError('NO_STOPS_IN_RANGE'),
        PlannerErrorCode.locationNotAccessible,
      );
      expect(
        PlannerErrorCode.fromGraphQLRoutingError('SOMETHING_NEW'),
        PlannerErrorCode.unknown,
      );
    });

    test('top-level errors throw OtpGraphQLException with every message', () {
      expect(
        () => parseGraphQLPlanResponse({
          'errors': [
            {'message': 'Validation error: field longName'},
            {'message': 'second'},
          ],
        }),
        throwsA(
          isA<OtpGraphQLException>()
              .having((e) => e.message, 'message', contains('longName'))
              .having((e) => e.messages, 'messages', hasLength(2))
              .having((e) => e.triggersFallback, 'fallback', isTrue),
        ),
      );
    });

    test('missing data.plan is a format error', () {
      expect(
        () => parseGraphQLPlanResponse({
          'data': {'plan': null},
        }),
        throwsA(isA<OtpFormatException>()),
      );
    });
  });

  group('Itinerary.relevantLegs', () {
    Leg leg(String mode, int duration, {String? route, bool transit = false}) =>
        Leg(
          startTime: DateTime(2026),
          endTime: DateTime(2026),
          mode: mode,
          from: const Place(name: 'A', lat: 0, lon: 0),
          to: const Place(name: 'B', lat: 1, lon: 1),
          duration: duration,
          routeShortName: route,
          transitLeg: transit,
          intermediateStops: [Place(name: '$mode$duration', lat: 0, lon: 0)],
        );

    test('drops walks of a minute or less and merges same-route legs', () {
      final itinerary = Itinerary(
        duration: 0,
        startTime: DateTime(2026),
        endTime: DateTime(2026),
        legs: [
          leg('WALK', 45),
          leg('BUS', 300, route: '30', transit: true),
          leg('BUS', 200, route: '30', transit: true),
          leg('WALK', 400),
        ],
      );
      final relevant = itinerary.relevantLegs;
      expect(relevant.map((l) => (l.mode, l.duration)), [
        ('BUS', 500),
        ('WALK', 400),
      ]);
      expect(relevant.first.intermediateStops, hasLength(2));
    });
  });
}
