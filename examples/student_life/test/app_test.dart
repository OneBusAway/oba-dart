// The app with real SDK widgets over a MockClient (captured fixtures).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:student_life_example/data/campus.dart';
import 'package:student_life_example/screens/campus_tab.dart';
import 'package:student_life_example/screens/event_detail_page.dart';
import 'package:student_life_example/screens/transit_tab.dart';
import 'package:student_life_example/widgets/host_page.dart';

import 'support/test_env.dart';

void main() {
  Future<TestEnv> env({
    bool showObaEmbeds = false,
    ThemeMode themeMode = ThemeMode.light,
  }) async {
    final e = await TestEnv.create(
      showObaEmbeds: showObaEmbeds,
      themeMode: themeMode,
      responses: {
        'arrivals-and-departures-for-stop': fixture('arrivals_mts_24151.json'),
        'stops-for-location': fixture('stops_for_location_query.json'),
      },
    );
    addTearDown(e.dispose);
    return e;
  }

  testWidgets('the San Diego region is fixed, with no regions download', (
    tester,
  ) async {
    final e = await env();
    expect(e.oba.core.currentRegion?.regionName, 'San Diego');
    expect(e.requests.where((r) => r.url.path.contains('regions')), isEmpty);
  });

  testWidgets('Today builds with its OBA embeds and live shuttle departures', (
    tester,
  ) async {
    final e = await env();
    await tester.pumpWidget(e.app());
    await TestEnv.settle(tester);

    expect(find.text('Next class'), findsOneWidget);
    expect(find.byType(ObaStopDeparturesCard), findsOneWidget);
    expect(find.byType(ServiceAlertsSection), findsOneWidget);
    expect(find.text('Eighth College / Theatre District'), findsWidgets);
    expect(find.text('Old Town'), findsWidgets);
    expect(
      e.requests.where(
        (r) => r.url.path.endsWith(
          'arrivals-and-departures-for-stop/MTS_24151.json',
        ),
      ),
      isNotEmpty,
    );
    expect(e.writes, isEmpty);
    await expectAccessible(tester);
  });

  testWidgets('Today is accessible in dark mode', (tester) async {
    final e = await env(themeMode: ThemeMode.dark);
    await tester.pumpWidget(e.app());
    await TestEnv.settle(tester);
    expect(
      Theme.of(tester.element(find.text('Next class'))).brightness,
      Brightness.dark,
    );
    await expectAccessible(tester);
  });

  testWidgets('the embed overlay labels every SDK widget on Today', (
    tester,
  ) async {
    final e = await env(showObaEmbeds: true);
    await tester.pumpWidget(e.app());
    await TestEnv.settle(tester);
    expect(find.text('OBA · ObaStopDeparturesCard'), findsOneWidget);
    expect(find.text('OBA · ServiceAlertsSection'), findsOneWidget);
  });

  testWidgets('a campus stop opens through the host onNavigate', (
    tester,
  ) async {
    final e = await env();
    await tester.pumpWidget(
      e.app(
        home: const Scaffold(
          body: SingleChildScrollView(
            child: CampusStopsList(stops: campusStops),
          ),
        ),
      ),
    );
    await TestEnv.settle(tester);

    await tester.tap(find.text('Eighth College / Theatre District'));
    await TestEnv.settle(tester);

    // The host's route: its own app bar with a generic title, and the SDK
    // stop page embedded below it (no second app bar). The stop's name
    // shows once, in the SDK page's compact header.
    final host = tester.widget<HostObaPage>(find.byType(HostObaPage));
    expect(host.title, 'Transit');
    expect(host.showsHeader, isTrue);
    expect(find.byType(AppBar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.textContaining('Eighth College'),
      ),
      findsNothing,
    );
    expect(
      find.text('Eighth College / Theatre District (North)'),
      findsOneWidget,
    );
    final page = tester.widget<StopPage>(find.byType(StopPage));
    expect(page.stopId, 'MTS_24151');
    expect(e.writes, isEmpty);
  });

  for (final (route, title, sdkPage) in [
    (const StopRoute('MTS_1'), 'Transit', StopPage),
    (const AlertsListRoute(), 'Service alerts', AlertsListPage),
    (const RecentStopsRoute(), 'Recent stops', RecentStopsPage),
    (const TripPlannerRoute(), 'Trip planner', TripPlannerPage),
  ]) {
    testWidgets('onNavigate opens ${route.id} under the host app bar', (
      tester,
    ) async {
      final e = await env();
      await tester.pumpWidget(
        e.app(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => ObaNavigator.of(context).push(route),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await TestEnv.settle(tester);
      expect(find.byType(sdkPage), findsOneWidget);
      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text(title)),
        findsOneWidget,
      );
      // Only the host's app bar; the SDK page is embedded.
      expect(find.byType(AppBar), findsOneWidget);
      final modal = ModalRoute.of(tester.element(find.byType(HostObaPage)));
      expect(modal?.settings.arguments, route);
      expect(e.writes, isEmpty);
    });
  }

  testWidgets('Campus: an event opens its detail page with nearby stops', (
    tester,
  ) async {
    final e = await env();
    await tester.pumpWidget(e.app(home: const CampusTab()));
    await TestEnv.settle(tester);
    expect(find.text('Winter Career Fair'), findsOneWidget);
    expect(find.text('Tritons Basketball vs. UC Irvine'), findsOneWidget);
    expect(find.text('Finals Study Jam'), findsOneWidget);
    await expectAccessible(tester);

    await tester.tap(find.text('Tritons Basketball vs. UC Irvine'));
    await TestEnv.settle(tester);
    expect(find.byType(EventDetailPage), findsOneWidget);
    expect(find.bySemanticsLabel('Where: RIMAC Arena'), findsOneWidget);
    expect(find.text('Getting there'), findsOneWidget);
    final card = tester.widget<ObaNearbyStopsCard>(
      find.byType(ObaNearbyStopsCard),
    );
    expect(card.around, CampusPlaces.rimacArena.coordinate);
    // Plan a trip: the trip planner as its own route, to the venue.
    await tester.tap(
      find.widgetWithText(FilledButton, 'Plan a trip to RIMAC Arena'),
    );
    await TestEnv.settle(tester);
    final planner = tester.widget<TripPlannerPage>(
      find.byType(TripPlannerPage),
    );
    expect(planner.destination?.name, 'RIMAC Arena');
    expect(planner.destination?.coordinate, CampusPlaces.rimacArena.coordinate);
    expect(find.byType(EventDetailPage, skipOffstage: false), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Directions to RIMAC Arena'), findsOneWidget);
    expect(e.writes, isEmpty);
  });

  testWidgets('Today reflows at 200% text with its embeds', (tester) async {
    final e = await env(showObaEmbeds: true);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(e.app());
    await TestEnv.settle(tester);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Featured event'), 300);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Transit shows the map, nearby stops, bookmarks and campus '
      'stops; the map opens full screen', (tester) async {
    final e = await env(showObaEmbeds: true);
    mockMapTileCache();
    // Tall enough to show the whole tab without scrolling.
    await tester.binding.setSurfaceSize(const Size(600, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(e.app());
    await TestEnv.settle(tester);
    await tester.tap(find.text('Transit'));
    await TestEnv.settle(tester);

    expect(find.byType(ObaMapView), findsOneWidget);
    expect(find.text('OBA · ObaMapView'), findsOneWidget);
    expect(find.byType(NearbyStopsSection), findsOneWidget);
    // One heading for the nearby section: the SDK's own, with the host's
    // wording. No second host heading above it.
    expect(find.text('Near campus'), findsOneWidget);
    expect(find.text('Nearby'), findsNothing);
    expect(find.text('Gilman Transit Center'), findsOneWidget);
    expect(find.byType(ObaBookmarksCard), findsOneWidget);

    await tester.tap(find.text('Open full map'));
    await TestEnv.settle(tester);
    expect(find.byType(FullMapPage), findsOneWidget);
    expect(e.writes, isEmpty);
  });

  testWidgets('Directions opens the trip planner under the host app bar', (
    tester,
  ) async {
    final e = await env();
    await tester.pumpWidget(e.app());
    await TestEnv.settle(tester);
    await tester.tap(find.text('Directions to Center Hall'));
    await TestEnv.settle(tester);

    expect(find.byType(HostObaPage), findsOneWidget);
    expect(find.byType(TripPlannerPage), findsOneWidget);
    // Its own route, not drawn inline in the feed.
    expect(
      ModalRoute.of(tester.element(find.byType(TripPlannerPage)))
          ?.settings
          .arguments,
      isA<TripPlannerRoute>(),
    );
    // Embedded: the SDK page draws no app bar of its own.
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Directions to Center Hall'), findsOneWidget);
    final page = tester.widget<TripPlannerPage>(find.byType(TripPlannerPage));
    expect(page.destination?.name, 'Center Hall');
  });

  testWidgets('Me: saved stops and alerts open SDK pages in host routes', (
    tester,
  ) async {
    final e = await env();
    await tester.pumpWidget(e.app());
    await TestEnv.settle(tester);
    await tester.tap(find.text('Me'));
    await TestEnv.settle(tester);

    await tester.tap(find.text('Saved stops'));
    await TestEnv.settle(tester);
    expect(find.byType(BookmarksPage), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Saved stops'),
      ),
      findsOneWidget,
    );
    await tester.pageBack();
    await TestEnv.settle(tester);

    await tester.tap(find.text('Service alerts'));
    await TestEnv.settle(tester);
    expect(find.byType(AlertsListPage), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(e.writes, isEmpty);
  });
}
