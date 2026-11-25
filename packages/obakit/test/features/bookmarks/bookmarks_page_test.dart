import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';
import 'bookmarks_support.dart';

void main() {
  late ObaTestEnv env;

  tearDown(() => env.dispose());

  testWidgets('empty state explains how to add a bookmark', (tester) async {
    env = await arrivalsEnv();
    final nav = RecordingNavigator();
    await env.pumpPage(tester, withNavigator(nav, const BookmarksPage()));
    expect(find.text('No bookmarks yet'), findsOneWidget);
    expect(find.textContaining('bookmark button'), findsOneWidget);
    await tester.tap(find.text('Find stops on the map'));
    expect(nav.popToRoots, 1);
    await expectObaAccessibility(tester);
  });

  testWidgets('stop bookmark shows live departures and opens the stop', (
    tester,
  ) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      env.app.core.userData.addBookmark(stopBookmark('Work'));
      final nav = RecordingNavigator();
      await env.pumpPage(tester, withNavigator(nav, const BookmarksPage()));
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('Old Town'), findsWidgets);
      expect(find.textContaining('min'), findsWidgets);
      await tester.tap(find.text('Work'));
      expect(nav.pushed.single, const StopRoute(kStopId));
      await expectObaAccessibility(tester);
      await unmount(tester);
    });
  });

  testWidgets('trip bookmark lists only its route and opens the trip', (
    tester,
  ) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      env.app.core.userData.addBookmark(tripBookmark('To Old Town'));
      final nav = RecordingNavigator();
      await env.pumpPage(tester, withNavigator(nav, const BookmarksPage()));
      expect(find.text('Old Town'), findsWidgets);
      expect(find.text('SIO'), findsNothing);
      expect(find.text('UTC'), findsNothing);
      await tester.tap(find.text('Old Town').first);
      expect(nav.pushed.single, isA<TripRoute>());
      await unmount(tester);
    });
  });

  testWidgets('a failed fetch shows an error with retry on the card', (
    tester,
  ) async {
    await atFixtureTime(() async {
      env = await ObaTestEnv.create();
      env.app.core.userData.addBookmark(stopBookmark('Work'));
      await env.pumpPage(tester, const BookmarksPage());
      expect(find.text("Couldn't load departures"), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      await unmount(tester);
    });
  });

  testWidgets('several bookmarks on one stop share one request', (
    tester,
  ) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      env.app.core.userData
        ..addBookmark(stopBookmark('A'))
        ..addBookmark(tripBookmark('B'));
      await env.pumpPage(tester, const BookmarksPage());
      expect(
        env.requests.where((r) => r.url.path.contains('arrivals-and')).length,
        1,
      );
      await unmount(tester);
    });
  });

  testWidgets('bookmarks of other regions are not listed', (tester) async {
    env = await arrivalsEnv();
    env.app.core.userData.addBookmark(stopBookmark('Elsewhere', regionId: 99));
    await env.pumpPage(tester, const BookmarksPage());
    expect(find.text('Elsewhere'), findsNothing);
    expect(find.text('No bookmarks yet'), findsOneWidget);
  });

  testWidgets('groups: ungrouped first, headers, pinned first, collapse', (
    tester,
  ) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      final store = env.app.core.userData;
      final home = store.addGroup('Home');
      store
        ..addBookmark(stopBookmark('Plain'))
        ..addBookmark(stopBookmark('Pinned', stopId: 'MTS_1'))
        ..addBookmark(stopBookmark('Grouped'), groupId: home.id);
      store.setPinned(store.bookmarks[1].id, true);
      await env.pumpPage(tester, const BookmarksPage());
      expect(find.text('Ungrouped'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      double y(String t) => tester.getTopLeft(find.text(t)).dy;
      expect(y('Pinned'), lessThan(y('Plain')));
      expect(y('Plain'), lessThan(y('Grouped')));
      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(find.text('Grouped'), findsNothing);
      await unmount(tester);
    });
  });

  testWidgets('sort by distance is a persisted choice', (tester) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      env.app.core.userData.addBookmark(stopBookmark('Work'));
      await env.pumpPage(tester, const BookmarksPage());
      await tester.tap(find.byTooltip('Sort bookmarks'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sort by distance'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(env.store.values['oba.bookmarks.sortByGroup'], 'false');
      expect(find.text('Ungrouped'), findsNothing);
      await unmount(tester);
    });
  });

  testWidgets('pin, move to group and delete with undo', (tester) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      final store = env.app.core.userData;
      store.addGroup('Home');
      store.addBookmark(stopBookmark('Work'));
      await env.pumpPage(tester, const BookmarksPage());

      await tester.tap(find.byTooltip('Actions for Work'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pin to top'));
      await tester.pumpAndSettle();
      expect(store.bookmarks.single.isPinned, isTrue);

      await tester.tap(find.byTooltip('Actions for Work'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Move to group'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home').last);
      await tester.pumpAndSettle();
      expect(store.bookmarks.single.groupId, store.bookmarkGroups.single.id);

      await tester.tap(find.byTooltip('Actions for Work'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(store.bookmarks, isEmpty);
      expect(find.text('Deleted Work'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(store.bookmarks.single.name, 'Work');
      expect(store.bookmarks.single.groupId, isNotNull);
      await unmount(tester);
    });
  });

  testWidgets('edit action pushes the editor', (tester) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      env.app.core.userData.addBookmark(stopBookmark('Work'));
      final nav = RecordingNavigator();
      await env.pumpPage(tester, withNavigator(nav, const BookmarksPage()));
      await tester.tap(find.byTooltip('Actions for Work'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      expect(nav.pushed.single, isA<BookmarkEditorRoute>());
      await tester.tap(find.byTooltip('Edit bookmarks and groups'));
      expect(nav.pushed.last, const ManageBookmarksRoute());
      await unmount(tester);
    });
  });

  testWidgets(
    'accessible and reflowing in every presentation, light and dark',
    (tester) async {
      await atFixtureTime(() async {
        env = await arrivalsEnv();
        final store = env.app.core.userData;
        store
          ..addBookmark(stopBookmark('Work'))
          ..addBookmark(tripBookmark('To Old Town'));
        for (final p in ObaPresentation.values) {
          for (final mode in [ThemeMode.light, ThemeMode.dark]) {
            await env.pumpPage(
              tester,
              const BookmarksPage(),
              presentation: p,
              themeMode: mode,
            );
            await expectObaAccessibility(tester);
          }
        }
        await env.expectNoOverflowAtTextScale(tester, const BookmarksPage());
        await env.expectNoOverflowAtTextScale(
          tester,
          const BookmarksPage(),
          presentation: ObaPresentation.embedded,
        );
        await unmount(tester);
      });
    },
  );

  testWidgets('the card stops refreshing in a hidden IndexedStack child', (
    tester,
  ) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      env.app.core.userData.addBookmark(stopBookmark('Work'));
      int arrivals() =>
          env.requests.where((r) => r.url.path.contains('arrivals-and')).length;
      // A host's tabs: IndexedStack keeps hidden children's tickers running
      // and reports them through Visibility.of.
      Widget tabs(int index) => Material(
        child: IndexedStack(
          index: index,
          children: const [
            SingleChildScrollView(child: ObaBookmarksCard()),
            SizedBox(),
          ],
        ),
      );
      await env.pumpPage(
        tester,
        tabs(0),
        presentation: ObaPresentation.embedded,
      );
      final shown = arrivals();
      expect(shown, 1);
      await env.pumpPage(
        tester,
        tabs(1),
        presentation: ObaPresentation.embedded,
      );
      await tester.pump(const Duration(seconds: 95));
      await ObaTestEnv.settle(tester);
      expect(arrivals(), shown);
      await unmount(tester);
    });
  });

  testWidgets('the compact card shows the newest three and See all', (
    tester,
  ) async {
    await atFixtureTime(() async {
      env = await arrivalsEnv();
      final store = env.app.core.userData;
      for (final n in ['a', 'b', 'c', 'd']) {
        store.addBookmark(stopBookmark(n, stopId: 'MTS_$n'));
      }
      final nav = RecordingNavigator();
      await env.pumpPage(
        tester,
        withNavigator(
          nav,
          const Material(
            child: SingleChildScrollView(child: ObaBookmarksCard()),
          ),
        ),
        presentation: ObaPresentation.embedded,
      );
      expect(find.text('See all'), findsOneWidget);
      await tester.tap(find.text('See all'));
      expect(nav.pushed.single, const BookmarksRoute());
      await expectObaAccessibility(tester);
      await unmount(tester);
    });
  });

  group('embedded header actions appear exactly once', () {
    const refresh = 'Refresh departures';

    testWidgets('without a header: at the top of the list', (tester) async {
      env = await arrivalsEnv();
      await env.pumpPage(
        tester,
        const BookmarksPage(),
        presentation: ObaPresentation.embedded,
      );
      expect(find.byTooltip(refresh), findsOneWidget);
      expect(find.byType(ObaSheetHeader), findsNothing);
    });

    testWidgets('with the compact header: in the header only', (tester) async {
      env = await arrivalsEnv();
      await env.pumpPage(
        tester,
        ObaPresentationScope.embedded(
          showsHeader: true,
          child: const Material(child: BookmarksPage()),
        ),
      );
      expect(find.byTooltip(refresh), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ObaSheetHeader),
          matching: find.byTooltip(refresh),
        ),
        findsOneWidget,
      );
    });
  });
}
