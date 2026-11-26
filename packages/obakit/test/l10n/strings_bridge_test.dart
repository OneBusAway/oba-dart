// The bridge from the lower packages' strings classes to the SDK's ARB
// strings (lib/src/l10n/strings_bridge.dart):
// - every member of each strings class is bridged (checked against the
//   classes' source, so a new member fails here until it is bridged);
// - in English the bridged strings match the packages' own defaults;
// - every bridged member reads from ObaLocalizations;
// - SDK screens show the current locale's strings end to end, using a
//   test-only "Spanish" ObaLocalizations (pinned strings, independent of
//   app_es.arb edits), and follow a locale change at runtime. The shipped
//   translations are covered by arb_consistency_test, plural_messages_test
//   and locale_sweep_test.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:oba_arrivals/oba_arrivals.dart'
    show ObaArrivalsPanel, ObaArrivalsStrings, OneBusAwayClient;
import 'package:obakit/obakit.dart';
import 'package:obakit/src/l10n/generated/oba_localizations_en.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import '../support/oba_test_harness.dart';

// -- Member coverage ---------------------------------------------------------

/// The `String` members a strings class declares, read from its source.
Set<String> declaredMembers(String path) => {
  for (final m in RegExp(
    r'^  String (?:get )?(\w+)',
    multiLine: true,
  ).allMatches(File(path).readAsStringSync()))
    m.group(1)!,
};

/// The members the bridge class [className] overrides.
Set<String> bridgedMembers(String className) {
  final source = File('lib/src/l10n/strings_bridge.dart').readAsStringSync();
  final start = source.indexOf('class $className ');
  expect(start, isNonNegative, reason: '$className not found');
  final next = source.indexOf('\nclass ', start + 1);
  final body = source.substring(start, next < 0 ? source.length : next);
  return {
    for (final m in RegExp(
      r'@override\s+String (?:get )?(\w+)',
    ).allMatches(body))
      m.group(1)!,
  };
}

/// Members deliberately inherited: they only combine other (bridged)
/// members or pass a value through.
const inherited = {
  'tripPlanner': {
    'fare', // Returns the already-formatted amount.
    'legModeName', // legMode(), or the humanized OTP token.
    'placeName', // The place's own name, rentalBike or unnamedPlace.
  },
};

// -- Sample calls --------------------------------------------------------------

typedef Cases<S> = Map<String, List<String> Function(S s)>;

final directions = [
  for (final d in StopDirection.values)
    if (d != StopDirection.unknown) d,
];

final Cases<ObaCoreStrings> coreCases = {
  'directionAdjective': (s) => [
    for (final d in directions) s.directionAdjective(d),
  ],
  'stopCodeNumeric': (s) => [s.stopCodeNumeric('1234')],
  'stopCodeNonNumeric': (s) => [s.stopCodeNonNumeric('Old Library')],
  'justNow': (s) => [s.justNow],
  'secondsAgo': (s) => [s.secondsAgo(31)],
  'minutesAgo': (s) => [s.minutesAgo(4)],
  'hoursAgo': (s) => [s.hoursAgo(2)],
  'daysAgo': (s) => [s.daysAgo(1), s.daysAgo(3)],
  'meters': (s) => [s.meters('350')],
  'kilometers': (s) => [s.kilometers('1.2')],
  'feet': (s) => [s.feet('500')],
  'miles': (s) => [s.miles('0.3')],
};

