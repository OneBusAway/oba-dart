// Live location is demand-driven: the provider's position stream is
// subscribed only while a visible consumer holds a lease (the map, a nearby
// section or page, a stop page), never just because permission exists.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'support/oba_test_harness.dart';

/// Near 15th Ave NE & NE Campus Pkwy (1_10914), in Puget Sound.
final udistrict = ObaLocation(
  lat: 47.6564,
  lon: -122.3122,
  timestamp: DateTime.utc(2018),
);

final _responses = {
  'stops-for-location': fixture('stops_for_location_seattle.json'),
  'arrivals-and-departures-for-stop': fixture(
    'arrivals-and-departures-for-stop-1_10914.json',
  ),
};

Future<ObaTestEnv> grantedEnv({ObaLocation? location}) => ObaTestEnv.create(
  responses: _responses,
  permission: LocationPermissionStatus.whileInUse,
  location: location ?? udistrict,
);

int count(ObaTestEnv env, String path) =>
    env.requests.where((r) => r.url.path.contains(path)).length;

/// Two host tabs; [index] picks the visible one.
Widget tabs(int index, List<Widget> children) => Material(
  child: IndexedStack(index: index, children: children),
);

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  group('subscriptions follow visible consumers', () {
    testWidgets('none with permission but no consumer on screen', (
      tester,
    ) async {
      env = await grantedEnv();
      expect(env.location.activeSubscriptions, 0, reason: 'after start');
      await env.pumpPage(
        tester,
        const SingleChildScrollView(child: ObaBookmarksCard()),
        presentation: ObaPresentation.embedded,
      );
      expect(env.location.activeSubscriptions, 0);
      expect(env.location.subscribeCount, 0);
      // The last-known fix is still readable.
      expect(env.app.core.currentLocation, udistrict);
    });

    testWidgets('one while a nearby section is visible; none when hidden in '
        'an IndexedStack, backgrounded, covered, or disposed', (tester) async {
      env = await grantedEnv();
      Widget page(int index) => tabs(index, const [
        SingleChildScrollView(child: NearbyStopsSection()),
        SizedBox(),
      ]);
      await env.pumpPage(
        tester,
        page(0),
        presentation: ObaPresentation.embedded,
      );
      expect(env.location.activeSubscriptions, 1);

      await env.pumpPage(
        tester,
        page(1),
        presentation: ObaPresentation.embedded,
      );
      expect(env.location.activeSubscriptions, 0, reason: 'hidden tab');

      await env.pumpPage(
        tester,
        page(0),
        presentation: ObaPresentation.embedded,
      );
      expect(env.location.activeSubscriptions, 1);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(env.location.activeSubscriptions, 0, reason: 'backgrounded');
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(env.location.activeSubscriptions, 1);

      final context = tester.element(find.byType(NearbyStopsSection));
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const Scaffold()));
      await ObaTestEnv.settle(tester);
      expect(env.location.activeSubscriptions, 0, reason: 'covered by a route');
      Navigator.of(context).pop();
      await ObaTestEnv.settle(tester);
      expect(env.location.activeSubscriptions, 1);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(env.location.activeSubscriptions, 0, reason: 'disposed');
    });

    testWidgets('several consumers share one subscription', (tester) async {
      env = await grantedEnv();
      await env.pumpPage(
        tester,
        const Column(
          children: [
            Expanded(child: ObaMapView()),
            NearbyStopsSection(maxStops: 1, maxRows: 1),
          ],
        ),
        presentation: ObaPresentation.embedded,
        surfaceSize: const Size(390, 844),
      );
      expect(env.app.core.locationService.holderCount, 2);
      expect(env.location.activeSubscriptions, 1);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(env.location.activeSubscriptions, 0);
      expect(env.app.core.locationService.holderCount, 0);
    });

    testWidgets('a stop page holds location (walk time) only while shown', (
      tester,
    ) async {
      env = await ObaTestEnv.create(
        responses: {
          'arrivals-and-departures-for-stop': fixture(
            'arrivals-and-departures-for-stop-1_10914.json',
          ),
        },
        permission: LocationPermissionStatus.whileInUse,
        location: udistrict,
      );
      Widget page(int index) =>
          tabs(index, const [StopPage(stopId: '1_10914'), SizedBox()]);
      await env.pumpPage(
        tester,
        page(0),
        presentation: ObaPresentation.embedded,
      );
      expect(env.location.activeSubscriptions, 1);
      await env.pumpPage(
        tester,
        page(1),
        presentation: ObaPresentation.embedded,
      );
      expect(env.location.activeSubscriptions, 0);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('moves reach a visible section through the subscription', (
      tester,
    ) async {
      env = await ObaTestEnv.create(responses: _responses);
      await env.pumpPage(
        tester,
        const SingleChildScrollView(child: NearbyStopsSection()),
        presentation: ObaPresentation.embedded,
      );
      // Not permitted yet: holding, but nothing to subscribe to.
      expect(env.location.activeSubscriptions, 0);
      expect(find.text('Use my location'), findsOneWidget);
      env.location.setLocation(udistrict);
      await tester.tap(find.text('Use my location'));
      await ObaTestEnv.settle(tester);
      expect(env.location.requestCount, 1);
      expect(env.location.activeSubscriptions, 1);
      expect(find.byType(NearbyDepartureTile), findsWidgets);
      await tester.pumpWidget(const SizedBox());
    });
  });

  testWidgets('first launch: onboarding grants location, the region is '
      'chosen from the fix and the map centres on the rider', (tester) async {
    env = await ObaTestEnv.create(
      responses: _responses,
      onboardingDone: false,
      region: 'Nowhere', // no fixed region: automatic selection
    );
    expect(env.app.core.regions.needsRegionSelection, isTrue);
    // Where the device is; nothing reads it before permission.
    env.location.setLocation(udistrict);
    await env.pumpApp(tester, surfaceSize: const Size(390, 844));
    expect(env.location.activeSubscriptions, 0);
    await tester.tap(find.text('Continue'));
    await ObaTestEnv.settle(tester);
    await tester.tap(find.text('Allow location access'));
    await ObaTestEnv.settle(tester);
    expect(env.location.requestCount, 1);
    expect(env.location.currentPositionCount, greaterThan(0));

    // The fix chose the region, so the region step is skipped.
    expect(env.app.core.currentRegion?.regionName, 'Puget Sound');
    expect(find.text('Choose your region'), findsNothing);
    final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
    expect(shell.coordinator.zoom, closeTo(16, 0.01));
    expect(shell.coordinator.center!.lat, closeTo(udistrict.lat, 0.01));
    // The visible map now follows the rider.
    expect(env.location.activeSubscriptions, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(env.location.activeSubscriptions, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(env.location.activeSubscriptions, 1);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(env.location.activeSubscriptions, 0);
  });

  group('the map in a hidden tab', () {
    testWidgets('loads nothing until first shown', (tester) async {
      env = await grantedEnv();
      Widget page(int index) => tabs(index, const [SizedBox(), ObaMapView()]);
      await env.pumpPage(
        tester,
        page(0),
        presentation: ObaPresentation.embedded,
        surfaceSize: const Size(390, 844),
      );
      await tester.pump(const Duration(seconds: 2));
      await ObaTestEnv.settle(tester);
      expect(count(env, 'stops-for-location'), 0);
      expect(env.tiles.requests, 0);
      expect(env.location.activeSubscriptions, 0);
      expect(find.byType(ObaStopPin), findsNothing);

      await env.pumpPage(
        tester,
        page(1),
        presentation: ObaPresentation.embedded,
        surfaceSize: const Size(390, 844),
      );
      expect(count(env, 'stops-for-location'), 1);
      expect(env.tiles.requests, greaterThan(0));
      expect(env.location.activeSubscriptions, 1);
      await expectObaAccessibility(tester, checkContrast: false);

      // Hidden again: location released; the camera doesn't move, so no
      // more stops requests.
      await env.pumpPage(
        tester,
        page(0),
        presentation: ObaPresentation.embedded,
        surfaceSize: const Size(390, 844),
      );
      expect(env.location.activeSubscriptions, 0);
      expect(count(env, 'stops-for-location'), 1);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('showsUserLocation: false holds no location', (tester) async {
      env = await grantedEnv();
      await env.pumpPage(
        tester,
        const ObaMapView(showsUserLocation: false),
        presentation: ObaPresentation.embedded,
        surfaceSize: const Size(390, 844),
      );
      expect(env.location.activeSubscriptions, 0);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('around: a fixed point bypasses location', () {
    const campus = Coordinate(47.6564, -122.3122);

    testWidgets('section: no permission text, no subscription, stops near '
        'the point; See all keeps the point', (tester) async {
      env = await ObaTestEnv.create(responses: _responses);
      final pushed = <ObaRoute>[];
      await env.pumpPage(
        tester,
        const SingleChildScrollView(child: NearbyStopsSection(around: campus)),
        presentation: ObaPresentation.embedded,
        onNavigate: (_, r) {
          pushed.add(r);
          return true;
        },
      );
      expect(find.text('Use my location'), findsNothing);
      expect(find.textContaining('location'), findsNothing);
      expect(find.byType(NearbyDepartureTile), findsWidgets);
      final stops = env.requests.firstWhere(
        (r) => r.url.path.contains('stops-for-location'),
      );
      expect(stops.url.queryParameters['lat'], startsWith('47.656'));
      expect(env.location.activeSubscriptions, 0);
      expect(env.location.requestCount, 0);
      expect(env.app.core.locationService.holderCount, 0);
      await tester.tap(find.text('See all'));
      await tester.pump();
      expect(pushed.single, const NearbyStopsRoute(coordinate: campus));
      await expectObaAccessibility(tester);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('card and page', (tester) async {
      env = await ObaTestEnv.create(responses: _responses);
      await env.pumpPage(
        tester,
        ListView(children: const [ObaNearbyStopsCard(around: campus)]),
        presentation: ObaPresentation.embedded,
      );
      expect(find.text('Departures near you'), findsOneWidget);
      expect(find.byType(NearbyDepartureTile), findsWidgets);
      expect(env.app.core.locationService.holderCount, 0);
      await expectObaAccessibility(tester);
      await env.expectNoOverflowAtTextScale(
        tester,
        ListView(children: const [ObaNearbyStopsCard(around: campus)]),
        presentation: ObaPresentation.embedded,
      );

      await env.pumpPage(tester, const NearbyStopsPage(coordinate: campus));
      expect(find.byType(ObaStopRow), findsWidgets);
      expect(env.app.core.locationService.holderCount, 0);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('a host with no location', () {
    Future<ObaTestEnv> noLocationEnv({bool onboardingDone = true}) =>
        ObaTestEnv.create(
          responses: _responses,
          locationProvider: const NoLocationProvider(),
          onboardingDone: onboardingDone,
        );

    testWidgets('nearby parts say location is not used here, and ask nothing', (
      tester,
    ) async {
      env = await noLocationEnv();
      expect(env.app.core.isLocationAvailable, isFalse);
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        await env.pumpPage(
          tester,
          ListView(children: const [ObaNearbyStopsCard()]),
          presentation: ObaPresentation.embedded,
          themeMode: mode,
        );
        expect(
          find.text(
            "This app doesn't use your location, so it can't show stops near you.",
          ),
          findsOneWidget,
        );
        expect(find.text('Use my location'), findsNothing);
        expect(find.textContaining('Location access is off'), findsNothing);
        await expectObaAccessibility(tester);
      }
      await env.expectNoOverflowAtTextScale(
        tester,
        ListView(children: const [ObaNearbyStopsCard()]),
        presentation: ObaPresentation.embedded,
      );

      await env.pumpPage(tester, const NearbyStopsPage());
      expect(
        find.text(
          "This app doesn't use your location, so it can't show stops near you.",
        ),
        findsOneWidget,
      );
      expect(find.text('Use my location'), findsNothing);
      await expectObaAccessibility(tester);
      await env.expectNoOverflowAtTextScale(tester, const NearbyStopsPage());
    });

    testWidgets('the map has no location button or permission pill', (
      tester,
    ) async {
      env = await noLocationEnv();
      await env.pumpPage(
        tester,
        const ObaMapView(),
        presentation: ObaPresentation.embedded,
        surfaceSize: const Size(390, 844),
      );
      expect(find.byTooltip('Show my location'), findsNothing);
      expect(find.textContaining('Location access is off'), findsNothing);
      await expectObaAccessibility(tester, checkContrast: false);
      await tester.pumpWidget(const SizedBox());
    });

    test('onboarding skips the location step', () async {
      env = await noLocationEnv(onboardingDone: false);
      expect(ObaOnboardingGate.pendingSteps(env.app.core), [
        OnboardingStep.welcome,
      ]);
    });
  });

  testWidgets('FixedLocationProvider: near the point with no prompt', (
    tester,
  ) async {
    env = await ObaTestEnv.create(
      responses: _responses,
      locationProvider: FixedLocationProvider(udistrict.coordinate),
    );
    await env.pumpPage(
      tester,
      const SingleChildScrollView(child: NearbyStopsSection()),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('Use my location'), findsNothing);
    expect(find.byType(NearbyDepartureTile), findsWidgets);
    final stops = env.requests.firstWhere(
      (r) => r.url.path.contains('stops-for-location'),
    );
    expect(stops.url.queryParameters['lat'], startsWith('47.656'));
    await tester.pumpWidget(const SizedBox());
  });
}
