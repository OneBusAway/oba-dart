import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:tapline_example/data/mock_data.dart';
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
    expect(find.text('Charged (Stored value)'), findsOneWidget);
    expect(
      find.text('Ride again from Eighth College / Theatre District'),
      findsOneWidget,
    );
    final card = tester.widget<ObaStopDeparturesCard>(
      find.byType(ObaStopDeparturesCard),
    );
    expect(card.stopId, Stops.eighthCollege);
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
}
