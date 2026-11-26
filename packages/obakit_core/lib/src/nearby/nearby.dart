import 'package:onebusaway/onebusaway.dart';

import '../arrivals/arrival_logic.dart';
import '../geo/distance.dart';
import '../user_data/bookmark.dart';

/// A row of the home Nearby section (iOS `HomeNearbyRow`).
sealed class NearbyRow {
  const NearbyRow(this.stop);

  final Stop stop;

  /// Stable identity for list keys.
  String get id;
}

/// The next departure of one route and headsign from a nearby stop.
final class NearbyDepartureRow extends NearbyRow {
  const NearbyDepartureRow(super.stop, this.arrival);

  final ArrivalAndDeparture arrival;

  @override
  String get id =>
      'departure|${stop.id}|${arrival.routeId}|'
      '${arrival.routeShortName ?? ''}|${arrival.tripHeadsign ?? ''}';
}

/// A stop whose arrivals have not loaded, or which has nothing coming.
final class NearbyStopOnlyRow extends NearbyRow {
  const NearbyStopOnlyRow(super.stop);

  @override
  String get id => 'stop|${stop.id}';
}

/// Defaults from iOS `HomeNearbyDepartures` and `HomeSheetSection`.
abstract final class NearbyDepartures {
  /// How many of the nearest stops have their arrivals fetched.
  static const int stopLimit = 3;

  /// Departures listed per stop, so a busy nearest stop does not push the
  /// others out.
  static const int perStopLimit = 2;

  /// Rows in the section.
  static const int rowLimit = 4;

  /// How long a stop's arrivals stand before they are fetched again.
  static const Duration staleAfter = Duration(seconds: 30);

  /// How far ahead to look, in minutes.
  static const int minutesAfter = 60;

  /// The section's rows for [stops] (nearest first) (iOS
  /// `HomeNearbyDepartures.rows`).
  ///
  /// [arrivals] holds the arrivals of each stop whose fetch finished; a
  /// stop missing from it shows as a [NearbyStopOnlyRow]. Departures in
  /// [excluding] (shown elsewhere, e.g. trip bookmarks) are skipped. When
  /// nothing at all is leaving, the stops themselves are listed so the
  /// section still leads somewhere.
  static List<NearbyRow> rows({
    required List<Stop> stops,
    required Map<String, List<ArrivalAndDeparture>> arrivals,
    required DateTime now,
    Set<TripBookmarkKey> excluding = const {},
    int limit = rowLimit,
    int perStop = perStopLimit,
  }) {
    final rows = <NearbyRow>[];
    for (final stop in stops) {
      final loaded = arrivals[stop.id];
      if (loaded == null) {
        rows.add(NearbyStopOnlyRow(stop));
        continue;
      }
      rows.addAll(
        nextDepartures(
          loaded,
          now: now,
          excluding: excluding,
        ).take(perStop).map((a) => NearbyDepartureRow(stop, a)),
      );
    }
    if (rows.isEmpty) {
      return [for (final s in stops.take(limit)) NearbyStopOnlyRow(s)];
    }
    return rows.take(limit).toList();
  }

  /// The soonest upcoming departure of each route and headsign, soonest
  /// first; ties broken by trip id.
  static List<ArrivalAndDeparture> nextDepartures(
    Iterable<ArrivalAndDeparture> arrivals, {
    required DateTime now,
    Set<TripBookmarkKey> excluding = const {},
  }) {
    final soonest = <TripBookmarkKey, ArrivalAndDeparture>{};
    for (final a in arrivals) {
      if (a.temporalState(now) == TemporalState.past) continue;
      final date = a.bestDate;
      if (date == null) continue;
      final key = TripBookmarkKey.fromArrival(a);
      if (excluding.contains(key)) continue;
      final current = soonest[key];
      if (current != null && !current.bestDate!.isAfter(date)) continue;
      soonest[key] = a;
    }
    return soonest.values.toList()..sort((a, b) {
      final c = a.bestDate!.compareTo(b.bestDate!);
      return c != 0 ? c : a.tripId.compareTo(b.tripId);
    });
  }
}

/// A stop with its distance from the point the list is centred on.
class NearbyStop {
  const NearbyStop(this.stop, this.distanceMeters);

  final Stop stop;
  final double distanceMeters;
}

/// Nearby stops that share a direction of travel.
class NearbyStopGroup {
  const NearbyStopGroup(this.direction, this.stops);

  /// [StopDirection.unknown] for stops without a direction.
  final StopDirection direction;

  /// Nearest first.
  final List<NearbyStop> stops;
}

/// Groups [stops] by direction (iOS `NearbyStopsViewController` sections),
/// each group nearest first, groups ordered by their nearest stop, with
/// stops of unknown direction last.
List<NearbyStopGroup> groupNearbyStopsByDirection(
  Iterable<Stop> stops,
  Coordinate center,
) {
  final buckets = <StopDirection, List<NearbyStop>>{};
  for (final s in stops) {
    buckets
        .putIfAbsent(s.compassDirection, () => [])
        .add(NearbyStop(s, distanceBetween(center, s.coordinate)));
  }
  final groups = [
    for (final e in buckets.entries)
      NearbyStopGroup(
        e.key,
        e.value..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters)),
      ),
  ];
  groups.sort((a, b) {
    final au = a.direction == StopDirection.unknown;
    final bu = b.direction == StopDirection.unknown;
    if (au != bu) return au ? 1 : -1;
    return a.stops.first.distanceMeters.compareTo(b.stops.first.distanceMeters);
  });
  return groups;
}
