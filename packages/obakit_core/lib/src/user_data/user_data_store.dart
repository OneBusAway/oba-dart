import 'package:clock/clock.dart';

import '../foundation/change_notifier.dart';
import '../foundation/json.dart';
import '../foundation/uuid.dart';
import '../geo/distance.dart';
import '../platform/key_value_store.dart';
import 'bookmark.dart';
import 'recents.dart';
import 'stop_preferences.dart';
import 'stored_alarm.dart';
import 'stored_stop.dart';

/// A survey the user answered or dismissed.
class CompletedSurvey {
  const CompletedSurvey({required this.surveyId, required this.userId});

  factory CompletedSurvey.fromJson(JsonObject j) => CompletedSurvey(
    surveyId: jInt(j, 'surveyId') ?? (throw const FormatException('id')),
    userId: jString(j, 'userId') ?? '',
  );

  final int surveyId;
  final String userId;

  JsonObject toJson() => {'surveyId': surveyId, 'userId': userId};
}

/// A survey the user asked to see later, with the launch count at the time.
class SurveyForLater {
  const SurveyForLater({
    required this.surveyId,
    required this.userId,
    required this.launchCountWhenMarked,
  });

  factory SurveyForLater.fromJson(JsonObject j) => SurveyForLater(
    surveyId: jInt(j, 'surveyId') ?? (throw const FormatException('id')),
    userId: jString(j, 'userId') ?? '',
    launchCountWhenMarked: jInt(j, 'launchCountWhenMarked') ?? 0,
  );

  final int surveyId;
  final String userId;
  final int launchCountWhenMarked;

  JsonObject toJson() => {
    'surveyId': surveyId,
    'userId': userId,
    'launchCountWhenMarked': launchCountWhenMarked,
  };
}

/// Everything the user saves: bookmarks and groups, recent stops, places and
/// searches, per-stop preferences, alarms, read service alerts, survey
/// bookkeeping and the app launch count. Port of iOS `UserDefaultsStore`.
///
/// State is read from the [KeyValueStore] once, kept in memory, and written
/// through on every change. Every mutation that changes something calls
/// [notifyListeners] once.
class UserDataStore extends ObaChangeNotifier {
  UserDataStore(this._store) {
    _bookmarks = parseObjects(_store.readList(_kBookmarks), Bookmark.fromJson);
    _groups = parseObjects(_store.readList(_kGroups), BookmarkGroup.fromJson);
    _recentStops = parseObjects(
      _store.readList(_kRecentStops),
      RecentStop.fromJson,
    );
    _recentPlaces = parseObjects(
      _store.readList(_kRecentPlaces),
      RecentPlace.fromJson,
    );
    _recentSearches = [
      for (final s in _store.readList(_kRecentSearches))
        if (s is String) s,
    ];
    _alarms = parseObjects(_store.readList(_kAlarms), StoredAlarm.fromJson);
    _stopPreferences = {
      for (final e in _store.readMap(_kStopPreferences).entries)
        if (e.value is Map<String, Object?>)
          e.key: StopPreferences.fromJson(e.value as Map<String, Object?>),
    };
    _readAlertIds = {
      for (final s in _store.readList(_kReadAlerts))
        if (s is String) s,
    };
    _completedSurveys = parseObjects(
      _store.readList(_kCompletedSurveys),
      CompletedSurvey.fromJson,
    );
    _surveysForLater = parseObjects(
      _store.readList(_kSurveysForLater),
      SurveyForLater.fromJson,
    );
  }

  static const _p = 'oba.userData.';
  static const _kBookmarks = '${_p}bookmarks';
  static const _kGroups = '${_p}bookmarkGroups';
  static const _kRecentStops = '${_p}recentStops';
  static const _kRecentPlaces = '${_p}recentPlaces';
  static const _kRecentSearches = '${_p}recentSearches';
  static const _kAlarms = '${_p}alarms';
  static const _kStopPreferences = '${_p}stopPreferences';
  static const _kReadAlerts = '${_p}readServiceAlerts';
  static const _kCompletedSurveys = '${_p}completedSurveys';
  static const _kSurveysForLater = '${_p}surveysForLater';
  static const _kSurveyUserId = '${_p}surveyUserIdentifier';
  static const _kLaunchCount = '${_p}appLaunchCount';
  static const _kSurveyEnabled = '${_p}isSurveyEnabled';
  static const _kSurveyReminder = '${_p}nextSurveyReminderDate';
  static const _kAlwaysShowSurveys = '${_p}alwaysShowSurveysOnStops';
  static const _kTripPlanning = '${_p}tripPlanningEnabled';

