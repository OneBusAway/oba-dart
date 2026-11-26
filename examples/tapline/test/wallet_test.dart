import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:tapline_example/screens/home_shell.dart';
import 'package:tapline_example/screens/ride_screen.dart';

import 'support/test_env.dart';

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());

  testWidgets('the Wallet tab builds with its SDK embeds', (tester) async {
    await env.pumpApp(tester, surfaceSize: const Size(390, 1600));
    expect(find.textContaining(r'$18.50'), findsWidgets);
    expect(find.textContaining('Day Pass · valid until'), findsOneWidget);
    expect(find.byType(ServiceAlertsSection), findsOneWidget);
    expect(find.byType(ObaNearbyStopsCard), findsOneWidget);
    // One way to the ticket: the shell's floating Ride button. Departures
    // from the last tap's stop live on the Ride screen, not here.
    expect(find.text('Ride'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('From your last ride'), findsNothing);
    expect(find.byType(ObaStopDeparturesCard), findsNothing);

    // The SDK fetched live data through the host's application, read-only.
    final urls = env.requests.map((r) => r.url.toString()).toList();
    expect(urls, contains(contains('stops-for-location')));
    env.expectReadOnly();
    await env.tearDown(tester);
  });

  testWidgets('the toggle outlines every embed', (tester) async {
    await env.pumpApp(tester, surfaceSize: const Size(390, 1600));
    expect(find.textContaining('OBA · '), findsNothing);
    await tester.tap(find.byTooltip('Show OBA embeds'));
    await tester.pump();
    expect(find.text('OBA · ServiceAlertsSection'), findsOneWidget);
    expect(find.text('OBA · ObaNearbyStopsCard'), findsOneWidget);
    expect(find.byTooltip('Hide OBA embeds'), findsOneWidget);
    await env.tearDown(tester);
  });

  testWidgets('the Ride button opens the ticket; tabs switch', (tester) async {
    await env.pumpApp(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await TestEnv.settle(tester);
    expect(find.byType(RideScreen), findsOneWidget);
    await tester.pageBack();
    await TestEnv.settle(tester);

    await tester.tap(find.text('Activity'));
    await TestEnv.settle(tester);
    expect(find.text('Gilman Transit Center'), findsWidgets);
    await tester.tap(find.text('Buy'));
    await TestEnv.settle(tester);
    expect(find.text('Which fare is right?'), findsOneWidget);
    await env.tearDown(tester);
  });

  testWidgets('accessible, and no overflow at 200% text', (tester) async {
    await env.pumpApp(tester, surfaceSize: const Size(390, 844));
    await expectAccessible(tester);
    await env.pumpApp(tester, textScale: 2, surfaceSize: const Size(390, 844));
    expect(tester.takeException(), isNull);
    // Tall enough to build every embed at 200%.
    await env.pumpApp(tester, textScale: 2, surfaceSize: const Size(390, 4000));
    expect(find.byType(ObaNearbyStopsCard), findsOneWidget);
    expect(tester.takeException(), isNull);
    await env.tearDown(tester);
  });

  testWidgets('accessible in dark mode, Wallet and Buy', (tester) async {
    await env.pumpApp(
      tester,
      brightness: Brightness.dark,
      surfaceSize: const Size(390, 2400),
    );
    expect(
      Theme.of(tester.element(find.text('Tapline'))).brightness,
      Brightness.dark,
    );
    await expectAccessible(tester);
    await tester.tap(find.text('Buy'));
    await TestEnv.settle(tester);
    await expectAccessible(tester);
    await env.tearDown(tester);
  });

  testWidgets('the Map tab hides the floating Ride button and has a ticket '
      'button in its app bar', (tester) async {
    mockMapTileCache();
    await env.pumpApp(
      tester,
      home: const HomeShell(initialIndex: HomeShell.mapTab),
    );
    expect(find.byType(ObaMapView), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    await tester.tap(find.byTooltip('Show your ticket'));
    await TestEnv.settle(tester);
    expect(find.byType(RideScreen), findsOneWidget);
    await tester.pageBack();
    await TestEnv.settle(tester);

    await tester.tap(find.text('Wallet'));
    await TestEnv.settle(tester);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    env.expectReadOnly();
    await env.tearDown(tester);
  });
}
