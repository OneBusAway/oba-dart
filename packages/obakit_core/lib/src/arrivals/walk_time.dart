import 'package:onebusaway/onebusaway.dart';

import '../geo/distance.dart';
import 'arrival_logic.dart';

/// Straight-line seconds to cover the distance between two points at
/// [metersPerSecond] (iOS `WalkingDirections.travelTime`). Null for a
/// non-positive speed.
double? travelTimeSeconds(
  Coordinate from,
  Coordinate to, {
  double metersPerSecond = 1.4,
}) {
  if (metersPerSecond <= 0) return null;
  return distanceBetween(from, to) / metersPerSecond;
}

/// How long it takes to reach a stop (iOS `WalkTimeInfo`).
class WalkTime {
  const WalkTime({required this.minutes, required this.distanceMeters});

  /// Distances at or below this are "at the stop": no walk time.
  static const atStopThresholdMeters = 40.0;

  /// Computes the walk from [user] to [stop]. Minutes round up, so the
  /// estimate never promises a shorter walk than reality. Null without a
  /// location, with an invalid speed, or within [atStopThresholdMeters].
  static WalkTime? compute({
    required Coordinate? user,
    required Coordinate? stop,
    required double metersPerSecond,
  }) {
    if (user == null || stop == null) return null;
    final distance = distanceBetween(user, stop);
    if (distance <= atStopThresholdMeters) return null;
    final seconds = travelTimeSeconds(
      user,
      stop,
      metersPerSecond: metersPerSecond,
    );
    if (seconds == null) return null;
    return WalkTime(minutes: (seconds / 60).ceil(), distanceMeters: distance);
  }

  final int minutes;
  final double distanceMeters;

  @override
  bool operator ==(Object other) =>
      other is WalkTime &&
      other.minutes == minutes &&
      other.distanceMeters == distanceMeters;

  @override
  int get hashCode => Object.hash(minutes, distanceMeters);
}

/// A chronological stop page split around the walk-time divider (iOS
/// `StopPageListBuilder.ChronologicalPartition`).
class ChronologicalPartition {
  const ChronologicalPartition({
    required this.past,
    required this.missed,
    required this.reachable,
  });

  /// Already gone.
  final List<ArrivalAndDeparture> past;

  /// Upcoming, but sooner than the walk; shown above the divider. Empty
  /// without a walk time.
  final List<ArrivalAndDeparture> missed;

  /// Catchable on foot (`minutes >= walkMinutes`).
  final List<ArrivalAndDeparture> reachable;

  /// Whether the UI should draw the walk divider (between [missed] and
  /// [reachable]).
  bool get showsWalkDivider => missed.isNotEmpty;
}

/// Sorts by minutes until departure and partitions into past / missed /
/// reachable given [walkMinutes].
ChronologicalPartition partitionByWalkTime(
  Iterable<ArrivalAndDeparture> arrivals, {
  required DateTime now,
  int? walkMinutes,
}) {
  final timed = [
    for (final a in arrivals)
      if (a.minutesUntil(now) case final m?) (a, m),
  ]..sort((x, y) => x.$2.compareTo(y.$2));
  final past = [
    for (final t in timed)
      if (t.$2 < 0) t.$1,
  ];
  final upcoming = [
    for (final t in timed)
      if (t.$2 >= 0) t,
  ];
  if (walkMinutes == null) {
    return ChronologicalPartition(
      past: past,
      missed: const [],
      reachable: [for (final t in upcoming) t.$1],
    );
  }
  return ChronologicalPartition(
    past: past,
    missed: [
      for (final t in upcoming)
        if (t.$2 < walkMinutes) t.$1,
    ],
    reachable: [
      for (final t in upcoming)
        if (t.$2 >= walkMinutes) t.$1,
    ],
  );
}

/// The index in [arrivals] (already in display order) before which the walk
/// divider goes: the first upcoming row whose minutes are at least
/// [walkMinutes]. Null when there is no walk time, or no upcoming row is
/// missed (nothing to separate). May equal `arrivals.length` when every
/// upcoming row is missed.
int? walkTimeDividerIndex(
  List<ArrivalAndDeparture> arrivals, {
  required DateTime now,
  int? walkMinutes,
}) {
  if (walkMinutes == null) return null;
  var sawMissed = false;
  for (var i = 0; i < arrivals.length; i++) {
    final m = arrivals[i].minutesUntil(now);
    if (m == null || m < 0) continue;
    if (m < walkMinutes) {
      sawMissed = true;
    } else {
      return sawMissed ? i : null;
    }
  }
  return sawMissed ? arrivals.length : null;
}
