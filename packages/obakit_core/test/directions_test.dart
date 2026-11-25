import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

void main() {
  const c = Coordinate(47.6, -122.3);

  test('provider mapping', () {
    expect(directionsAppFor(WalkingDirectionsProvider.askEveryTime), isNull);
    expect(
      directionsAppFor(WalkingDirectionsProvider.googleMaps),
      DirectionsApp.googleMaps,
    );
  });

  test('apple maps walking link', () {
    final u = walkingDirectionsUrl(DirectionsApp.appleMaps, c);
    expect(u.host, 'maps.apple.com');
    expect(u.queryParameters, {'daddr': '47.6,-122.3', 'dirflg': 'w'});
  });

  test('google maps bike link', () {
    final u = walkingDirectionsUrl(DirectionsApp.googleMaps, c, bike: true);
    expect(u.toString(), startsWith('https://www.google.com/maps/dir/'));
    expect(u.queryParameters['travelmode'], 'bicycling');
    expect(u.queryParameters['destination'], '47.6,-122.3');
  });
}
