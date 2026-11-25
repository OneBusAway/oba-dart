/// A latitude/longitude pair in degrees. Kept free of map-library types so
/// the API layer stays pure Dart.
typedef GeoPoint = ({double lat, double lon});

/// Decodes a Google encoded polyline (precision 5, the encoding OTP uses for
/// `legGeometry.points`). A truncated or malformed string yields the points
/// decoded before the damage rather than throwing.
List<GeoPoint> decodePolyline(String encoded) {
  final points = <GeoPoint>[];
  var index = 0;
  var lat = 0;
  var lon = 0;

  // Returns null when the string ends mid-value.
  int? nextValue() {
    var result = 0;
    var shift = 0;
    while (index < encoded.length) {
      final byte = encoded.codeUnitAt(index++) - 63;
      if (byte < 0 || byte > 0x3f) return null;
      result |= (byte & 0x1f) << shift;
      shift += 5;
      if (byte < 0x20) {
        return (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      }
      if (shift > 30) return null;
    }
    return null;
  }

  while (index < encoded.length) {
    final dLat = nextValue();
    final dLon = nextValue();
    if (dLat == null || dLon == null) break;
    lat += dLat;
    lon += dLon;
    points.add((lat: lat / 1e5, lon: lon / 1e5));
  }
  return points;
}
