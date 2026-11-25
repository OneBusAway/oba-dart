import '../models/coordinate.dart';
import 'errors.dart';

/// Google encoded polyline codec (default precision 1e5).
class Polyline {
  const Polyline._();

  /// Decodes [encoded] into coordinates. Throws [ObaFormatException] when the
  /// string is truncated or contains characters outside the polyline alphabet.
  static List<Coordinate> decode(String encoded, {double precision = 1e5}) {
    final units = encoded.codeUnits;
    final out = <Coordinate>[];
    var pos = 0;
    var lat = 0;
    var lon = 0;

    int next() {
      var result = 0;
      var shift = 0;
      while (true) {
        if (pos >= units.length) {
          throw const ObaFormatException('Truncated encoded polyline');
        }
        final b = units[pos++] - 63;
        if (b < 0 || b > 63) {
          throw const ObaFormatException(
            'Invalid character in encoded polyline',
          );
        }
        result |= (b & 0x1F) << shift;
        shift += 5;
        if (b < 0x20) break;
        if (shift > 60) {
          throw const ObaFormatException('Encoded polyline value too long');
        }
      }
      return (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    }

    while (pos < units.length) {
      lat += next();
      lon += next();
      out.add(Coordinate(lat / precision, lon / precision));
    }
    return out;
  }

  /// Encodes [coordinates] as an encoded polyline.
  static String encode(
    Iterable<Coordinate> coordinates, {
    double precision = 1e5,
  }) {
    final buf = StringBuffer();
    var prevLat = 0;
    var prevLon = 0;

    void put(int value) {
      var v = value < 0 ? ~(value << 1) : (value << 1);
      while (v >= 0x20) {
        buf.writeCharCode(((v & 0x1F) | 0x20) + 63);
        v >>= 5;
      }
      buf.writeCharCode(v + 63);
    }

    for (final c in coordinates) {
      final lat = (c.lat * precision).round();
      final lon = (c.lon * precision).round();
      put(lat - prevLat);
      put(lon - prevLon);
      prevLat = lat;
      prevLon = lon;
    }
    return buf.toString();
  }
}

/// Decodes a Google encoded polyline. See [Polyline.decode].
List<Coordinate> decodePolyline(String encoded, {double precision = 1e5}) =>
    Polyline.decode(encoded, precision: precision);

/// Encodes coordinates as a Google polyline. See [Polyline.encode].
String encodePolyline(
  Iterable<Coordinate> coordinates, {
  double precision = 1e5,
}) => Polyline.encode(coordinates, precision: precision);
