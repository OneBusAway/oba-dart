import 'dart:math' as math;

/// A WGS84 latitude/longitude pair in degrees.
class Coordinate {
  const Coordinate(this.lat, this.lon);

  final double lat;
  final double lon;

  /// Mean Earth radius in metres (IUGG).
  static const double earthRadiusMeters = 6371008.8;

  /// Great-circle (haversine) distance to [other], in metres.
  double distanceTo(Coordinate other) {
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(other.lat - lat);
    final dLon = rad(other.lon - lon);
    final h =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(lat)) *
            math.cos(rad(other.lat)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * earthRadiusMeters * math.asin(math.min(1, math.sqrt(h)));
  }

  @override
  bool operator ==(Object other) =>
      other is Coordinate && other.lat == lat && other.lon == lon;

  @override
  int get hashCode => Object.hash(lat, lon);

  @override
  String toString() => 'Coordinate($lat, $lon)';
}
