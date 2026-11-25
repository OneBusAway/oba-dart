/// A WGS84 latitude/longitude pair in degrees.
class Coordinate {
  const Coordinate(this.lat, this.lon);

  final double lat;
  final double lon;

  @override
  bool operator ==(Object other) =>
      other is Coordinate && other.lat == lat && other.lon == lon;

  @override
  int get hashCode => Object.hash(lat, lon);

  @override
  String toString() => 'Coordinate($lat, $lon)';
}
