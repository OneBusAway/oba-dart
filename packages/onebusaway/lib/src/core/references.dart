import '../models/agency.dart';
import '../models/route.dart';
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
  });

  factory References.fromJson(JsonMap? json) {
    if (json == null) return empty;
    Map<String, T> index<T>(
      String key,
      T Function(JsonMap) parse,
      String Function(T) id,
    ) =>
        {
          for (final item in readList(
              json, key, (v) => parse(asJsonMap(v, '$key[]'))))
            id(item): item,
        };
    return References(
      agencies: index('agencies', Agency.fromJson, (a) => a.id),
      routes: index('routes', Route.fromJson, (r) => r.id),
      stops: index('stops', Stop.fromJson, (s) => s.id),
      trips: index('trips', Trip.fromJson, (t) => t.id),
    );
  }

  static const References empty = References();

  final Map<String, Agency> agencies;
  final Map<String, Route> routes;
  final Map<String, Stop> stops;
  final Map<String, Trip> trips;

  Agency? agency(String id) => agencies[id];
  Route? route(String id) => routes[id];
  Stop? stop(String id) => stops[id];
  Trip? trip(String id) => trips[id];
}