final Cases<ObaArrivalsStrings> arrivalsCases = {
  'now': (s) => [s.now],
  'minutesCompact': (s) => [s.minutesCompact(5)],
  'minLate': (s) => [s.minLate(1), s.minLate(4)],
  'minEarly': (s) => [s.minEarly(1), s.minEarly(4)],
  'onTime': (s) => [s.onTime],
  'scheduled': (s) => [s.scheduled],
  'canceled': (s) => [s.canceled],
  'everyMinutesFrom': (s) => [s.everyMinutesFrom(10, '9:00 AM')],
  'everyMinutesUntil': (s) => [s.everyMinutesUntil(10, '9:00 PM')],
  'stopNumber': (s) => [s.stopNumber('24151')],
  'directionBound': (s) => [
    for (final c in ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'X'])
      s.directionBound(c),
  ],
  'refresh': (s) => [s.refresh],
  'retry': (s) => [s.retry],
  'noArrivals': (s) => [s.noArrivals(35)],
  'stopNotFound': (s) => [s.stopNotFound],
  'networkError': (s) => [s.networkError],
  'loadError': (s) => [s.loadError],
  'staleNotice': (s) => [s.staleNotice('9:41 AM')],
  'arrivingNow': (s) => [s.arrivingNow],
  'arrivingInMinutes': (s) => [s.arrivingInMinutes(1), s.arrivingInMinutes(6)],
  'realtime': (s) => [s.realtime],
  'rowTapHint': (s) => [s.rowTapHint],
  'routeSemantics': (s) => [s.routeSemantics('IL')],
  'atTime': (s) => [s.atTime('10:47 PM')],
  'minutesLateSemantics': (s) => [
    s.minutesLateSemantics(1),
    s.minutesLateSemantics(3),
  ],
  'minutesEarlySemantics': (s) => [
    s.minutesEarlySemantics(1),
    s.minutesEarlySemantics(3),
  ],
  'everyMinutesFromSemantics': (s) => [
    s.everyMinutesFromSemantics(10, '9:00 AM'),
  ],
  'everyMinutesUntilSemantics': (s) => [
    s.everyMinutesUntilSemantics(10, '9:00 PM'),
  ],
  'scheduledSemantics': (s) => [s.scheduledSemantics],
  'loadingArrivals': (s) => [s.loadingArrivals],
  'refreshing': (s) => [s.refreshing],
  'arrivalsUpdated': (s) => [s.arrivalsUpdated],
};

tp.Place place(String name, {String? bikeShareId}) =>
    tp.Place(name: name, lat: 47.6, lon: -122.3, bikeShareId: bikeShareId);

tp.Leg leg(String mode) => tp.Leg(
  startTime: DateTime(2026, 11, 25, 9),
  endTime: DateTime(2026, 11, 25, 9, 30),
  mode: mode,
  from: place('Westlake'),
  to: place('U District'),
  duration: 1800,
);

tp.LegSummaryItem chip(tp.LegKind kind, {String? route}) => tp.LegSummaryItem(
  kind: kind,
  leg: leg(kind == tp.LegKind.transit ? 'BUS' : 'WALK'),
  routeName: route,
);

const units = [tp.DistanceUnits.imperial, tp.DistanceUnits.metric];
// 1 ft, 610 ft, 1.5 mi, 1 m, 350 m, 2.5 km.
const distances = [0.3048, 186.0, 2414.0, 1.0, 350.0, 2500.0];

