import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  const routesRequest = SearchRequest('1', SearchType.route);

  testWidgets('runs the search, lists routes, opens one', (tester) async {
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
      const SearchResultsPage(request: routesRequest),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    expect(find.text('10 results for “1”'), findsOneWidget);
    expect(find.text('Routes'), findsOneWidget);
    await tester.tap(find.text('12').first);
    await tester.pump();
    expect(pushed.single, const RouteStopsRoute('1_12'));
    await expectObaAccessibility(tester);
    await env.pumpPage(
      tester,
      const SearchResultsPage(request: routesRequest),
      themeMode: ThemeMode.dark,
    );
    await expectObaAccessibility(tester);
    await env.expectNoOverflowAtTextScale(
      tester,
      const SearchResultsPage(request: routesRequest),
    );
  });

  testWidgets('stops: listed and drawn on the map', (tester) async {
    env = await ObaTestEnv.create(
      responses: {
        'stops-for-location': fixture('stops_for_location_seattle.json'),
      },
    );
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const SearchResultsPage(
        request: SearchRequest('15th', SearchType.stopNumber),
      ),
      coordinator: map,
      presentation: ObaPresentation.sheet,
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    expect(find.text('Stops'), findsOneWidget);
    expect(map.overlay.stops, hasLength(26));
    expect(map.overlay.fitBounds, isNotNull);
    await tester.tap(find.text('15th Ave NE & NE Campus Pkwy'));
    await tester.pump();
    expect(pushed.single, const StopRoute('1_10914'));
  });

  testWidgets('vehicle matches: picking one opens its trip', (tester) async {
    env = await ObaTestEnv.create(
      responses: {
        'vehicles': fixture('vehicles-query-1_1.json'),
        'vehicle/': fixture('vehicle_for_id_4011.json'),
      },
    );
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const SearchResultsPage(
        request: SearchRequest('1_1', SearchType.vehicleId),
      ),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    expect(find.text('Vehicles'), findsOneWidget);
    await tester.tap(find.text('Vehicle 1_1156'));
    await ObaTestEnv.settle(tester);
    final trip = pushed.single as TripRoute;
    expect(trip.trip.tripId, '40_40804394');
    await expectObaAccessibility(tester);
  });

  testWidgets('places from a finished search, with map markers', (
    tester,
  ) async {
    env = await ObaTestEnv.create();
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    const request = SearchRequest('coffee', SearchType.address);
    const places = [
      Place(name: 'Cafe A', coordinate: Coordinate(47.61, -122.33)),
      Place(
        name: 'Cafe B',
        subtitle: '1 Pike St',
        coordinate: Coordinate(47.62, -122.34),
      ),
    ];
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const SearchResultsPage(
        request: request,
        result: PlaceSearchResult(request, places),
      ),
      coordinator: map,
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    expect(env.requests, isEmpty);
    expect(map.overlay.markers.map((m) => m.label), [
      'Place: Cafe A',
      'Place: Cafe B',
    ]);
    await tester.tap(find.text('Cafe B'));
    await tester.pump();
    expect((pushed.single as PlaceRoute).place, places[1]);
  });

  testWidgets('error with retry; empty result', (tester) async {
    env = await ObaTestEnv.create();
    await env.pumpPage(tester, const SearchResultsPage(request: routesRequest));
    expect(find.text('Try again'), findsOneWidget);
    await expectObaAccessibility(tester);

    const empty = SearchRequest('zzz', SearchType.address);
    await env.pumpPage(
      tester,
      const SearchResultsPage(
        request: empty,
        result: PlaceSearchResult(empty, []),
      ),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('No results'), findsOneWidget);
  });
}
