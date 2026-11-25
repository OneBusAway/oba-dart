import '../core/json.dart';

/// Reads a list of `{"points": "<encoded polyline>", …}` as the encoded
/// strings.
List<String> _readPolylines(JsonMap json, String key) =>
    readObjectList(json, key, (p) => readString(p, 'points'));

/// Entry of `stops-for-route/{id}`.
class StopsForRoute {
  const StopsForRoute({
    required this.routeId,
    this.stopIds = const [],
    this.polylines = const [],
    this.stopGroupings = const [],
  });

  factory StopsForRoute.fromJson(JsonMap json) => StopsForRoute(
    routeId: readString(json, 'routeId'),
    stopIds: readStringList(json, 'stopIds'),
    polylines: _readPolylines(json, 'polylines'),
    stopGroupings: readObjectList(json, 'stopGroupings', StopGrouping.fromJson),
  );

  final String routeId;

  /// Every stop on the route; resolve with `References.stopsWithIds`.
  final List<String> stopIds;

  /// Encoded (Google polyline algorithm) shapes of the route.
  final List<String> polylines;
  final List<StopGrouping> stopGroupings;
}

class StopGrouping {
  const StopGrouping({
    this.ordered = false,
    this.type,
    this.stopGroups = const [],
  });

  factory StopGrouping.fromJson(JsonMap json) => StopGrouping(
    ordered: readBool(json, 'ordered'),
    type: readOptString(json, 'type'),
    stopGroups: readObjectList(json, 'stopGroups', StopGroup.fromJson),
  );

  final bool ordered;

  /// e.g. `direction`.
  final String? type;
  final List<StopGroup> stopGroups;
}

/// Usually one direction of the route.
class StopGroup {
  const StopGroup({
    required this.id,
    this.name,
    this.nameType,
    this.names = const [],
    this.stopIds = const [],
    this.polylines = const [],
  });

  factory StopGroup.fromJson(JsonMap json) {
    final name = readOptMap(json, 'name');
    return StopGroup(
      id: readString(json, 'id'),
      name: name == null ? null : readOptString(name, 'name'),
      nameType: name == null ? null : readOptString(name, 'type'),
      names: name == null ? const [] : readStringList(name, 'names'),
      stopIds: readStringList(json, 'stopIds'),
      polylines: _readPolylines(json, 'polylines'),
    );
  }

  final String id;

  /// e.g. the destination headsign.
  final String? name;

  /// e.g. `destination`.
  final String? nameType;
  final List<String> names;

  /// Stops in travel order.
  final List<String> stopIds;
  final List<String> polylines;
}
