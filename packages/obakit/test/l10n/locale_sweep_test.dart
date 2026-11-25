// Every supported locale on the main surfaces, with realistic fixture data,
// at 100% and 200% text on a 390x844 phone: no exceptions (a malformed
// message throws when it is formatted), no layout overflow, and the
// accessibility guidelines. Translations are often much longer than English
// (and Arabic is right-to-left), so this is where a layout that only fits
// English shows up.
//
// Run one locale: flutter test test/l10n/locale_sweep_test.dart --plain-name "[ru]"

import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import '../support/oba_test_harness.dart';

const _phone = Size(390, 844);

/// The server time of `arrivals_mts_24151.json` (bookmarks).
final _mtsNow = DateTime.fromMillisecondsSinceEpoch(1790228579290);

/// The server time of the MTS 11670 alerts fixture.
final _alertsNow = DateTime.fromMillisecondsSinceEpoch(1474553212655);

final _trip = TripRef(
  tripId: '1_18196913',
  serviceDate: DateTime.fromMillisecondsSinceEpoch(1343631600000),
  stopId: '1_29930',
  stopSequence: 10,
  vehicleId: '1_4011',
);

final _downtown = ObaLocation(
  lat: 47.6097,
  lon: -122.3331,
  timestamp: DateTime.utc(2026),
);

/// Sound Transit OTP 2.x capture (Westlake to U District).
tp.TripPlan _plan() => tp.parseGraphQLPlanResponse(
  jsonDecode(
    File(
      '../obakit_trip_planner/test/fixtures/graphql/'
      'soundtransit_westlake_to_udistrict.json',
    ).readAsStringSync(),
  ) as Map<String, dynamic>,
);

class _FixedPlanService implements tp.TripPlanService {
  @override
  bool get supportsVehicleRental => false;

  @override
  Future<tp.TripPlan> plan(tp.TripPlanRequest request) async => _plan();
}

class _NoSearch implements tp.TripPlaceSearch {
  @override
  Future<List<tp.TripPlace>> search(String query, {tp.TripPlace? near}) async =>
      const [];
}

/// The trip planner form with a plan loaded, as the SDK page shows it but
/// with a fixture-backed service (the real one only talks to OTP servers).
class _PlannedTrip extends StatelessWidget {
  const _PlannedTrip();

  @override
  Widget build(BuildContext context) => ObaSheetPage(
    title: context.obaL10n.titleTripPlanner,
    body: tp.TripPlannerView(
      service: _FixedPlanService(),
      strings: context.obaTripPlannerStrings,
      placeSearch: _NoSearch(),
      mapConfig: tp.TripMapConfig(
        userAgentPackageName: 'org.onebusaway.test',
        tileProvider: FakeTileProvider(),
      ),
      initialOrigin: const tp.TripPlace(
        name: 'Westlake Station',
        lat: 47.6114,
        lon: -122.3374,
      ),
      initialDestination: const tp.TripPlace(
        name: 'U District Station',
        lat: 47.6603,
        lon: -122.3140,
      ),
    ),
  );
}

/// One surface of the sweep.
class _Surface {
  const _Surface(
    this.name, {
    required this.env,
    required this.page,
    this.now,
    this.after,
  });

  final String name;
  final Future<ObaTestEnv> Function() env;
  final Widget Function() page;

  /// A fixed clock for fixtures whose times matter.
  final DateTime? now;

  /// Runs after the page settles (expand the sheet, type a query, ...).
  final Future<void> Function(WidgetTester tester, ObaLocalizations l10n)?
  after;
}

Bookmark _stopBookmark() => Bookmark.forStop(
  name: 'Work',
  regionId: 1,
  stop: const StoredStop(
    id: 'MTS_24151',
    name: 'Pine St & 3rd Ave',
    lat: 47.61,
    lon: -122.34,
    code: '24151',
    direction: 'N',
  ),
);

