import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit/src/features/map/stops_loader.dart';

import 'support/oba_test_harness.dart';

RegionRect _box(double lat, double lon, double span) => RegionRect(
  minLat: lat - span / 2,
  maxLat: lat + span / 2,
  minLon: lon - span / 2,
  maxLon: lon + span / 2,
);

Stop _stop(String id, double lat, double lon) =>
    Stop(id: id, name: 'Stop $id', lat: lat, lon: lon);

void main() {
  group('zoom threshold', () {
    test('matches the iOS map-rect height rule', () {
      // ~0.01 degrees tall at Seattle is street level: well under 40,000
      // map points.
      expect(
        ObaMapLogic.visibleMapRectHeight(_box(47.6, -122.3, 0.01)),
        lessThan(40000),
      );
      expect(ObaMapLogic.shouldLoadStops(_box(47.6, -122.3, 0.01)), isTrue);
      // Half a degree tall is a whole city: stops are hidden.
      expect(ObaMapLogic.shouldLoadStops(_box(47.6, -122.3, 0.5)), isFalse);
      expect(ObaMapLogic.stopsRequestFor(_box(47.6, -122.3, 0.5)), isNull);
    });

    test('the boundary sits at 40,000 map points', () {
      // At the equator 1 degree of latitude is ~ 2^28 / 360 map points.
      const pointsPerDegree = ObaMapLogic.mapKitWorldSize / 360;
      final justIn = 39000 / pointsPerDegree;
      final justOut = 41000 / pointsPerDegree;
      expect(ObaMapLogic.shouldLoadStops(_box(0, 0, justIn)), isTrue);
      expect(ObaMapLogic.shouldLoadStops(_box(0, 0, justOut)), isFalse);
    });
  });

  group('bounds to request', () {
    test('uses the centre and spans', () {
      final r = ObaMapLogic.stopsRequestFor(_box(47.6, -122.3, 0.01))!;
      expect(r.center.lat, closeTo(47.6, 1e-9));
      expect(r.latSpan, closeTo(0.01, 1e-9));
      expect(r.lonSpan, closeTo(0.01, 1e-9));
    });

    test('a contained, similar viewport is covered; zooming far in is not', () {
      final previous = ObaMapLogic.stopsRequestFor(_box(47.6, -122.3, 0.02))!;
      expect(
        ObaMapLogic.requestCovers(previous, _box(47.601, -122.3, 0.015)),
        isTrue,
      );
      expect(
        ObaMapLogic.requestCovers(previous, _box(47.6, -122.3, 0.005)),
        isFalse,
      );
      expect(
        ObaMapLogic.requestCovers(previous, _box(47.62, -122.3, 0.02)),
        isFalse,
      );
    });

    test('caps markers, nearest first', () {
      final stops = [
        for (var i = 0; i < 10; i++) _stop('$i', 47.6 + i * 0.001, -122.3),
      ];
      final capped = ObaMapLogic.capStops(
        stops.reversed,
        center: const Coordinate(47.6, -122.3),
        max: 3,
      );
      expect(capped.map((s) => s.id), ['0', '1', '2']);
      // Under the cap the order is still nearest first.
      final all = ObaMapLogic.capStops(
        stops.reversed,
        center: const Coordinate(47.6, -122.3),
        max: 1000,
      );
      expect(all.first.id, '0');
    });

    test('boundsOf', () {
      expect(ObaMapLogic.boundsOf(const []), isNull);
      final b = ObaMapLogic.boundsOf(const [
        Coordinate(1, 5),
        Coordinate(-2, 3),
      ])!;
      expect([b.minLat, b.maxLat, b.minLon, b.maxLon], [-2, 1, 3, 5]);
    });
  });

  group('marker diffing', () {
    test('the cache rebuilds only changed markers', () {
      final cache = StopMarkerCache<String>();
      final a = _stop('a', 1, 1);
      final b = _stop('b', 2, 2);
      StopMarkerSpec spec(Stop s, {bool selected = false}) => StopMarkerSpec(
        stop: s,
        routeType: RouteType.bus,
        isSelected: selected,
      );
      var out = cache.update([spec(a), spec(b)], (s) => 'm-${s.id}');
      expect(out, ['m-a', 'm-b']);
      expect(cache.buildCount, 2);
      out = cache.update([spec(a), spec(b)], (s) => 'new-${s.id}');
      expect(out, ['m-a', 'm-b'], reason: 'unchanged specs are reused');
      expect(cache.buildCount, 2);
      out = cache.update([
        spec(a, selected: true),
        spec(b),
      ], (s) => 'sel-${s.id}');
      expect(out, ['sel-a', 'm-b']);
      expect(cache.buildCount, 3);
      out = cache.update([spec(b)], (s) => 'x');
      expect(out, ['m-b']);
      out = cache.update([spec(a, selected: true)], (s) => 'again-${s.id}');
      expect(out, ['again-a'], reason: 'removed entries are forgotten');
    });
  });

  group('StopsLoader', () {
    late List<Uri> calls;
    late StopsLoader loader;

    setUp(() {
      calls = [];
      final client = OneBusAwayClient(
        baseUrl: Uri.parse('https://api.example.org/'),
        apiKey: 'k',
        httpClient: MockClient((r) async {
          calls.add(r.url);
          return http.Response(fixture('stops_for_location_query.json'), 200);
        }),
      );
      loader = StopsLoader(client: () => client);
    });

    tearDown(() => loader.dispose());

    test('just under the zoom threshold: loads (no crash)', () async {
      // The largest box that still loads; 15% more would not.
      var lo = 0.001, hi = 1.0;
      for (var i = 0; i < 40; i++) {
        final mid = (lo + hi) / 2;
        if (ObaMapLogic.shouldLoadStops(_box(47.16, -122.5, mid))) {
          lo = mid;
        } else {
          hi = mid;
        }
      }
      await loader.onCameraIdle(_box(47.16, -122.5, lo));
      expect(loader.isZoomedOut, isFalse);
      expect(calls, hasLength(1));
    });

    test('zoomed out: no request, flagged', () async {
      await loader.onCameraIdle(_box(47.16, -122.5, 1));
      expect(loader.isZoomedOut, isTrue);
      expect(calls, isEmpty);
      expect(loader.stops, isEmpty);
    });

    test('loads stops and route references, then reuses the cache', () async {
      await loader.onCameraIdle(_box(47.159439, -122.505051, 0.01));
      expect(calls, hasLength(1));
      expect(calls.single.path, contains('stops-for-location'));
      expect(loader.stops.single.name, '108th / Bridgeport');
      expect(loader.routeTypesFor(loader.stops.single), isNotEmpty);
      await loader.onCameraIdle(_box(47.1595, -122.505051, 0.01));
      expect(calls, hasLength(1), reason: 'covered by the last request');
      loader.reset();
      expect(loader.stops, isEmpty);
    });

    test('routes are trimmed with the stop cache; no copy per read', () async {
      final client = OneBusAwayClient(
        baseUrl: Uri.parse('https://api.example.org/'),
        apiKey: 'k',
        httpClient: MockClient(
          (r) async =>
              http.Response(fixture('stops_for_location_seattle.json'), 200),
        ),
      );
      final small = StopsLoader(client: () => client, maxCached: 1);
      addTearDown(small.dispose);
      await small.onCameraIdle(_box(47.6495, -122.3038, 0.01));
      // 26 stops and 34 routes arrived; only the newest stop (one route)
      // is kept, and with it only its route.
      expect(small.routes.keys, ['98_869-28']);
      expect(identical(small.routes, small.routes), isTrue);
      expect(() => small.routes.clear(), throwsUnsupportedError);
    });
  });
}
