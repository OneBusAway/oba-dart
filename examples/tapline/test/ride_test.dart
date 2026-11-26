import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:tapline_example/screens/ride_screen.dart';
import 'package:tapline_example/widgets/ticket_code.dart';

import 'support/test_env.dart';

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());

  testWidgets('the ticket code, pass name and headings are labelled', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await env.pumpApp(
      tester,
      home: const RideScreen(),
      surfaceSize: const Size(390, 2000),
    );
    expect(
      find.bySemanticsLabel(RegExp(r'^Ticket code for Day Pass, valid until ')),
      findsOneWidget,
    );
    final heading = tester.getSemantics(find.text('Day Pass'));
    expect(heading.flagsCollection.isHeader, isTrue);
    expect(find.textContaining('brightness'), findsOneWidget);
    expect(find.textContaining('Live ticket'), findsOneWidget);
    // The SDK card for the boarding stop, titled by the host.
    final card = tester.widget<ObaStopDeparturesCard>(
      find.byType(ObaStopDeparturesCard),
    );
    expect(card.title, 'Your next ride from UCSD Central Campus');
    await expectAccessible(tester);
    semantics.dispose();
    await env.tearDown(tester);
  });

  testWidgets('the code redraws every 30 seconds', (tester) async {
    await env.pumpApp(tester, home: const RideScreen());
    int token() => tester.widget<TicketCode>(find.byType(TicketCode)).token;
    final first = token();
    expect(first, ticketToken('pass-today', DateTime.now()));
    await tester.pump(const Duration(seconds: 30));
    // The token is from the wall clock; it must at least have been rebuilt
    // from the current window.
    expect(token(), ticketToken('pass-today', DateTime.now()));
    await env.tearDown(tester);
  });

  testWidgets('the live band animates, and stops with reduce motion', (
    tester,
  ) async {
    await env.pumpApp(
      tester,
      home: const RideScreen(),
      animations: true,
      settleAll: false,
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.hasRunningAnimations, isTrue);
    await env.tearDown(tester);

    env = await TestEnv.create();
    await env.pumpApp(tester, home: const RideScreen());
    expect(tester.hasRunningAnimations, isFalse);
    await env.tearDown(tester);
  });

  testWidgets('no overflow at 200% text', (tester) async {
    await env.pumpApp(
      tester,
      home: const RideScreen(),
      textScale: 2,
      surfaceSize: const Size(390, 844),
    );
    expect(tester.takeException(), isNull);
    await env.tearDown(tester);
  });
}
