// The app with real SDK widgets over a MockClient (captured fixtures).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;
import 'package:student_life_example/chosen_trip.dart';
import 'package:student_life_example/data/campus.dart';
import 'package:student_life_example/screens/campus_tab.dart';
import 'package:student_life_example/screens/event_detail_page.dart';
import 'package:student_life_example/screens/today_tab.dart';
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
    // Tall enough to build the whole feed.
    await tester.binding.setSurfaceSize(const Size(600, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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
    // Tall enough to build the whole feed.
    await tester.binding.setSurfaceSize(const Size(600, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
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

  group('Your trip on Today', () {
    testWidgets('prompts to plan a trip when none is chosen', (tester) async {
      final e = await env();
      await tester.pumpWidget(e.app());
      await TestEnv.settle(tester);
      expect(find.byType(ChosenTripCard), findsOneWidget);
      expect(find.textContaining('No trip planned'), findsOneWidget);
      expect(find.textContaining('Leave by'), findsNothing);

      await tester.ensureVisible(
        find.widgetWithText(OutlinedButton, 'Plan a trip'),
      );
      await tester.tap(find.widgetWithText(OutlinedButton, 'Plan a trip'));
      await TestEnv.settle(tester);
      final page = tester.widget<TripPlannerPage>(find.byType(TripPlannerPage));
      expect(page.destination, isNull);
      expect(page.onItinerarySelected, isNotNull);
    });

    testWidgets('Directions: the itinerary the student opens shows on Today, '
        'and clears', (tester) async {
      final e = await env();
      // The itinerary's details page draws a map.
      mockMapTileCache();
      await tester.pumpWidget(e.app());
      await TestEnv.settle(tester);
      await tester.tap(find.text('Directions to Center Hall'));
      await TestEnv.settle(tester);

      await openItinerary(
        tester,
        westlakeItinerary(endingAt: CampusPlaces.centerHall.coordinate),
      );
      await TestEnv.settle(tester);
      // The SDK still opens the itinerary's details after the callback.
      expect(find.byType(TripPlannerPage, skipOffstage: false), findsOneWidget);
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      navigator.popUntil((r) => r.isFirst);
      await TestEnv.settle(tester);

      expect(find.text('Leave by 9:00 AM · 1 Line'), findsOneWidget);
      expect(find.text('To Center Hall'), findsOneWidget);
      expect(find.textContaining('No trip planned'), findsNothing);
      await expectAccessible(tester);

      await tester.ensureVisible(find.text('Clear trip'));
      await tester.tap(find.text('Clear trip'));
      await tester.pump();
      expect(find.textContaining('Leave by'), findsNothing);
      expect(find.textContaining('No trip planned'), findsOneWidget);
      expect(e.writes, isEmpty);
    });

    testWidgets('an event\'s Plan a trip sets the trip to its venue', (
      tester,
    ) async {
      final e = await env();
      // The itinerary's details page draws a map.
      mockMapTileCache();
      await tester.pumpWidget(e.app());
      await TestEnv.settle(tester);
      await tester.scrollUntilVisible(find.text('Winter Career Fair'), 300);
      await tester.tap(find.text('Winter Career Fair'));
      await TestEnv.settle(tester);
      await tester.tap(
        find.widgetWithText(FilledButton, 'Plan a trip to Price Center'),
      );
      await TestEnv.settle(tester);
      await openItinerary(
        tester,
        westlakeItinerary(endingAt: CampusPlaces.priceCenter.coordinate),
      );
      await TestEnv.settle(tester);

      final trip = ChosenTripScope.read(
        tester.element(find.byType(TripPlannerPage, skipOffstage: false)),
      )!;
      expect(trip.destination, 'Price Center');
      expect(tripRouteLabel(trip.itinerary!), '1 Line');
      tester
          .state<NavigatorState>(find.byType(Navigator).first)
          .popUntil((r) => r.isFirst);
      await TestEnv.settle(tester);
      await tester.scrollUntilVisible(find.text('To Price Center'), -300);
      expect(find.text('Leave by 9:00 AM · 1 Line'), findsOneWidget);
    });
  });

  test('the trip keeps the prefilled name only if it ends there', () {
    final hall = CampusPlaces.centerHall;
    // Ends at Center Hall: the prefilled name.
    expect(
      tripDestinationName(
        westlakeItinerary(endingAt: hall.coordinate),
        name: hall.name,
        coordinate: hall.coordinate,
      ),
      'Center Hall',
    );
    // The student picked somewhere else in the planner, and OTP calls it
    // only "Destination".
    expect(
      tripDestinationName(
        westlakeItinerary(),
        name: hall.name,
        coordinate: hall.coordinate,
      ),
      'your destination',
    );
  });

  test('the route label falls back to the mode, then to Walk', () {
    final it = westlakeItinerary();
    final noName = tp.Itinerary(
      duration: it.duration,
      startTime: it.startTime,
      endTime: it.endTime,
      legs: [
        for (final leg in it.legs)
          leg.transitLeg
              ? tp.Leg(
                  startTime: leg.startTime,
                  endTime: leg.endTime,
                  mode: 'BUS',
                  from: leg.from,
                  to: leg.to,
                  transitLeg: true,
                )
              : leg,
      ],
    );
    expect(tripRouteLabel(noName), 'Bus');
    final walk = tp.Itinerary(
      duration: 60,
      startTime: it.startTime,
      endTime: it.endTime,
      legs: [it.legs.first],
    );
    expect(tripRouteLabel(walk), 'Walk');
  });
}