final Cases<tp.TripPlannerStrings> tripPlannerCases = {
  'originLabel': (s) => [s.originLabel],
  'destinationLabel': (s) => [s.destinationLabel],
  'chooseOrigin': (s) => [s.chooseOrigin],
  'chooseDestination': (s) => [s.chooseDestination],
  'currentLocation': (s) => [s.currentLocation],
  'swapEndpoints': (s) => [s.swapEndpoints],
  'planTrip': (s) => [s.planTrip],
  'planningTrip': (s) => [s.planningTrip],
  'options': (s) => [s.options],
  'timeOption': (s) => [
    for (final o in tp.TripTimeOption.values) s.timeOption(o),
  ],
  'changeTime': (s) => [s.changeTime('Wed, Nov 25, 9:00 AM')],
  'transportMode': (s) => [
    for (final m in tp.TransportMode.values) s.transportMode(m),
  ],
  'wheelchairAccessible': (s) => [s.wheelchairAccessible],
  'walkingDistance': (s) => [
    for (final d in tp.WalkingDistance.values) s.walkingDistance(d),
  ],
  'maxWalk': (s) => [s.maxWalk('0.5 mile')],
  'noTripsFound': (s) => [s.noTripsFound],
  'retry': (s) => [s.retry],
  'realTime': (s) => [s.realTime],
  'duration': (s) => [
    for (final secs in [60, 2460, 3600, 3900]) s.duration(secs),
  ],
  'distance': (s) => [
    for (final u in units)
      for (final m in distances) s.distance(m, u),
  ],
  'timeRange': (s) => [s.timeRange('9:04 AM', '9:46 AM')],
  'transfers': (s) => [s.transfers(0), s.transfers(1), s.transfers(2)],
  'walkDistance': (s) => [s.walkDistance('0.4 mi')],
  'fare': (s) => [s.fare(r'$2.75')],
  'departsAt': (s) => [s.departsAt('9:04 AM', 'Westlake')],
  'realTimeStatus': (s) => [
    s.realTimeStatus(const tp.OnTimeStatus()),
    s.realTimeStatus(const tp.LateStatus(2)),
    s.realTimeStatus(const tp.EarlyStatus(1)),
    s.realTimeStatus(const tp.ScheduledStatus()),
  ],
  'legMode': (s) => [for (final m in tp.LegMode.values) s.legMode(m)],
  'legModeName': (s) => [s.legModeName(leg('BUS'))],
  'itinerarySemantics': (s) => [
    s.itinerarySemantics(
      timeRange: '9:04 AM to 9:46 AM',
      duration: '42 minutes',
      legs: 'Walk 5 minutes',
      details: 'No transfers',
    ),
  ],
  'legChipSemantics': (s) => [
    s.legChipSemantics(chip(tp.LegKind.walk)),
    s.legChipSemantics(chip(tp.LegKind.bike)),
    s.legChipSemantics(chip(tp.LegKind.rentalBike)),
    s.legChipSemantics(chip(tp.LegKind.car)),
    s.legChipSemantics(chip(tp.LegKind.transit, route: '49')),
    s.legChipSemantics(chip(tp.LegKind.transit)),
  ],
  'then': (s) => [s.then],
  'openItineraryHint': (s) => [s.openItineraryHint],
  'durationSemantics': (s) => [
    for (final secs in [60, 2460, 3600, 7200, 3660, 3900])
      s.durationSemantics(secs),
  ],
  'distanceSemantics': (s) => [
    for (final u in units)
      for (final m in distances) s.distanceSemantics(m, u),
  ],
  'timeRangeSemantics': (s) => [s.timeRangeSemantics('9:04 AM', '9:46 AM')],
  'realTimeStatusSemantics': (s) => [
    s.realTimeStatusSemantics(const tp.OnTimeStatus()),
    s.realTimeStatusSemantics(const tp.LateStatus(1)),
    s.realTimeStatusSemantics(const tp.LateStatus(2)),
    s.realTimeStatusSemantics(const tp.EarlyStatus(1)),
    s.realTimeStatusSemantics(const tp.EarlyStatus(3)),
    s.realTimeStatusSemantics(const tp.ScheduledStatus()),
  ],
  'resultsHeading': (s) => [s.resultsHeading],
  'tripsFound': (s) => [s.tripsFound(1), s.tripsFound(3)],
  'placesFound': (s) => [s.placesFound(1), s.placesFound(3)],
  'mapSemanticsLabel': (s) => [s.mapSemanticsLabel],
  'tripDetails': (s) => [s.tripDetails],
  'mapLabel': (s) => [s.mapLabel],
  'start': (s) => [s.start],
  'destination': (s) => [s.destination],
  'unnamedPlace': (s) => [s.unnamedPlace],
  'rentalBike': (s) => [s.rentalBike],
  'walkTo': (s) => [s.walkTo('Pine St')],
  'bikeTo': (s) => [s.bikeTo('Pine St')],
  'rideRentalBikeTo': (s) => [s.rideRentalBikeTo('Pine St')],
  'driveTo': (s) => [s.driveTo('Pine St')],
  'board': (s) => [
    s.board('Bus', '30', 'Old Town'),
    s.board('Bus', '30', null),
    s.board('Ferry', null, 'Bainbridge'),
    s.board('Ferry', null, null),
  ],
  'getOffAt': (s) => [s.getOffAt('Westlake')],
  'arriveAt': (s) => [s.arriveAt('Westlake')],
  'stopCount': (s) => [s.stopCount(1), s.stopCount(4)],
  'showStops': (s) => [s.showStops(1), s.showStops(4)],
  'hideStops': (s) => [s.hideStops(1), s.hideStops(4)],
  'stepCount': (s) => [s.stepCount(1), s.stepCount(4)],
  'showSteps': (s) => [s.showSteps(1), s.showSteps(4)],
  'hideSteps': (s) => [s.hideSteps(1), s.hideSteps(4)],
  'legDistanceDuration': (s) => [s.legDistanceDuration('0.4 mi', '8 min')],
  'relativeDirection': (s) => [
    for (final d in tp.RelativeDirection.values) s.relativeDirection(d),
  ],
  'stepInstruction': (s) => [
    for (final token in [null, 'RIGHT'])
      s.stepInstruction(
        tp.LegStep(
          distance: 186,
          streetName: 'Pine St',
          lat: 47.6,
          lon: -122.3,
          relativeDirection: token,
        ),
        tp.DistanceUnits.imperial,
      ),
  ],
  'placeName': (s) => [s.placeName(place('Westlake'))],
  'searchHint': (s) => [s.searchHint],
  'searchNoResults': (s) => [s.searchNoResults],
  'searchError': (s) => [s.searchError],
  'useCurrentLocation': (s) => [s.useCurrentLocation],
  'locationUnavailable': (s) => [s.locationUnavailable],
  'clearSearch': (s) => [s.clearSearch],
  'searchLabel': (s) => [s.searchLabel],
  'errorMessage': (s) => [
    s.errorMessage(const tp.MissingTripEndpointsError()),
    s.errorMessage(
      const tp.OtpPlannerException(tp.PlannerErrorCode.tooClose, 'x'),
    ),
    s.errorMessage(const tp.OtpNetworkException('x')),
    s.errorMessage(const tp.OtpHttpException(500)),
    s.errorMessage(const tp.OtpFormatException('x')),
    s.errorMessage(tp.OtpGraphQLException(const ['x'])),
    s.errorMessage(StateError('x')),
  ],
  'plannerError': (s) => [
    for (final c in tp.PlannerErrorCode.values) s.plannerError(c),
  ],
};

