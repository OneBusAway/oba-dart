import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

void main() {
  late ObaTestEnv env;
  setUp(() async {
    env = await ObaTestEnv.create(
      responses: {'stops-for-route': fixture('stops_for_route_1_44.json')},
    );
  });
  tearDown(() => env.dispose());

  testWidgets('stops by direction; switching direction; tap pushes stop', (
    tester,
  ) async {
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const RouteStopsPage(routeId: '1_44'),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    expect(find.text('Route 44'), findsOneWidget);
    expect(find.text('To BALLARD WALLINGFORD'), findsOneWidget);
    expect(find.text('32 stops'), findsOneWidget);
    expect(find.text('MONTLAKE BLVD E & SR 520'), findsOneWidget);
    await tester.tap(find.byType(ObaStopRow).first);
    expect(pushed.last, const StopRoute('1_25751'));

    await tester.tap(
      find.text('To UNIVERSITY OF WASHINGTON MEDICAL CENTER WALLINGFORD'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ObaStopRow).first);
    expect(pushed.last, const StopRoute('1_18085'));
  });

  testWidgets('route shape and stops on the map', (tester) async {
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    await env.pumpPage(
      tester,
      const RouteStopsPage(routeId: '1_44'),
      coordinator: map,
    );
    expect(map.overlay.stops.length, 32);
    expect(map.overlay.polylines, isNotEmpty);
    expect(map.overlay.hideStopPins, isTrue);
    expect(map.overlay.fitBounds, isNotNull);
  });

  testWidgets('error state', (tester) async {
    env.dispose();
    env = await ObaTestEnv.create(responses: {'stops-for-route': '{bad'});
    await env.pumpPage(tester, const RouteStopsPage(routeId: '1_44'));
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('embedded', (tester) async {
    await env.pumpPage(
      tester,
      const RouteStopsPage(routeId: '1_44'),
      presentation: ObaPresentation.embedded,
    );
    expect(find.byType(ObaStopRow), findsWidgets);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('accessibility (${mode.name})', (tester) async {
      await env.pumpPage(
        tester,
        const RouteStopsPage(routeId: '1_44'),
        themeMode: mode,
      );
      await expectObaAccessibility(tester);
    });
  }

  testWidgets('no overflow at 200% text', (tester) async {
    await env.expectNoOverflowAtTextScale(
      tester,
      const RouteStopsPage(routeId: '1_44'),
    );
  });
}
