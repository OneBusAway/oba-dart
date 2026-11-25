import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

import 'support/fixtures.dart';

void main() {
  const strings = TripPlannerStrings();

  group('durations', () {
    test('rounds to minutes, never below one', () {
      expect(strings.duration(0), '0 min');
      expect(strings.duration(20), '1 min');
      expect(strings.duration(89), '1 min');
      expect(strings.duration(90), '2 min');
      expect(strings.duration(2482), '41 min');
      expect(strings.duration(3600), '1 hr');
      expect(strings.duration(3900), '1 hr 5 min');
      expect(strings.durationSemantics(60), '1 minute');
      expect(strings.durationSemantics(2482), '41 minutes');
      expect(strings.durationSemantics(3600), '1 hour');
      expect(strings.durationSemantics(3900), '1 hour 5 minutes');
      expect(strings.durationSemantics(7500), '2 hours 5 minutes');
    });
  });

  group('distances', () {
    test('imperial uses feet under 0.1 mi, then miles', () {
      expect(strings.distance(100, DistanceUnits.imperial), '328 ft');
      expect(strings.distance(629.6, DistanceUnits.imperial), '0.4 mi');
      expect(strings.distance(1609, DistanceUnits.imperial), '1 mi');
    });

    test('metric uses meters under 1 km, then km', () {
      expect(strings.distance(629.6, DistanceUnits.metric), '630 m');
      expect(strings.distance(1500, DistanceUnits.metric), '1.5 km');
    });

    test('units follow the locale region', () {
      expect(
        DistanceUnits.forLocale(const Locale('en', 'US')),
        DistanceUnits.imperial,
      );
      expect(
        DistanceUnits.forLocale(const Locale('en', 'GB')),
        DistanceUnits.imperial,
      );
      expect(
        DistanceUnits.forLocale(const Locale('fr', 'FR')),
        DistanceUnits.metric,
      );
      expect(DistanceUnits.forLocale(const Locale('es')), DistanceUnits.metric);
    });
  });

  test('money', () {
    expect(
      formatMoney(const Money(cents: 250, currencyCode: 'USD', symbol: r'$')),
      r'$2.50',
    );
    expect(
      formatMoney(const Money(cents: 300, currencyCode: 'EUR')),
      '3.00 EUR',
    );
    expect(
      formatMoney(
        const Money(cents: 300, currencyCode: 'JPY', fractionDigits: 0),
      ),
      '300 JPY',
    );
  });

  test('clock times use the locale and the 24-hour setting', () {
    const localizations = DefaultMaterialLocalizations();
    final t = DateTime(2026, 11, 25, 21, 4);
    expect(formatClockTime(t, localizations), '9:04 PM');
    expect(
      formatClockTime(t, localizations, alwaysUse24HourFormat: true),
      '21:04',
    );
  });

  group('real-time status', () {
    test('rounds delay to minutes', () {
      expect(
        RealTimeStatus.of(realTime: false, delaySeconds: 300),
        const ScheduledStatus(),
      );
      expect(RealTimeStatus.of(realTime: true), const ScheduledStatus());
      expect(
        RealTimeStatus.of(realTime: true, delaySeconds: 20),
        const OnTimeStatus(),
      );
      expect(
        RealTimeStatus.of(realTime: true, delaySeconds: 150),
        const LateStatus(3),
      );
      expect(
        RealTimeStatus.of(realTime: true, delaySeconds: -120),
        const EarlyStatus(2),
      );
      expect(strings.realTimeStatus(const LateStatus(3)), '3 min late');
    });
  });

  group('leg summaries', () {
    test('real SDMTS itinerary: walk, Blue line, walk', () {
      final itinerary = sdPlan().itineraries.first;
      final chips = legSummary(itinerary);
      expect(chips.map((c) => (c.kind, c.routeName)), [
        (LegKind.walk, null),
        (LegKind.transit, 'Blue'),
        (LegKind.walk, null),
      ]);
      expect(firstTransitLeg(itinerary)!.routeShortName, 'Blue');
      expect(
        strings.legChipSemantics(chips[1]),
        'Tram Blue, ${strings.durationSemantics(chips[1].durationSeconds)}',
      );
    });

    test('an all-short-walk itinerary still gets one chip', () {
      final leg = Leg(
        startTime: DateTime(2026),
        endTime: DateTime(2026),
        mode: 'WALK',
        duration: 30,
        from: const Place(name: 'A', lat: 0, lon: 0),
        to: const Place(name: 'B', lat: 0, lon: 0),
      );
      final itinerary = Itinerary(
        duration: 30,
        startTime: DateTime(2026),
        endTime: DateTime(2026),
        legs: [leg],
      );
      expect(legSummary(itinerary).single.kind, LegKind.walk);
      expect(firstTransitLeg(itinerary), isNull);
    });
  });

  group('instructions', () {
    test('step sentences, including unknown directions', () {
      const step = LegStep(
        distance: 100,
        streetName: 'Pine St',
        relativeDirection: 'RIGHT',
        lat: 0,
        lon: 0,
      );
      expect(
        strings.stepInstruction(step, DistanceUnits.imperial),
        'Turn right onto Pine St, walk 328 ft.',
      );
      const odd = LegStep(
        distance: 10,
        streetName: 'Path',
        relativeDirection: 'SPIN_AROUND',
        lat: 0,
        lon: 0,
      );
      expect(
        strings.stepInstruction(odd, DistanceUnits.metric),
        'Spin Around onto Path, walk 10 m.',
      );
      const noTurn = LegStep(distance: 10, streetName: 'Path', lat: 0, lon: 0);
      expect(
        strings.stepInstruction(noTurn, DistanceUnits.metric),
        'Walk along Path for 10 m.',
      );
    });

    test('boarding text and place names', () {
      expect(
        strings.board('Bus', '30', 'Old Town'),
        'Take Bus 30 toward Old Town',
      );
      expect(strings.board('Ferry', null, null), 'Take Ferry');
      expect(
        strings.placeName(
          const Place(
            name: ' Default vehicle type ',
            lat: 0,
            lon: 0,
            bikeShareId: 'x',
          ),
        ),
        'Rental bike',
      );
      expect(
        strings.placeName(const Place(name: '', lat: 0, lon: 0)),
        'Unnamed location',
      );
    });

    test('unknown leg modes are humanized', () {
      final leg = Leg(
        startTime: DateTime(2026),
        endTime: DateTime(2026),
        mode: 'HOVERCRAFT_FERRY',
        transitLeg: true,
        from: const Place(name: 'A', lat: 0, lon: 0),
        to: const Place(name: 'B', lat: 0, lon: 0),
      );
      expect(strings.legModeName(leg), 'Hovercraft Ferry');
      expect(LegKind.of(leg), LegKind.transit);
    });
  });

  group('error messages', () {
    test('every error kind has rider-facing text', () {
      expect(
        strings.errorMessage(const MissingTripEndpointsError()),
        contains('origin and destination'),
      );
      expect(
        strings.errorMessage(
          const OtpPlannerException(PlannerErrorCode.pathNotFound, 'x'),
        ),
        'No route is available for this trip.',
      );
      expect(
        strings.errorMessage(const OtpNetworkException('x')),
        contains('connection'),
      );
      expect(
        strings.errorMessage(const OtpHttpException(500)),
        'Server returned invalid response',
      );
      expect(
        strings.errorMessage(StateError('x')),
        'An unknown error occurred.',
      );
    });
  });

  group('theme', () {
    test('parses GTFS colours and picks readable text', () {
      expect(parseHexColor('28813F'), const Color(0xFF28813F));
      expect(parseHexColor('#fff'), const Color(0xFFFFFFFF));
      expect(parseHexColor('nope'), isNull);
      expect(contrastingTextColor(const Color(0xFF000080)), Colors.white);
      expect(contrastingTextColor(const Color(0xFFFFFF00)), Colors.black);
    });

    test('legs use route colours, falling back to mode colours', () {
      final theme = TripPlannerTheme.fromColorScheme(
        ColorScheme.fromSeed(seedColor: Colors.blue),
      );
      final legs = stPlan().itineraries.first.legs;
      expect(theme.colorForLeg(legs[1]), const Color(0xFF28813F));
      expect(theme.onColorForLeg(legs[1]), const Color(0xFFFFFFFF));
      expect(theme.colorForLeg(legs[0]), theme.walk);
    });
  });
}
