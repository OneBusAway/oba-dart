import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  group('LocationService', () {
    late FakeLocationProvider provider;
    late LocationService service;

    setUp(() {
      provider = FakeLocationProvider(
        location: seattle,
        permission: LocationPermissionStatus.whileInUse,
      );
      service = LocationService(provider);
    });
    tearDown(() => service.dispose());

    test('no subscription without a lease', () async {
      await service.checkPermission();
      expect(service.permission, LocationPermissionStatus.whileInUse);
      expect(provider.activeSubscriptions, 0);
      expect(service.isUpdating, isFalse);
    });

    test('reference-counted: one subscription for many leases', () async {
      await service.checkPermission();
      final a = service.acquire();
      final b = service.acquire();
      expect(provider.activeSubscriptions, 1);
      expect(service.holderCount, 2);
      a.release();
      a.release(); // twice is a no-op
      expect(service.holderCount, 1);
      expect(provider.activeSubscriptions, 1);
      provider.setLocation(tampa);
      expect(service.currentLocation, tampa);
      b.release();
      expect(provider.activeSubscriptions, 0);
      expect(b.isActive, isFalse);
    });

    test('the last-known fix is readable without a lease', () async {
      service.readLastKnown();
      expect(service.currentLocation, seattle);
      expect(provider.activeSubscriptions, 0);
    });

    test(
      'a lease without permission subscribes once permission is granted',
      () async {
        provider.permission = LocationPermissionStatus.notDetermined;
        await service.checkPermission();
        final lease = service.acquire();
        await Future<void>.delayed(Duration.zero);
        expect(provider.activeSubscriptions, 0);
        expect(provider.requestCount, 0, reason: 'acquiring never prompts');

        await service.requestPermission();
        expect(provider.activeSubscriptions, 1);
        lease.release();
        expect(provider.activeSubscriptions, 0);
      },
    );

    test('acquire re-checks a permission granted in system settings', () async {
      provider.permission = LocationPermissionStatus.denied;
      await service.checkPermission();
      var changes = 0;
      service.addListener(() => changes++);
      provider.permission = LocationPermissionStatus.always;
      final lease = service.acquire();
      await Future<void>.delayed(Duration.zero);
      expect(service.permission, LocationPermissionStatus.always);
      expect(changes, 1);
      expect(provider.activeSubscriptions, 1);
      lease.release();
    });

    test('requestFix is one-shot', () async {
      await service.checkPermission();
      provider.setLocation(tampa);
      expect(await service.requestFix(), tampa);
      expect(service.currentLocation, tampa);
      expect(provider.activeSubscriptions, 0);
    });

    test('dispose cancels', () async {
      await service.checkPermission();
      service.acquire();
      expect(provider.activeSubscriptions, 1);
      service.dispose();
      expect(provider.activeSubscriptions, 0);
      service = LocationService(provider); // for tearDown
    });
  });

  group('FixedLocationProvider', () {
    test('reports one point with permission and no prompt', () async {
      final p = FixedLocationProvider(const Coordinate(32.88, -117.23));
      expect(await p.checkPermission(), LocationPermissionStatus.whileInUse);
      expect(await p.requestPermission(), LocationPermissionStatus.whileInUse);
      expect(p.lastKnownLocation!.coordinate, const Coordinate(32.88, -117.23));
      expect((await p.currentPosition())!.coordinate, p.coordinate);
      final got = <ObaLocation>[];
      final sub = p.positionStream.listen(got.add);
      await Future<void>.delayed(Duration.zero);
      expect(got.single.coordinate, const Coordinate(32.88, -117.23));
      p.coordinate = const Coordinate(1, 2);
      expect(got.last.coordinate, const Coordinate(1, 2));
      await sub.cancel();
    });

    test('drives the core application near the point', () async {
      final store = InMemoryKeyValueStore();
      final app = ObaCoreApplication(
        ObaAppConfig(
          appName: 'OBA',
          apiKey: 'key',
          appVersion: '1.0',
          bundledRegionsJson: fixture('regions-v3.json'),
          keyValueStore: store,
          locationProvider: FixedLocationProvider(
            const Coordinate(47.6062, -122.3321),
          ),
          regionsPath: null,
        ),
      );
      await app.start();
      addTearDown(app.dispose);
      expect(app.isLocationAvailable, isTrue);
      expect(app.locationPermission.isGranted, isTrue);
      expect(app.currentRegion!.regionName, 'Puget Sound');
      expect(
        app.currentLocation!.coordinate,
        const Coordinate(47.6062, -122.3321),
      );
    });
  });

  group('NoLocationProvider', () {
    test('is unavailable and never subscribes', () async {
      final service = LocationService(const NoLocationProvider());
      addTearDown(service.dispose);
      expect(service.isAvailable, isFalse);
      await service.checkPermission();
      expect(
        await service.requestPermission(),
        LocationPermissionStatus.denied,
      );
      final lease = service.acquire();
      expect(service.isUpdating, isFalse);
      expect(service.currentLocation, isNull);
      lease.release();
    });
  });

  group('a host provider that throws', () {
    test('requestPermission reads as denied, like checkPermission', () async {
      final service = LocationService(_ThrowingProvider(throwOnRequest: true));
      addTearDown(service.dispose);
      expect(
        await service.requestPermission(),
        LocationPermissionStatus.denied,
      );
      expect(service.permission, LocationPermissionStatus.denied);
    });

    test('a failed fix after the grant is no fix, not an error', () async {
      final service = LocationService(_ThrowingProvider());
      addTearDown(service.dispose);
      expect(
        await service.requestPermission(),
        LocationPermissionStatus.whileInUse,
      );
      expect(service.currentLocation, isNull);
      expect(await service.requestFix(), isNull);
    });
  });
}

/// Grants permission (unless [throwOnRequest]) and fails every fix, as a
/// host's own location plugin can.
class _ThrowingProvider implements LocationProvider {
  _ThrowingProvider({this.throwOnRequest = false});

  final bool throwOnRequest;

  @override
  Future<LocationPermissionStatus> checkPermission() async =>
      LocationPermissionStatus.notDetermined;

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    if (throwOnRequest) throw StateError('permission request in progress');
    return LocationPermissionStatus.whileInUse;
  }

  @override
  Future<ObaLocation?> currentPosition() async =>
      throw StateError('location services are off');

  @override
  Stream<ObaLocation> get positionStream => const Stream.empty();

  @override
  ObaLocation? get lastKnownLocation => null;
}
