import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;
import 'package:obakit/src/features/search/place_page.dart'
    show placeMapsAppUrl;
import 'package:obakit/src/features/search/search_routes.dart'
    show buildWeatherAccessory, searchHomeSections;

import '../../support/oba_test_harness.dart';
import 'nearby_test.dart' show makeEnv, udistrict;

const needle = Place(
  name: 'Space Needle',
  subtitle: '400 Broad St, Seattle',
  coordinate: Coordinate(47.6205, -122.3493),
);

const pin = Place(
  name: 'Dropped pin',
  coordinate: Coordinate(47.61, -122.33),
  id: 'dropped-47.61,-122.33',
);

/// 15:30 Pacific on the weather fixture's day (22:30 UTC).
final weatherTime = DateTime.utc(2018, 10, 17, 22, 30);

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  group('PlacePage', () {
    testWidgets('details, actions and navigation', (tester) async {
      env = await ObaTestEnv.create(
        location: udistrict,
        permission: LocationPermissionStatus.whileInUse,
      );
      final pushed = <ObaRoute>[];
      await env.pumpPage(
        tester,
        const PlacePage(place: needle),
        onNavigate: (_, r) {
          pushed.add(r);
          return true;
        },
      );
      expect(find.text('Space Needle'), findsWidgets);
      expect(find.text('400 Broad St, Seattle'), findsOneWidget);
      expect(find.text('47.62050, -122.34930'), findsOneWidget);
      expect(find.text('Distance'), findsOneWidget);
      expect(find.text('Remove pin'), findsNothing);

      await tester.tap(find.text('Directions to here'));
      await tester.tap(find.text('Directions from here'));
      await tester.tap(find.text('Nearby stops'));
      await tester.pump();
      expect(pushed, [
        const TripPlannerRoute(destination: needle),
        const TripPlannerRoute(origin: needle),
        const NearbyStopsRoute(coordinate: Coordinate(47.6205, -122.3493)),
      ]);
      expect((pushed[0] as TripPlannerRoute).destination, needle);
      expect((pushed[2] as NearbyStopsRoute).coordinate, needle.coordinate);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Open in maps app'), findsOneWidget);

      await expectObaAccessibility(tester);
      await env.pumpPage(
        tester,
        const PlacePage(place: needle),
        themeMode: ThemeMode.dark,
      );
      await expectObaAccessibility(tester);
      await env.expectNoOverflowAtTextScale(
        tester,
        const PlacePage(place: needle, isDroppedPin: true),
      );
    });

    testWidgets('dropped pin: marker on the map, remove pin pops', (
      tester,
    ) async {
      env = await ObaTestEnv.create(region: 'MTA New York');
      final map = ObaMapCoordinator();
      addTearDown(map.dispose);
      await env.pumpPage(
        tester,
        const PlacePage(place: pin, isDroppedPin: true),
        coordinator: map,
      );
      expect(map.overlay.markers.single.label, 'Place: Dropped pin');
      // No trip planning in this region.
      expect(find.text('Directions to here'), findsNothing);

      await env.pumpPage(
        tester,
        Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () =>
                  ObaNavigator.of(context)
                      .push(const PlaceRoute(pin, isDroppedPin: true)),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await ObaTestEnv.settle(tester);
      await tester.tap(find.text('Remove pin'));
      await ObaTestEnv.settle(tester);
      expect(find.text('Remove pin'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    test('maps app links', () {
      expect(
        placeMapsAppUrl(needle, TargetPlatform.iOS).host,
        'maps.apple.com',
      );
      expect(placeMapsAppUrl(needle, TargetPlatform.android).scheme, 'geo');
      expect(
        placeMapsAppUrl(needle, TargetPlatform.linux).host,
        'www.openstreetmap.org',
      );
    });
  });

  group('weather', () {
    Future<ObaTestEnv> weatherEnv({bool fails = false}) => ObaTestEnv.create(
      responses: {
        if (!fails) 'weather.json': fixture('pugetsound-weather.json'),
      },
    );

    testWidgets('button: temperature and condition; opens the forecast', (
      tester,
    ) async {
      env = await weatherEnv();
      final pushed = <ObaRoute>[];
      await env.pumpPage(
        tester,
        Material(
          child: Center(
            child: Builder(builder: (c) => buildWeatherAccessory(c)!),
          ),
        ),
        onNavigate: (_, r) {
          pushed.add(r);
          return true;
        },
      );
      expect(find.text('71°F'), findsOneWidget);
      final semantics = tester.getSemantics(find.byType(ObaWeatherButton));
      expect(semantics.label, 'Weather: 71 degrees Fahrenheit, Clear');
      await tester.tap(find.byType(ObaWeatherButton));
      await tester.pump();
      expect(pushed.single, const WeatherRoute());
      await expectObaAccessibility(tester);
    });

    testWidgets('button: hidden when the forecast fails', (tester) async {
      env = await weatherEnv(fails: true);
      await env.pumpPage(
        tester,
        const Material(child: Center(child: ObaWeatherButton())),
      );
      expect(find.textContaining('°'), findsNothing);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('page: forecast details, hourly list, units', (tester) async {
      env = await weatherEnv();
      await withClock(Clock.fixed(weatherTime), () async {
        await env.pumpPage(tester, const WeatherPage());
        expect(find.text('71°F'), findsWidgets);
        expect(find.text('Clear'), findsWidgets);
        expect(find.text('Puget Sound'), findsOneWidget);
        expect(find.textContaining('High '), findsOneWidget);
        expect(find.text('Feels like'), findsOneWidget);
        expect(find.text('Wind'), findsOneWidget);
        expect(find.text('Chance of rain'), findsOneWidget);
        expect(find.text('Partly cloudy starting tonight.'), findsOneWidget);
        expect(find.text('Next 24 hours'), findsOneWidget);
        expect(find.text('Now'), findsOneWidget);
        expect(
          find.text('Temperatures in degrees Fahrenheit (°F)'),
          findsOneWidget,
        );
        await expectObaAccessibility(tester);
        await env.pumpPage(
          tester,
          const WeatherPage(),
          themeMode: ThemeMode.dark,
        );
        await expectObaAccessibility(tester);
        await env.expectNoOverflowAtTextScale(tester, const WeatherPage());
      });
      // Cached: the page and the reloads made one request.
      expect(
        env.requests.where((r) => r.url.path.contains('weather')).length,
        1,
      );
    });

    testWidgets('page: Celsius for a non-US locale', (tester) async {
      env = await weatherEnv();
      await withClock(Clock.fixed(weatherTime), () async {
        await tester.pumpWidget(
          ObaScope(
            application: env.app,
            child: MaterialApp(
              locale: const Locale('en', 'GB'),
              localizationsDelegates: obaLocalizationsDelegates,
              supportedLocales: const [Locale('en', 'GB'), Locale('en')],
              home: const WeatherPage(),
            ),
          ),
        );
        await ObaTestEnv.settle(tester);
        expect(find.text('22°C'), findsOneWidget);
        expect(find.textContaining('mph'), findsOneWidget);
      });
    });

    testWidgets('page: error with retry', (tester) async {
      env = await weatherEnv(fails: true);
      await env.pumpPage(tester, const WeatherPage());
      expect(find.text('Try again'), findsOneWidget);
      await expectObaAccessibility(tester);
    });
  });

  group('TripPlannerPage', () {
    testWidgets('unavailable region: empty state', (tester) async {
      env = await ObaTestEnv.create(region: 'MTA New York');
      await env.pumpPage(tester, const TripPlannerPage());
      expect(
        find.text('Trip planning isn\'t available in this region.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.directions_outlined), findsOneWidget);
      await expectObaAccessibility(tester);
    });

    testWidgets('embedded with a destination', (tester) async {
      env = await ObaTestEnv.create();
      await env.pumpPage(
        tester,
        const TripPlannerPage(destination: needle),
        presentation: ObaPresentation.embedded,
      );
      expect(find.text('Space Needle'), findsWidgets);
      expect(env.requests, isEmpty);
    });
  });

  group('ItineraryRoute', () {
    tp.Itinerary itinerary() => tp
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
    // The harness's fake tiles, so no network is touched.
    tp.TripMapConfig config() => tp.TripMapConfig(
      userAgentPackageName: 'test',
      tileProvider: env.app.map.tileProvider,
    );

    testWidgets('in the shell: drawn on the main map, steps only', (
      tester,
    ) async {
      env = await ObaTestEnv.create();
      final map = ObaMapCoordinator();
      addTearDown(map.dispose);
      final route = ItineraryRoute(itinerary(), mapConfig: config());
      await env.pumpPage(
        tester,
        Builder(builder: route.build),
        presentation: ObaPresentation.sheet,
        coordinator: map,
      );
      expect(map.overlay.polylines, isNotEmpty);
      expect(map.overlay.fitBounds, isNotNull);
      expect(map.overlay.markers.map((m) => m.kind), [
        ObaMapMarkerKind.origin,
        ObaMapMarkerKind.destination,
      ]);
      expect(find.byType(tp.ItineraryMap), findsNothing);
      expect(find.text('Trip details'), findsOneWidget);
    });

    testWidgets('without a map: its own map above the steps', (tester) async {
      env = await ObaTestEnv.create();
      final route = ItineraryRoute(itinerary(), mapConfig: config());
      await env.pumpPage(tester, Builder(builder: route.build));
      expect(find.byType(tp.ItineraryMap), findsOneWidget);
    });
  });

  group('Explore and home sections', () {
    testWidgets('shortcuts open their pages', (tester) async {
      env = await ObaTestEnv.create();
      final pushed = <ObaRoute>[];
      await env.pumpPage(
        tester,
        ListView(children: const [ExploreSection()]),
        presentation: ObaPresentation.embedded,
        onNavigate: (_, r) {
          pushed.add(r);
          return true;
        },
      );
      await tester.tap(find.text('Plan a trip'));
      await tester.tap(find.text('Weather'));
      await tester.tap(find.text('Agencies'));
      await tester.pump();
      expect(pushed, [
        const TripPlannerRoute(),
        const WeatherRoute(),
        const AgenciesRoute(),
      ]);
      await expectObaAccessibility(tester);
      await env.expectNoOverflowAtTextScale(
        tester,
        ListView(children: const [ExploreSection()]),
        presentation: ObaPresentation.embedded,
      );
    });

    testWidgets('no trip planning: no Plan a trip', (tester) async {
      env = await ObaTestEnv.create(region: 'MTA New York');
      await env.pumpPage(
        tester,
        ListView(children: const [ExploreSection()]),
        presentation: ObaPresentation.embedded,
      );
      expect(find.text('Plan a trip'), findsNothing);
      expect(find.text('Agencies'), findsOneWidget);
    });

    testWidgets('the home tab lists Nearby and Explore', (tester) async {
      env = await makeEnv(location: udistrict);
      await env.pumpPage(
        tester,
        ListView(
          children: [
            for (final s in searchHomeSections) Builder(builder: s.builder),
          ],
        ),
        presentation: ObaPresentation.embedded,
      );
      expect(find.text('Nearby'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
    });
  });
}
