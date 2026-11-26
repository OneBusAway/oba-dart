import 'package:onebusaway/onebusaway.dart';

import '../arrivals/arrival_logic.dart' show naturalCompare;

/// One scheduled departure from a stop.
class ScheduledDeparture {
  const ScheduledDeparture({
    required this.tripId,
    required this.time,
    this.headsign,
  });

  final String tripId;
  final DateTime time;
  final String? headsign;
}

/// One direction of a route at a stop: its departures (soonest first) and
/// any frequency-based service.
class StopScheduleDirection {
  const StopScheduleDirection({
    this.headsign,
    this.departures = const [],
    this.frequencies = const [],
  });

  final String? headsign;
  final List<ScheduledDeparture> departures;

  /// Frequency-based blocks ("every 10 min from 6:00 to 9:00").
  final List<ScheduleFrequency> frequencies;

  bool get isEmpty => departures.isEmpty && frequencies.isEmpty;
}

/// A route's schedule at a stop, by direction.
class RouteScheduleAtStop {
  const RouteScheduleAtStop({
    required this.routeId,
    this.route,
    this.directions = const [],
  });

  final String routeId;
  final Route? route;
  final List<StopScheduleDirection> directions;

  String get displayName => route?.shortName ?? route?.longName ?? routeId;

  int get departureCount =>
      directions.fold(0, (n, d) => n + d.departures.length);
}

/// The routes of a `schedule-for-stop` response in natural name order,
/// each direction's departures sorted. A stop time's own headsign wins
/// over the direction's (iOS `ScheduleForStopViewModel`).
List<RouteScheduleAtStop> stopScheduleRoutes(
  ScheduleForStop schedule,
  References references,
) {
  final routes = [
    for (final rs in schedule.stopRouteSchedules)
      RouteScheduleAtStop(
        routeId: rs.routeId,
        route: references.route(rs.routeId),
        directions: [
          for (final d in rs.stopRouteDirectionSchedules)
            StopScheduleDirection(
              headsign: d.tripHeadsign,
              frequencies: [...d.scheduleFrequencies]
                ..sort((a, b) => a.startTime.compareTo(b.startTime)),
              departures: [
                for (final t in d.scheduleStopTimes)
                  if (t.departureEnabled || t.arrivalEnabled)
                    ScheduledDeparture(
                      tripId: t.tripId,
                      time: t.departureTime,
                      headsign: (t.stopHeadsign?.trim().isNotEmpty ?? false)
                          ? t.stopHeadsign
                          : d.tripHeadsign,
                    ),
              ]..sort((a, b) => a.time.compareTo(b.time)),
            ),
        ],
      ),
  ];
  routes.sort((a, b) => naturalCompare(a.displayName, b.displayName));
  return routes;
}

/// Times bucketed by hour of day, in input order within each hour. [local]
/// converts an instant to the zone whose hours are shown (the device zone
/// by default).
List<(int hour, List<T> items)> groupByHour<T>(
  Iterable<T> items,
  DateTime Function(T item) time, {
  DateTime Function(DateTime)? local,
}) {
  final toLocal = local ?? (DateTime d) => d.toLocal();
  final out = <(int, List<T>)>[];
  for (final item in items) {
    final hour = toLocal(time(item)).hour;
    if (out.isNotEmpty && out.last.$1 == hour) {
      out.last.$2.add(item);
    } else {
      out.add((hour, [item]));
    }
  }
  return out;
}

/// One direction of a route timetable: its stops in travel order and its
/// trips sorted by start time; `times[trip][stop]` is null where the trip
/// skips the stop.
class RouteTimetableDirection {
  const RouteTimetableDirection({
    this.directionId,
    this.headsign,
    required this.stops,
    required this.tripIds,
    required this.times,
  });

  final String? directionId;
  final String? headsign;

  /// Stop ids paired with their resolved stops (null when missing from
  /// references).
  final List<(String id, Stop? stop)> stops;
  final List<String> tripIds;
  final List<List<DateTime?>> times;

  /// Departure times at the stop at [stopIndex], in trip order, skipping
  /// trips that don't serve it.
  List<DateTime> timesAtStop(int stopIndex) => [
    for (final row in times) ?row[stopIndex],
  ];

  /// The index of [stopId] in [stops], or null.
  int? indexOfStop(String stopId) {
    final i = stops.indexWhere((s) => s.$1 == stopId);
    return i < 0 ? null : i;
  }
}

/// Builds the timetable for each direction of a `schedule-for-route`
/// response. Times are seconds after the schedule date's midnight, so each
/// is `scheduleDate + seconds` (iOS `ScheduleForRouteViewModel`).
List<RouteTimetableDirection> routeTimetable(
  ScheduleForRoute schedule,
  References references,
) {
  final base = schedule.scheduleDate;
  return [
    for (final g in schedule.stopTripGroupings)
      () {
        final trips = [
          for (final t in g.tripsWithStopTimes)
            (
              id: t.tripId,
              byStop: {
                for (final st in t.stopTimes.reversed)
                  st.stopId: base.add(Duration(seconds: st.departureTime)),
              },
              start: t.stopTimes.isEmpty
                  ? null
                  : t.stopTimes
                        .map((s) => s.departureTime)
                        .reduce((a, b) => a < b ? a : b),
            ),
        ];
        trips.sort((a, b) {
          if (a.start == null) return b.start == null ? 0 : 1;
          if (b.start == null) return -1;
          return a.start!.compareTo(b.start!);
        });
        return RouteTimetableDirection(
          directionId: g.directionId,
          headsign: g.tripHeadsigns.firstOrNull,
          stops: [for (final id in g.stopIds) (id, references.stop(id))],
          tripIds: [for (final t in trips) t.id],
          times: [
            for (final t in trips) [for (final id in g.stopIds) t.byStop[id]],
          ],
        );
      }(),
  ];
}
