import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

class FakePlaces implements PlaceSearchProvider {
  FakePlaces([this.result = const []]);

  final List<Place> result;
  final queries = <String>[];

  @override
  Future<List<Place>> search(
    String query, {
    Coordinate? near,
    RegionRect? within,
  }) async {
    queries.add(query);
    return result;
  }
}

const needle = Place(
  name: 'Space Needle',
  subtitle: '400 Broad St, Seattle',
  coordinate: Coordinate(47.6205, -122.3493),
);

Future<void> typeQuery(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.pump();
}

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  testWidgets('empty query: prompt, no requests; a11y light and dark', (
    tester,
  ) async {
    env = await ObaTestEnv.create();
    await env.pumpPage(tester, const SearchPage());
    expect(find.text('Find routes, stops and places'), findsOneWidget);
    await typeQuery(tester, '   ');
    await tester.pump(const Duration(seconds: 1));
    expect(env.requests, isEmpty);
    await expectObaAccessibility(tester);
    await env.pumpPage(tester, const SearchPage(), themeMode: ThemeMode.dark);
    await expectObaAccessibility(tester);
    await env.expectNoOverflowAtTextScale(tester, const SearchPage());
  });

  testWidgets('typing shows quick rows the region supports', (tester) async {
    env = await ObaTestEnv.create();
    await env.pumpPage(tester, const SearchPage());
    await typeQuery(tester, '10');
    expect(find.text('Route: 10'), findsOneWidget);
    expect(find.text('Stop number: 10'), findsOneWidget);
    expect(find.text('Vehicle: 10'), findsOneWidget);
    // No place search provider configured.
    expect(find.text('Address: 10'), findsNothing);
    expect(env.requests, isEmpty);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Routes'));
    await tester.pump();
    expect(find.text('Route: 10'), findsOneWidget);
    expect(find.text('Stop number: 10'), findsNothing);
    expect(find.text('Vehicle: 10'), findsNothing);
    await expectObaAccessibility(tester);
  });

  testWidgets('places: debounced live results, recent place on tap', (
    tester,
  ) async {
    final places = FakePlaces([needle]);
    env = await ObaTestEnv.create(placeSearch: places);
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const SearchPage(),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    await typeQuery(tester, 's');
    await typeQuery(tester, 'sp');
    await typeQuery(tester, 'spa');
    expect(places.queries, isEmpty);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(places.queries, ['spa']);
    expect(find.text('Address: spa'), findsOneWidget);
    expect(find.text('Space Needle'), findsOneWidget);
    await tester.tap(find.text('Space Needle'));
    await tester.pump();
    expect(pushed.single, isA<PlaceRoute>());
    expect((pushed.single as PlaceRoute).place, needle);
    expect(env.app.core.userData.recentPlaces.single.name, 'Space Needle');
  });

  testWidgets('a single route opens its stops and records the search', (
    tester,
  ) async {
    env = await ObaTestEnv.create(
      responses: {
        'routes-for-location': fixture('routes_for_location_query.json'),
      },
    );
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const SearchPage(),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    await typeQuery(tester, '11');
    await tester.tap(find.text('Route: 11'));
    await ObaTestEnv.settle(tester);
    expect(pushed.single, const RouteStopsRoute('3_11'));
    expect(env.app.core.userData.recentSearches.first, '11');
    expect(env.requests.single.url.queryParameters['query'], '11');
  });

  testWidgets('several routes push the results list', (tester) async {
    env = await ObaTestEnv.create(
      responses: {
        'routes-for-location': fixture(
          'routes_for_location_downtown_seattle1.json',
        ),
      },
    );
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const SearchPage(),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    await typeQuery(tester, '1');
    // Enter under "All" runs the first quick search (route).
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await ObaTestEnv.settle(tester);
    final route = pushed.single as SearchResultsRoute;
    expect(route.request, const SearchRequest('1', SearchType.route));
    expect(route.result, isA<RouteSearchResult>());
  });

  testWidgets('Enter under All falls through to the stop number', (
    tester,
  ) async {
    env = await ObaTestEnv.create(
      responses: {
        // No route is called "75403"...
        'routes-for-location': fixture('stops_for_location_outofrange.json'),
        // ...but a stop has that number.
        'stops-for-location': fixture('stops_for_location_query.json'),
      },
    );
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const SearchPage(),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    await typeQuery(tester, '75403');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await ObaTestEnv.settle(tester);
    expect(pushed.single, isA<StopRoute>());
    expect(find.textContaining('No search results'), findsNothing);
  });

  testWidgets('no results and errors show a message', (tester) async {
    env = await ObaTestEnv.create(
      responses: {
        'stops-for-location': fixture('stops_for_location_outofrange.json'),
      },
    );
    await env.pumpPage(tester, const SearchPage());
    await typeQuery(tester, '99999');
    await tester.tap(find.text('Stop number: 99999'));
    await ObaTestEnv.settle(tester);
    expect(
      find.text('No search results were found for “99999”.'),
      findsOneWidget,
    );
    await expectObaAccessibility(tester);
    await tester.tap(find.byTooltip('Dismiss'));
    await tester.pump();
    expect(find.textContaining('No search results'), findsNothing);

    // Routes are not stubbed: the server error reads as a message.
    await tester.tap(find.text('Route: 99999'));
    await ObaTestEnv.settle(tester);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('address search without a provider explains why', (tester) async {
    env = await ObaTestEnv.create();
    await env.pumpPage(tester, const SearchPage());
    await tester.tap(find.widgetWithText(ChoiceChip, 'Places'));
    await typeQuery(tester, 'pike');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await ObaTestEnv.settle(tester);
    expect(
      find.text('Address search isn\'t set up in this app.'),
      findsOneWidget,
    );
  });

  testWidgets('local matches and recent searches', (tester) async {
    env = await ObaTestEnv.create();
    final region = env.app.core.currentRegion!.id;
    env.app.core.userData.addRecentStop(
      const StoredStop(
        id: '1_75403',
        name: 'Pine St & 3rd Ave',
        lat: 47.61,
        lon: -122.34,
        code: '75403',
        direction: 'N',
        routeIds: [],
        routes: [],
      ),
      regionId: region,
    );
    env.app.core.userData.addRecentSearch('Route 44');
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const SearchPage(),
      presentation: ObaPresentation.embedded,
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    expect(find.text('Recent searches'), findsOneWidget);
    await tester.tap(find.text('Route 44'));
    await tester.pump();
    expect(find.text('Route: Route 44'), findsOneWidget);

    await typeQuery(tester, 'pine');
    expect(find.text('Recent stops'), findsOneWidget);
    await tester.tap(find.text('Pine St & 3rd Ave'));
    await tester.pump();
    expect(pushed.single, const StopRoute('1_75403'));
  });

  testWidgets('clear recent searches asks first', (tester) async {
    env = await ObaTestEnv.create();
    env.app.core.userData.addRecentSearch('44');
    await env.pumpPage(tester, const SearchPage());
    await tester.tap(find.text('Clear recent searches'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(env.app.core.userData.recentSearches, isEmpty);
    expect(find.text('Find routes, stops and places'), findsOneWidget);
  });

  testWidgets('works in the sheet presentation', (tester) async {
    env = await ObaTestEnv.create();
    await env.pumpPage(
      tester,
      const SearchPage(initialQuery: '44'),
      presentation: ObaPresentation.sheet,
    );
    expect(find.text('Route: 44'), findsOneWidget);
    await env.expectNoOverflowAtTextScale(
      tester,
      const SearchPage(initialQuery: '44'),
      presentation: ObaPresentation.sheet,
    );
  });
}
