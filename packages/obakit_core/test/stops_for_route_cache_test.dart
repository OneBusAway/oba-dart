import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  late FakeHttp http;
  late OneBusAwayClient client;

  setUp(() {
    http = FakeHttp({
      'stops-for-route': (200, fixture('stops_for_route_1_44.json')),
    });
    client = OneBusAwayClient(
      baseUrl: Uri.parse('https://api.example.com/'),
      apiKey: 'k',
      httpClient: http.client,
    );
  });

  int requestsFor(String id) =>
      http.requests.where((r) => r.url.path.contains('/$id.json')).length;

  test('a route is fetched once; concurrent requests share it', () async {
    final cache = StopsForRouteCache();
    final a = cache.get(client, '1_44');
    final b = cache.get(client, '1_44');
    expect(identical(a, b), isTrue);
    final r = await a;
    expect(r.entry.stopIds, isNotEmpty);
    await cache.get(client, '1_44');
    expect(requestsFor('1_44'), 1);
  });

  test('least recently used routes are dropped beyond capacity', () async {
    final cache = StopsForRouteCache(capacity: 2);
    await cache.get(client, 'a');
    await cache.get(client, 'b');
    await cache.get(client, 'a'); // a is now most recent
    await cache.get(client, 'c'); // drops b
    expect(cache.length, 2);
    await cache.get(client, 'a');
    expect(requestsFor('a'), 1);
    await cache.get(client, 'b');
    expect(requestsFor('b'), 2);
  });

  test('failures are not cached', () async {
    http.routes['stops-for-route'] = (500, 'boom');
    final cache = StopsForRouteCache();
    await expectLater(cache.get(client, 'x'), throwsA(isA<ObaException>()));
    expect(cache.length, 0);
    http.routes['stops-for-route'] = (
      200,
      fixture('stops_for_route_1_44.json'),
    );
    await cache.get(client, 'x');
    expect(requestsFor('x'), 2);
  });

  test('a different client (region change) or clear() empties it', () async {
    final cache = StopsForRouteCache();
    await cache.get(client, 'a');
    final other = OneBusAwayClient(
      baseUrl: Uri.parse('https://other.example.com/'),
      apiKey: 'k',
      httpClient: http.client,
    );
    await cache.get(other, 'a');
    expect(requestsFor('a'), 2);
    cache.clear();
    expect(cache.length, 0);
    await cache.get(other, 'a');
    expect(requestsFor('a'), 3);
  });
}
