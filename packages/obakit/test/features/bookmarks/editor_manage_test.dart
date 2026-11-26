import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';
import 'bookmarks_support.dart';

ArrivalAndDeparture fixtureArrival() {
  final json = jsonDecode(fixture('arrivals_mts_24151.json')) as Map;
  final entry = json['data']['entry'] as Map<String, dynamic>;
  return StopWithArrivalsAndDepartures.fromJson(entry).arrivalsAndDepartures
      .firstWhere((a) => a.routeId == 'MTS_30' && a.tripHeadsign == 'Old Town');
}

Stop fixtureStop() => kStop(name: 'Pine St & 3rd Ave').toStop();

void main() {
  late ObaTestEnv env;

  tearDown(() => env.dispose());

  group('editor', () {
    testWidgets('creates a stop bookmark with the stop name prefilled', (
      tester,
    ) async {
      env = await ObaTestEnv.create();
      final nav = RecordingNavigator();
      await env.pumpPage(
        tester,
        withNavigator(
          nav,
          BookmarkEditorPage(route: BookmarkEditorRoute(stop: fixtureStop())),
        ),
      );
      expect(find.text('Pine St & 3rd Ave'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Home stop');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      final saved = env.app.core.userData.bookmarks.single;
      expect(saved.name, 'Home stop');
      expect(saved.isTripBookmark, isFalse);
      expect(saved.regionId, 1);
      expect(nav.pops, 1);
    });

    testWidgets('an arrival makes a trip bookmark unless switched off', (
      tester,
    ) async {
      env = await ObaTestEnv.create();
      final route = BookmarkEditorRoute(
        stop: fixtureStop(),
        arrival: fixtureArrival(),
      );
      await env.pumpPage(tester, BookmarkEditorPage(route: route));
      expect(find.text('30 - Old Town'), findsOneWidget);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      final trip = env.app.core.userData.bookmarks.single;
      expect(trip.isTripBookmark, isTrue);
      expect(trip.routeId, 'MTS_30');

      await env.pumpPage(tester, BookmarkEditorPage(route: route));
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(find.text('Pine St & 3rd Ave'), findsOneWidget);
    });

    testWidgets('rejects a blank name and a duplicate', (tester) async {
      env = await ObaTestEnv.create();
      env.app.core.userData.addBookmark(
        Bookmark.forStop(name: 'Pine St & 3rd Ave', regionId: 1, stop: kStop()),
      );
      await env.pumpPage(
        tester,
        BookmarkEditorPage(route: BookmarkEditorRoute(stop: fixtureStop())),
      );
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(find.textContaining('already have a bookmark'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '  ');
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(find.text('Enter a name for this bookmark.'), findsOneWidget);
      expect(env.app.core.userData.bookmarks, hasLength(1));
      await expectObaAccessibility(tester);
    });

    testWidgets('edits name and group, adds a group, deletes', (tester) async {
      env = await ObaTestEnv.create();
      final store = env.app.core.userData;
      store.addGroup('Home');
      final b = stopBookmark('Work');
      store.addBookmark(b);
      final nav = RecordingNavigator();
      await env.pumpPage(
        tester,
        withNavigator(
          nav,
          BookmarkEditorPage(route: BookmarkEditorRoute(bookmark: b)),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Office');
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      var saved = store.bookmarks.single;
      expect(saved.name, 'Office');
      expect(saved.groupId, store.bookmarkGroups.single.id);

      await env.pumpPage(
        tester,
        withNavigator(
          nav,
          BookmarkEditorPage(route: BookmarkEditorRoute(bookmark: saved)),
        ),
      );
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('New group…').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Gym');
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Save'),
        ),
      );
      await tester.pumpAndSettle();
      expect(store.bookmarkGroups.map((g) => g.name), ['Home', 'Gym']);
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      saved = store.bookmarks.single;
      expect(store.findGroup(saved.groupId)?.name, 'Gym');

      await env.pumpPage(
        tester,
        withNavigator(
          nav,
          BookmarkEditorPage(route: BookmarkEditorRoute(bookmark: saved)),
        ),
      );
      await tester.tap(find.text('Delete bookmark'));
      await tester.pumpAndSettle();
      expect(find.text('Delete this bookmark?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(store.bookmarks, isEmpty);
    });

    testWidgets('accessible and reflowing everywhere', (tester) async {
      env = await ObaTestEnv.create();
      final page = BookmarkEditorPage(
        route: BookmarkEditorRoute(
          stop: fixtureStop(),
          arrival: fixtureArrival(),
        ),
      );
      for (final p in ObaPresentation.values) {
        for (final mode in [ThemeMode.light, ThemeMode.dark]) {
          await env.pumpPage(tester, page, presentation: p, themeMode: mode);
          await expectObaAccessibility(tester);
        }
      }
      await env.expectNoOverflowAtTextScale(tester, page);
    });
  });

  group('manage', () {
    List<String> names() => [
      for (final b in env.app.core.userData.bookmarksInGroup(null)) b.name,
    ];

    testWidgets('moves bookmarks with buttons, no drag needed', (tester) async {
      env = await ObaTestEnv.create();
      final store = env.app.core.userData;
      for (final n in ['A', 'B', 'C']) {
        store.addBookmark(stopBookmark(n, stopId: 'MTS_$n'));
      }
      await env.pumpPage(tester, const ManageBookmarksPage());
      await tester.tap(find.byTooltip('Move C up'));
      await tester.pumpAndSettle();
      expect(names(), ['A', 'C', 'B']);
      await tester.tap(find.byTooltip('Move A down'));
      await tester.pumpAndSettle();
      expect(names(), ['C', 'A', 'B']);
    });

    testWidgets('reorders by dragging the handle', (tester) async {
      env = await ObaTestEnv.create();
      final store = env.app.core.userData;
      for (final n in ['A', 'B']) {
        store.addBookmark(stopBookmark(n, stopId: 'MTS_$n'));
      }
      await env.pumpPage(tester, const ManageBookmarksPage());
      final handle = find.byIcon(Icons.drag_handle).first;
      final gesture = await tester.startGesture(tester.getCenter(handle));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveBy(const Offset(0, 30));
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.moveBy(const Offset(0, 200));
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(names(), ['B', 'A']);
    });

    testWidgets('adds, renames, reorders and deletes groups', (tester) async {
      env = await ObaTestEnv.create();
      final store = env.app.core.userData;
      await env.pumpPage(tester, const ManageBookmarksPage());
      expect(
        find.text('There are no bookmarks or groups to manage yet.'),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('Add group'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Home');
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      store.addGroup('Work');
      await tester.pumpAndSettle();
      expect(store.bookmarkGroups.map((g) => g.name), ['Home', 'Work']);

      await tester.tap(find.byTooltip('Move Work up'));
      await tester.pumpAndSettle();
      expect(store.bookmarkGroups.map((g) => g.name), ['Work', 'Home']);

      await tester.tap(find.byTooltip('Rename group').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Job');
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      expect(store.bookmarkGroups.first.name, 'Job');

      await tester.tap(find.byTooltip('Delete group').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(store.bookmarkGroups.map((g) => g.name), ['Home']);
    });

    testWidgets('accessible and reflowing everywhere', (tester) async {
      env = await ObaTestEnv.create();
      final store = env.app.core.userData;
      final g = store.addGroup('Home');
      store
        ..addBookmark(stopBookmark('A'))
        ..addBookmark(stopBookmark('B', stopId: 'MTS_B'), groupId: g.id);
      for (final p in ObaPresentation.values) {
        for (final mode in [ThemeMode.light, ThemeMode.dark]) {
          await env.pumpPage(
            tester,
            const ManageBookmarksPage(),
            presentation: p,
            themeMode: mode,
          );
          await expectObaAccessibility(tester);
        }
      }
      await env.expectNoOverflowAtTextScale(
        tester,
        const ManageBookmarksPage(),
      );
    });
  });
}
