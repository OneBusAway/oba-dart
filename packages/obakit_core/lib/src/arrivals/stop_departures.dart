import 'package:onebusaway/onebusaway.dart';

import '../user_data/stop_preferences.dart';
import 'arrival_logic.dart';
import 'walk_time.dart';

/// What a stop page shows, derived from one arrivals response: the iOS
/// `StopPageContent` + `StopPageListBuilder` pipeline.
///
/// Raw arrivals go through [cleanArrivals] and [filterTerminalDuplicates],
/// then the departure-type filter, then the stop's hidden routes (unless
/// [showHiddenRoutes]). The result is sorted by time and split into
/// [past] and [upcoming]; [walkDividerIndex] is where the walk-time
/// divider goes within [upcoming].
class StopDepartures {
  const StopDepartures._({
    required this.all,
    required this.past,
    required this.upcoming,
    required this.groups,
    required this.walkDividerIndex,
    required this.rawCount,
    required this.hiddenByRoutes,
    required this.hiddenByFilter,
  });

  factory StopDepartures.build(
    Iterable<ArrivalAndDeparture> raw, {
    required References references,
    required DateTime now,
    StopPreferences preferences = const StopPreferences(),
    ArrivalDepartureFilter filter = ArrivalDepartureFilter.all,
    bool showHiddenRoutes = false,
    int? walkMinutes,
  }) {
    final cleaned = filterTerminalDuplicates(cleanArrivals(raw));
    final byType = filterByArrivalDepartureFilter(cleaned, filter);
    final visible = showHiddenRoutes
        ? byType
        : filterHiddenRoutes(byType, preferences);
    final sorted = sortByTime(visible);
    final past = [
      for (final a in sorted)
        if ((a.minutesUntil(now) ?? -1) < 0) a,
    ];
    final upcoming = [
      for (final a in sorted)
        if ((a.minutesUntil(now) ?? -1) >= 0) a,
    ];
    return StopDepartures._(
      all: sorted,
      past: past,
      upcoming: upcoming,
      groups: groupArrivalsByRoute(
        sorted,
        references: references,
        preferences: preferences,
        hideRoutes: false,
      ),
      walkDividerIndex: walkTimeDividerIndex(
        upcoming,
        now: now,
        walkMinutes: walkMinutes,
      ),
      rawCount: cleaned.length,
      hiddenByRoutes: byType.length - visible.length,
      hiddenByFilter: cleaned.length - byType.length,
    );
  }

  /// Every visible row, soonest first.
  final List<ArrivalAndDeparture> all;

  /// Rows already gone, soonest (longest ago) first.
  final List<ArrivalAndDeparture> past;

  /// Rows now or later.
  final List<ArrivalAndDeparture> upcoming;

  /// [all] grouped by route, ordered by the preferences' sort.
  final List<GroupedArrivalDeparture> groups;

  /// Index into [upcoming] before which the walk-time divider goes, or
  /// null for none.
  final int? walkDividerIndex;

  /// Rows after cleaning, before any filter.
  final int rawCount;

  /// Rows the hidden-routes filter removed.
  final int hiddenByRoutes;

  /// Rows the departure-type filter removed.
  final int hiddenByFilter;

  bool get isEmpty => all.isEmpty;

  /// Empty only because routes are hidden at this stop.
  bool get isEmptyBecauseOfHiddenRoutes => all.isEmpty && hiddenByRoutes > 0;

  /// Empty only because of the departure-type filter.
  bool get isEmptyBecauseOfFilter =>
      all.isEmpty && hiddenByRoutes == 0 && hiddenByFilter > 0;
}

/// Remembers the last [StopDepartures.build] and returns it again while its
/// inputs are unchanged: the same `raw` and `references` objects (one
/// arrivals response), equal preferences, filter, hidden-routes flag and
/// walk minutes, and a `now` that has not crossed any time the result
/// depends on (a departure leaving, or entering the walk window).
///
/// A stop page rebuilds for many reasons (user data, settings, expanding a
/// section); this keeps those rebuilds from re-running the pipeline.
class StopDeparturesMemo {
  Iterable<ArrivalAndDeparture>? _raw;
  References? _references;
  StopPreferences? _preferences;
  ArrivalDepartureFilter? _filter;
  bool? _showHidden;
  int? _walk;
  int _validFrom = 0;
  int _validUntil = 0;
  StopDepartures? _value;

  /// How many times the pipeline actually ran (for tests).
  int computeCount = 0;

  /// [StopDepartures.build], or the previous result when nothing it
  /// depends on changed.
  StopDepartures build(
    Iterable<ArrivalAndDeparture> raw, {
    required References references,
    required DateTime now,
    StopPreferences preferences = const StopPreferences(),
    ArrivalDepartureFilter filter = ArrivalDepartureFilter.all,
    bool showHiddenRoutes = false,
    int? walkMinutes,
  }) {
    final t = now.millisecondsSinceEpoch;
    final cached = _value;
    if (cached != null &&
        identical(raw, _raw) &&
        identical(references, _references) &&
        preferences == _preferences &&
        filter == _filter &&
        showHiddenRoutes == _showHidden &&
        walkMinutes == _walk &&
        t >= _validFrom &&
        t <= _validUntil) {
      return cached;
    }
    computeCount++;
    final value = StopDepartures.build(
      raw,
      references: references,
      now: now,
      preferences: preferences,
      filter: filter,
      showHiddenRoutes: showHiddenRoutes,
      walkMinutes: walkMinutes,
    );
    // The result only depends on `now` through `minutesUntil(now) < 0`
    // (past vs upcoming, flips once now > departure) and
    // `minutesUntil(now) < walkMinutes` (flips once now > departure - walk).
    var until = 8640000000000000; // DateTime's max milliseconds.
    final walkMs = walkMinutes == null ? null : walkMinutes * 60000;
    for (final a in value.all) {
      final d = a.bestDate?.millisecondsSinceEpoch;
      if (d == null) continue;
      if (d >= t && d < until) until = d;
      if (walkMs != null) {
        final w = d - walkMs;
        if (w >= t && w < until) until = w;
      }
    }
    _raw = raw;
    _references = references;
    _preferences = preferences;
    _filter = filter;
    _showHidden = showHiddenRoutes;
    _walk = walkMinutes;
    _validFrom = t;
    _validUntil = until;
    return _value = value;
  }
}
