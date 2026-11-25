import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;
import 'package:shared_preferences/shared_preferences.dart';

class _FakeGeolocatorApi extends GeolocatorApi {
  /// Thrown by every permission call, like geolocator's
  /// `PermissionDefinitionsNotFoundException` in a host whose manifest
  /// declares no location permission.
  Object? permissionError;
  bool serviceEnabled = true;
  LocationPermission permission = LocationPermission.denied;
  LocationPermission afterRequest = LocationPermission.whileInUse;
  Position? last;
  final StreamController<Position> controller = StreamController.broadcast();
  int streamStarts = 0;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;
  @override
  Future<LocationPermission> checkPermission() async =>
      permissionError == null ? permission : throw permissionError!;
  @override
  Future<LocationPermission> requestPermission() async =>
      permissionError == null
      ? permission = afterRequest
      : throw permissionError!;
  @override
  Future<Position?> getLastKnownPosition() async => last;
  @override
  Future<Position> getCurrentPosition(LocationSettings settings) async =>
      last ?? (throw StateError('no fix'));
  @override
  Stream<Position> getPositionStream(LocationSettings settings) {
    streamStarts++;
    return controller.stream;
  }
}

Position _pos(double lat, double lon, {double heading = -1}) => Position(
  latitude: lat,
  longitude: lon,
  timestamp: DateTime.utc(2026),
  accuracy: 12,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: heading,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

class _CountingNotifier extends ObaChangeNotifier {
  void ping() => notifyListeners();
}

void main() {
  group('SharedPreferencesKeyValueStore', () {
    test('reads mock values synchronously after load', () async {
      SharedPreferences.setMockInitialValues({
        'oba.a': '"x"',
        'host.key': 'not ours',
        'oba.number': 3,
      });
      final store = await SharedPreferencesKeyValueStore.create();
      expect(store.getString('oba.a'), '"x"');
      expect(store.getString('oba.number'), isNull, reason: 'not a string');
      expect(store.keys, unorderedEquals(['oba.a', 'oba.number']));
    });

    test('writes are visible at once and persist', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await SharedPreferencesKeyValueStore.create();
      final write = store.setString('oba.k', 'v');
      expect(store.getString('oba.k'), 'v');
      await write;
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('oba.k'), 'v');
      await store.remove('oba.k');
      expect(store.getString('oba.k'), isNull);
    });

    test('backs obakit_core stores', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await SharedPreferencesKeyValueStore.create();
      final settings = ObaSettings(store)..mapType = MapType.hybrid;
      expect(ObaSettings(store).mapType, MapType.hybrid);
      settings.dispose();
    });

    test('throws before load', () {
      final store = SharedPreferencesKeyValueStore();
      expect(() => store.getString('oba.x'), throwsStateError);
    });
  });

  group('GeolocatorLocationProvider', () {
    test('maps permissions and service state', () async {
      final api = _FakeGeolocatorApi();
      final provider = GeolocatorLocationProvider(api: api);
      // Never asked: geolocator says denied, which means "may ask".
      expect(
        await provider.checkPermission(),
        LocationPermissionStatus.notDetermined,
      );
      api.afterRequest = LocationPermission.denied;
      expect(
        await provider.requestPermission(),
        LocationPermissionStatus.denied,
      );
      expect(await provider.checkPermission(), LocationPermissionStatus.denied);
      api.permission = LocationPermission.deniedForever;
      expect(
        await provider.checkPermission(),
        LocationPermissionStatus.deniedForever,
      );
      api.serviceEnabled = false;
      expect(
        await provider.checkPermission(),
        LocationPermissionStatus.serviceDisabled,
      );
      expect(
        await provider.requestPermission(),
        LocationPermissionStatus.serviceDisabled,
      );
      api.serviceEnabled = true;
      api.afterRequest = LocationPermission.whileInUse;
      expect(
        await provider.requestPermission(),
        LocationPermissionStatus.whileInUse,
      );
    });

    test('a host without location permissions reads as denied', () async {
      final api = _FakeGeolocatorApi()
        ..permissionError = const PermissionDefinitionsNotFoundException(
          'No location permissions are defined in the manifest.',
        );
      final provider = GeolocatorLocationProvider(api: api);
      expect(await provider.checkPermission(), LocationPermissionStatus.denied);
      expect(
        await provider.requestPermission(),
        LocationPermissionStatus.denied,
      );
      // So the application still starts (start() checks permission).
      final app = ObaCoreApplication(
        ObaAppConfig(
          appName: 'Host',
          apiKey: 'test',
          appVersion: '1.0.0',
          bundledRegionsJson: '',
          regionsPath: null,
          keyValueStore: InMemoryKeyValueStore(),
          locationProvider: provider,
          httpClient: MockClient((_) async => http.Response('', 404)),
        ),
      );
      await app.start();
      expect(app.locationPermission, LocationPermissionStatus.denied);
      app.dispose();
    });

    test('never touches the GPS until listened to', () async {
      final api = _FakeGeolocatorApi()..permission = LocationPermission.always;
      final provider = GeolocatorLocationProvider(api: api);
      expect(api.streamStarts, 0);
      final got = <ObaLocation>[];
      final sub = provider.positionStream.listen(got.add);
      expect(api.streamStarts, 1);
      api.controller.add(_pos(47.6, -122.3, heading: 90));
      api.controller.add(_pos(47.7, -122.3));
      await Future<void>.delayed(Duration.zero);
      expect(got.map((l) => l.lat), [47.6, 47.7]);
      expect(got.first.heading, 90);
      expect(got.last.heading, isNull, reason: 'negative heading is unknown');
      expect(provider.lastKnownLocation?.lat, 47.7);
      await sub.cancel();
    });

    test('warmUp seeds the last fix only when permitted', () async {
      final api = _FakeGeolocatorApi()..last = _pos(1, 2);
      final provider = GeolocatorLocationProvider(api: api);
      await provider.warmUp();
      expect(provider.lastKnownLocation, isNull);
      api.permission = LocationPermission.whileInUse;
      await provider.warmUp();
      expect(provider.lastKnownLocation?.lon, 2);
      expect((await provider.currentPosition())?.lat, 1);
    });
  });

  group('ObaListenableAdapter', () {
    test('forwards listeners and compares by source', () {
      final source = _CountingNotifier();
      final adapter = ObaListenableAdapter(source);
      var calls = 0;
      void listener() => calls++;
      adapter.addListener(listener);
      source.ping();
      adapter.removeListener(listener);
      source.ping();
      expect(calls, 1);
      expect(ObaListenableAdapter(source), adapter);
      expect(source.listenable, adapter);
    });

    test('value listenable exposes the value', () {
      final v = ObaValueNotifier(1);
      final ValueListenable<int> adapter = v.valueListenable;
      var seen = 0;
      adapter.addListener(() => seen = adapter.value);
      v.value = 5;
      expect(seen, 5);
    });
  });

  group('NominatimPlaceSearch', () {
    const body =
        '[{"place_id":1,"lat":"47.61","lon":"-122.33","name":"Pike Place Market",'
        '"display_name":"Pike Place Market, 85 Pike St, Seattle, WA"},'
        '{"place_id":2,"lat":"bad","lon":"0","display_name":"skip"}]';

    test('builds a bounded request with the user agent', () async {
      final requests = <http.Request>[];
      final search = NominatimPlaceSearch(
        userAgent: 'OBA-test/1.0',
        minInterval: Duration.zero,
        httpClient: MockClient((r) async {
          requests.add(r);
          return http.Response.bytes(utf8.encode(body), 200);
        }),
      );
      final places = await search.search(
        ' pike ',
        within: const RegionRect(
          minLat: 47,
          maxLat: 48,
          minLon: -123,
          maxLon: -122,
        ),
      );
      expect(places, hasLength(1));
      expect(places.single.name, 'Pike Place Market');
      expect(places.single.subtitle, '85 Pike St, Seattle, WA');
      expect(places.single.coordinate, const Coordinate(47.61, -122.33));
      final r = requests.single;
      expect(r.headers['User-Agent'], 'OBA-test/1.0');
      expect(r.url.queryParameters['q'], 'pike');
      expect(r.url.queryParameters['viewbox'], '-123.0,48.0,-122.0,47.0');
      expect(r.url.queryParameters['bounded'], '1');
    });

    test('runs one request at a time and drops superseded queries', () async {
      final completers = <Completer<http.Response>>[];
      final queries = <String>[];
      final search = NominatimPlaceSearch(
        userAgent: 'ua',
        minInterval: Duration.zero,
        httpClient: MockClient((r) {
          queries.add(r.url.queryParameters['q']!);
          final c = Completer<http.Response>();
          completers.add(c);
          return c.future;
        }),
      );
      final a = search.search('a');
      await Future<void>.delayed(Duration.zero);
      final b = search.search('b');
      final c = search.search('c');
      await Future<void>.delayed(Duration.zero);
      expect(queries, ['a'], reason: 'only one in flight');
      completers.single.complete(http.Response('[]', 200));
      expect(await a, isEmpty);
      expect(await b, isEmpty, reason: 'superseded by c');
      await Future<void>.delayed(Duration.zero);
      expect(queries, ['a', 'c']);
      completers.last.complete(http.Response(body, 200));
      expect(await c, hasLength(1));
    });

    test('surfaces HTTP errors', () async {
      final search = NominatimPlaceSearch(
        userAgent: 'ua',
        minInterval: Duration.zero,
        httpClient: MockClient((_) async => http.Response('', 429)),
      );
      expect(search.search('x'), throwsA(isA<PlaceSearchException>()));
    });
  });

  test('PlaceSearchTripBridge maps places and passes the region', () async {
    RegionRect? within;
    Coordinate? near;
    final bridge = PlaceSearchTripBridge(
      _FakePlaces((q, n, w) {
        near = n;
        within = w;
        return [
          const Place(
            name: 'Home',
            subtitle: 'Street',
            coordinate: Coordinate(1, 2),
          ),
        ];
      }),
      region: () =>
          const RegionRect(minLat: 0, maxLat: 2, minLon: 0, maxLon: 3),
    );
    final results = await bridge.search(
      'home',
      near: const tp.TripPlace(name: 'x', lat: 5, lon: 6),
    );
    expect(results.single.name, 'Home');
    expect(results.single.subtitle, 'Street');
    expect(results.single.lat, 1);
    expect(near, const Coordinate(5, 6));
    expect(within?.maxLon, 3);
  });
}

class _FakePlaces implements PlaceSearchProvider {
  _FakePlaces(this.fn);
  final List<Place> Function(String, Coordinate?, RegionRect?) fn;

  @override
  Future<List<Place>> search(
    String query, {
    Coordinate? near,
    RegionRect? within,
  }) async => fn(query, near, within);
}
