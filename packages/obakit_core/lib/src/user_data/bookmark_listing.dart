import 'package:onebusaway/onebusaway.dart';

import '../geo/distance.dart';
import 'bookmark.dart';

/// The id of the section holding bookmarks that are in no group (iOS
/// `"unknown_group"`).
const String ungroupedBookmarkSectionId = 'unknown_group';

/// The id of the single section of a distance-sorted list (iOS
/// `"distance_sorted_group"`).
const String distanceBookmarkSectionId = 'distance_sorted_group';

/// One section of the bookmarks list: a group, the ungrouped bucket, or the
/// single distance-sorted bucket.
class BookmarkListSection {
  const BookmarkListSection({
    required this.id,
    required this.bookmarks,
    this.group,
  });

  final String id;

  /// Null for the ungrouped and distance-sorted sections.
  final BookmarkGroup? group;
  final List<Bookmark> bookmarks;

  bool get isUngrouped => id == ungroupedBookmarkSectionId;
}

/// Pinned bookmarks first, otherwise keeping the order of [bookmarks].
List<Bookmark> pinnedFirst(Iterable<Bookmark> bookmarks) {
  final list = bookmarks.toList();
  return [...list.where((b) => b.isPinned), ...list.where((b) => !b.isPinned)];
}

/// Splits [bookmarks] by group: the ungrouped bucket first, then the
/// groups in `sortOrder`. Inside a section bookmarks follow `sortOrder`
/// with pinned ones first. Empty groups are left out, and a bookmark whose
/// group no longer exists counts as ungrouped.
List<BookmarkListSection> sectionBookmarksByGroup(
  Iterable<Bookmark> bookmarks,
  Iterable<BookmarkGroup> groups,
) {
  final sortedGroups = groups.toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  final groupIds = {for (final g in sortedGroups) g.id};
  List<Bookmark> inGroup(bool Function(Bookmark) test) => pinnedFirst(
    bookmarks.where(test).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
  );

  final ungrouped = inGroup(
    (b) => b.groupId == null || !groupIds.contains(b.groupId),
  );
  return [
    if (ungrouped.isNotEmpty)
      BookmarkListSection(id: ungroupedBookmarkSectionId, bookmarks: ungrouped),
    for (final g in sortedGroups)
      if (inGroup((b) => b.groupId == g.id) case final list
          when list.isNotEmpty)
        BookmarkListSection(id: g.id, group: g, bookmarks: list),
  ];
}

/// One section holding every bookmark, the nearest stop first (pinned
/// ones before the rest). Without a [from] position the bookmarks keep
/// their saved order.
List<BookmarkListSection> sectionBookmarksByDistance(
  Iterable<Bookmark> bookmarks,
  Coordinate? from,
) {
  final list = bookmarks.toList();
  if (list.isEmpty) return const [];
  if (from != null) {
    final distances = {
      for (final b in list) b.id: distanceBetween(from, b.stop.coordinate),
    };
    list.sort((a, b) => distances[a.id]!.compareTo(distances[b.id]!));
  }
  return [
    BookmarkListSection(
      id: distanceBookmarkSectionId,
      bookmarks: pinnedFirst(list),
    ),
  ];
}

/// The bookmarks a compact list (the home sheet, a host card) shows: every
/// pinned bookmark, then the newest unpinned ones until [limit] are shown.
/// So [limit] is a floor: a pin is never squeezed out (iOS
/// `HomeBookmarksSectionModel.refreshSelection`).
List<Bookmark> selectHomeBookmarks(
  Iterable<Bookmark> bookmarks, {
  int limit = 3,
}) {
  final all = bookmarks.toList()
    ..sort((a, b) {
      final byDate = b.dateCreated.compareTo(a.dateCreated);
      return byDate != 0 ? byDate : a.sortOrder.compareTo(b.sortOrder);
    });
  final pinned = all.where((b) => b.isPinned).toList();
  final rest = all.where((b) => !b.isPinned);
  return [...pinned, ...rest.take((limit - pinned.length).clamp(0, limit))];
}
