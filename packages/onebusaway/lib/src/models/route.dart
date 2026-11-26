import '../core/json.dart';

/// GTFS `route_type`. Values the app doesn't know become [unknown].
enum RouteType {
  lightRail(0),
  subway(1),
  rail(2),
  bus(3),
  ferry(4),
  cableCar(5),
  gondola(6),
  funicular(7),
  unknown(999);

  const RouteType(this.value);

  /// The GTFS wire value.
  final int value;

  static RouteType fromValue(int? value) => RouteType.values.firstWhere(
    (t) => t.value == value,
    orElse: () => RouteType.unknown,
  );
}

class Route {
  const Route({
    required this.id,
    required this.agencyId,
    this.shortName,
    this.longName,
    this.description,
    this.type,
    this.color,
    this.textColor,
    this.url,
  });

  factory Route.fromJson(JsonMap json) => Route(
    id: readString(json, 'id'),
    agencyId: readString(json, 'agencyId'),
    shortName: readOptString(json, 'shortName'),
    longName: readOptString(json, 'longName'),
    description: readOptString(json, 'description'),
    type: readOptInt(json, 'type'),
    color: readOptString(json, 'color'),
    textColor: readOptString(json, 'textColor'),
    url: readOptString(json, 'url'),
  );

  final String id;
  final String agencyId;
  final String? shortName;
  final String? longName;
  final String? description;

  /// GTFS route_type (3 = bus). See [routeType] for the typed value.
  final int? type;

  /// GTFS hex color without `#`, possibly lowercase, e.g. `ffcd00`.
  final String? color;
  final String? textColor;
  final String? url;

  /// [type] as a [RouteType]; missing or unrecognized values are
  /// [RouteType.unknown].
  RouteType get routeType => RouteType.fromValue(type);
}
