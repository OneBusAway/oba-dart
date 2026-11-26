import 'dart:convert';

import 'package:onebusaway/onebusaway.dart';
import 'package:test/test.dart';

import 'support/fixtures.dart';

void main() {
  test('decodes the canonical Google example', () {
    final points = Polyline.decode('_p~iF~ps|U_ulLnnqC_mqNvxq`@');
    expect(points, const [
      Coordinate(38.5, -120.2),
      Coordinate(40.7, -120.95),
      Coordinate(43.252, -126.453),
    ]);
  });

  test('encodes the canonical Google example', () {
    expect(
      Polyline.encode(const [
        Coordinate(38.5, -120.2),
        Coordinate(40.7, -120.95),
        Coordinate(43.252, -126.453),
      ]),
      '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
    );
  });

  test('empty input', () {
    expect(Polyline.decode(''), isEmpty);
    expect(Polyline.encode(const []), '');
  });

  test('real shape fixture round trips', () {
    final json = jsonDecode(fixture('shape_1_20010002.json')) as Map;
    final entry = (json['data'] as Map)['entry'] as Map;
    final encoded = entry['points'] as String;
    final points = decodePolyline(encoded);
    expect(points, hasLength(entry['length'] as int));
    for (final p in points) {
      expect(p.lat, inInclusiveRange(47, 48));
      expect(p.lon, inInclusiveRange(-123, -122));
    }
    expect(encodePolyline(points), encoded);
  });

  test('custom precision round trips', () {
    const pts = [Coordinate(1.123456, 2.654321), Coordinate(-3.5, -4.25)];
    final enc = Polyline.encode(pts, precision: 1e6);
    expect(Polyline.decode(enc, precision: 1e6), pts);
  });

  test('truncated or invalid input throws ObaFormatException', () {
    expect(() => Polyline.decode('_p~iF'), throwsA(isA<ObaFormatException>()));
    expect(
      () => Polyline.decode('_p~iF~ps|'),
      throwsA(isA<ObaFormatException>()),
    );
    expect(() => Polyline.decode(' '), throwsA(isA<ObaFormatException>()));
  });
}
