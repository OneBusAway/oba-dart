import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:tapline_example/data/mock_data.dart';
import 'package:tapline_example/data/models.dart';
import 'package:tapline_example/data/wallet.dart';
import 'package:tapline_example/screens/ride_screen.dart';
import 'package:tapline_example/widgets/host_oba_page.dart';
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
    // The SDK card for the last tap's stop, titled by the host. Not "your
    // next ride": on a return trip the rider is at the other end.
    final card = tester.widget<ObaStopDeparturesCard>(
      find.byType(ObaStopDeparturesCard),
    );
    expect(card.stopId, Stops.ucsdCentralCampus);
    expect(card.title, 'Ride again');
    expect(find.textContaining('Your next ride'), findsNothing);
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

  testWidgets('an expired pass shows stored value, not a validity', (
    tester,
  ) async {
    final now = DateTime(2026, 11, 25, 8);
    final wallet = Wallet(
      balanceCents: 1850,
      passes: [
        Pass(
          id: 'old',
          product: dayPass,
          activatedAt: DateTime(2026, 11, 24, 8),
          expiresAt: endOfServiceDay(DateTime(2026, 11, 24)),
        ),
      ],
      taps: [],
      now: () => now,
    );
    await env.pumpApp(
      tester,
      wallet: wallet,
      home: const RideScreen(),
      surfaceSize: const Size(390, 2000),
    );
    expect(find.text('Stored value'), findsOneWidget);
    expect(find.textContaining('valid until'), findsNothing);
    await env.tearDown(tester);
  });

  testWidgets('a last tap without a stop falls back to nearby departures', (
    tester,
  ) async {
    final now = DateTime.now();
    final wallet = Wallet(
      balanceCents: 1850,
      passes: [],
      taps: [
        // An on-board validator: the route is known, the stop is not.
        Tap(
          id: 'tap-bus',
          time: now.subtract(const Duration(minutes: 10)),
          routeShortName: '201',
          routeName: 'SuperLoop',
          baseFareCents: 250,
          chargedCents: 250,
          paidWith: Tap.storedValue,
        ),
      ],
      now: () => now,
    );
    await env.pumpApp(
      tester,
      wallet: wallet,
      home: const RideScreen(),
      surfaceSize: const Size(390, 2000),
    );
    expect(find.byType(ObaStopDeparturesCard), findsNothing);
    expect(find.byType(ObaNearbyStopsCard), findsOneWidget);
    expect(find.textContaining('Ride again'), findsNothing);
    env.expectReadOnly();
    await env.tearDown(tester);
  });

  testWidgets('a departure opens the trip page under Tapline\'s app bar', (
    tester,
  ) async {
    await env.pumpApp(
      tester,
      home: const RideScreen(),
      surfaceSize: const Size(390, 2000),
    );
    await tester.tap(find.byType(ObaDepartureRow).first);
    await TestEnv.settle(tester);

    expect(find.byType(TripPage), findsOneWidget);
    final host = tester.widget<HostObaPage>(find.byType(HostObaPage));
    expect(host.title, 'Transit');
    expect(host.showsHeader, isTrue);
    // Embedded: the SDK page draws no app bar of its own.
    expect(find.byType(AppBar), findsOneWidget);
    env.expectReadOnly();
    await env.tearDown(tester);
  });
}
