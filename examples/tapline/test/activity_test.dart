import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:tapline_example/data/mock_data.dart';
import 'package:tapline_example/data/models.dart';
import 'package:tapline_example/data/wallet.dart';
import 'package:tapline_example/screens/activity_screen.dart';

import 'support/test_env.dart';

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());

  testWidgets('lists taps, each read as one sentence', (tester) async {
    final semantics = tester.ensureSemantics();
    await env.pumpApp(tester, home: const ActivityScreen());
    expect(find.byType(TapRow), findsNWidgets(5));
    expect(find.text('Gilman Transit Center'), findsNWidgets(2));
    expect(find.text(r'$0.00 · Day Pass'), findsNWidgets(2));
    expect(
      find.bySemanticsLabel(
        RegExp(
          r'^Route Blue, UC San Diego Blue Line, from UCSD Central Campus\. '
          r'.*Fare \$0\.00, paid with Day Pass\.$',
        ),
      ),
      findsWidgets,
    );
    await expectAccessible(tester);
    semantics.dispose();
    await env.tearDown(tester);
  });

  testWidgets('a tap opens its detail with the fare breakdown and live '
      'departures from the stop', (tester) async {
    await env.pumpApp(tester, home: const ActivityScreen());
    await tester.tap(find.byType(TapRow).at(2)); // route 30, stored value
    await TestEnv.settle(tester);
    expect(find.text('Ride details'), findsOneWidget);
    expect(find.text('Base fare'), findsOneWidget);
    // Stored value: the fare is deducted, nothing is "covered by pass".
    expect(find.text('Deducted from stored value'), findsOneWidget);
    expect(find.textContaining('Covered by'), findsNothing);
    expect(find.textContaining('Charged ('), findsNothing);
    final card = tester.widget<ObaStopDeparturesCard>(
      find.byType(ObaStopDeparturesCard),
    );
    expect(card.stopId, Stops.eighthCollege);
    // The stop's name shows once: under the departures card's title.
    expect(card.title, 'Ride again');
    expect(find.textContaining('Eighth College'), findsOneWidget);
    expect(
      env.requests.map((r) => r.url.path),
      contains(contains('arrivals-and-departures-for-stop/MTS_24151')),
    );
    env.expectReadOnly();
    await env.tearDown(tester);
  });

  testWidgets('no overflow at 200% text', (tester) async {
    await env.pumpApp(
      tester,
      home: const ActivityScreen(),
      textScale: 2,
      surfaceSize: const Size(390, 844),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(TapRow).first);
    await TestEnv.settle(tester);
    expect(tester.takeException(), isNull);
    await env.tearDown(tester);
  });

  testWidgets('a pass ride shows what the pass covered', (tester) async {
    await env.pumpApp(tester, home: const ActivityScreen());
    await tester.tap(find.byType(TapRow).first); // Blue Line, Day Pass
    await TestEnv.settle(tester);
    expect(find.text('Covered by Day Pass'), findsOneWidget);
    expect(find.text(r'-$2.50'), findsOneWidget);
    expect(find.text('Charged (Day Pass)'), findsOneWidget);
    expect(find.text('Deducted from stored value'), findsNothing);
    await env.tearDown(tester);
  });

  testWidgets('a tap without a stop reads by its route and has no departures', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final now = DateTime.now();
    final wallet = Wallet(
      balanceCents: 0,
      passes: [],
      taps: [
        Tap(
          id: 'tap-bus',
          time: now,
          routeShortName: '201',
          routeName: 'SuperLoop',
          baseFareCents: 250,
          chargedCents: 250,
          paidWith: Tap.storedValue,
        ),
      ],
      now: () => now,
    );
    await env.pumpApp(tester, wallet: wallet, home: const ActivityScreen());
    expect(find.text('SuperLoop'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'^Route 201, SuperLoop\. ')),
      findsOneWidget,
    );
    await tester.tap(find.byType(TapRow));
    await TestEnv.settle(tester);
    expect(find.text('Ride details'), findsOneWidget);
    expect(find.byType(ObaStopDeparturesCard), findsNothing);
    semantics.dispose();
    await env.tearDown(tester);
  });
}
