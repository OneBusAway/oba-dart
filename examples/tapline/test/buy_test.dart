import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;
import 'package:tapline_example/data/mock_data.dart';
import 'package:tapline_example/data/models.dart';
import 'package:tapline_example/data/wallet.dart';
import 'package:tapline_example/screens/buy_screen.dart';
import 'package:tapline_example/widgets/host_oba_page.dart';

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

  group('Trip fare suggestion', () {
    final morning = DateTime(2026, 11, 25, 8);
    Wallet wallet({int balance = 1850, bool pass = false}) => Wallet(
      balanceCents: balance,
      passes: [
        if (pass)
          Pass(
            id: 'p',
            product: dayPass,
            activatedAt: morning,
            expiresAt: endOfServiceDay(morning),
          ),
      ],
      taps: [],
      now: () => morning,
    );

    test('without a fare from OTP, uses the sample table by agency', () {
      final trip = westlakeItinerary(); // one Sound Transit leg, no fare
      expect(trip.fare, isNull);
      expect(sampleTripFareCents(trip), 300);
      final s = tripFareSuggestion(wallet(), trip);
      expect(s.fromPlanner, isFalse);
      expect(
        s.text,
        r'Suggested fare for your trip: $3.00 (stored value covers it)',
      );
      expect(
        tripFareSuggestion(wallet(pass: true), trip).text,
        r'Suggested fare for your trip: $3.00 (your Day Pass covers it)',
      );
      expect(
        tripFareSuggestion(wallet(balance: 100), trip).text,
        r'Suggested fare for your trip: $3.00 '
        r'(add $2.00 of stored value to cover it)',
      );
      expect(
        fareAdvice(wallet(), trip: trip).first,
        startsWith('Suggested fare for your trip'),
      );
      expect(fareAdvice(wallet()).first, isNot(contains('Suggested fare')));
    });

    test('uses the itinerary fare when OTP reports one', () {
      final base = westlakeItinerary();
      final trip = tp.Itinerary(
        duration: base.duration,
        startTime: base.startTime,
        endTime: base.endTime,
        legs: base.legs,
        fare: const tp.Money(cents: 275, currencyCode: 'USD'),
      );
      final s = tripFareSuggestion(wallet(), trip);
      expect(s.fromPlanner, isTrue);
      expect(s.cents, 275);
      expect(s.text, contains(r'$2.75'));
    });

    test('the sample table counts transit legs, with 2-hour transfers', () {
      final t0 = DateTime(2026, 11, 25, 9);
      final here = westlakeItinerary().legs.first.from;
      tp.Leg leg(String mode, Duration after) => tp.Leg(
        startTime: t0.add(after),
        endTime: t0.add(after + const Duration(minutes: 20)),
        mode: mode,
        from: here,
        to: here,
        transitLeg: mode != 'WALK',
      );
      tp.Itinerary trip(List<tp.Leg> legs) => tp.Itinerary(
        duration: 0,
        startTime: legs.first.startTime,
        endTime: legs.last.endTime,
        legs: legs,
      );
      expect(sampleTripFareCents(trip([leg('WALK', Duration.zero)])), 0);
      // Bus then a transfer to rail within 2 hours: pay the difference.
      expect(
        sampleTripFareCents(
          trip([
            leg('BUS', Duration.zero),
            leg('RAIL', const Duration(minutes: 30)),
          ]),
        ),
        500,
      );
      // Two buses 3 hours apart: two fares.
      expect(
        sampleTripFareCents(
          trip([
            leg('BUS', Duration.zero),
            leg('BUS', const Duration(hours: 3)),
          ]),
        ),
        500,
      );
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

    testWidgets('Plan your trip pushes the trip planner under Tapline\'s '
        'app bar', (tester) async {
      await env.pumpApp(tester, home: const BuyScreen());
      await tester.tap(find.text('Not sure which fare? Plan your trip'));
      await TestEnv.settle(tester);
      expect(find.byType(TripPlannerPage), findsOneWidget);
      final host = tester.widget<HostObaPage>(find.byType(HostObaPage));
      expect(host.title, 'Plan a trip');
      expect(find.byType(AppBar), findsOneWidget);
      final route = ModalRoute.of(tester.element(find.byType(TripPlannerPage)));
      expect(route?.settings.arguments, isA<TripPlannerRoute>());
      env.expectReadOnly();
      await env.tearDown(tester);
    });

    testWidgets('the itinerary opened in the planner drives the fare '
        'suggestion, and clears', (tester) async {
      // The itinerary's details page draws a map.
      mockMapTileCache();
      final wallet = Wallet.sample(now: () => DateTime(2026, 11, 25, 8));
      await env.pumpApp(
        tester,
        wallet: wallet,
        home: const BuyScreen(),
        surfaceSize: const Size(390, 1600),
      );
      expect(find.textContaining('Suggested fare'), findsNothing);
      expect(find.textContaining('get a fare suggestion'), findsOneWidget);

      await tester.tap(find.text('Not sure which fare? Plan your trip'));
      await TestEnv.settle(tester);
      expect(
        tester
            .widget<TripPlannerPage>(find.byType(TripPlannerPage))
            .onItinerarySelected,
        isNotNull,
      );
      await openItinerary(tester, westlakeItinerary());
      await TestEnv.settle(tester);
      tester
          .state<NavigatorState>(find.byType(Navigator).first)
          .popUntil((r) => r.isFirst);
      await TestEnv.settle(tester);

      expect(
        find.text(
          r'Suggested fare for your trip: $3.00 (your Day Pass covers it)',
        ),
        findsOneWidget,
      );
      expect(find.textContaining("demo fare table"), findsOneWidget);
      await expectAccessible(tester);

      await tester.tap(find.text('Clear planned trip'));
      await tester.pump();
      expect(find.textContaining('Suggested fare'), findsNothing);
      env.expectReadOnly();
      await env.tearDown(tester);
    });
  });
}
