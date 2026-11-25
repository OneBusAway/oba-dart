import 'package:obakit_core/obakit_core.dart';
import 'package:obakit_core/src/foundation/uuid.dart';
import 'package:obakit_core/src/geo/distance.dart';
import 'package:test/test.dart';

void main() {
  group('ObaChangeNotifier', () {
    test('notifies listeners in order and stops after removal', () {
      final n = ObaChangeNotifier();
      final calls = <String>[];
      void a() => calls.add('a');
      void b() => calls.add('b');
      n
        ..addListener(a)
        ..addListener(b)
        ..notifyListeners();
      n
        ..removeListener(a)
        ..notifyListeners();
      expect(calls, ['a', 'b', 'b']);
    });

    test('a throwing listener does not stop the others', () {
      final errors = <Object>[];
      final saved = ObaChangeNotifier.onListenerError;
      ObaChangeNotifier.onListenerError = (e, _) => errors.add(e);
      addTearDown(() => ObaChangeNotifier.onListenerError = saved);
      final n = ObaChangeNotifier();
      var called = false;
      n
        ..addListener(() => throw StateError('boom'))
        ..addListener(() => called = true)
        ..notifyListeners();
      expect(called, isTrue);
      expect(errors.single, isA<StateError>());
    });

    test('a listener removed during notification is not called', () {
      final n = ObaChangeNotifier();
      var bCalled = false;
      void b() => bCalled = true;
      n
        ..addListener(() => n.removeListener(b))
        ..addListener(b)
        ..notifyListeners();
      expect(bCalled, isFalse);
    });

    test('dispose drops listeners', () {
      final n = ObaChangeNotifier();
      var count = 0;
      n.addListener(() => count++);
      n.dispose();
      n.notifyListeners();
      expect(count, 0);
      expect(n.isDisposed, isTrue);
    });
  });

  test('ObaValueNotifier notifies only on change', () {
    final v = ObaValueNotifier(1);
    var count = 0;
    v.addListener(() => count++);
    v.value = 1;
    v.value = 2;
    expect(count, 1);
    expect(v.value, 2);
  });

  test('generateUuid is a v4 UUID and unique', () {
    final a = generateUuid();
    expect(
      a,
      matches(
        RegExp(
          r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$',
        ),
      ),
    );
    expect(generateUuid(), isNot(a));
  });

  group('KeyValueStoreJson', () {
    test('round-trips JSON values and tolerates garbage', () {
      final s = InMemoryKeyValueStore({'bad': '{nope'});
      s.writeJson('n', 3);
      s.writeJson('l', [1, 'a']);
      s.writeJson('m', {'x': true});
      expect(s.readInt('n'), 3);
      expect(s.readDouble('n'), 3.0);
      expect(s.readList('l'), [1, 'a']);
      expect(s.readMap('m'), {'x': true});
      expect(s.readJson('bad'), isNull);
      expect(s.readList('bad'), isEmpty);
      expect(s.readBool('n'), isNull);
      s.writeJson('n', null);
      expect(s.keys, isNot(contains('n')));
    });
  });

  group('FakeLocationProvider', () {
    test('withholds positions until permission is granted', () async {
      final p = FakeLocationProvider(
        location: ObaLocation(lat: 1, lon: 2, timestamp: DateTime.utc(2024)),
      );
      expect(await p.currentPosition(), isNull);
      expect(await p.requestPermission(), LocationPermissionStatus.whileInUse);
      expect((await p.currentPosition())!.lat, 1);
      final got = <ObaLocation>[];
      p.positionStream.listen(got.add);
      p.setLocation(ObaLocation(lat: 3, lon: 4, timestamp: DateTime.utc(2024)));
      expect(got.single.coordinate, const Coordinate(3, 4));
    });
  });

  group('distance', () {
    test('haversine matches a known distance', () {
      // Seattle Space Needle to Pike Place Market: about 1.44 km.
      final d = distanceBetween(
        const Coordinate(47.6205, -122.3493),
        const Coordinate(47.6097, -122.3422),
      );
      expect(d, closeTo(1310, 30));
      expect(
        distanceBetween(const Coordinate(0, 0), const Coordinate(0, 0)),
        0,
      );
    });

    test('nearestStops sorts nearest first and honours the limit', () {
      const center = Coordinate(47.6, -122.3);
      Stop s(String id, double lat, double lon) =>
          Stop(id: id, name: id, lat: lat, lon: lon);
      final stops = [
        s('far', 47.7, -122.3),
        s('near', 47.601, -122.3),
        s('mid', 47.62, -122.3),
      ];
      expect(nearestStops(stops, center).map((s) => s.id), [
        'near',
        'mid',
        'far',
      ]);
      expect(nearestStops(stops, center, limit: 1).map((s) => s.id), ['near']);
      expect(nearestStops(stops, center, limit: 0), isEmpty);
    });

    test('ordering scales longitude by latitude', () {
      // At 60°N a degree of longitude is half a degree of latitude.
      const c = Coordinate(60, 0);
      expect(
        squaredDistanceForOrdering(const Coordinate(60, 0.9), c) <
            squaredDistanceForOrdering(const Coordinate(60.5, 0), c),
        isTrue,
      );
    });
  });
}
