import 'package:onebusaway/onebusaway.dart';
import 'package:test/test.dart';

void main() {
  test('agencyLocalId splits at the first underscore only', () {
    expect(agencyLocalId('1_75403'), '75403');
    expect(agencyLocalId('MTS_24151'), '24151');
    expect(agencyLocalId('KCM_100_A'), '100_A');
    expect(agencyLocalId('plain'), 'plain');
  });

  test('Coordinate.distanceTo is the haversine distance', () {
    const a = Coordinate(47.6, -122.33);
    expect(a.distanceTo(const Coordinate(47.61, -122.33)), closeTo(1112, 2));
    expect(a.distanceTo(a), 0);
  });
}
