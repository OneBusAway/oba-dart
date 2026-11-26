import 'package:onebusaway/onebusaway.dart';

import '../user_data/bookmark.dart';
import '../user_data/stop_preferences.dart';

/// Whether a row is the vehicle arriving at, or departing from, the stop.
enum ArrivalDepartureStatus { arriving, departing }

/// Whether the best time is in the past, the current minute, or the future.
enum TemporalState { past, present, future }

enum ScheduleStatus { unknown, early, onTime, delayed }

/// iOS `ArrivalDeparture.earliestPlausibleDate` (2001-01-01T00:00:01Z).
final DateTime earliestPlausibleDate = DateTime.utc(2001, 1, 1, 0, 0, 1);

/// iOS's per-row computed properties. Time-dependent values take `now`
/// explicitly; pass the controller's server-corrected time.
///
/// Note: ETA flooring duplicates a few lines of `oba_arrivals`
/// (`minutesUntil`), which this pure-Dart package cannot depend on. Unlike
/// `oba_arrivals`, these follow iOS and use the *departure* time when the
/// stop is the trip's first (`stopSequence == 0`).
extension ArrivalDepartureLogic on ArrivalAndDeparture {
  ArrivalDepartureStatus get arrivalDepartureStatus => stopSequence == 0
      ? ArrivalDepartureStatus.departing
      : ArrivalDepartureStatus.arriving;

  /// Identity of this visit: stop, trip, route, service date, sequence and
  /// arrival/departure status (iOS `ArrivalDeparture.id`).
  String get visitId =>
      'stop=$stopId,trip=$tripId,route=$routeId,'
      'serviceDate=${serviceDate.millisecondsSinceEpoch},'
      'sequence=$stopSequence,status=${arrivalDepartureStatus.name}';

  /// Predicted time when available, otherwise scheduled; departure times for
  /// departures. Null when the server sent neither.
  DateTime? get bestDate => switch (arrivalDepartureStatus) {
    ArrivalDepartureStatus.arriving =>
      predictedArrivalTime ?? scheduledArrivalTime,
    ArrivalDepartureStatus.departing =>
      predictedDepartureTime ?? scheduledDepartureTime,
  };

  DateTime? get scheduledDate => switch (arrivalDepartureStatus) {
    ArrivalDepartureStatus.arriving => scheduledArrivalTime,
    ArrivalDepartureStatus.departing => scheduledDepartureTime,
  };

  bool get hasPlausibleDate {
    final d = bestDate;
    return d != null && !d.isBefore(earliestPlausibleDate);
  }

  /// Whole minutes until [bestDate], floored, so the current minute is 0 and
  /// anything already gone is negative. Null without a time.
  int? minutesUntil(DateTime now) {
    final d = bestDate;
    if (d == null) return null;
    return ((d.millisecondsSinceEpoch - now.millisecondsSinceEpoch) / 60000)
        .floor();
  }

  TemporalState temporalState(DateTime now) {
    final m = minutesUntil(now) ?? -1;
    if (m < 0) return TemporalState.past;
    if (m == 0) return TemporalState.present;
    return TemporalState.future;
  }

  double? get _rawDeviationMinutes {
    final best = bestDate;
    final scheduled = scheduledDate;
    if (best == null || scheduled == null) return null;
    return best.difference(scheduled).inMilliseconds / 60000;
  }

  /// Predicted minus scheduled, rounded to whole minutes (0 without data).
  int get deviationFromScheduleInMinutes => (_rawDeviationMinutes ?? 0).round();

  /// Early beyond 1.5 min, late beyond 1.5 min, else on time; unknown
  /// without a prediction.
  ScheduleStatus get scheduleStatus {
    if (!predicted) return ScheduleStatus.unknown;
    final d = _rawDeviationMinutes ?? 0;
    if (d < -1.5) return ScheduleStatus.early;
    if (d < 1.5) return ScheduleStatus.onTime;
    return ScheduleStatus.delayed;
  }

  /// `"10 - Downtown"`, skipping blank parts.
  String routeAndHeadsign({String? routeShortName}) => [
    routeShortName ?? this.routeShortName ?? routeId,
    tripHeadsign,
  ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' - ');

  TripBookmarkKey get tripBookmarkKey => TripBookmarkKey.fromArrival(this);
}

// -- List operations ------------------------------------------------------------

/// Drops rows whose best time is missing or an epoch sentinel.
List<ArrivalAndDeparture> filterImplausibleDates(
  Iterable<ArrivalAndDeparture> arrivals,
) => arrivals.where((a) => a.hasPlausibleDate).toList();

/// Collapses rows with the same [ArrivalDepartureLogic.visitId] (one per
/// vehicle when a feed assigns two vehicles to one trip), keeping the most
/// recently updated, at the first occurrence's position.
List<ArrivalAndDeparture> filterDuplicateVehicleReports(
  Iterable<ArrivalAndDeparture> arrivals,
) {
  final seen = <String, int>{};
  final result = <ArrivalAndDeparture>[];
  for (final a in arrivals) {
    final i = seen[a.visitId];
    if (i == null) {
      seen[a.visitId] = result.length;
      result.add(a);
    } else {
      final existing = result[i].lastUpdateTime;
      final candidate = a.lastUpdateTime;
      if (candidate != null &&
          (existing == null || candidate.isAfter(existing))) {
        result[i] = a;
      }
    }
  }
  return result;
}

