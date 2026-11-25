import '../core/errors.dart';
import '../core/json.dart';
import 'coordinate.dart';

/// GTFS `location_type` of a stop.
enum StopLocationType {
  stop(0),
  station(1),
  stationEntrance(2),
  unknown(-1);

  const StopLocationType(this.value);

  final int value;

  static StopLocationType fromValue(int? value) => StopLocationType.values
      .firstWhere((t) => t.value == value, orElse: () => unknown);
}

enum WheelchairBoarding {
  accessible,
  notAccessible,
  unknown;

  /// Parses OBA's wire value. Servers send `ACCESSIBLE`, `NOT_ACCESSIBLE`,
  /// `UNKNOWN` or null; camelCase spellings are accepted too.
  static WheelchairBoarding parse(String? value) =>
      switch (value?.toUpperCase().replaceAll('_', '')) {
        'ACCESSIBLE' => accessible,
        'NOTACCESSIBLE' => notAccessible,
        _ => unknown,
      };
}

/// The eight compass points a stop's `direction` can name.
enum StopDirection {
  n,
  ne,
  e,
  se,
  s,
  sw,
  w,
  nw,
  unknown;

  static StopDirection parse(String? value) => StopDirection.values.firstWhere(
    (d) => d != unknown && d.name == value?.toLowerCase(),
    orElse: () => unknown,
  );
}

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
    this.locationType = StopLocationType.stop,
    this.parent,
  });

  factory Stop.fromJson(JsonMap json) => Stop(
    id: readString(json, 'id'),
    code: readOptString(json, 'code'),
    name: readString(json, 'name'),
    lat:
        readOptDouble(json, 'lat') ??
        (throw const ObaFormatException('Missing "lat"')),
    lon:
        readOptDouble(json, 'lon') ??
        (throw const ObaFormatException('Missing "lon"')),
    direction: readOptString(json, 'direction'),
    routeIds: readStringList(json, 'routeIds'),
    wheelchairBoarding: readOptString(json, 'wheelchairBoarding'),
    locationType: json['locationType'] == null
        ? StopLocationType.stop
        : StopLocationType.fromValue(readInt(json, 'locationType')),
    parent: readOptString(json, 'parent'),
  );

  final String id;

  /// Rider-facing stop number, e.g. `24151`.
  final String? code;
  final String name;
  final double lat;
  final double lon;

  /// Compass direction code such as `SW`, or null. See [compassDirection].
  final String? direction;
  final List<String> routeIds;

  /// Raw wire value, e.g. `UNKNOWN`. See [wheelchairBoardingStatus].
  final String? wheelchairBoarding;
  final StopLocationType locationType;

  /// The id of the parent station, when the server sends one.
  final String? parent;

  Coordinate get coordinate => Coordinate(lat, lon);

  StopDirection get compassDirection => StopDirection.parse(direction);

  WheelchairBoarding get wheelchairBoardingStatus =>
      WheelchairBoarding.parse(wheelchairBoarding);
}
