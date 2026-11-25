import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_core/obakit_core.dart' as oba show Route;

import '../../support/oba_test_harness.dart';

/// Near 15th Ave NE & NE Campus Pkwy (1_10914), in Puget Sound.
final udistrict = ObaLocation(
  lat: 47.6564,
  lon: -122.3122,
  timestamp: DateTime.utc(2018),
);

Future<ObaTestEnv> makeEnv({
  ObaLocation? location,
  LocationPermissionStatus? permission,
  bool stops = true,
}) => ObaTestEnv.create(
  responses: {
    if (stops) 'stops-for-location': fixture('stops_for_location_seattle.json'),
    'arrivals-and-departures-for-stop': fixture(
      'arrivals-and-departures-for-stop-1_10914.json',
    ),
  },
  location: location,
  permission:
      permission ??
      (location == null
          ? LocationPermissionStatus.notDetermined
          : LocationPermissionStatus.whileInUse),
);

Widget feed(Widget child) => ListView(children: [child]);

int count(ObaTestEnv env, String path) =>
    env.requests.where((r) => r.url.path.contains(path)).length;

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  testWidgets('section: next departures of the closest stops, politely', (
    tester,
  ) async {
    env = await makeEnv(location: udistrict);
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    expect(find.text('Nearby'), findsOneWidget);
    // One stops request; arrivals for at most three stops.
    expect(count(env, 'stops-for-location'), 1);
    expect(count(env, 'arrivals-and-departures-for-stop'), 3);
    // The fixture's one departure (route 49, ~5.6 min, 2.6 min late) for
    // each stop.
    expect(find.byType(NearbyDepartureTile), findsNWidgets(3));
    expect(find.text('Downtown Seattle Broadway'), findsNWidgets(3));
    expect(find.text('5 min'), findsNWidgets(3));
    expect(find.text('3 min late'), findsNWidgets(3));
    final semantics = tester.getSemantics(
      find.byType(NearbyDepartureTile).first,
    );
    expect(
      semantics.label,
      startsWith('49 to Downtown Seattle Broadway, in 5 minutes, 3 min late.'),
    );

    await tester.tap(find.byType(NearbyDepartureTile).first);
    await tester.pump();
    expect(pushed.single, isA<StopRoute>());

    await tester.tap(find.text('See all'));
    await tester.pump();
    expect(pushed.last, const NearbyStopsRoute());

    // A refresh within 30 s fetches nothing new.
    await tester.pump(const Duration(seconds: 10));
    expect(count(env, 'arrivals-and-departures-for-stop'), 3);

    await expectObaAccessibility(tester);
    await env.pumpPage(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
      themeMode: ThemeMode.dark,
    );
    await expectObaAccessibility(tester);
    await env.expectNoOverflowAtTextScale(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
    );
  });

  testWidgets('section: refreshes every 30 s, only while visible', (
    tester,
  ) async {
    env = await makeEnv(location: udistrict);
    await env.pumpPage(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
    );
    expect(count(env, 'arrivals-and-departures-for-stop'), 3);
    await tester.pump(const Duration(seconds: 31));
    await ObaTestEnv.settle(tester);
    expect(count(env, 'arrivals-and-departures-for-stop'), 6);

    // Hidden (an off-screen tab, a covering route): nothing is fetched.
    await env.pumpPage(
      tester,
      feed(const TickerMode(enabled: false, child: NearbyStopsSection())),
      presentation: ObaPresentation.embedded,
    );
    final before = count(env, 'arrivals-and-departures-for-stop');
    await tester.pump(const Duration(seconds: 61));
    await ObaTestEnv.settle(tester);
    expect(count(env, 'arrivals-and-departures-for-stop'), before);
  });

  testWidgets('controller: stops fetched together; refreshed every 30 s', (
    tester,
  ) async {
    env = await makeEnv();
    var arrivals = 0, inFlight = 0, maxInFlight = 0;
    var failNext = false;
    final client = OneBusAwayClient(
      baseUrl: Uri.parse('https://api.example.org/'),
      apiKey: 'k',
      httpClient: MockClient((r) async {
        if (r.url.path.contains('stops-for-location')) {
          return http.Response(fixture('stops_for_location_seattle.json'), 200);
        }
        arrivals++;
        inFlight++;
        maxInFlight = math.max(maxInFlight, inFlight);
        final fail = failNext && arrivals % 3 == 1;
        // A slow server: responses take two seconds.
        await Future<void>.delayed(const Duration(seconds: 2));
        inFlight--;
        if (fail) return http.Response('boom', 500);
        return http.Response(
          fixture('arrivals-and-departures-for-stop-1_10914.json'),
          200,
        );
      }),
    );
    final c = NearbyDeparturesController(client: () => client);
    addTearDown(c.dispose);
    c.visible = true;
    c.setCenter(udistrict.coordinate);
    await tester.pump();
    var notified = 0;
    c.addListener(() => notified++);
    await tester.pump(const Duration(seconds: 3));
    expect(arrivals, 3);
    expect(maxInFlight, 3, reason: 'all three stops at once');
    expect(notified, 1, reason: 'one notification for the round');

    // The section re-checks every 30 s from when the round started; the
    // slow responses must not push the refresh to the following tick.
    await tester.pump(const Duration(seconds: 27));
    c.loadIfNeeded();
    await tester.pump(const Duration(seconds: 3));
    expect(arrivals, 6);

    // A failure ends the round without retrying; the others still land.
    failNext = true;
    await tester.pump(const Duration(seconds: 27));
    notified = 0;
    c.loadIfNeeded();
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
    expect(arrivals, 9);
    expect(notified, 1);
  });

  testWidgets('controller: map-centre stops do not pile up routes', (
    tester,
  ) async {
    env = await makeEnv();
    final c = NearbyDeparturesController(client: () => null);
    addTearDown(c.dispose);
    Stop stop(String id, double lat, String route) =>
        Stop(id: id, name: id, lat: lat, lon: -122.3, routeIds: [route]);
    oba.Route route(String id) => oba.Route(id: id, agencyId: '1');
    for (var i = 0; i < 20; i++) {
      final lat = 47.0 + i;
      c.useStops(
        Coordinate(lat, -122.3),
        [stop('s$i', lat, 'r$i')],
        {'r$i': route('r$i')},
      );
    }
    expect(c.stops.single.id, 's19');
    expect(c.routes.keys, ['r19']);
  });

  testWidgets('section: no refresh in a hidden IndexedStack child', (
    tester,
  ) async {
    env = await makeEnv(location: udistrict);
    // A host's bottom-navigation tabs: IndexedStack keeps hidden children's
    // tickers running and reports them through Visibility.of.
    Widget tabs(int index) => IndexedStack(
      index: index,
      children: [feed(const NearbyStopsSection()), const SizedBox()],
    );
    await env.pumpPage(tester, tabs(0), presentation: ObaPresentation.embedded);
    expect(count(env, 'arrivals-and-departures-for-stop'), 3);
    await env.pumpPage(tester, tabs(1), presentation: ObaPresentation.embedded);
    final before = count(env, 'arrivals-and-departures-for-stop');
    await tester.pump(const Duration(seconds: 61));
    await ObaTestEnv.settle(tester);
    expect(count(env, 'arrivals-and-departures-for-stop'), before);
  });

  testWidgets('section: asks for location when it has none', (tester) async {
    env = await makeEnv();
    await env.pumpPage(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
    );
    expect(
      find.text('Turn on location to see departures from stops near you.'),
      findsOneWidget,
    );
    expect(env.requests, isEmpty);
    await expectObaAccessibility(tester);

    env.location.setLocation(udistrict);
    await tester.tap(find.text('Use my location'));
    await ObaTestEnv.settle(tester);
    expect(env.location.requestCount, 1);
    expect(find.byType(NearbyDepartureTile), findsWidgets);
  });

  testWidgets('section: denied location says so', (tester) async {
    env = await makeEnv(permission: LocationPermissionStatus.deniedForever);
    await env.pumpPage(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
    );
    expect(find.textContaining('Location access is off'), findsOneWidget);
    expect(find.text('Use my location'), findsNothing);
  });

  testWidgets('section: falls back to the map centre', (tester) async {
    env = await makeEnv();
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    await env.pumpPage(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
      coordinator: map,
    );
    // Zoomed out: no stops on the map, so nothing stands in for location.
    expect(find.text('Use my location'), findsOneWidget);
    map.updateCamera(
      center: udistrict.coordinate,
      zoom: 16,
      visibleBounds: const RegionRect(
        minLat: 47.65,
        maxLat: 47.66,
        minLon: -122.32,
        maxLon: -122.30,
      ),
    );
    map.updateVisibleStops([
      for (var i = 0; i < 5; i++)
        Stop(
          id: '1_${10914 + i}',
          name: 'Map stop $i',
          lat: 47.6564 + i * 0.001,
          lon: -122.3122,
        ),
    ], const {});
    await ObaTestEnv.settle(tester);
    expect(
      find.text('Showing stops near the centre of the map.'),
      findsOneWidget,
    );
    expect(find.byType(NearbyDepartureTile), findsNWidgets(3));
    // The map's stops were re-used: no stops request.
    expect(count(env, 'stops-for-location'), 0);
    expect(count(env, 'arrivals-and-departures-for-stop'), 3);
  });

  testWidgets('section: no stops nearby; server error with retry', (
    tester,
  ) async {
    env = await ObaTestEnv.create(
      responses: {
        'stops-for-location': fixture('stops_for_location_outofrange.json'),
      },
      location: udistrict,
      permission: LocationPermissionStatus.whileInUse,
    );
    await env.pumpPage(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('No stops nearby'), findsOneWidget);
    env.dispose();

    env = await makeEnv(location: udistrict, stops: false);
    await env.pumpPage(
      tester,
      feed(const NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('card embeds in a host feed', (tester) async {
    env = await makeEnv(location: udistrict);
    await env.pumpPage(
      tester,
      feed(const ObaNearbyStopsCard(maxRows: 2)),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('Departures near you'), findsOneWidget);
    expect(find.byType(NearbyDepartureTile), findsNWidgets(2));
    await expectObaAccessibility(tester);
  });

  testWidgets('page: grouped by direction with distances', (tester) async {
    env = await makeEnv(location: udistrict);
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    await env.pumpPage(tester, const NearbyStopsPage(), coordinator: map);
    expect(find.text('Nearby stops'), findsWidgets);
    expect(find.text('Southbound stops'), findsOneWidget);
    expect(find.textContaining(' away'), findsWidgets);
    expect(map.overlay.stops, hasLength(26));
    await expectObaAccessibility(tester);

    // Refresh button reloads.
    final before = count(env, 'stops-for-location');
    await tester.tap(find.byTooltip('Refresh'));
    await ObaTestEnv.settle(tester);
    expect(count(env, 'stops-for-location'), before + 1);

    await env.pumpPage(
      tester,
      const NearbyStopsPage(),
      themeMode: ThemeMode.dark,
    );
    await expectObaAccessibility(tester);
    await env.expectNoOverflowAtTextScale(tester, const NearbyStopsPage());
  });

  testWidgets('page: an explicit coordinate; embedded and sheet', (
    tester,
  ) async {
    env = await makeEnv();
    const c = Coordinate(47.6564, -122.3122);
    await env.pumpPage(
      tester,
      const NearbyStopsPage(coordinate: c),
      presentation: ObaPresentation.sheet,
    );
    expect(find.text('15th Ave NE & NE Campus Pkwy'), findsWidgets);
    await env.pumpPage(
      tester,
      const NearbyStopsPage(coordinate: c),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('15th Ave NE & NE Campus Pkwy'), findsWidgets);
  });

  testWidgets('page: location prompt, empty and error states', (tester) async {
    env = await makeEnv();
    await env.pumpPage(tester, const NearbyStopsPage());
    expect(find.text('Use my location'), findsOneWidget);
    await expectObaAccessibility(tester);
    env.dispose();

    env = await makeEnv(location: udistrict, stops: false);
    await env.pumpPage(tester, const NearbyStopsPage());
    expect(find.text('Try again'), findsOneWidget);
  });
}
