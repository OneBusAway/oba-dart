import 'package:onebusaway/onebusaway.dart';

import '../foundation/json.dart';

/// Route data embedded in bookmarks and recent stops, so they render
/// offline.
class StoredRoute {
  const StoredRoute({
    required this.id,
    this.agencyId = '',
    this.shortName,
    this.longName,
    this.description,
    this.type,
    this.color,
    this.textColor,
  });

  factory StoredRoute.fromRoute(Route r) => StoredRoute(
    id: r.id,
    agencyId: r.agencyId,
    shortName: r.shortName,
    longName: r.longName,
    description: r.description,
    type: r.type,
    color: r.color,
    textColor: r.textColor,
  );

  /// Throws [FormatException] without an `id`.
  factory StoredRoute.fromJson(JsonObject j) => StoredRoute(
    id: jString(j, 'id') ?? (throw const FormatException('route id')),
    agencyId: jString(j, 'agencyId') ?? '',
    shortName: jString(j, 'shortName'),
    longName: jString(j, 'longName'),
    description: jString(j, 'description'),
    type: jInt(j, 'type'),
    color: jString(j, 'color'),
    textColor: jString(j, 'textColor'),
  );

  final String id;
  final String agencyId;
  final String? shortName;
  final String? longName;
  final String? description;
  final int? type;
  final String? color;
  final String? textColor;

  RouteType get routeType => RouteType.fromValue(type);

  Route toRoute() => Route(
    id: id,
    agencyId: agencyId,
    shortName: shortName,
    longName: longName,
    description: description,
    type: type,
    color: color,
    textColor: textColor,
  );

  JsonObject toJson() => {
    'id': id,
    'agencyId': agencyId,
    'shortName': ?shortName,
    'longName': ?longName,
    'description': ?description,
    'type': ?type,
    'color': ?color,
    'textColor': ?textColor,
  };

  @override
  bool operator ==(Object other) =>
      other is StoredRoute &&
      other.id == id &&
      other.agencyId == agencyId &&
      other.shortName == shortName &&
      other.longName == longName &&
      other.description == description &&
      other.type == type &&
      other.color == color &&
      other.textColor == textColor;

  @override
  int get hashCode => Object.hash(
    id,
    agencyId,
    shortName,
    longName,
    description,
    type,
    color,
    textColor,
  );
}

/// Stop data embedded in bookmarks and recent stops: enough to render a row
/// and pin offline.
class StoredStop {
  const StoredStop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.code,
    this.direction,
    this.routeIds = const [],
    this.routes = const [],
    this.wheelchairBoarding,
  });

  /// Copies [stop], resolving its routes from [references] when given.
  factory StoredStop.fromStop(Stop stop, {References? references}) =>
      StoredStop(
        id: stop.id,
        name: stop.name,
        lat: stop.lat,
        lon: stop.lon,
        code: stop.code,
        direction: stop.direction,
        routeIds: stop.routeIds,
        wheelchairBoarding: stop.wheelchairBoarding,
        routes: references == null
            ? const []
            : [
                for (final id in stop.routeIds)
                  if (references.route(id) case final r?)
                    StoredRoute.fromRoute(r),
              ],
      );

  /// Throws [FormatException] without `id`, `lat` or `lon`.
  factory StoredStop.fromJson(JsonObject j) => StoredStop(
    id: jString(j, 'id') ?? (throw const FormatException('stop id')),
    name: jString(j, 'name') ?? '',
    lat: jDouble(j, 'lat') ?? (throw const FormatException('stop lat')),
    lon: jDouble(j, 'lon') ?? (throw const FormatException('stop lon')),
    code: jString(j, 'code'),
    direction: jString(j, 'direction'),
    routeIds: jStringList(j, 'routeIds'),
    routes: jObjectList(j, 'routes', StoredRoute.fromJson),
    wheelchairBoarding: jString(j, 'wheelchairBoarding'),
  );

  final String id;
  final String name;
  final double lat;
  final double lon;
  final String? code;

  /// Compass code such as `SW`.
  final String? direction;
  final List<String> routeIds;

  /// Route details, when known (may be empty even if [routeIds] is not).
  final List<StoredRoute> routes;
  final String? wheelchairBoarding;

  Coordinate get coordinate => Coordinate(lat, lon);

  StopDirection get compassDirection => StopDirection.parse(direction);

  Stop toStop() => Stop(
    id: id,
    code: code,
    name: name,
    lat: lat,
    lon: lon,
    direction: direction,
    routeIds: routeIds,
    wheelchairBoarding: wheelchairBoarding,
  );

  JsonObject toJson() => {
    'id': id,
    'name': name,
    'lat': lat,
    'lon': lon,
    'code': ?code,
    'direction': ?direction,
    'routeIds': routeIds,
    'routes': [for (final r in routes) r.toJson()],
    'wheelchairBoarding': ?wheelchairBoarding,
  };

  @override
  bool operator ==(Object other) =>
      other is StoredStop &&
      other.id == id &&
      other.name == name &&
      other.lat == lat &&
      other.lon == lon &&
      other.code == code &&
      other.direction == direction &&
      _eq(other.routeIds, routeIds) &&
      _eq(other.routes, routes) &&
      other.wheelchairBoarding == wheelchairBoarding;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    lat,
    lon,
    code,
    direction,
    Object.hashAll(routeIds),
    Object.hashAll(routes),
    wheelchairBoarding,
  );
}

bool _eq<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
