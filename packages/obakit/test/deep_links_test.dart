import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'support/oba_test_harness.dart';

void main() {
  late ObaTestEnv env;
  late ObaDeepLinkHandler handler;
  setUp(() async {
    env = await ObaTestEnv.create();
    handler = ObaDeepLinkHandler(env.app.core);
  });
  tearDown(() => env.dispose());

  test('a stop in the current region opens directly', () {
    final a = handler.resolve(Uri.parse('onebusaway://stop?id=1_1121'));
    expect(a, isA<OpenRouteAction>());
    a as OpenRouteAction;
    expect(a.route, const StopRoute('1_1121'));
    expect(a.switchToRegion, isNull);
  });

  test('a stop in another known region switches region', () {
    final a = handler.resolve(
      Uri.parse('https://onebusaway.co/regions/11/stops/MTS_11589'),
    ) as OpenRouteAction;
    expect(a.route, const StopRoute('MTS_11589'));
    expect(a.switchToRegion?.regionName, 'San Diego');
  });

  test('unknown regions are reported', () {
    expect(
      handler.resolve(
        Uri.parse('onebusaway://view-stop?stopID=1&regionID=999'),
      ),
      isA<UnknownRegionAction>(),
    );
  });

  test('trip links open the trip page', () {
    final a = handler.resolve(
      Uri.parse(
        'https://onebusaway.co/regions/1/stops/1_75403/trips'
        '?trip_id=1_604670535&service_date=1700000000&stop_sequence=7',
      ),
    ) as OpenRouteAction;
    final route = a.route as TripRoute;
    expect(route.trip.tripId, '1_604670535');
    expect(route.trip.stopSequence, 7);
    expect(route.trip.stopId, '1_75403');
  });

  test('add-region links open the custom region form', () {
    final a = handler.resolve(
      Uri.parse(
        'onebusaway://add-region?name=Test&oba-url=https://oba.example.org/',
      ),
    ) as OpenRouteAction;
    expect((a.route as CustomRegionRoute).prefill?.name, 'Test');
  });

  test('other links are ignored', () {
    expect(handler.resolve(Uri.parse('https://example.org/')), isNull);
  });
}
