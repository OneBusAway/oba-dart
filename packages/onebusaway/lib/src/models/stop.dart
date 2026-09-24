import '../core/json.dart';

class Stop {
  const Stop({
    required this.id,
    this.code,
    required this.name,
    required this.lat,
    required this.lon,
    this.direction,
    this.routeIds = const [],
    this.wheelchairBoarding,
  });

  factory Stop.fromJson(JsonMap json) => Stop(
        id: readString(json, 'id'),
        code: readOptString(json, 'code'),
        name: readString(json, 'name'),
        lat: readOptDouble(json, 'lat') ?? 0,
        lon: readOptDouble(json, 'lon') ?? 0,
        direction: readOptString(json, 'direction'),
        routeIds: readStringList(json, 'routeIds'),
        wheelchairBoarding: readOptString(json, 'wheelchairBoarding'),
      );

  final String id;

  /// Rider-facing stop number, e.g. `24151`.
  final String? code;
  final String name;
  final double lat;
  final double lon;

  /// Compass direction code such as `SW`, or null.
  final String? direction;
  final List<String> routeIds;
  final String? wheelchairBoarding;
}