  static const maximumRecentStops = 20;
  static const maximumRecentPlaces = 10;
  static const maximumRecentSearches = 10;

  final KeyValueStore _store;

  late List<Bookmark> _bookmarks;
  late List<BookmarkGroup> _groups;
  late List<RecentStop> _recentStops;
  late List<RecentPlace> _recentPlaces;
  late List<String> _recentSearches;
  late List<StoredAlarm> _alarms;
  late Map<String, StopPreferences> _stopPreferences;
  late Set<String> _readAlertIds;
  late List<CompletedSurvey> _completedSurveys;
  late List<SurveyForLater> _surveysForLater;

  // -- Bookmark groups --------------------------------------------------------

  /// Groups ordered by `sortOrder`.
  List<BookmarkGroup> get bookmarkGroups =>
      List.of(_groups)..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  BookmarkGroup? findGroup(String? id) =>
      id == null ? null : _groups.where((g) => g.id == id).firstOrNull;

  /// Adds a group named [name] after the existing ones.
  BookmarkGroup addGroup(String name) {
    final next = _groups.isEmpty
        ? 0
        : _groups.map((g) => g.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
    final group = BookmarkGroup(
      id: generateUuid(),
      name: name,
      sortOrder: next,
    );
    upsertGroup(group);
    return group;
  }

  /// Inserts [group] or replaces the group with its id.
  void upsertGroup(BookmarkGroup group) {
    final i = _groups.indexWhere((g) => g.id == group.id);
    if (i >= 0) {
      if (_groups[i] == group) return;
      _groups[i] = group;
    } else {
      _groups.add(group);
    }
    _saveGroups();
    notifyListeners();
  }

  void renameGroup(String id, String name) {
    final group = findGroup(id);
    if (group != null) upsertGroup(group.copyWith(name: name));
  }

  /// Reorders groups to match [orderedIds]; groups not listed keep their
  /// relative order after the listed ones.
  void reorderGroups(List<String> orderedIds) {
    final ordered = [
      for (final id in orderedIds) ?findGroup(id),
      for (final g in bookmarkGroups)
        if (!orderedIds.contains(g.id)) g,
    ];
    replaceBookmarkGroups([
      for (var i = 0; i < ordered.length; i++)
        ordered[i].copyWith(sortOrder: i),
    ]);
  }

  /// Moves the group at [oldIndex] to [newIndex] (indexes into
  /// [bookmarkGroups], with [newIndex] measured after removal).
  void moveGroup(int oldIndex, int newIndex) {
    final ids = bookmarkGroups.map((g) => g.id).toList();
    final id = ids.removeAt(oldIndex);
    ids.insert(newIndex.clamp(0, ids.length), id);
    reorderGroups(ids);
  }

  /// Deletes the group; its bookmarks become ungrouped, appended after the
  /// existing ungrouped ones in their old order.
  void deleteGroup(String id) {
    final exists = _groups.any((g) => g.id == id);
    final orphans = _bookmarks.any((b) => b.groupId == id);
    if (!exists && !orphans) return;
    _groups.removeWhere((g) => g.id == id);
    if (orphans) _ungroup({id});
    _saveGroups();
    _saveBookmarks();
    notifyListeners();
  }

  /// Replaces all groups (e.g. after an edit screen). Bookmarks in groups
  /// that disappear become ungrouped.
  void replaceBookmarkGroups(List<BookmarkGroup> groups) {
    final newIds = groups.map((g) => g.id).toSet();
    final deleted = {
      for (final g in _groups)
        if (!newIds.contains(g.id)) g.id,
      for (final b in _bookmarks)
        if (b.groupId != null && !newIds.contains(b.groupId)) b.groupId!,
    };
    final bookmarksChanged = _bookmarks.any(
      (b) => b.groupId != null && deleted.contains(b.groupId),
    );
    final groupsChanged =
        groups.length != _groups.length ||
        groups.any((g) => findGroup(g.id) != g);
    if (!bookmarksChanged && !groupsChanged) return;
    if (bookmarksChanged) _ungroup(deleted);
    _groups = List.of(groups);
    _saveGroups();
    _saveBookmarks();
    notifyListeners();
  }

  void _ungroup(Set<String> groupIds) {
    final orderedGroups = [
      ...bookmarkGroups.map((g) => g.id).where(groupIds.contains),
      ...groupIds.where((id) => findGroup(id) == null),
    ];
    final ungrouped = _sorted(_bookmarks.where((b) => b.groupId == null));
    final moved = [
      for (final gid in orderedGroups)
        ..._sorted(_bookmarks.where((b) => b.groupId == gid)),
    ];
    final combined = [...ungrouped, ...moved];
    final renumbered = {
      for (var i = 0; i < combined.length; i++)
        combined[i].id: combined[i].copyWith(groupId: () => null, sortOrder: i),
    };
    _bookmarks = [for (final b in _bookmarks) renumbered[b.id] ?? b];
  }

  // -- Bookmarks --------------------------------------------------------------

  /// All bookmarks, in storage order.
  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);

