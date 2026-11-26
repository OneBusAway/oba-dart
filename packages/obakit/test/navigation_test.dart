import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' show FlutterMap, MarkerLayer;
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'support/oba_test_harness.dart';

void main() {
  group('ObaRoute', () {
    test('identity ignores the transfer context', () {
      final t = ObaTransferContext(
        arrivalTime: DateTime.utc(2026),
        fromRouteShortName: '10',
        fromTripHeadsign: 'Downtown',
      );
      expect(const StopRoute('1_75403'), StopRoute('1_75403', transfer: t));
      expect(const StopRoute('1_75403').id, 'stopDetails-1_75403');
      expect(const StopRoute('a') == const StopRoute('b'), isFalse);
    });

    test('the name hint is not part of the route identity', () {
      const named = StopRoute('1_75403', name: 'Pine St & 3rd Ave');
      expect(named.name, 'Pine St & 3rd Ave');
      expect(named.id, 'stopDetails-1_75403');
      expect(named, const StopRoute('1_75403'));
      expect(named, const StopRoute('1_75403', name: 'Other name'));
      expect(const StopRoute('1_75403').name, isNull);
    });

    test('trip planner ids never contain coordinates', () {
      const p = Place(name: 'Home', coordinate: Coordinate(47.1, -122.2));
      expect(const TripPlannerRoute().id, 'tripPlanner_blank');
      expect(
        const TripPlannerRoute(destination: p).id,
        'tripPlanner_destination',
      );
    });

    test('detents mirror iOS', () {
      expect(const HomeRoute().detents.initial, ObaSheetDetent.collapsed);
      expect(const StopRoute('x').detents.initial, ObaSheetDetent.medium);
      expect(const SearchRoute().detents.detents, [ObaSheetDetent.large]);
      expect(
        const PlaceRoute(Place(name: 'p', coordinate: Coordinate(0, 0)))
            .detents
            .detents,
        [ObaSheetDetent.medium],
      );
    });
  });

  group('ObaSheetDetents', () {
    final heights = ObaSheetDetents.stop.resolve(
      maxHeight: 800,
      headerHeight: 120,
    );

    test('resolves ascending', () => expect(heights, [120, 400, 800]));

    test('snaps to the nearest detent, or one step on a fling', () {
      expect(ObaSheetDetents.snap(heights, 300, 0), 400);
      expect(ObaSheetDetents.snap(heights, 200, 0), 120);
      expect(ObaSheetDetents.snap(heights, 410, 1000), 800);
      expect(ObaSheetDetents.snap(heights, 390, -1000), 120);
    });

    test('steps up and down (the accessible resize)', () {
      expect(ObaSheetDetents.step(heights, 400, up: true), 800);
      expect(ObaSheetDetents.step(heights, 800, up: true), isNull);
      expect(ObaSheetDetents.step(heights, 400, up: false), 120);
    });
  });

  group('ObaMapCoordinator overlays', () {
    test('only the active owner shows, and it comes back on pop', () {
      final c = ObaMapCoordinator();
      final a = Object(), b = Object();
      const overlayA = ObaMapOverlay(hideStopPins: true);
      const overlayB = ObaMapOverlay(
        markers: [ObaMapMarker(coordinate: Coordinate(1, 1), label: 'x')],
      );
      c.setActiveOwner(a);
      c.setOverlay(a, overlayA);
      expect(c.overlay, same(overlayA));
      c.setActiveOwner(b);
      c.setOverlay(b, overlayB);
      expect(c.overlay, same(overlayB));
      c.removeOverlay(b);
      c.setActiveOwner(a);
      expect(c.overlay, same(overlayA));
      c.dispose();
    });

    test('an overlay refit happens only when its bounds change', () {
      final c = ObaMapCoordinator();
      final d = _FakeDelegate();
      c.attach(d);
      final owner = Object();
      const rect = RegionRect(minLat: 1, maxLat: 2, minLon: 3, maxLon: 4);
      c.setOverlay(owner, const ObaMapOverlay(fitBounds: rect));
      // A refresh with new vehicles but the same bounds keeps the camera.
      c.setOverlay(
        owner,
        const ObaMapOverlay(
          fitBounds: RegionRect(minLat: 1, maxLat: 2, minLon: 3, maxLon: 4),
          markers: [ObaMapMarker(coordinate: Coordinate(1, 3), label: 'bus')],
        ),
      );
      expect(d.fits, hasLength(1));
      c.setOverlay(
        owner,
        const ObaMapOverlay(
          fitBounds: RegionRect(minLat: 5, maxLat: 6, minLon: 3, maxLon: 4),
        ),
      );
      expect(d.fits, hasLength(2));
      c.dispose();
    });

    test('camera commands wait for the map', () {
      final c = ObaMapCoordinator();
      final d = _FakeDelegate();
      c.moveTo(const Coordinate(1, 2), zoom: 15);
      expect(d.moves, isEmpty);
      c.attach(d);
      expect(d.moves.single, (const Coordinate(1, 2), 15.0));
      c.focusStop(const Stop(id: 's', name: 'S', lat: 3, lon: 4));
      expect(c.selectedStopId, 's');
      expect(d.moves.last.$1, const Coordinate(3, 4));
      c.dispose();
    });
  });

  group('embedded navigation (no shell)', () {
    late ObaTestEnv env;
    setUp(() async => env = await ObaTestEnv.create());
    tearDown(() => env.dispose());

    testWidgets('pushes SDK pages on the host navigator as full pages', (
      tester,
    ) async {
      await env.pumpPage(tester, const _PushButton(StopRoute('1_75403')));
      await tester.tap(find.text('go'));
      await ObaTestEnv.settle(tester);
      expect(find.byType(StopPage), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget, reason: 'page presentation');
      await expectObaAccessibility(tester);
      await tester.pageBack();
      await ObaTestEnv.settle(tester);
      expect(find.byType(StopPage), findsNothing);
    });

    testWidgets('pages pushed above the scope still find it', (tester) async {
      // The host put ObaScope *inside* its MaterialApp, around one card.
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: obaLocalizationsDelegates,
          home: Scaffold(
            body: ObaScope(
              application: env.app,
              child: const _PushButton(SettingsRoute()),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await ObaTestEnv.settle(tester);
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the host onNavigate callback can take over', (tester) async {
      final seen = <ObaRoute>[];
      await env.pumpPage(
        tester,
        const _PushButton(StopRoute('42')),
        onNavigate: (context, route) {
          seen.add(route);
          return true;
        },
      );
      await tester.tap(find.text('go'));
      await ObaTestEnv.settle(tester);
      expect(seen, [const StopRoute('42')]);
      expect(find.byType(StopPage), findsNothing);
    });

    testWidgets('localizations work without host delegates', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ObaScope(
            application: env.app,
            child: const StopPage(stopId: 'x'),
          ),
        ),
      );
      expect(find.text('Stop'), findsOneWidget);
    });
  });

  group('shell', () {
    late ObaTestEnv env;
    setUp(() async => env = await ObaTestEnv.create());
    tearDown(() => env.dispose());

    Future<ObaHomeShellState> pumpShell(
      WidgetTester tester, {
      Size size = const Size(390, 844),
    }) async {
      await env.pumpPage(tester, const ObaHomeShell(), surfaceSize: size);
      return tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
    }

    testWidgets(
      'home opens collapsed; stop pushes inside the sheet at medium',
      (tester) async {
        final shell = await pumpShell(tester);
        expect(find.byType(ObaHomeSheet), findsOneWidget);
        expect(find.byType(ObaMapView), findsOneWidget);
        final collapsed = shell.sheet.height;
        expect(collapsed, shell.sheet.minHeight);
        expect(collapsed, lessThan(shell.sheet.maxHeight * 0.5));

        shell.navigator.push(const StopRoute('1_75403'));
        await ObaTestEnv.settle(tester);
        expect(shell.routeStack, [
          const HomeRoute(),
          const StopRoute('1_75403'),
        ]);
        expect(shell.sheet.height, closeTo(shell.sheet.maxHeight * 0.5, 0.5));
        expect(find.byType(StopPage), findsOneWidget);
        expect(find.byType(ObaMapView), findsOneWidget, reason: 'map stays');
        expect(shell.coordinator.selectedStopId, '1_75403');

        // Search opens full; popping restores the stop at medium.
        shell.navigator.push(const SearchRoute());
        await ObaTestEnv.settle(tester);
        expect(shell.sheet.height, closeTo(shell.sheet.maxHeight, 0.5));
        await tester.tap(find.byTooltip('Back'));
        await ObaTestEnv.settle(tester);
        expect(shell.routeStack.last, const StopRoute('1_75403'));
        expect(shell.sheet.height, closeTo(shell.sheet.maxHeight * 0.5, 0.5));

        shell.navigator.popToRoot();
        await ObaTestEnv.settle(tester);
        expect(shell.routeStack, [const HomeRoute()]);
        expect(shell.sheet.height, closeTo(collapsed, 0.5));
        expect(shell.coordinator.selectedStopId, isNull);
      },
    );

    testWidgets('the home header fits at the largest text on a small phone', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await env.pumpPage(
        tester,
        const ObaHomeShell(),
        textScale: 2.35,
        surfaceSize: const Size(320, 640),
      );
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      shell.sheet.expand();
      await ObaTestEnv.settle(tester);
      shell.sheet.collapse();
      shell.sheet.collapse();
      await ObaTestEnv.settle(tester);
      expect(tester.takeException(), isNull);
      handle.dispose();
    });

    testWidgets('screen readers reach the sheet before the map', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await env.pumpPage(tester, const ObaHomeShell());
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      final labels = <String>[];
      void visit(SemanticsNode n) {
        if (n.isMergedIntoParent) return;
        final l = n.getSemanticsData().label;
        if (l.isNotEmpty) labels.add(l);
        for (final c in n.debugListChildrenInOrder(
          DebugSemanticsDumpOrder.traversalOrder,
        )) {
          visit(c);
        }
      }

      visit(
        tester
            .binding
            .renderViews
            .first
            .owner!
            .semanticsOwner!
            .rootSemanticsNode!,
      );
      expect(labels.indexOf('Search'), greaterThanOrEqualTo(0));
      expect(labels.indexOf('Search'), lessThan(labels.indexOf('Map')));
      // A section's heading comes before its empty-state text.
      shell.sheet.expandFully();
      await ObaTestEnv.settle(tester);
      labels.clear();
      visit(
        tester
            .binding
            .renderViews
            .first
            .owner!
            .semanticsOwner!
            .rootSemanticsNode!,
      );
      final heading = labels.indexOf('Recent stops');
      expect(heading, greaterThanOrEqualTo(0));
      expect(labels[heading + 1], 'Stops you look at appear here.');
      handle.dispose();
    });

    testWidgets('home sections fetch only while the sheet is raised', (
      tester,
    ) async {
      final e = await ObaTestEnv.create(
        permission: LocationPermissionStatus.whileInUse,
        location: ObaLocation(
          lat: 47.6097,
          lon: -122.3331,
          timestamp: DateTime.utc(2026),
        ),
        responses: {
          'stops-for-location': fixture('stops_for_location_seattle.json'),
        },
      );
      addTearDown(e.dispose);
      await e.pumpPage(tester, const ObaHomeShell());
      final shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      bool departures() =>
          e.requests.any((r) => r.url.path.contains('arrivals-and-departures'));
      expect(shell.sheet.isCollapsed, isTrue);
      await ObaTestEnv.settle(tester);
      expect(departures(), isFalse, reason: 'collapsed: nothing fetched');
      shell.sheet.expand();
      await ObaTestEnv.settle(tester);
      expect(departures(), isTrue, reason: 'raised: nearby departures load');
    });

    testWidgets('the map opens on the rider, or centres on the first fix', (
      tester,
    ) async {
      // Known location at launch: start there, zoomed in.
      final located = await ObaTestEnv.create(
        permission: LocationPermissionStatus.whileInUse,
        location: ObaLocation(
          lat: 47.6097,
          lon: -122.3331,
          timestamp: DateTime.utc(2026),
        ),
      );
      addTearDown(located.dispose);
      await located.pumpPage(tester, const ObaHomeShell());
      var shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      expect(shell.coordinator.zoom, 16.0);
      await tester.pumpWidget(const SizedBox());

      // No fix yet: the region overview, then the rider once a fix comes.
      final later = await ObaTestEnv.create(
        permission: LocationPermissionStatus.whileInUse,
      );
      addTearDown(later.dispose);
      await later.pumpPage(tester, const ObaHomeShell());
      shell = tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
      expect(shell.coordinator.zoom, lessThan(13));
      later.location.setLocation(
        ObaLocation(
          lat: 47.6097,
          lon: -122.3331,
          timestamp: DateTime.utc(2026),
        ),
      );
      await ObaTestEnv.settle(tester);
      expect(shell.coordinator.zoom, closeTo(16.0, 0.01));
      expect(shell.coordinator.center!.lat, closeTo(47.6, 0.05));
    });

    testWidgets('status bar icons stay dark over the map in dark mode', (
      tester,
    ) async {
      await env.pumpPage(
        tester,
        const ObaHomeShell(),
        themeMode: ThemeMode.dark,
      );
      final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
        find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first,
      );
      expect(region.value.statusBarIconBrightness, Brightness.dark);
      expect(region.value.statusBarBrightness, Brightness.light);
    });

    testWidgets('pushing an open route goes back to it', (tester) async {
      final shell = await pumpShell(tester);
      shell.navigator.push(const StopRoute('a'));
      await ObaTestEnv.settle(tester);
      shell.navigator.push(const RouteStopsRoute('r'));
      await ObaTestEnv.settle(tester);
      shell.navigator.push(const StopRoute('a'));
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack, [const HomeRoute(), const StopRoute('a')]);
    });

    testWidgets('pages in the sheet push through ObaNavigator', (tester) async {
      final shell = await pumpShell(tester);
      await tester.tap(find.byType(ObaSearchFieldButton));
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack.last, const SearchRoute());
      expect(find.byType(SearchPage), findsOneWidget);
      expect(
        find.byType(AppBar),
        findsNothing,
        reason: 'sheet header, not AppBar',
      );
    });

    testWidgets('the handle resizes without dragging', (tester) async {
      final shell = await pumpShell(tester);
      final handle = tester.ensureSemantics();
      await tester.pump();
      final start = shell.sheet.height;
      final node = tester.getSemantics(find.bySemanticsLabel('Panel'));
      expect(node.label, contains('Panel'));
      node.owner!.performAction(node.id, SemanticsAction.increase);
      await ObaTestEnv.settle(tester);
      expect(shell.sheet.height, greaterThan(start));
      node.owner!.performAction(node.id, SemanticsAction.decrease);
      await ObaTestEnv.settle(tester);
      expect(shell.sheet.height, closeTo(start, 0.5));
      handle.dispose();
    });

    testWidgets('dragging the sheet header snaps to a detent', (tester) async {
      final shell = await pumpShell(tester);
      final start = shell.sheet.height;
      await tester.drag(find.byType(ObaSheetHandle), const Offset(0, -300));
      await ObaTestEnv.settle(tester);
      expect(shell.sheet.height, greaterThan(start));
      expect(
        shell.sheet.snapHeights.any(
          (h) => (h - shell.sheet.height).abs() < 0.5,
        ),
        isTrue,
      );
    });

    testWidgets('dragging the sheet moves the map chrome, not the map', (
      tester,
    ) async {
      final shell = await pumpShell(tester);
      final mapWidget = tester.widget(find.byType(FlutterMap));
      final markers = tester.widgetList(find.byType(MarkerLayer)).toList();
      final attribution = find.textContaining('©');
      double pad() =>
          shell.sheet.height.clamp(0, shell.sheet.maxHeight * 0.5).toDouble();
      final padBefore = pad();
      final bottomBefore = tester.getBottomLeft(attribution).dy;

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(ObaSheetHandle)),
      );
      for (var i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(0, -20));
        await tester.pump();
      }
      // Mid-drag, every frame: the map subtree is the same widget, and the
      // floating chrome follows the sheet.
      expect(
        identical(tester.widget(find.byType(FlutterMap)), mapWidget),
        isTrue,
      );
      expect(tester.widgetList(find.byType(MarkerLayer)).toList(), markers);
      expect(pad(), greaterThan(padBefore));
      expect(
        tester.getBottomLeft(attribution).dy,
        closeTo(bottomBefore - (pad() - padBefore), 0.5),
      );
      await gesture.up();
      await ObaTestEnv.settle(tester);
      expect(
        identical(tester.widget(find.byType(FlutterMap)), mapWidget),
        isTrue,
      );
    });

    testWidgets('wide layouts use a side panel', (tester) async {
      final shell = await pumpShell(tester, size: const Size(1200, 800));
      expect(find.byType(ObaSheetHandle), findsNothing);
      shell.navigator.push(const StopRoute('1_75403'));
      await ObaTestEnv.settle(tester);
      expect(find.byType(StopPage), findsOneWidget);
      final panel = tester.getRect(find.byType(StopPage));
      expect(panel.width, lessThanOrEqualTo(400));
      expect(find.byTooltip('Back'), findsOneWidget);
    });

    testWidgets('page overlays show while on top and return on pop', (
      tester,
    ) async {
      final shell = await pumpShell(tester);
      shell.navigator.push(const _OverlayRoute());
      await ObaTestEnv.settle(tester);
      expect(shell.coordinator.overlay.markers.single.label, 'Here');
      shell.navigator.push(const SearchRoute());
      await ObaTestEnv.settle(tester);
      expect(shell.coordinator.overlay.isEmpty, isTrue);
      shell.navigator.pop();
      await ObaTestEnv.settle(tester);
      expect(shell.coordinator.overlay.markers.single.label, 'Here');
      shell.navigator.pop();
      await ObaTestEnv.settle(tester);
      expect(shell.coordinator.overlay.isEmpty, isTrue);
    });

    testWidgets('a dropped pin leaves the page below its overlay', (
      tester,
    ) async {
      final shell = await pumpShell(tester);
      shell.navigator.push(const _OverlayRoute());
      await ObaTestEnv.settle(tester);
      await tester.longPressAt(const Offset(195, 200));
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack.last, isA<PlaceRoute>());
      expect(
        shell.coordinator.overlay.markers.single.kind,
        ObaMapMarkerKind.place,
      );
      // The pin's own page offers "Remove pin"; it just closes the page.
      final remove = find.text('Remove pin');
      await tester.ensureVisible(remove);
      await ObaTestEnv.settle(tester);
      tester
          .widget<ObaListRow>(
            find.ancestor(of: remove, matching: find.byType(ObaListRow)),
          )
          .onTap!();
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack.last, isA<_OverlayRoute>());
      expect(shell.coordinator.overlay.markers.single.label, 'Here');
    });
  });
}

class _PushButton extends StatelessWidget {
  const _PushButton(this.route);
  final ObaRoute route;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: TextButton(
        onPressed: () => ObaNavigator.of(context).push(route),
        child: const Text('go'),
      ),
    ),
  );
}

class _OverlayRoute extends ObaCustomRoute {
  const _OverlayRoute();

  @override
  String get id => 'test-overlay';

  @override
  Widget build(BuildContext context) => const ObaMapOverlays(
    overlay: ObaMapOverlay(
      markers: [
        ObaMapMarker(coordinate: Coordinate(47.6, -122.3), label: 'Here'),
      ],
    ),
    child: ObaSheetPage(title: 'Overlay', slivers: []),
  );
}

class _FakeDelegate implements ObaMapCameraDelegate {
  final moves = <(Coordinate, double?)>[];
  final fits = <RegionRect>[];

  @override
  void fitBounds(RegionRect bounds) => fits.add(bounds);

  @override
  void moveTo(Coordinate center, {double? zoom}) => moves.add((center, zoom));
}
