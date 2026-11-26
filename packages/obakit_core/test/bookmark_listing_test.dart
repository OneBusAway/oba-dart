import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

Bookmark bm(
  String name, {
  String? group,
  int order = 0,
  bool pinned = false,
  double lat = 47.6,
  DateTime? created,
}) => Bookmark(
  id: name,
  name: name,
  regionId: 1,
  stop: storedStop(id: '1_$name', lat: lat),
  dateCreated: created ?? DateTime.utc(2024),
  groupId: group,
  sortOrder: order,
  isPinned: pinned,
);

List<String> names(Iterable<Bookmark> b) => [for (final x in b) x.name];

void main() {
  group('sectionBookmarksByGroup', () {
    test(
      'ungrouped first, groups by sort order, pinned first, skips empty',
      () {
        final groups = [
          const BookmarkGroup(id: 'g2', name: 'Work', sortOrder: 1),
          const BookmarkGroup(id: 'g1', name: 'Home', sortOrder: 0),
          const BookmarkGroup(id: 'g3', name: 'Empty', sortOrder: 2),
        ];
        final sections = sectionBookmarksByGroup([
          bm('a', order: 0),
          bm('b', order: 1, pinned: true),
          bm('c', group: 'g2'),
          bm('d', group: 'g1', order: 1),
          bm('e', group: 'g1', order: 0),
          bm('orphan', group: 'deleted', order: 5),
        ], groups);
        expect(
          [for (final s in sections) s.id],
          [ungroupedBookmarkSectionId, 'g1', 'g2'],
        );
        expect(names(sections[0].bookmarks), ['b', 'a', 'orphan']);
        expect(names(sections[1].bookmarks), ['e', 'd']);
        expect(sections[1].group?.name, 'Home');
      },
    );

    test('no bookmarks gives no sections', () {
      expect(sectionBookmarksByGroup(const [], const []), isEmpty);
    });
  });

  group('sectionBookmarksByDistance', () {
    test('nearest first with pinned ahead; without a position keeps order', () {
      final list = [
        bm('far', lat: 48.0),
        bm('near', lat: 47.61),
        bm('pinnedFar', lat: 49, pinned: true),
      ];
      final sorted = sectionBookmarksByDistance(
        list,
        const Coordinate(47.6, -122.3),
      );
      expect(sorted.single.id, distanceBookmarkSectionId);
      expect(names(sorted.single.bookmarks), ['pinnedFar', 'near', 'far']);
      expect(names(sectionBookmarksByDistance(list, null).single.bookmarks), [
        'pinnedFar',
        'far',
        'near',
      ]);
      expect(sectionBookmarksByDistance(const [], null), isEmpty);
    });
  });

  group('selectHomeBookmarks', () {
    test('every pin, then newest fill up to the limit', () {
      final list = [
        bm('old', created: DateTime.utc(2020)),
        bm('mid', created: DateTime.utc(2022)),
        bm('new', created: DateTime.utc(2024)),
        bm('newer', created: DateTime.utc(2025)),
        bm('pin', pinned: true, created: DateTime.utc(2019)),
      ];
      expect(names(selectHomeBookmarks(list, limit: 3)), [
        'pin',
        'newer',
        'new',
      ]);
      final pins = [
        for (var i = 0; i < 4; i++) bm('p$i', pinned: true),
        bm('x'),
      ];
      expect(selectHomeBookmarks(pins, limit: 3), hasLength(4));
    });
  });

  group('alertsInScope', () {
    Situation alert(
      String id, {
      String? stop,
      String? route,
      String? severity,
      List<TimeWindow> windows = const [],
    }) => Situation(
      id: id,
      severity: severity,
      activeWindows: windows,
      allAffects: [AffectedEntity(stopId: stop, routeId: route)],
    );
    final now = DateTime.utc(2024, 6);

    test('filters by stop or route, drops expired and duplicates', () {
      final alerts = [
        alert('stop', stop: '1_1'),
        alert('route', route: 'r1', severity: 'severe'),
        alert('other', stop: '1_9'),
        alert(
          'expired',
          stop: '1_1',
          windows: [
            TimeWindow(from: DateTime.utc(2020), to: DateTime.utc(2021)),
          ],
        ),
        alert('stop', stop: '1_1'),
      ];
      expect(
        [
          for (final a in alertsInScope(
            alerts,
            stopId: '1_1',
            routeId: 'r1',
            now: now,
          ))
            a.id,
        ],
        ['route', 'stop'],
      );
      expect(alertsInScope(alerts, now: now).map((a) => a.id), [
        'route',
        'other',
        'stop',
      ]);
    });

    test('affected ids are distinct and ordered', () {
      final a = Situation(
        id: 'x',
        allAffects: const [
          AffectedEntity(routeId: 'r1'),
          AffectedEntity(routeId: 'r1', stopId: 's1'),
          AffectedEntity(routeId: 'r2'),
        ],
      );
      expect(affectedRouteIds(a), ['r1', 'r2']);
      expect(affectedStopIds(a), ['s1']);
    });
  });
}
