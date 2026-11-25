import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'support/oba_test_harness.dart';

void main() {
  group('ObaApp', () {
    late ObaTestEnv env;
    setUp(() async {
      env = await ObaTestEnv.create(
        responses: {
          'stops-for-location': fixture('stops_for_location_query.json'),
        },
      );
    });
    tearDown(() => env.dispose());

    testWidgets('boots to the map and home sheet', (tester) async {
      await env.pumpApp(tester, surfaceSize: const Size(390, 844));
      expect(find.byType(ObaHomeShell), findsOneWidget);
      expect(find.byType(ObaMapView), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('Bookmarks'), findsWidgets);
      // The region's service area is too big for stops: the pill says so
      // and nothing was requested.
      expect(find.text('Zoom in to see stops'), findsOneWidget);
      expect(
        env.requests.where((r) => r.url.path.contains('stops-for-location')),
        isEmpty,
      );
      expect(env.tiles.requests, greaterThan(0), reason: 'fake tiles in use');
      await expectObaAccessibility(tester);

      // A page that draws its own stops (a route) hides the pill.
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      shell.coordinator.showRoute(
        shapes: const [],
        stops: const [Stop(id: 's', name: 'S', lat: 47.6, lon: -122.3)],
      );
      await tester.pump();
      expect(find.text('Zoom in to see stops'), findsNothing);

      // Zoomed out, a route's many stops draw as compact dots.
      shell.coordinator.showRoute(
        shapes: const [],
        stops: const [
          Stop(id: 'a', name: 'A', lat: 47.6, lon: -122.3),
          Stop(id: 'b', name: 'B', lat: 47.2, lon: -122.5),
        ],
      );
      await ObaTestEnv.settle(tester);
      final pins = tester.widgetList<ObaStopPin>(find.byType(ObaStopPin));
      expect(pins, hasLength(2));
      expect(pins.every((p) => p.spec.compact), isTrue);
    });

    testWidgets('zooming in loads stop pins that open the stop page', (
      tester,
    ) async {
      await env.pumpApp(tester, surfaceSize: const Size(390, 844));
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      shell.coordinator.moveTo(
        const Coordinate(47.159439, -122.505051),
        zoom: 17,
      );
      await ObaTestEnv.settle(tester);
      expect(
        env.requests.where((r) => r.url.path.contains('stops-for-location')),
        hasLength(1),
      );
      expect(find.text('Zoom in to see stops'), findsNothing);
      expect(find.byType(ObaStopPin), findsOneWidget);
      expect(shell.coordinator.visibleStops.single.name, '108th / Bridgeport');

      // The pin is a labelled button.
      final handle = tester.ensureSemantics();
      await tester.pump();
      expect(
        find.bySemanticsLabel(RegExp('108th / Bridgeport, Bus stop')),
        findsOneWidget,
      );
      handle.dispose();

      await tester.tap(find.byType(ObaStopPin));
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack.last, isA<StopRoute>());
      expect(find.byType(StopPage), findsOneWidget);
      expect(shell.coordinator.selectedStopId, isNotNull);

      // The accessible list shows the same stop.
      shell.navigator.push(const StopsOnMapRoute());
      await ObaTestEnv.settle(tester);
      expect(find.text('1 stop on the map'), findsOneWidget);
      expect(find.text('108th / Bridgeport'), findsOneWidget);
    });

    testWidgets('restores the saved camera', (tester) async {
      await env.pumpApp(tester, surfaceSize: const Size(390, 844));
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      shell.coordinator.moveTo(const Coordinate(47.6, -122.33), zoom: 15);
      await ObaTestEnv.settle(tester);
      final saved = MapCameraStore(env.store).read()!;
      expect(saved.zoom, closeTo(15, 0.01));
      expect(saved.regionId, 1);
    });

    testWidgets('long press drops a pin', (tester) async {
      await env.pumpApp(tester, surfaceSize: const Size(390, 844));
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      await tester.longPressAt(const Offset(195, 300));
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack.last, isA<PlaceRoute>());
      expect(find.text('Dropped pin'), findsWidgets);
    });

    testWidgets('handles deep links once the shell is up', (tester) async {
      final links = StreamController<Uri>();
      addTearDown(links.close);
      await env.pumpApp(
        tester,
        surfaceSize: const Size(390, 844),
        initialLink: Uri.parse('onebusaway://stop?id=1_75403'),
        links: links.stream,
      );
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      expect(shell.routeStack.last, const StopRoute('1_75403'));
      links.add(Uri.parse('onebusaway://view-stop?stopID=99&regionID=11'));
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack.last, const StopRoute('99'));
      expect(env.app.core.currentRegion?.regionName, 'San Diego');
    });

    testWidgets('reflows at 200% text in light and dark', (tester) async {
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        await env.pumpPage(
          tester,
          const ObaHomeShell(),
          textScale: 2,
          themeMode: mode,
          surfaceSize: const Size(390, 844),
        );
        expect(tester.takeException(), isNull);
        final shell = tester.state<ObaHomeShellState>(
          find.byType(ObaHomeShell),
        );
        shell.navigator.push(const StopRoute('1'));
        await ObaTestEnv.settle(tester);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('respects reduced motion', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            disableAnimations: true,
            size: Size(390, 844),
          ),
          child: env.wrap(const ObaHomeShell()),
        ),
      );
      await ObaTestEnv.settle(tester);
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      shell.navigator.push(const StopRoute('1'));
      await tester.pump();
      await tester.pump();
      expect(
        shell.sheet.height,
        closeTo(shell.sheet.maxHeight * 0.5, 0.5),
        reason: 'no animation frames needed',
      );
    });
  });

  group('embedding single screens', () {
    late ObaTestEnv env;
    setUp(() async => env = await ObaTestEnv.create());
    tearDown(() => env.dispose());

    testWidgets('a section in a host feed, under the host theme', (
      tester,
    ) async {
      await env.pumpPage(
        tester,
        Scaffold(
          body: ListView(
            children: const [Text('Host card'), NearbyStopsSection()],
          ),
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
      );
      expect(find.text('Nearby'), findsOneWidget);
      await expectObaAccessibility(tester);
      await tester.tap(find.text('See all'));
      await ObaTestEnv.settle(tester);
      expect(find.byType(NearbyStopsPage), findsOneWidget);
    });

    testWidgets('the map in a host tab, with a host callback', (tester) async {
      Stop? selected;
      await env.pumpPage(
        tester,
        Scaffold(body: ObaMapView(onStopSelected: (s) => selected = s)),
        surfaceSize: const Size(390, 844),
      );
      expect(find.text('Zoom in to see stops'), findsOneWidget);
      expect(selected, isNull);
      await expectObaAccessibility(tester);
    });

    testWidgets('the map says when stops fail to load, and retries', (
      tester,
    ) async {
      // Zoomed in on the rider; every stops request fails (no fixture: 404).
      final failing = await ObaTestEnv.create(
        location: ObaLocation(
          lat: 47.6097,
          lon: -122.3331,
          timestamp: DateTime.utc(2026),
        ),
        permission: LocationPermissionStatus.whileInUse,
      );
      addTearDown(failing.dispose);
      int stopsRequests() => failing.requests
          .where((r) => r.url.path.contains('stops-for-location'))
          .length;
      await failing.pumpPage(
        tester,
        const Scaffold(body: ObaMapView()),
        surfaceSize: const Size(390, 844),
      );
      expect(stopsRequests(), greaterThan(0));
      final message = find.text(
        "The server didn't respond as expected. Try again in a moment.",
      );
      expect(message, findsOneWidget);
      final before = stopsRequests();
      await tester.tap(message);
      await ObaTestEnv.settle(tester);
      expect(stopsRequests(), before + 1);
      await expectObaAccessibility(tester);
    });

    testWidgets('a page works in every presentation', (tester) async {
      for (final p in ObaPresentation.values) {
        await env.pumpPage(tester, const MapSettingsPage(), presentation: p);
        expect(find.text('Show heading'), findsOneWidget, reason: '$p');
        expect(
          find.byType(AppBar),
          p == ObaPresentation.page ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
      }
      await env.expectNoOverflowAtTextScale(tester, const MapSettingsPage());
    });

    testWidgets('pages without a map treat the coordinator as optional', (
      tester,
    ) async {
      await env.pumpPage(tester, const StopsOnMapPage());
      expect(find.text('No stops on the map'), findsOneWidget);
    });
  });
}
