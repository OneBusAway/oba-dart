import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapline_example/data/mock_data.dart';
import 'package:tapline_example/data/models.dart';
import 'package:tapline_example/data/wallet.dart';
import 'package:tapline_example/widgets/balance_card.dart';

void main() {
  testWidgets('the balance card drops a pass when it expires', (tester) async {
    final start = clock.now();
    final wallet = Wallet(
      balanceCents: 500,
      passes: [
        Pass(
          id: 'ride',
          product: oneRide,
          activatedAt: start,
          expiresAt: start.add(const Duration(minutes: 10)),
        ),
      ],
      taps: [],
      now: clock.now,
    );
    await tester.pumpWidget(
      // As on the Wallet tab, which rebuilds the card from the wallet.
      MaterialApp(
        home: Scaffold(
          body: ListenableBuilder(
            listenable: wallet,
            builder: (context, _) => BalanceCard(wallet: wallet),
          ),
        ),
      ),
    );
    expect(find.textContaining('1-Ride · valid until'), findsOneWidget);

    await tester.pump(const Duration(minutes: 9));
    expect(find.textContaining('1-Ride · valid until'), findsOneWidget);

    await tester.pump(const Duration(minutes: 1, seconds: 1));
    expect(find.textContaining('1-Ride'), findsNothing);
    expect(find.text('No active pass'), findsOneWidget);

    // Unmounting removes the last listener and cancels the expiry timer.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a 30-day pass waits without notifying until it expires', (
    tester,
  ) async {
    final start = clock.now();
    final wallet = Wallet(
      balanceCents: 0,
      passes: [
        Pass(
          id: 'month',
          product: monthPass,
          activatedAt: start,
          expiresAt: start.add(const Duration(days: 30)),
        ),
      ],
      taps: [],
      now: clock.now,
    );
    var notified = 0;
    void listener() => notified++;
    wallet.addListener(listener);
    // Timers wake at most daily (browsers can't wait 30 days), but a wake
    // before the pass expires changes nothing, so nothing is notified.
    await tester.pump(const Duration(days: 29, hours: 23));
    expect(notified, 0);
    expect(wallet.activePass?.product, monthPass);
    await tester.pump(const Duration(hours: 2));
    expect(notified, 1);
    expect(wallet.activePass, isNull);
    wallet.removeListener(listener);
  });
}
