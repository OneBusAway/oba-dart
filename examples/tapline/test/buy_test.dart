import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapline_example/data/mock_data.dart';
import 'package:tapline_example/data/models.dart';
import 'package:tapline_example/data/wallet.dart';
import 'package:tapline_example/screens/buy_screen.dart';

import 'support/test_env.dart';

void main() {
  group('Wallet', () {
    test('a top-up adds stored value; a pass becomes active', () {
      final now = DateTime(2026, 11, 25, 10);
      final wallet = Wallet(
        balanceCents: 1850,
        passes: [],
        taps: [],
        now: () => now,
      );
      expect(wallet.activePass, isNull);
      wallet.purchase(topUps[1]);
      expect(wallet.balanceCents, 2850);
      wallet.purchase(dayPass);
      expect(wallet.activePass?.product, dayPass);
      expect(wallet.activePass?.expiresAt, DateTime(2026, 11, 25, 23, 59));
      wallet.purchase(monthPass);
      expect(wallet.activePass?.product, monthPass, reason: 'lasts longest');
    });

    test('fare advice is host logic from the rider history', () {
      final now = DateTime(2026, 11, 25, 18);
      Tap tap(int h) => Tap(
        id: 't$h',
        time: DateTime(2026, 11, 25, h),
        routeShortName: '201',
        routeName: 'SuperLoop',
        stopId: Stops.gilmanTransitCenter,
        stopName: 'Gilman Transit Center',
        baseFareCents: 250,
        chargedCents: 250,
        paidWith: 'Stored value',
      );
      final busy = Wallet(
        balanceCents: 0,
        passes: [],
        taps: [tap(8), tap(12)],
        now: () => now,
      );
      expect(fareAdvice(busy).first, contains('A Day Pass'));
      final quiet = Wallet(
        balanceCents: 0,
        passes: [],
        taps: [],
        now: () => now,
      );
      expect(fareAdvice(quiet).first, contains('1-Ride'));
      expect(formatMoney(1850), r'$18.50');
    });
  });

  group('Buy screen', () {
    late TestEnv env;
    setUp(() async => env = await TestEnv.create());

    testWidgets('lists products, advice and the trip planner card', (
      tester,
    ) async {
      await env.pumpApp(tester, home: const BuyScreen());
      expect(find.text('1-Ride'), findsOneWidget);
      expect(find.text('Day Pass'), findsOneWidget);
      expect(find.text('30-Day Pass'), findsOneWidget);
      expect(find.text('Which fare is right?'), findsOneWidget);
      expect(find.text('Not sure which fare? Plan your trip'), findsOneWidget);
      await expectAccessible(tester);
      await env.tearDown(tester);
    });

    testWidgets('checkout confirms a demo purchase and updates the balance', (
      tester,
    ) async {
      final wallet = Wallet.sample();
      await env.pumpApp(
        tester,
        wallet: wallet,
        surfaceSize: const Size(390, 2400),
      );
      expect(find.text(r'$18.50'), findsOneWidget);

      await tester.tap(find.text('Buy'));
      await TestEnv.settle(tester);
      await tester.tap(find.text(r'Add $10.00'));
      await tester.pumpAndSettle();
      expect(find.text('Checkout'), findsOneWidget);
      await expectAccessible(tester);

      await tester.tap(find.text(r'Confirm demo purchase, $10.00'));
      await tester.pumpAndSettle();
      expect(wallet.balanceCents, 2850);
      expect(
        find.text(r'Demo purchase, no charge. Stored value is now $28.50.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Wallet'));
      await TestEnv.settle(tester);
      expect(find.text(r'$28.50'), findsOneWidget);
      env.expectReadOnly();
      await env.tearDown(tester);
    });

    testWidgets('no overflow at 200% text, screen and checkout sheet', (
      tester,
    ) async {
      await env.pumpApp(
        tester,
        home: const BuyScreen(),
        textScale: 2,
        surfaceSize: const Size(390, 844),
      );
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('Day Pass'), 200);
      await tester.tap(find.text('Day Pass'));
      await tester.pumpAndSettle();
      expect(find.text('Checkout'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await env.tearDown(tester);
    });
  });
}