// -- Localizations used by the tests -------------------------------------------

/// Every string is `⟦member⟧`, so a bridged member that ignores the
/// localizations is easy to spot.
class _MarkerL10n implements ObaLocalizations {
  @override
  String get localeName => 'xx';

  @override
  dynamic noSuchMethod(Invocation invocation) => '⟦${invocation.memberName}⟧';
}

/// Pinned stand-in for Spanish: English with a few strings replaced, so the
/// expectations don't move when app_es.arb is edited.
class _FakeSpanish extends ObaLocalizationsEn {
  _FakeSpanish() : super('es');

  @override
  String get coreJustNow => 'Justo ahora';
  @override
  String get tripPlannerPlanTrip => 'Planificar viaje';
  @override
  String get tripPlannerOriginLabel => 'Desde';
  @override
  String get tripPlannerTripDetails => 'Detalles del viaje';
  @override
  String get arrivalsStopNotFound => 'Parada no encontrada';
  @override
  String get arrivalsRetry => 'Reintentar';
  @override
  String get arrivalsRefresh => 'Actualizar llegadas';
  @override
  String coreStopCodeNumeric(String code) => 'Parada n.º $code';
}

class _FakeSpanishDelegate extends LocalizationsDelegate<ObaLocalizations> {
  const _FakeSpanishDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'es' || locale.languageCode == 'en';

