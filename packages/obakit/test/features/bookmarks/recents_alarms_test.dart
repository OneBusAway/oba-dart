import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';
import 'bookmarks_support.dart';

void main() {
  late ObaTestEnv env;

  tearDown(() => env.dispose());

  void seedRecents() {
    final store = env.app.core.userData;
    store
      ..addRecentStop(kStop(id: 'MTS_1', name: 'First St'), regionId: 1)
      ..addRecentStop(kStop(id: 'MTS_2', name: 'Second St'), regionId: 1)
      ..addRecentStop(kStop(id: 'X_9', name: 'Elsewhere'), regionId: 99);
  }

  group('recent stops', () {
    testWidgets('empty state offers to find stops', (tester) async {
      env = await ObaTestEnv.create();
      final nav = RecordingNavigator();
      await env.pumpPage(tester, withNavigator(nav, const RecentStopsPage()));
      expect(find.text('No recent stops'), findsOneWidget);
      await tester.tap(find.text('Find stops on the map'));
      expect(nav.popToRoots, 1);
      await expectObaAccessibility(tester);
    });

    testWidgets('newest first, current region only, tap opens the stop', (
      tester,
    ) async {
      env = await ObaTestEnv.create();
      seedRecents();
      final nav = RecordingNavigator();
      await env.pumpPage(tester, withNavigator(nav, const RecentStopsPage()));
      expect(find.text('Elsewhere'), findsNothing);
      expect(
        tester.getTopLeft(find.text('Second St')).dy,
        lessThan(tester.getTopLeft(find.text('First St')).dy),
      );
      await tester.tap(find.text('First St'));
      expect(nav.pushed.single, const StopRoute('MTS_1'));
    });

    testWidgets('remove button, swipe and clear all', (tester) async {
      env = await ObaTestEnv.create();
      seedRecents();
      final store = env.app.core.userData;
      await env.pumpPage(tester, const RecentStopsPage());

      await tester.tap(find.byTooltip('Remove Second St from recent stops'));
      await tester.pumpAndSettle();
      expect(find.text('Second St'), findsNothing);
      expect(find.text('Removed Second St'), findsOneWidget);

      await tester.drag(
        find.byKey(const ValueKey('recent-MTS_1')),
        const Offset(-700, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('First St'), findsNothing);
      expect(store.recentStopsInRegion(1), isEmpty);

      store.addRecentStop(kStop(id: 'MTS_3', name: 'Third St'), regionId: 1);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Clear all'));
      await tester.pumpAndSettle();
      expect(find.text('Clear recent stops?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(store.recentStopsInRegion(1), hasLength(1));
      await tester.tap(find.byTooltip('Clear all'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Clear all'));
      await tester.pumpAndSettle();
      expect(store.recentStopsInRegion(1), isEmpty);
      expect(find.text('No recent stops'), findsOneWidget);
    });

    testWidgets('accessible and reflowing everywhere', (tester) async {
      env = await ObaTestEnv.create();
      seedRecents();
      for (final p in ObaPresentation.values) {
        for (final mode in [ThemeMode.light, ThemeMode.dark]) {
          await env.pumpPage(
            tester,
            const RecentStopsPage(),
            presentation: p,
            themeMode: mode,
          );
          await expectObaAccessibility(tester);
        }
      }
      await env.expectNoOverflowAtTextScale(tester, const RecentStopsPage());
    });

    testWidgets('section shows the newest and links to the list', (
      tester,
    ) async {
      env = await ObaTestEnv.create();
      seedRecents();
      final nav = RecordingNavigator();
      await env.pumpPage(
        tester,
        withNavigator(
          nav,
          const SingleChildScrollView(child: RecentStopsSection()),
        ),
        presentation: ObaPresentation.embedded,
      );
      expect(find.text('Second St'), findsOneWidget);
      await tester.tap(find.text('See all'));
      expect(nav.pushed.single, const RecentStopsRoute());
      await expectObaAccessibility(tester);
    });

    testWidgets('empty section says what will appear', (tester) async {
      env = await ObaTestEnv.create();
      await env.pumpPage(
        tester,
        const RecentStopsSection(),
        presentation: ObaPresentation.embedded,
      );
      expect(find.text('Stops you look at appear here.'), findsOneWidget);
      expect(find.text('See all'), findsNothing);
    });
  });

  group('alarms section', () {
    StoredAlarm alarm({required DateTime trip}) => StoredAlarm(
      url: Uri.parse('https://alarms.example/1'),
      tripDate: trip,
      leadTimeMinutes: 5,
      deepLink: TripDeepLink(
        title: '30 - Old Town',
        regionId: 1,
        stopId: kStopId,
        tripId: 'MTS_t1',
        serviceDate: DateTime.utc(2026, 9, 24),
        stopSequence: 9,
      ),
    );

    testWidgets('is empty without alarms and hides expired ones', (
      tester,
    ) async {
      await atFixtureTime(() async {
        env = await ObaTestEnv.create();
        env.app.core.userData.addAlarm(
          alarm(trip: fixtureNow.subtract(const Duration(hours: 1))),
        );
        await env.pumpPage(
          tester,
          const AlarmsSection(),
          presentation: ObaPresentation.embedded,
        );
        expect(find.text('Alarms'), findsNothing);
      });
    });

    testWidgets('lists active alarms; tap opens the trip', (tester) async {
      await atFixtureTime(() async {
        env = await ObaTestEnv.create();
        env.app.core.userData.addAlarm(
          alarm(trip: fixtureNow.add(const Duration(hours: 1))),
        );
        final nav = RecordingNavigator();
        await env.pumpPage(
          tester,
          withNavigator(
            nav,
            const SingleChildScrollView(child: AlarmsSection()),
          ),
          presentation: ObaPresentation.embedded,
        );
        expect(find.text('Alarms'), findsOneWidget);
        expect(find.text('30 - Old Town'), findsOneWidget);
        expect(
          find.textContaining('5 minutes before departure'),
          findsOneWidget,
        );
        await tester.tap(find.text('30 - Old Town'));
        expect(nav.pushed.single, isA<TripRoute>());
        await expectObaAccessibility(tester);
      });
    });

    testWidgets('removing an alarm deletes it and confirms', (tester) async {
      await atFixtureTime(() async {
        env = await ObaTestEnv.create();
        env.app.core.userData.addAlarm(
          alarm(trip: fixtureNow.add(const Duration(hours: 1))),
        );
        await env.pumpPage(tester, const Scaffold(body: AlarmsSection()));
        await tester.tap(find.byTooltip('Delete alarm for 30 - Old Town'));
        await tester.pumpAndSettle();
        expect(find.text('Alarm deleted'), findsOneWidget);
        expect(env.app.core.userData.alarms, isEmpty);
      });
    });
  });
}
