import '../core/json.dart';
import 'coordinate.dart';

/// Reads an optional `{"lat": …, "lon": …}` object as a [Coordinate].
Coordinate? readOptCoordinate(JsonMap json, String key) {
  final map = readOptMap(json, key);
  if (map == null) return null;
  return Coordinate(readDouble(map, 'lat'), readDouble(map, 'lon'));
}
