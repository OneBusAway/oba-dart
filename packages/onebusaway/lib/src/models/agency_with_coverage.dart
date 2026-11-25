import '../core/json.dart';
import 'coordinate.dart';

/// One entry of `agencies-with-coverage`. Resolve the agency itself with
/// `References.agency(agencyId)`.
class AgencyWithCoverage {
  const AgencyWithCoverage({
    required this.agencyId,
    required this.lat,
    required this.lon,
    required this.latSpan,
    required this.lonSpan,
  });

  factory AgencyWithCoverage.fromJson(JsonMap json) => AgencyWithCoverage(
    agencyId: readString(json, 'agencyId'),
    lat: readDouble(json, 'lat'),
    lon: readDouble(json, 'lon'),
    latSpan: readDouble(json, 'latSpan'),
    lonSpan: readDouble(json, 'lonSpan'),
  );

  final String agencyId;

  /// Center of the coverage area.
  final double lat;
  final double lon;

  /// Height and width of the coverage area, in degrees.
  final double latSpan;
  final double lonSpan;

  Coordinate get center => Coordinate(lat, lon);
}