  List<Bookmark> get favoritedBookmarks =>
      _bookmarks.where((b) => b.isFavorite).toList();

  List<Bookmark> get pinnedBookmarks =>
      _bookmarks.where((b) => b.isPinned).toList();

  /// Bookmarks in [groupId] (null: ungrouped), by `sortOrder`.
  List<Bookmark> bookmarksInGroup(String? groupId) =>
      _sorted(_bookmarks.where((b) => b.groupId == groupId));

  List<Bookmark> bookmarksInRegion(int? regionId) => regionId == null
      ? []
      : _bookmarks.where((b) => b.regionId == regionId).toList();

  Bookmark? findBookmark(String id) =>
      _bookmarks.where((b) => b.id == id).firstOrNull;

  Bookmark? findBookmarkForStop(String stopId, {int? regionId}) => _bookmarks
      .where(
        (b) =>
            b.stopId == stopId &&
            !b.isTripBookmark &&
            (regionId == null || b.regionId == regionId),
      )
      .firstOrNull;

  /// Bookmarks whose route, headsign or stop matches [text] (trimmed).
  List<Bookmark> findBookmarks(String text) {
    final q = text.trim();
    return _bookmarks.where((b) => b.matchesQuery(q)).toList();
  }

  /// Whether an equivalent bookmark (same name, stop, route...) exists.
  bool isDuplicate(Bookmark bookmark) =>
      _bookmarks.any((b) => b.isEquivalentTo(bookmark));

  /// Adds [bookmark] (or moves it, when one with its id exists) into
  /// [groupId] at [index] (default: the end). Both the destination and the
  /// source group are renumbered 0..n-1.
  void addBookmark(Bookmark bookmark, {String? groupId, int? index}) {
    final existing = findBookmark(bookmark.id);
    final oldGroupId = existing?.groupId;
    final others = _bookmarks.where((b) => b.id != bookmark.id).toList();
    final destination = _sorted(others.where((b) => b.groupId == groupId));
    final at = (index ?? destination.length).clamp(0, destination.length);
    destination.insert(at, bookmark.copyWith(groupId: () => groupId));
    final renumbered = <String, Bookmark>{
      for (var i = 0; i < destination.length; i++)
        destination[i].id: destination[i].copyWith(sortOrder: i),
    };
    if (existing != null && oldGroupId != groupId) {
      final source = _sorted(others.where((b) => b.groupId == oldGroupId));
      for (var i = 0; i < source.length; i++) {
        renumbered[source[i].id] = source[i].copyWith(sortOrder: i);
      }
    }
    final next = [
      for (final b in others) renumbered[b.id] ?? b,
      if (existing == null) renumbered[bookmark.id]!,
    ];
    if (existing != null) {
      // Keep the moved bookmark at its old storage position.
      final i = _bookmarks.indexWhere((b) => b.id == bookmark.id);
      next.insert(i.clamp(0, next.length), renumbered[bookmark.id]!);
    }
    if (_listEquals(next, _bookmarks)) return;
    _bookmarks = next;
    _saveBookmarks();
    notifyListeners();
  }

