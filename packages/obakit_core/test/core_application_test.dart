import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  late FakeHttp http;
  late InMemoryKeyValueStore store;
  late FakeLocationProvider location;

  ObaAppConfig config({
    PushServiceProvider? push,
    String? regionsPath = '/regions-v3.json',
  }) => ObaAppConfig(
    appName: 'OBA',
    apiKey: 'key',
    appVersion: '1.0',
    bundledRegionsJson: fixture('regions-v3.json'),
    keyValueStore: store,
    locationProvider: location,
    httpClient: http.client,
    pushServiceProvider: push,
    regionsPath: regionsPath,
  );

  setUp(() {
    http = FakeHttp({
      'regions-v3.json': (500, 'offline'),
      'agencies-with-coverage': (200, fixture('agencies_with_coverage.json')),
    });
    store = InMemoryKeyValueStore();
    location = FakeLocationProvider();
  });

  test(
    'start without location needs a region; selecting builds clients',
    () async {
      final app = ObaCoreApplication(config());
      await app.start();
      addTearDown(app.dispose);
      expect(app.isStarted, isTrue);
      expect(app.currentRegion, isNull);
      expect(app.restClient, isNull);
      expect(app.userData.appLaunchCount, 1);

      var changes = 0;
      app.clientsListenable.addListener(() => changes++);
      app.regions.setCurrentRegion(regionNamed('Puget Sound'));
      expect(app.restClient, isNotNull);
      expect(app.obacoClient!.regionId, 1);
      expect(app.clients!.region.id, 1);
      expect(changes, 1);
      expect(app.obacoStatus, FeatureStatus.running);
      expect(app.deepLinkingStatus, FeatureStatus.running);
      expect(app.tripPlanningStatus, FeatureStatus.running);
      expect(app.pushStatus, FeatureStatus.off);
      app.userData.setTripPlanningEnabled(1, false);
      expect(app.tripPlanningStatus, FeatureStatus.off);
      app.regions.setCurrentRegion(regionNamed('Spokane'));
      expect(app.tripPlanningStatus, FeatureStatus.off);
    },
  );

  test('a granted location selects the region; moves are followed only '
      'while a lease is held', () async {
    location = FakeLocationProvider(
      location: seattle,
      permission: LocationPermissionStatus.whileInUse,
    );
    final app = ObaCoreApplication(
      config(push: FakePushServiceProvider(token: 't')),
    );
    await app.start();
    addTearDown(app.dispose);
    expect(app.currentRegion!.regionName, 'Puget Sound');
    expect(app.pushStatus, FeatureStatus.running);
    expect(app.alarmsAvailable, isTrue);
    // Nothing on screen: no continuous subscription, even with permission.
    expect(location.activeSubscriptions, 0);
    expect(app.locationService.isUpdating, isFalse);
    // A last-known fix existed, so no one-shot fix was needed either.
    expect(location.currentPositionCount, 0);

    final lease = app.acquireLocation();
    expect(location.activeSubscriptions, 1);
    location.setLocation(tampa);
    expect(app.currentRegion!.regionName, 'Tampa Bay');
    expect(app.currentLocation, tampa);

    lease.release();
    expect(location.activeSubscriptions, 0);
    location.setLocation(seattle);
    // Not followed, but the last fix stays readable.
    expect(app.currentLocation, tampa);
    expect(app.currentRegion!.regionName, 'Tampa Bay');
  });

  test(
    'requestLocationPermission takes one fix; updates need a lease',
    () async {
      location = FakeLocationProvider(location: seattle);
      final app = ObaCoreApplication(config());
      await app.start();
      addTearDown(app.dispose);
      expect(app.currentRegion!.regionName, 'Puget Sound'); // last known fix
      location.setLocation(tampa); // moved before permission
      var notified = 0;
      app.addListener(() => notified++);
      final status = await app.requestLocationPermission();
      expect(status.isGranted, isTrue);
      expect(notified, greaterThan(0));
      expect(app.locationPermission, LocationPermissionStatus.whileInUse);
      expect(location.currentPositionCount, 1);
      expect(app.currentRegion!.regionName, 'Tampa Bay'); // from the one fix
      expect(location.activeSubscriptions, 0);

      final lease = app.acquireLocation();
      expect(location.activeSubscriptions, 1);
      location.setLocation(seattle);
      expect(app.currentRegion!.regionName, 'Puget Sound');
      lease.release();
    },
  );

  test(
    'auto region selection with no cached fix takes one fix at start',
    () async {
      location = FakeLocationProvider(
        permission: LocationPermissionStatus.whileInUse,
      );
      final app = ObaCoreApplication(config());
      await app.start();
      addTearDown(app.dispose);
      expect(location.currentPositionCount, 1);
      expect(location.activeSubscriptions, 0);
    },
  );

  test('a fixed region takes no fix at start', () async {
    location = FakeLocationProvider(
      permission: LocationPermissionStatus.whileInUse,
    );
    final app = ObaCoreApplication(
      ObaAppConfig(
        appName: 'OBA',
        apiKey: 'key',
        appVersion: '1.0',
        bundledRegionsJson: fixture('regions-v3.json'),
        keyValueStore: store,
        locationProvider: location,
        httpClient: http.client,
        regionsPath: null,
        fixedRegion: const FixedRegionConfig(name: 'Puget Sound'),
      ),
    );
    await app.start();
    addTearDown(app.dispose);
    expect(location.currentPositionCount, 0);
    expect(location.activeSubscriptions, 0);
  });

  test('dispose drops the subscription', () async {
    location = FakeLocationProvider(
      location: seattle,
      permission: LocationPermissionStatus.whileInUse,
    );
    final app = ObaCoreApplication(config());
    await app.start();
    app.acquireLocation();
    expect(location.activeSubscriptions, 1);
    app.dispose();
    expect(location.activeSubscriptions, 0);
  });

  group('bundled regions', () {
    ObaAppConfig noRegions() => ObaAppConfig(
      appName: 'OBA',
      apiKey: 'key',
      appVersion: '1.0',
      keyValueStore: store,
      locationProvider: location,
      httpClient: http.client,
      regionsPath: null,
      fixedRegion: const FixedRegionConfig(name: 'Puget Sound'),
    );

    test('the loader supplies the list when the config has none', () async {
      var loads = 0;
      final app = ObaCoreApplication(
        noRegions(),
        bundledRegionsLoader: () async {
          loads++;
          return fixture('regions-v3.json');
        },
      );
      await app.start();
      addTearDown(app.dispose);
      expect(loads, 1);
      expect(app.currentRegion!.regionName, 'Puget Sound');
    });

    test('the host list wins and the loader is not called', () async {
      var loads = 0;
      final app = ObaCoreApplication(
        config(regionsPath: null),
        bundledRegionsLoader: () async {
          loads++;
          return '';
        },
      );
      await app.start();
      addTearDown(app.dispose);
      expect(loads, 0);
      expect(app.regions.regions, isNotEmpty);
    });

    test(
      'a cached list skips the loader; a failing loader is harmless',
      () async {
        final first = ObaCoreApplication(
          noRegions(),
          bundledRegionsLoader: () => throw StateError('no asset'),
        );
        await first.start();
        expect(first.regions.regions, isEmpty);
        expect(first.currentRegion, isNull);
        first.dispose();

        store.writeJson(RegionsService.cachedRegionsKey, [
          regionNamed('Puget Sound').toJson(),
        ]);
        var loads = 0;
        final second = ObaCoreApplication(
          noRegions(),
          bundledRegionsLoader: () async {
            loads++;
            return '';
          },
        );
        await second.start();
        addTearDown(second.dispose);
        expect(loads, 0);
        expect(second.currentRegion!.regionName, 'Puget Sound');
      },
    );
  });

  test('user uuid is stable and the launch count accumulates', () async {
    final a = ObaCoreApplication(config(regionsPath: null));
    await a.start();
    final id = a.userUuid;
    a.dispose();
    final b = ObaCoreApplication(config(regionsPath: null));
    await b.start();
    addTearDown(b.dispose);
    expect(b.userUuid, id);
    expect(b.userData.appLaunchCount, 2);
  });

  test('region time zone resolves when enabled', () async {
    final app = ObaCoreApplication(config());
    await app.start();
    addTearDown(app.dispose);
    app.regions.setCurrentRegion(regionNamed('Puget Sound'));
    expect(app.regionTimeZone, isNull);
    app.settings.showRegionTimeZone = true;
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(app.regionTimeZone, 'America/Los_Angeles');
    app.settings.showRegionTimeZone = false;
    await Future<void>.delayed(Duration.zero);
    expect(app.regionTimeZone, isNull);
  });

  test('preferredTimeZone picks the most common, ties alphabetically', () {
    expect(ObaCoreApplication.preferredTimeZone(['B', 'A', 'B']), 'B');
    expect(ObaCoreApplication.preferredTimeZone(['B', 'A']), 'A');
    expect(ObaCoreApplication.preferredTimeZone([]), isNull);
  });

  test('analytics follows the reporting setting', () async {
    final analytics = NoopAnalytics();
    final app = ObaCoreApplication(
      ObaAppConfig(
        appName: 'OBA',
        apiKey: 'k',
        appVersion: '1',
        bundledRegionsJson: fixture('regions-v3.json'),
        keyValueStore: store,
        locationProvider: location,
        httpClient: http.client,
        analytics: analytics,
        regionsPath: null,
      ),
    );
    await app.start();
    addTearDown(app.dispose);
    expect(analytics.reportingEnabled, isTrue);
    app.settings.analyticsReportingEnabled = false;
    expect(analytics.reportingEnabled, isFalse);
  });

  test('services are wired to the current region', () async {
    http.routes['routes-for-location'] = (
      200,
      fixture('routes_for_location_query.json'),
    );
    final app = ObaCoreApplication(config());
    await app.start();
    addTearDown(app.dispose);
    app.regions.setCurrentRegion(regionNamed('Puget Sound'));
    final r = await app.search.search(
      const SearchRequest('10', SearchType.route),
    );
    expect(r, isA<RouteSearchResult>());
    expect(http.requests.last.url.host, region(app).obaBaseUrl.host);
  });
}

Region region(ObaCoreApplication app) => app.currentRegion!;
