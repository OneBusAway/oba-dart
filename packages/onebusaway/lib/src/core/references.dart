import '../models/agency.dart';
import '../models/route.dart';
import '../models/situation.dart';
import '../models/stop.dart';
import '../models/trip.dart';
import 'json.dart';

/// The `references` block shared by every OBA response, indexed by id.
///
/// Note: `routes` can include routes that don't serve the requested stop;
/// filter by `Stop.routeIds` when you need the stop's routes.
class References {
  const References({
    this.agencies = const {},
    this.routes = const {},
    this.stops = const {},
    this.trips = const {},
    this.situations = const {},
  });

  factory References.fromJson(JsonMap? json) {
    if (json == null) return empty;
    Map<String, T> index<T>(
      String key,
      T Function(JsonMap) parse,
      String Function(T) id,
    ) => {for (final item in readObjectList(json, key, parse)) id(item): item};
    return References(
      agencies: index('agencies', Agency.fromJson, (a) => a.id),
      routes: index('routes', Route.fromJson, (r) => r.id),
      stops: index('stops', Stop.fromJson, (s) => s.id),
      trips: index('trips', Trip.fromJson, (t) => t.id),
      situations: index('situations', Situation.fromJson, (s) => s.id),
    );
  }

  static const References empty = References();

  final Map<String, Agency> agencies;
  final Map<String, Route> routes;
  final Map<String, Stop> stops;
  final Map<String, Trip> trips;

  /// Service alerts, by id.
  final Map<String, Situation> situations;

  Agency? agency(String id) => agencies[id];
  Route? route(String id) => routes[id];
  Stop? stop(String id) => stops[id];
  Trip? trip(String id) => trips[id];
  Situation? situation(String id) => situations[id];

  /// The stops for [ids] that are present, in the order of [ids].
  List<Stop> stopsWithIds(Iterable<String> ids) => [
    for (final id in ids) ?stops[id],
  ];

  /// The situations for [ids] that are present, in the order of [ids].
  List<Situation> situationsWithIds(Iterable<String> ids) => [
    for (final id in ids) ?situations[id],
  ];

  /// A copy with [stop] added (or replacing the stop with its id).
  References withStop(Stop stop) => References(
    agencies: agencies,
    routes: routes,
    stops: {...stops, stop.id: stop},
    trips: trips,
    situations: situations,
  );
}