  /// Moves a bookmark within its group, from [oldIndex] to [newIndex]
  /// (indexes into [bookmarksInGroup], [newIndex] measured after removal).
  void moveBookmark(String? groupId, int oldIndex, int newIndex) {
    final list = bookmarksInGroup(groupId);
    if (oldIndex < 0 || oldIndex >= list.length) return;
    addBookmark(list[oldIndex], groupId: groupId, index: newIndex);
  }

  /// Replaces the stored bookmark with [bookmark]'s id, keeping its stored
  /// group and sort order. Use [addBookmark] to move it.
  void updateBookmark(Bookmark bookmark) {
    final i = _bookmarks.indexWhere((b) => b.id == bookmark.id);
    if (i < 0) return;
    final stored = _bookmarks[i];
    final updated = bookmark.copyWith(
      groupId: () => stored.groupId,
      sortOrder: stored.sortOrder,
    );
    if (updated == stored) return;
    _bookmarks[i] = updated;
    _saveBookmarks();
    notifyListeners();
  }

  void setPinned(String bookmarkId, bool isPinned) {
    final b = findBookmark(bookmarkId);
    if (b == null || b.isPinned == isPinned) return;
    updateBookmark(b.copyWith(isPinned: isPinned));
  }

  void setFavorite(String bookmarkId, bool isFavorite) {
    final b = findBookmark(bookmarkId);
    if (b == null || b.isFavorite == isFavorite) return;
    updateBookmark(b.copyWith(isFavorite: isFavorite));
  }

  /// Deletes a bookmark and renumbers the rest of its group.
  void deleteBookmark(String id) {
    final stored = findBookmark(id);
    if (stored == null) return;
    _bookmarks.removeWhere((b) => b.id == id);
    final remaining = _sorted(
      _bookmarks.where((b) => b.groupId == stored.groupId),
    );
    final renumbered = {
      for (var i = 0; i < remaining.length; i++)
        remaining[i].id: remaining[i].copyWith(sortOrder: i),
    };
    _bookmarks = [for (final b in _bookmarks) renumbered[b.id] ?? b];
    _saveBookmarks();
    notifyListeners();
  }

  // -- Recent stops -----------------------------------------------------------

  /// Recent stops, newest first, across all regions.
  List<RecentStop> get recentStops => List.unmodifiable(_recentStops);

  /// Recent stops in [regionId], newest first, without duplicates.
  List<StoredStop> recentStopsInRegion(int? regionId) {
    if (regionId == null) return [];
    final seen = <String>{};
    return [
      for (final r in _recentStops)
        if (r.regionId == regionId && seen.add(r.stop.id)) r.stop,
    ];
  }

  /// Records a stop view: moves it to the front, caps the list at
  /// [maximumRecentStops], and refreshes the embedded stop of matching
  /// bookmarks.
  void addRecentStop(StoredStop stop, {required int regionId}) {
    var bookmarksChanged = false;
    _bookmarks = [
      for (final b in _bookmarks)
        if (b.stopId == stop.id && b.regionId == regionId && b.stop != stop)
          () {
            bookmarksChanged = true;
            return b.copyWith(stop: stop);
          }()
        else
          b,
    ];
    if (bookmarksChanged) _saveBookmarks();
    _recentStops = [
      RecentStop(stop: stop, regionId: regionId),
      ..._recentStops.where((r) => r.stop.id != stop.id),
    ].take(maximumRecentStops).toList();
    _saveRecentStops();
    notifyListeners();
  }

  void deleteRecentStop(String stopId) {
    final before = _recentStops.length;
    _recentStops.removeWhere((r) => r.stop.id == stopId);
    if (_recentStops.length == before) return;
    _saveRecentStops();
    notifyListeners();
  }

  void deleteAllRecentStops() {
    if (_recentStops.isEmpty) return;
    _recentStops = [];
    _saveRecentStops();
    notifyListeners();
  }

