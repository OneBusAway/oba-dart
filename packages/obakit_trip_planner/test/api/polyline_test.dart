import 'package:flutter_test/flutter_test.dart';
import 'package:obakit_trip_planner/src/api/polyline.dart';

void main() {
  test('decodes the Google reference polyline', () {
    // https://developers.google.com/maps/documentation/utilities/polylinealgorithm
    final points = decodePolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@');
    expect(points, hasLength(3));
    expect(points[0].lat, closeTo(38.5, 1e-9));
    expect(points[0].lon, closeTo(-120.2, 1e-9));
    expect(points[1].lat, closeTo(40.7, 1e-9));
    expect(points[1].lon, closeTo(-120.95, 1e-9));
    expect(points[2].lat, closeTo(43.252, 1e-9));
    expect(points[2].lon, closeTo(-126.453, 1e-9));
  });

  test('empty and truncated input', () {
    expect(decodePolyline(''), isEmpty);
    // A complete first point followed by a dangling latitude chunk.
    expect(decodePolyline('_p~iF~ps|U_'), hasLength(1));
    // Characters outside the encoding alphabet stop decoding.
    expect(decodePolyline('_p~iF~ps|U\u0001\u0001'), hasLength(1));
  });
}