/// Keeps one row per (trip, stop, route), so a terminal's arrival and
/// departure rows show once. Prefers real-time over scheduled, then the
/// departure over the arrival; otherwise the first wins.
List<ArrivalAndDeparture> filterTerminalDuplicates(
  Iterable<ArrivalAndDeparture> arrivals,
) {
  final seen = <(String, String, String), int>{};
  final result = <ArrivalAndDeparture>[];
  for (final a in arrivals) {
    final key = (a.tripId, a.stopId, a.routeId);
    final i = seen[key];
    if (i == null) {
      seen[key] = result.length;
      result.add(a);
      continue;
    }
    final existing = result[i];
    final replace =
        (!existing.predicted && a.predicted) ||
        (existing.predicted == a.predicted &&
            existing.arrivalDepartureStatus ==
                ArrivalDepartureStatus.arriving &&
            a.arrivalDepartureStatus == ArrivalDepartureStatus.departing);
    if (replace) result[i] = a;
  }
  return result;
}

/// The ingestion pipeline iOS runs when arrivals are decoded: implausible
/// dates, then duplicate vehicle reports. Terminal duplicates are a
/// separate, display-time choice ([filterTerminalDuplicates]).
List<ArrivalAndDeparture> cleanArrivals(
  Iterable<ArrivalAndDeparture> arrivals,
) => filterDuplicateVehicleReports(filterImplausibleDates(arrivals));

/// Filters by real-time availability.
List<ArrivalAndDeparture> filterByArrivalDepartureFilter(
  Iterable<ArrivalAndDeparture> arrivals,
  ArrivalDepartureFilter filter,
) => switch (filter) {
  ArrivalDepartureFilter.all => arrivals.toList(),
  ArrivalDepartureFilter.estimatedOnly =>
    arrivals.where((a) => a.predicted).toList(),
  ArrivalDepartureFilter.scheduledOnly =>
    arrivals.where((a) => !a.predicted).toList(),
};

/// Drops rows for routes hidden in [preferences].
List<ArrivalAndDeparture> filterHiddenRoutes(
  Iterable<ArrivalAndDeparture> arrivals,
  StopPreferences preferences,
) => arrivals.where((a) => !preferences.isRouteHidden(a.routeId)).toList();

/// Sorted by best time, soonest first (rows without a time last).
List<ArrivalAndDeparture> sortByTime(Iterable<ArrivalAndDeparture> arrivals) {
  final list = arrivals.toList();
  final far = DateTime.utc(9999);
  list.sort((a, b) => (a.bestDate ?? far).compareTo(b.bestDate ?? far));
  return list;
}

/// Arrivals for one route.
class GroupedArrivalDeparture {
  const GroupedArrivalDeparture({
    required this.routeId,
    required this.route,
    required this.arrivals,
  });

  final String routeId;

  /// From the response references; null when missing.
  final Route? route;

  /// In input order.
  final List<ArrivalAndDeparture> arrivals;

  /// Short name, falling back to the arrival's, then the route id.
  String get displayName =>
      route?.shortName ??
      arrivals.firstOrNull?.routeShortName ??
      route?.longName ??
      routeId;
}

/// Groups by route (iOS `group(preferences:filter:)`), dropping hidden
/// routes when [hideRoutes]. With [StopSort.route], groups are ordered by
/// route name (natural order); with [StopSort.time], by their soonest
/// arrival. [references] resolves routes.
List<GroupedArrivalDeparture> groupArrivalsByRoute(
  Iterable<ArrivalAndDeparture> arrivals, {
  required References references,
  StopPreferences preferences = const StopPreferences(),
  bool hideRoutes = true,
  StopSort? sort,
}) {
  final buckets = <String, List<ArrivalAndDeparture>>{};
  for (final a in arrivals) {
    if (hideRoutes && preferences.isRouteHidden(a.routeId)) continue;
    buckets.putIfAbsent(a.routeId, () => []).add(a);
  }
  final groups = [
    for (final e in buckets.entries)
      GroupedArrivalDeparture(
        routeId: e.key,
        route: references.route(e.key),
        arrivals: e.value,
      ),
  ];
  switch (sort ?? preferences.sortType) {
    case StopSort.route:
      groups.sort((a, b) => naturalCompare(a.displayName, b.displayName));
    case StopSort.time:
      final far = DateTime.utc(9999);
      DateTime first(GroupedArrivalDeparture g) => g.arrivals
          .map((a) => a.bestDate ?? far)
          .fold(far, (m, d) => d.isBefore(m) ? d : m);
      groups.sort((a, b) => first(a).compareTo(first(b)));
  }
  return groups;
}

/// Arrivals that match [key] (a trip bookmark), soonest first.
/// [routeShortName] resolves a missing short name from references.
List<ArrivalAndDeparture> arrivalsMatchingTripKey(
  Iterable<ArrivalAndDeparture> arrivals,
  TripBookmarkKey key, {
  References? references,
}) => sortByTime(
  arrivals.where(
    (a) =>
        TripBookmarkKey.fromArrival(
          a,
          routeShortName:
              a.routeShortName ?? references?.route(a.routeId)?.shortName,
        ) ==
        key,
  ),
);

/// Compares strings so embedded numbers sort numerically and letters
/// case-insensitively: `2 < 10 < 10X < A Line` (an approximation of Apple's
/// `localizedStandardCompare`).
int naturalCompare(String a, String b) {
  final re = RegExp(r'\d+|\D+');
  final pa = re.allMatches(a.toLowerCase()).map((m) => m[0]!).toList();
  final pb = re.allMatches(b.toLowerCase()).map((m) => m[0]!).toList();
  for (var i = 0; i < pa.length && i < pb.length; i++) {
    final x = pa[i];
    final y = pb[i];
    final nx = int.tryParse(x);
    final ny = int.tryParse(y);
    final c = (nx != null && ny != null) ? nx.compareTo(ny) : x.compareTo(y);
    if (c != 0) return c;
  }
  final c = pa.length.compareTo(pb.length);
  return c != 0 ? c : a.compareTo(b);
}