  /// Recent stops whose name or routes match [text] (trimmed).
  List<StoredStop> findRecentStops(String text, {int? regionId}) {
    final q = text.trim().toLowerCase();
    final stops = regionId == null
        ? _recentStops.map((r) => r.stop)
        : recentStopsInRegion(regionId);
    return stops
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.routes.any(
                (r) =>
                    (r.shortName?.toLowerCase().contains(q) ?? false) ||
                    (r.longName?.toLowerCase().contains(q) ?? false) ||
                    (r.description?.toLowerCase().contains(q) ?? false),
              ),
        )
        .toList();
  }

  // -- Recent places and searches ----------------------------------------------

  List<RecentPlace> get recentPlaces => List.unmodifiable(_recentPlaces);

  /// Adds [place] to the front, replacing any place within 10 m, capped at
  /// [maximumRecentPlaces].
  void addRecentPlace(RecentPlace place) {
    _recentPlaces = [
      place,
      ..._recentPlaces.where(
        (p) => distanceBetween(p.coordinate, place.coordinate) >= 10,
      ),
    ].take(maximumRecentPlaces).toList();
    _store.writeJson(_kRecentPlaces, [
      for (final p in _recentPlaces) p.toJson(),
    ]);
    notifyListeners();
  }

  void deleteAllRecentPlaces() {
    if (_recentPlaces.isEmpty) return;
    _recentPlaces = [];
    _store.writeJson(_kRecentPlaces, null);
    notifyListeners();
  }

  /// Recent search queries, newest first.
  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  /// Adds a query (trimmed; blank ignored), de-duplicated case-insensitively.
  void addRecentSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    _recentSearches = [
      q,
      ..._recentSearches.where((s) => s.toLowerCase() != q.toLowerCase()),
    ].take(maximumRecentSearches).toList();
    _store.writeJson(_kRecentSearches, _recentSearches);
    notifyListeners();
  }

  void deleteAllRecentSearches() {
    if (_recentSearches.isEmpty) return;
    _recentSearches = [];
    _store.writeJson(_kRecentSearches, null);
    notifyListeners();
  }

  // -- Stop preferences -------------------------------------------------------

  static String stopPreferencesKey(int regionId, String stopId) =>
      '${regionId}_$stopId';

  StopPreferences stopPreferences(int regionId, String stopId) =>
      _stopPreferences[stopPreferencesKey(regionId, stopId)] ??
      const StopPreferences();

  bool hasStopPreferences(int regionId, String stopId) =>
      _stopPreferences.containsKey(stopPreferencesKey(regionId, stopId));

  void setStopPreferences(
    int regionId,
    String stopId,
    StopPreferences preferences,
  ) {
    final key = stopPreferencesKey(regionId, stopId);
    if (_stopPreferences[key] == preferences) return;
    _stopPreferences[key] = preferences;
    _store.writeJson(_kStopPreferences, {
      for (final e in _stopPreferences.entries) e.key: e.value.toJson(),
    });
    notifyListeners();
  }

  // -- Alarms -----------------------------------------------------------------

  List<StoredAlarm> get alarms => List.unmodifiable(_alarms);

  void addAlarm(StoredAlarm alarm) {
    _alarms = [..._alarms.where((a) => a.url != alarm.url), alarm];
    _saveAlarms();
    notifyListeners();
  }

  /// Removes every alarm with [url].
  void deleteAlarm(Uri url) {
    final before = _alarms.length;
    _alarms.removeWhere((a) => a.url == url);
    if (_alarms.length == before) return;
    _saveAlarms();
    notifyListeners();
  }

  /// Removes alarms whose trip date is missing or has passed.
  void deleteExpiredAlarms() {
    final now = clock.now();
    final before = _alarms.length;
    _alarms.removeWhere((a) => a.isExpiredAt(now));
    if (_alarms.length == before) return;
    _saveAlarms();
    notifyListeners();
  }

  // -- Service alerts ---------------------------------------------------------

  bool isAlertUnread(String alertId) => !_readAlertIds.contains(alertId);

  void markAlertRead(String alertId) {
    if (!_readAlertIds.add(alertId)) return;
    _store.writeJson(_kReadAlerts, _readAlertIds.toList());
    notifyListeners();
  }

  void markAlertsRead(Iterable<String> alertIds) {
    final before = _readAlertIds.length;
    _readAlertIds.addAll(alertIds);
    if (_readAlertIds.length == before) return;
    _store.writeJson(_kReadAlerts, _readAlertIds.toList());
    notifyListeners();
  }

  // -- Trip planning ----------------------------------------------------------

  /// Defaults to enabled.
  bool isTripPlanningEnabled(int regionId) =>
      _store.readMap(_kTripPlanning)['$regionId'] != false;

  void setTripPlanningEnabled(int regionId, bool enabled) {
    _store.writeJson(_kTripPlanning, {
      ..._store.readMap(_kTripPlanning),
      '$regionId': enabled,
    });
    notifyListeners();
  }

  // -- Launch count and surveys -------------------------------------------------

  int get appLaunchCount => _store.readInt(_kLaunchCount) ?? 0;

  void incrementAppLaunchCount() {
    _store.writeJson(_kLaunchCount, appLaunchCount + 1);
    notifyListeners();
  }

  /// A random id for survey responses, created on first use.
  String get surveyUserIdentifier {
    final existing = _store.readStringValue(_kSurveyUserId);
    if (existing != null) return existing;
    final id = generateUuid();
    _store.writeJson(_kSurveyUserId, id);
    return id;
  }

  set surveyUserIdentifier(String id) => _store.writeJson(_kSurveyUserId, id);

  /// Defaults to true.
  bool get isSurveyEnabled => _store.readBool(_kSurveyEnabled) ?? true;

  set isSurveyEnabled(bool v) {
    _store.writeJson(_kSurveyEnabled, v);
    notifyListeners();
  }

  DateTime? get nextSurveyReminderDate =>
      DateTime.tryParse(_store.readStringValue(_kSurveyReminder) ?? '');

  set nextSurveyReminderDate(DateTime? date) {
    _store.writeJson(_kSurveyReminder, date == null ? null : isoDate(date));
    notifyListeners();
  }

  bool get alwaysShowSurveysOnStops =>
      _store.readBool(_kAlwaysShowSurveys) ?? false;

  set alwaysShowSurveysOnStops(bool v) {
    _store.writeJson(_kAlwaysShowSurveys, v);
    notifyListeners();
  }

  bool isSurveyCompleted(int surveyId, String userId) => _completedSurveys.any(
    (c) => c.surveyId == surveyId && c.userId == userId,
  );

  /// Marks completed, and clears any "later" mark.
  void markSurveyCompleted(int surveyId, String userId) {
    _completedSurveys = [
      ..._completedSurveys.where(
        (c) => !(c.surveyId == surveyId && c.userId == userId),
      ),
      CompletedSurvey(surveyId: surveyId, userId: userId),
    ];
    _surveysForLater.removeWhere(
      (s) => s.surveyId == surveyId && s.userId == userId,
    );
    _saveSurveys();
    notifyListeners();
  }

  bool isSurveyMarkedForLater(int surveyId, String userId) =>
      _surveysForLater.any((s) => s.surveyId == surveyId && s.userId == userId);

  void markSurveyForLater(int surveyId, String userId) {
    _surveysForLater = [
      ..._surveysForLater.where(
        (s) => !(s.surveyId == surveyId && s.userId == userId),
      ),
      SurveyForLater(
        surveyId: surveyId,
        userId: userId,
        launchCountWhenMarked: appLaunchCount,
      ),
    ];
    _saveSurveys();
    notifyListeners();
  }

  /// True on every third launch after the survey was marked for later.
  bool shouldShowSurveyLater(int surveyId, String userId) {
    final mark = _surveysForLater
        .where((s) => s.surveyId == surveyId && s.userId == userId)
        .firstOrNull;
    if (mark == null) return false;
    final since = appLaunchCount - mark.launchCountWhenMarked;
    return since > 0 && since % 3 == 0;
  }

  // -- Persistence --------------------------------------------------------------

  static List<Bookmark> _sorted(Iterable<Bookmark> b) =>
      b.toList()..sort((x, y) => x.sortOrder.compareTo(y.sortOrder));

  static bool _listEquals(List<Bookmark> a, List<Bookmark> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _saveBookmarks() =>
      _store.writeJson(_kBookmarks, [for (final b in _bookmarks) b.toJson()]);

  void _saveGroups() =>
      _store.writeJson(_kGroups, [for (final g in _groups) g.toJson()]);

  void _saveRecentStops() => _store.writeJson(_kRecentStops, [
    for (final r in _recentStops) r.toJson(),
  ]);

  void _saveAlarms() =>
      _store.writeJson(_kAlarms, [for (final a in _alarms) a.toJson()]);

  void _saveSurveys() {
    _store.writeJson(_kCompletedSurveys, [
      for (final c in _completedSurveys) c.toJson(),
    ]);
    _store.writeJson(_kSurveysForLater, [
      for (final s in _surveysForLater) s.toJson(),
    ]);
  }
}