  @override
  Future<ObaLocalizations> load(Locale locale) => SynchronousFuture(
    locale.languageCode == 'es' ? _FakeSpanish() : ObaLocalizationsEn(),
  );

  @override
  bool shouldReload(_FakeSpanishDelegate old) => false;
}

const spanish = Locale('es');
const delegates = <LocalizationsDelegate<Object?>>[
  _FakeSpanishDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

void main() {
  final english = ObaLocalizationsEn();

  group('every member is bridged', () {
    for (final (label, path, className, cases) in [
      (
        'core',
        '../obakit_core/lib/src/format/strings.dart',
        'ObaL10nCoreStrings',
        coreCases.keys.toSet(),
      ),
      (
        'arrivals',
        '../oba_arrivals/lib/src/strings.dart',
        'ObaL10nArrivalsStrings',
        arrivalsCases.keys.toSet(),
      ),
      (
        'tripPlanner',
        '../obakit_trip_planner/lib/src/strings.dart',
        'ObaL10nTripPlannerStrings',
        tripPlannerCases.keys.toSet(),
      ),
    ]) {
      test(label, () {
        final declared = declaredMembers(path);
        expect(declared, isNotEmpty);
        final skipped = inherited[label] ?? const <String>{};
        expect(
          declared.difference(bridgedMembers(className)),
          skipped,
          reason: 'override the new members in $className (strings_bridge)',
        );
        expect(
          cases,
          declared,
          reason: 'add a sample call for each member to this test',
        );
      });
    }
  });

  group('English matches the packages\' defaults', () {
    void check<S>(Cases<S> cases, S defaults, S bridged) {
      for (final e in cases.entries) {
        expect(e.value(bridged), e.value(defaults), reason: e.key);
      }
    }

    test('core', () {
      check(coreCases, const ObaCoreStrings(), ObaL10nCoreStrings(english));
    });
    test('arrivals', () {
      check(
        arrivalsCases,
        const ObaArrivalsStrings(),
        ObaL10nArrivalsStrings(english),
      );
    });
    test('trip planner', () {
      check(
        tripPlannerCases,
        const tp.TripPlannerStrings(),
        ObaL10nTripPlannerStrings(english),
      );
    });
  });

  group('every bridged member reads ObaLocalizations', () {
    final marker = _MarkerL10n();
    void check<S>(String label, Cases<S> cases, S bridged) {
      final skipped = inherited[label] ?? const <String>{};
      for (final e in cases.entries) {
        if (skipped.contains(e.key)) continue;
        for (final s in e.value(bridged)) {
          expect(s, contains('⟦'), reason: '${e.key} returned "$s"');
        }
      }
    }

    test('core', () {
      check('core', coreCases, ObaL10nCoreStrings(marker));
    });
    test('arrivals', () {
      check('arrivals', arrivalsCases, ObaL10nArrivalsStrings(marker));
    });
    test('trip planner', () {
      check('tripPlanner', tripPlannerCases, ObaL10nTripPlannerStrings(marker));
    });
  });

  test('obakit never formats with the English-only core formatters', () {
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      if (file.path.endsWith('strings_bridge.dart')) continue;
      final lines = file.readAsLinesSync();
      for (final (i, line) in lines.indexed) {
        final exempt = i > 0 && lines[i - 1].contains('l10n-exempt');
        if (exempt) continue;
        if (RegExp(
          r'ObaFormatters\(|ObaCoreStrings\(|'
          r'TripPlannerStrings\(|ObaArrivalsStrings\(',
        ).hasMatch(line)) {
          offenders.add('${file.path}:${i + 1}: ${line.trim()}');
        }
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'use context.obaFormatters / context.obaTripPlannerStrings, '
          'or mark a non-UI use with a "// l10n-exempt" line above it',
    );
  });

  group('screens use the current locale', () {
    late ObaTestEnv env;
    tearDown(() => env.dispose());

    testWidgets('stop page: core formatter text', (tester) async {
      env = await ObaTestEnv.create(
        responses: {
          'arrivals-and-departures-for-stop': fixture(
            'arrivals_and_departures_for_stop_1_10020.json',
          ),
        },
      );
      const page = StopPage(stopId: '1_10020');
      await env.pumpPage(tester, page, localizationsDelegates: delegates);
      expect(find.textContaining('Just Now'), findsWidgets);
      expect(find.textContaining('Justo ahora'), findsNothing);

      // A runtime locale change reaches the formatter strings.
      await env.pumpPage(
        tester,
        page,
        locale: spanish,
        localizationsDelegates: delegates,
      );
      expect(find.textContaining('Justo ahora'), findsWidgets);
      expect(find.textContaining('Just Now'), findsNothing);
    });

    testWidgets('trip planner page and itinerary details', (tester) async {
      env = await ObaTestEnv.create();
      await env.pumpPage(
        tester,
        const TripPlannerPage(),
        presentation: ObaPresentation.embedded,
        locale: spanish,
        localizationsDelegates: delegates,
      );
      expect(find.text('Planificar viaje'), findsOneWidget);
      expect(find.text('Plan trip'), findsNothing);
      expect(find.textContaining('Desde'), findsWidgets);

      final itinerary = tp
          .parseGraphQLPlanResponse(
            jsonDecode(
              File(
                '../obakit_trip_planner/test/fixtures/graphql/'
                'soundtransit_westlake_to_udistrict.json',
              ).readAsStringSync(),
            ) as Map<String, dynamic>,
          )
          .itineraries
          .first;
      final route = ItineraryRoute(
        itinerary,
        mapConfig: tp.TripMapConfig(
          userAgentPackageName: 'test',
          tileProvider: env.app.map.tileProvider,
        ),
      );
      await env.pumpPage(
        tester,
        Builder(builder: route.build),
        locale: spanish,
        localizationsDelegates: delegates,
      );
      expect(find.text('Detalles del viaje'), findsOneWidget);
      expect(find.text('Trip details'), findsNothing);
    });

    testWidgets('an arrivals panel inside ObaScope, text and semantics', (
      tester,
    ) async {
      env = await ObaTestEnv.create();
      // 200 with an empty body: the "stop not found" error state.
      final client = OneBusAwayClient(
        baseUrl: Uri.parse('https://example.test/'),
        apiKey: 'test',
        httpClient: MockClient((_) async => http.Response('', 200)),
      );
      addTearDown(client.close);
      final panel = ObaArrivalsPanel(client: client, stopId: '1_24151');
      final handle = tester.ensureSemantics();
      await env.pumpPage(
        tester,
        SingleChildScrollView(child: panel),
        localizationsDelegates: delegates,
      );
      expect(
        find.text('Stop not found or service unavailable'),
        findsOneWidget,
      );
      expect(find.text('Stop #24151'), findsOneWidget);

      await env.pumpPage(
        tester,
        SingleChildScrollView(child: panel),
        locale: spanish,
        localizationsDelegates: delegates,
      );
      expect(find.text('Parada no encontrada'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
      expect(find.text('Parada n.º 24151'), findsOneWidget);
      expect(find.byTooltip('Actualizar llegadas'), findsOneWidget);
      // Screen readers get the translated name too.
      expect(
        tester.getSemantics(find.byTooltip('Actualizar llegadas')).tooltip,
        'Actualizar llegadas',
      );
      handle.dispose();

      // Strings the host passes itself still win.
      await env.pumpPage(
        tester,
        SingleChildScrollView(
          child: ObaArrivalsPanel(
            client: client,
            stopId: '1_24151',
            strings: const _HostStrings(),
          ),
        ),
        locale: spanish,
        localizationsDelegates: delegates,
      );
      expect(find.text('Host retry'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });
  });
}

class _HostStrings extends ObaArrivalsStrings {
  const _HostStrings();

  @override
  String get retry => 'Host retry';
}
