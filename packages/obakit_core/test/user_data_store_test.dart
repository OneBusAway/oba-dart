import 'package:clock/clock.dart';
import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  late InMemoryKeyValueStore kv;
  late UserDataStore store;
  late int notifications;

  setUp(() {
    kv = InMemoryKeyValueStore();
    store = UserDataStore(kv);
    notifications = 0;
    store.addListener(() => notifications++);
  });

  UserDataStore reload() => UserDataStore(kv);

  Bookmark stopBookmark(String stopId, {String? name, int region = 1}) =>
      Bookmark.forStop(
        name: name ?? 'Stop $stopId',
        regionId: region,
        stop: storedStop(id: stopId),
      );

  List<String> names(List<Bookmark> b) => [for (final x in b) x.name];

  group('bookmarks', () {
    test('add appends with sequential sort orders and persists', () {
      store.addBookmark(stopBookmark('1_1', name: 'A'));
      store.addBookmark(stopBookmark('1_2', name: 'B'));
      store.addBookmark(stopBookmark('1_3', name: 'C'), index: 0);
      expect(names(store.bookmarksInGroup(null)), ['C', 'A', 'B']);
      expect(store.bookmarksInGroup(null).map((b) => b.sortOrder), [0, 1, 2]);
      expect(notifications, 3);
      expect(names(reload().bookmarksInGroup(null)), ['C', 'A', 'B']);
    });

    test('moving between groups renumbers both groups', () {
      final g = store.addGroup('Work');
      final a = stopBookmark('1_1', name: 'A');
      final b = stopBookmark('1_2', name: 'B');
      final c = stopBookmark('1_3', name: 'C');
      for (final x in [a, b, c]) {
        store.addBookmark(x);
      }
      store.addBookmark(store.findBookmark(b.id)!, groupId: g.id);
      expect(names(store.bookmarksInGroup(null)), ['A', 'C']);
      expect(store.bookmarksInGroup(null).map((x) => x.sortOrder), [0, 1]);
      expect(store.bookmarksInGroup(g.id).single.groupId, g.id);
      expect(store.bookmarks, hasLength(3));
    });

    test('moveBookmark reorders within a group; a no-op does not notify', () {
      for (final n in ['A', 'B', 'C']) {
        store.addBookmark(stopBookmark('1_$n', name: n));
      }
      store.moveBookmark(null, 0, 2);
      expect(names(store.bookmarksInGroup(null)), ['B', 'C', 'A']);
      final before = notifications;
      store.moveBookmark(null, 2, 2);
      expect(notifications, before);
    });

    test('update keeps group and order; pin and favourite', () {
      final g = store.addGroup('G');
      final a = stopBookmark('1_1', name: 'A');
      store.addBookmark(a, groupId: g.id);
      store.updateBookmark(a.copyWith(name: 'Renamed', groupId: () => null));
      final stored = store.findBookmark(a.id)!;
      expect(stored.name, 'Renamed');
      expect(stored.groupId, g.id);
      store.setPinned(a.id, true);
      store.setFavorite(a.id, true);
      expect(store.pinnedBookmarks.single.id, a.id);
      expect(store.favoritedBookmarks.single.id, a.id);
      expect(reload().findBookmark(a.id)!.isPinned, isTrue);
    });

    test('delete renumbers the remaining bookmarks', () {
      final a = stopBookmark('1_1', name: 'A');
      store
        ..addBookmark(a)
        ..addBookmark(stopBookmark('1_2', name: 'B'))
        ..deleteBookmark(a.id);
      expect(store.bookmarksInGroup(null).single.sortOrder, 0);
      final before = notifications;
      store.deleteBookmark('missing');
      expect(notifications, before);
    });

    test('duplicates, region filter, search, stop lookup', () {
      final route = const StoredRoute(
        id: '1_10',
        shortName: '10',
        longName: 'Capitol Hill',
      );
      final a = Bookmark.forStop(
        name: 'Home',
        regionId: 1,
        stop: storedStop(id: '1_1', name: 'Pine St', routes: [route]),
      );
      store.addBookmark(a);
      store.addBookmark(
        Bookmark.forStop(
          name: 'Elm',
          regionId: 0,
          stop: storedStop(id: '0_9', name: 'Elm'),
        ),
      );
      expect(store.isDuplicate(stopBookmark('1_1', name: 'Home')), isTrue);
      expect(store.isDuplicate(stopBookmark('1_1', name: 'Other')), isFalse);
      expect(store.bookmarksInRegion(1).single.id, a.id);
      expect(store.bookmarksInRegion(null), isEmpty);
      expect(store.findBookmarks('  capitol ').single.id, a.id);
      expect(store.findBookmarks('pine').single.id, a.id);
      expect(store.findBookmarks('zzz'), isEmpty);
      expect(store.findBookmarkForStop('1_1')!.id, a.id);
      expect(store.findBookmarkForStop('1_1', regionId: 0), isNull);
    });

    test('trip bookmarks carry a trip key', () {
      final a = arrival(routeId: '1_10', routeShortName: '10', headsign: 'UW');
      final b = Bookmark.forTrip(
        name: '10 to UW',
        regionId: 1,
        stop: storedStop(),
        arrival: a,
      );
      expect(b.isTripBookmark, isTrue);
      expect(b.hasDestination, isFalse);
      expect(b.tripKey, TripBookmarkKey.fromArrival(a));
      expect(b.matchesQuery('uw'), isTrue);
      expect(stopBookmark('1_1').tripKey, isNull);
    });

    test('bookmark JSON round-trips and tolerates missing optionals', () {
      final b = Bookmark.forTrip(
        name: 'x',
        regionId: 1,
        stop: storedStop(
          routes: [const StoredRoute(id: 'r', shortName: '1')],
        ),
        arrival: arrival(),
        destinationStop: storedStop(id: '1_200', name: 'Dest'),
      ).copyWith(isPinned: true, sortOrder: 4);
      expect(Bookmark.fromJson(b.toJson()), b);
      final minimal = Bookmark.fromJson({
        'id': 'i',
        'regionId': 1,
        'stop': {'id': 's', 'lat': 1, 'lon': 2},
      });
      expect(minimal.name, '');
      expect(minimal.isFavorite, isFalse);
      expect(() => Bookmark.fromJson({'id': 'x'}), throwsFormatException);
    });

    test('unreadable stored bookmarks are skipped, not fatal', () {
      kv.writeJson('oba.userData.bookmarks', [
        {'garbage': true},
        stopBookmark('1_1').toJson(),
        42,
      ]);
      expect(reload().bookmarks, hasLength(1));
    });

    test('bookmarksByStopId keeps the last per stop', () {
      final a = stopBookmark('1_1', name: 'first');
      final b = stopBookmark('1_1', name: 'second');
      expect(bookmarksByStopId([a, b])['1_1']!.name, 'second');
    });
  });

  group('groups', () {
    test('add, rename, reorder, persist', () {
      final a = store.addGroup('A');
      final b = store.addGroup('B');
      expect(b.sortOrder, a.sortOrder + 1);
      store.renameGroup(a.id, 'Alpha');
      store.moveGroup(1, 0);
      expect(store.bookmarkGroups.map((g) => g.name), ['B', 'Alpha']);
      expect(reload().bookmarkGroups.map((g) => g.name), ['B', 'Alpha']);
    });

    test('deleting a group ungroups its bookmarks after existing ones', () {
      final g = store.addGroup('G');
      store.addBookmark(stopBookmark('1_1', name: 'U'));
      store.addBookmark(stopBookmark('1_2', name: 'G1'), groupId: g.id);
      store.addBookmark(stopBookmark('1_3', name: 'G2'), groupId: g.id);
      store.deleteGroup(g.id);
      expect(store.bookmarkGroups, isEmpty);
      expect(names(store.bookmarksInGroup(null)), ['U', 'G1', 'G2']);
      expect(store.bookmarksInGroup(null).map((b) => b.sortOrder), [0, 1, 2]);
    });

    test('replaceBookmarkGroups ungroups orphans; no-op is silent', () {
      final a = store.addGroup('A');
      final b = store.addGroup('B');
      store.addBookmark(stopBookmark('1_1'), groupId: b.id);
      store.replaceBookmarkGroups([a]);
      expect(store.bookmarkGroups.single.id, a.id);
      expect(store.bookmarksInGroup(null), hasLength(1));
      final before = notifications;
      store.replaceBookmarkGroups([a]);
      expect(notifications, before);
    });
  });

  group('recent stops', () {
    test('newest first, deduplicated, capped at 20', () {
      for (var i = 0; i < 25; i++) {
        store.addRecentStop(storedStop(id: '1_$i'), regionId: 1);
      }
      store.addRecentStop(storedStop(id: '1_10'), regionId: 1);
      final ids = store.recentStopsInRegion(1).map((s) => s.id).toList();
      expect(ids, hasLength(20));
      expect(ids.first, '1_10');
      expect(ids.where((i) => i == '1_10'), hasLength(1));
      expect(store.recentStopsInRegion(2), isEmpty);
      expect(store.recentStopsInRegion(null), isEmpty);
      expect(reload().recentStops, hasLength(20));
    });

    test('refreshes the embedded stop of matching bookmarks', () {
      final b = stopBookmark('1_1');
      store.addBookmark(b);
      store.addRecentStop(storedStop(id: '1_1', name: 'New name'), regionId: 1);
      expect(store.findBookmark(b.id)!.stop.name, 'New name');
    });

    test('delete one, delete all, search', () {
      store.addRecentStop(storedStop(id: '1_1', name: 'Pine'), regionId: 1);
      store.addRecentStop(storedStop(id: '1_2', name: 'Pike'), regionId: 1);
      expect(store.findRecentStops('pin').single.id, '1_1');
      store.deleteRecentStop('1_1');
      expect(store.recentStops.single.stop.id, '1_2');
      store.deleteAllRecentStops();
      expect(store.recentStops, isEmpty);
    });
  });

  group('recent places and searches', () {
    test('places within 10 m replace each other; capped at 10', () {
      store.addRecentPlace(
        const RecentPlace(name: 'A', lat: 47.6, lon: -122.3),
      );
      store.addRecentPlace(
        const RecentPlace(name: 'A2', lat: 47.60001, lon: -122.3),
      );
      expect(store.recentPlaces.single.name, 'A2');
      for (var i = 0; i < 12; i++) {
        store.addRecentPlace(
          RecentPlace(name: '$i', lat: i.toDouble(), lon: 0),
        );
      }
      expect(store.recentPlaces, hasLength(10));
      expect(reload().recentPlaces.first.name, '11');
      store.deleteAllRecentPlaces();
      expect(store.recentPlaces, isEmpty);
    });

    test('searches dedupe case-insensitively and ignore blanks', () {
      store
        ..addRecentSearch('10')
        ..addRecentSearch('  ')
        ..addRecentSearch('Pine')
        ..addRecentSearch('pine ');
      expect(store.recentSearches, ['pine', '10']);
      store.deleteAllRecentSearches();
      expect(reload().recentSearches, isEmpty);
    });
  });

  group('stop preferences', () {
    test('keyed by region and stop, with defaults', () {
      expect(store.stopPreferences(1, '1_1'), const StopPreferences());
      expect(store.hasStopPreferences(1, '1_1'), isFalse);
      final prefs = const StopPreferences(sortType: StopSort.route)
          .toggleRouteHidden('1_10');
      store.setStopPreferences(1, '1_1', prefs);
      expect(store.stopPreferences(1, '1_1').isRouteHidden('1_10'), isTrue);
      expect(store.stopPreferences(2, '1_1'), const StopPreferences());
      expect(reload().stopPreferences(1, '1_1'), prefs);
      expect(UserDataStore.stopPreferencesKey(1, '1_1'), '1_1_1');
      expect(prefs.toggleRouteHidden('1_10').hasHiddenRoutes, isFalse);
    });
  });

  group('alarms', () {
    test('add replaces by url, delete, prune expired', () {
      final now = DateTime.utc(2024, 1, 1, 12);
      final past = StoredAlarm(
        url: Uri.parse('https://a/1'),
        tripDate: now.subtract(const Duration(minutes: 1)),
      );
      final future = StoredAlarm(
        url: Uri.parse('https://a/2'),
        tripDate: now.add(const Duration(minutes: 5)),
        leadTimeMinutes: 3,
      );
      final undated = StoredAlarm(url: Uri.parse('https://a/3'));
      store
        ..addAlarm(past)
        ..addAlarm(future)
        ..addAlarm(future)
        ..addAlarm(undated);
      expect(store.alarms, hasLength(3));
      withClock(Clock.fixed(now), store.deleteExpiredAlarms);
      expect(store.alarms.single.url, future.url);
      expect(reload().alarms.single.leadTimeMinutes, 3);
      store.deleteAlarm(future.url);
      expect(store.alarms, isEmpty);
    });
  });

  test('read alerts', () {
    expect(store.isAlertUnread('a'), isTrue);
    store.markAlertRead('a');
    final before = notifications;
    store.markAlertRead('a');
    expect(notifications, before);
    store.markAlertsRead(['b', 'c']);
    expect(reload().isAlertUnread('c'), isFalse);
  });

  test('read alerts keep only the newest ids', () {
    const cap = UserDataStore.maximumReadAlerts;
    store.markAlertsRead([for (var i = 0; i < cap; i++) 'a$i']);
    store.markAlertRead('new');
    expect(store.isAlertUnread('a0'), isTrue);
    expect(store.isAlertUnread('a1'), isFalse);
    expect(store.isAlertUnread('new'), isFalse);
    expect(kv.readList('oba.userData.readServiceAlerts'), hasLength(cap));
    expect(reload().isAlertUnread('a0'), isTrue);
  });

  test('trip planning defaults on per region', () {
    expect(store.isTripPlanningEnabled(1), isTrue);
    store.setTripPlanningEnabled(1, false);
    expect(reload().isTripPlanningEnabled(1), isFalse);
    expect(store.isTripPlanningEnabled(2), isTrue);
  });

  group('surveys bookkeeping', () {
    test('launch count, user id, completion and later', () {
      expect(store.appLaunchCount, 0);
      store.incrementAppLaunchCount();
      final id = store.surveyUserIdentifier;
      expect(reload().surveyUserIdentifier, id);
      store.markSurveyForLater(7, id);
      expect(store.isSurveyMarkedForLater(7, id), isTrue);
      expect(store.shouldShowSurveyLater(7, id), isFalse);
      for (var i = 0; i < 3; i++) {
        store.incrementAppLaunchCount();
      }
      expect(store.shouldShowSurveyLater(7, id), isTrue);
      store.incrementAppLaunchCount();
      expect(store.shouldShowSurveyLater(7, id), isFalse);
      store.markSurveyCompleted(7, id);
      expect(store.isSurveyCompleted(7, id), isTrue);
      expect(store.isSurveyMarkedForLater(7, id), isFalse);
      expect(store.isSurveyCompleted(7, 'other'), isFalse);
    });

    test('flags and reminder date persist', () {
      expect(store.isSurveyEnabled, isTrue);
      store.isSurveyEnabled = false;
      store.alwaysShowSurveysOnStops = true;
      final d = DateTime.utc(2030);
      store.nextSurveyReminderDate = d;
      final r = reload();
      expect(r.isSurveyEnabled, isFalse);
      expect(r.alwaysShowSurveysOnStops, isTrue);
      expect(r.nextSurveyReminderDate, d);
      store.nextSurveyReminderDate = null;
      expect(reload().nextSurveyReminderDate, isNull);
    });
  });
}