final _surfaces = <_Surface>[
  _Surface(
    'home shell, sheet raised',
    env: () async {
      final env = await ObaTestEnv.create(
        permission: LocationPermissionStatus.whileInUse,
        location: _downtown,
        responses: {
          'stops-for-location': fixture('stops_for_location_seattle.json'),
          'arrivals-and-departures-for-stop': fixture(
            'arrivals_and_departures_for_stop_1_10020.json',
          ),
        },
      );
      env.app.core.userData.addBookmark(_stopBookmark());
      return env;
    },
    page: () => const ObaHomeShell(),
    after: (tester, _) async {
      tester.state<ObaHomeShellState>(find.byType(ObaHomeShell)).sheet.expand();
      await ObaTestEnv.settle(tester);
    },
  ),
  _Surface(
    'stop page',
    env: () => ObaTestEnv.create(
      responses: {
        'arrivals-and-departures-for-stop': fixture(
          'arrivals_and_departures_for_stop_1_10020.json',
        ),
      },
    ),
    page: () => const StopPage(stopId: '1_10020'),
  ),
  _Surface(
    'stop page with alerts',
    now: _alertsNow,
    env: () => ObaTestEnv.create(
      responses: {
        'arrivals-and-departures-for-stop': fixture(
          'arrivals_and_departures_for_stop_mts_11670_route_alerts.json',
        ),
      },
    ),
    page: () => const StopPage(stopId: 'MTS_11670'),
  ),
  _Surface(
    'trip page',
    env: () => ObaTestEnv.create(
      responses: {
        'trip-details': fixture('trip_details_1_18196913.json'),
        'arrival-and-departure-for-stop': fixture(
          'arrival_for_trip_1_18196913.json',
        ),
        'shape': fixture('shape_1_20010002.json'),
      },
    ),
    page: () => TripPage(trip: _trip),
  ),
  _Surface(
    'bookmarks page',
    now: _mtsNow,
    env: () async {
      final env = await ObaTestEnv.create(
        responses: {
          'arrivals-and-departures-for-stop': fixture(
            'arrivals_mts_24151.json',
          ),
        },
      );
      env.app.core.userData.addBookmark(_stopBookmark());
      return env;
    },
    page: () => const BookmarksPage(),
  ),
  _Surface(
    'search page, typed',
    env: () => ObaTestEnv.create(),
    page: () => const SearchPage(),
    after: (tester, _) async {
      await tester.enterText(find.byType(TextField), '10');
      await tester.pumpAndSettle();
    },
  ),
  _Surface(
    'search results',
    env: () => ObaTestEnv.create(
      responses: {
        'routes-for-location': fixture(
          'routes_for_location_downtown_seattle1.json',
        ),
      },
    ),
    page: () =>
        const SearchResultsPage(request: SearchRequest('1', SearchType.route)),
  ),
  _Surface(
    'settings page',
    env: () => ObaTestEnv.create(),
    page: () => const SettingsPage(),
  ),
  _Surface(
    'more page',
    env: () => ObaTestEnv.create(),
    page: () => const MorePage(),
  ),
  for (final step in OnboardingStep.values)
    _Surface(
      'onboarding ${step.name}',
      env: () => ObaTestEnv.create(onboardingDone: false),
      page: () => OnboardingStepPage(step: step, onComplete: () {}),
    ),
  _Surface(
    'trip planner, form',
    env: () => ObaTestEnv.create(),
    page: () => const TripPlannerPage(),
  ),
  _Surface(
    'trip planner, results',
    env: () => ObaTestEnv.create(),
    page: () => const _PlannedTrip(),
    after: (tester, l10n) async {
      final plan = find.descendant(
        of: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        matching: find.text(l10n.tripPlannerPlanTrip),
      );
      // The form is a lazy list: scroll the button into existence.
      await tester.scrollUntilVisible(
        plan,
        200,
        scrollable: find
            .descendant(
              of: find.byType(tp.TripPlannerView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(plan);
      await ObaTestEnv.settle(tester);
      expect(find.byType(tp.ItineraryCard, skipOffstage: false), findsWidgets);
    },
  ),
  _Surface(
    'itinerary',
    env: () => ObaTestEnv.create(),
    page: () => Builder(
      builder: ItineraryRoute(
        _plan().itineraries.first,
        mapConfig: tp.TripMapConfig(
          userAgentPackageName: 'org.onebusaway.test',
          tileProvider: FakeTileProvider(),
        ),
      ).build,
    ),
  ),
  _Surface(
    'alerts list',
    now: _alertsNow,
    env: () => ObaTestEnv.create(
      responses: {
        'arrivals-and-departures-for-stop': fixture(
          'arrivals_and_departures_for_stop_mts_11670_route_alerts.json',
        ),
      },
    ),
    page: () => const AlertsListPage(stopId: 'MTS_11670'),
  ),
  _Surface(
    'report a stop problem',
    env: () => ObaTestEnv.create(),
    page: () => const ReportStopProblemPage(stopId: '1_10020'),
  ),
  _Surface(
    'report a trip problem',
    env: () => ObaTestEnv.create(),
    page: () => ReportTripProblemPage(trip: _trip),
  ),
];

void main() {
  for (final locale in obaSupportedLocales) {
    final tag = locale.toLanguageTag();
    group('[$tag]', () {
      for (final surface in _surfaces) {
        testWidgets(surface.name, (tester) async {
          Future<void> body() async {
            final env = await surface.env();
            addTearDown(env.dispose);
            final l10n = lookupObaLocalizations(locale);
            for (final scale in const [1.0, 2.0]) {
              await env.pumpPage(
                tester,
                Builder(builder: (_) => surface.page()),
                locale: locale,
                textScale: scale,
                surfaceSize: _phone,
              );
              await surface.after?.call(tester, l10n);
              final error = tester.takeException();
              expect(
                error,
                isNull,
                reason:
                    '${surface.name} in $tag at ${scale}x\n'
                    '${_overflowingFlexes(tester)}',
              );
              expect(
                Directionality.of(tester.element(find.byType(Scaffold).first)),
                locale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              );
              await expectObaAccessibility(
                tester,
                // The test font draws Hangul and Han as hollow boxes, so the
                // pixel-sampling contrast check misreads them (colours are
                // locale-independent and checked in every other locale).
                checkContrast: !const {
                  'ko',
                  'zh',
                }.contains(locale.languageCode),
              );
            }
            await tester.pumpWidget(const SizedBox());
          }

          final now = surface.now;
          if (now == null) {
            await body();
          } else {
            await withClock(Clock.fixed(now), body);
          }
        });
      }
    });
  }
}

/// Describes each Flex whose children are bigger than it (an overflow):
/// its ancestors and the text inside, to point at the widget to fix.
String _overflowingFlexes(WidgetTester tester) {
  final out = StringBuffer();
  void visit(Element e) {
    final r = e.renderObject;
    if (e.widget is Flex && r is RenderBox && r.hasSize) {
      final flex = e.widget as Flex;
      double total = 0;
      r.visitChildren((c) {
        if (c is RenderBox && c.hasSize) {
          total += flex.direction == Axis.horizontal
              ? c.size.width
              : c.size.height;
        }
      });
      final own = flex.direction == Axis.horizontal
          ? r.size.width
          : r.size.height;
      if (total > own + 0.5) {
        final chain = <String>[];
        e.visitAncestorElements((a) {
          chain.add(a.widget.runtimeType.toString());
          return chain.length < 14;
        });
        final texts = <String>[];
        void t(Element x) {
          if (x.widget case RichText(:final text)) {
            texts.add(text.toPlainText());
          }
          x.visitChildren(t);
        }

        t(e);
        out.writeln(
          'overflow by ${total - own}: ${chain.join(' < ')}\n'
          '  text: $texts',
        );
      }
    }
    e.visitChildren(visit);
  }

  tester.binding.rootElement!.visitChildren(visit);
  return out.toString();
}
