import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  final bundled = fixture('regions-v3.json');

  RegionsService make({
    InMemoryKeyValueStore? store,
    ObaLocation? location,
    FixedRegionConfig? fixed,
    RegionsClient? client,
    String? bundledJson,
  }) => RegionsService(
    store: store ?? InMemoryKeyValueStore(),
    bundledRegionsJson: bundledJson ?? bundled,
    initialLocation: location,
    fixedRegion: fixed,
    client: client,
  );

  String envelope(List<Region> regions) => jsonEncode({
    'code': 200,
    'version': 3,
    'currentTime': 0,
    'text': 'OK',
    'data': {
      'list': [for (final r in regions) r.toJson()],
    },
  });

  group('initial region', () {
    test('loads the bundled list and needs a selection with no hints', () {
      final s = make();
      expect(s.regions, hasLength(17));
      expect(s.currentRegion, isNull);
      expect(s.needsRegionSelection, isTrue);
      expect(s.automaticallySelectRegion, isTrue);
    });

    test('selects by location and persists the id', () {
      final store = InMemoryKeyValueStore();
      final s = make(store: store, location: seattle);
      expect(s.currentRegion!.regionName, 'Puget Sound');
      expect(store.readInt(RegionsService.currentRegionIdKey), 1);
    });

    test('location wins over a stored region while auto-select is on', () {
      final store = InMemoryKeyValueStore()
        ..writeJson(RegionsService.currentRegionIdKey, 0);
      expect(make(store: store, location: seattle).currentRegion!.id, 1);
    });

    test('a stored region wins when auto-select is off', () {
      final store = InMemoryKeyValueStore()
        ..writeJson(RegionsService.currentRegionIdKey, 0)
        ..writeJson(RegionsService.automaticallySelectRegionKey, false);
      expect(make(store: store, location: seattle).currentRegion!.id, 0);
    });

    test('fixed region by name, then by URL, turns auto-select off', () {
      final store = InMemoryKeyValueStore();
      final s = make(
        store: store,
        fixed: const FixedRegionConfig(name: 'Spokane'),
      );
      expect(s.currentRegion!.regionName, 'Spokane');
      expect(s.automaticallySelectRegion, isFalse);

      final byUrl = make(
        fixed: FixedRegionConfig(
          name: 'nope',
          obaBaseUrl: regionNamed('San Diego').obaBaseUrl,
        ),
      );
      expect(byUrl.currentRegion!.regionName, 'San Diego');
    });

    test('location beats the fixed region', () {
      final s = make(
        location: tampa,
        fixed: const FixedRegionConfig(name: 'Spokane'),
      );
      expect(s.currentRegion!.regionName, 'Tampa Bay');
    });

    test('a single active region is selected', () {
      final only = regionNamed('Spokane');
      final s = make(bundledJson: envelope([only, regionNamed('Atlanta')]));
      expect(s.currentRegion!.id, only.id);
    });

    test('prefers the cached list over the bundled one', () {
      final store = InMemoryKeyValueStore()
        ..writeJson(RegionsService.cachedRegionsKey, [
          regionNamed('Spokane').toJson(),
        ]);
      expect(make(store: store).regions.single.regionName, 'Spokane');
    });

    test('a broken bundled file yields an empty list', () {
      expect(make(bundledJson: '').regions, isEmpty);
    });
  });

  group('selection', () {
    test('setCurrentRegion persists and notifies once', () {
      final store = InMemoryKeyValueStore();
      final s = make(store: store);
      var regionChanges = 0;
      s.currentRegionListenable.addListener(() => regionChanges++);
      s.setCurrentRegion(regionNamed('Spokane'));
      s.setCurrentRegion(regionNamed('Spokane'));
      expect(regionChanges, 1);
      expect(store.readInt(RegionsService.currentRegionIdKey), 12);
      expect(make(store: store).currentRegion!.regionName, 'Spokane');
    });

    test('updateLocation switches region only with auto-select on', () {
      final s = make(location: seattle);
      s.updateLocation(tampa);
      expect(s.currentRegion!.regionName, 'Tampa Bay');
      s.automaticallySelectRegion = false;
      s.updateLocation(seattle);
      expect(s.currentRegion!.regionName, 'Tampa Bay');
      s.automaticallySelectRegion = true;
      expect(s.currentRegion!.regionName, 'Puget Sound');
    });

    test('a location outside every region keeps the current one', () {
      final s = make(location: seattle);
      s.updateLocation(
        ObaLocation(lat: 0, lon: 0, timestamp: DateTime.utc(2024)),
      );
      expect(s.currentRegion!.regionName, 'Puget Sound');
      expect(s.physicallyLocatedRegion, isNull);
    });
  });

  group('refresh', () {
    test('downloads, caches, and records the time', () async {
      final store = InMemoryKeyValueStore();
      final http = FakeHttp({
        'regions-v3.json': (200, envelope([regionNamed('Spokane')])),
      });
      final s = make(
        store: store,
        client: RegionsClient(httpClient: http.client),
      );
      final now = DateTime.utc(2024, 5, 1);
      await withClock(Clock.fixed(now), () => s.updateRegionsList());
      expect(s.regions.single.regionName, 'Spokane');
      expect(s.regionsUpdatedAt, now);
      expect(store.readList(RegionsService.cachedRegionsKey), hasLength(1));
      // A single active region now; picks nothing automatically after init,
      // but the cache wins on the next launch.
      expect(make(store: store).currentRegion!.regionName, 'Spokane');
    });

    test('skips when fresh unless forced', () async {
      final http = FakeHttp({
        'regions-v3.json': (200, envelope(regionsFixture())),
      });
      final s = make(client: RegionsClient(httpClient: http.client));
      final t = DateTime.utc(2024, 5, 1);
      await withClock(Clock.fixed(t), () => s.updateRegionsList());
      await withClock(
        Clock.fixed(t.add(const Duration(hours: 23))),
        () => s.updateRegionsList(),
      );
      expect(http.requests, hasLength(1));
      await withClock(
        Clock.fixed(t.add(const Duration(hours: 23))),
        () => s.updateRegionsList(force: true),
      );
      await withClock(
        Clock.fixed(t.add(const Duration(days: 2))),
        () => s.updateRegionsList(),
      );
      expect(http.requests, hasLength(3));
    });

    test('records failures without throwing from updateRegionsList', () async {
      final http = FakeHttp({'regions-v3.json': (500, 'oops')});
      final s = make(client: RegionsClient(httpClient: http.client));
      await s.updateRegionsList(force: true);
      expect(s.lastRefreshFailed, isTrue);
      expect(s.regions, hasLength(17));
      await expectLater(s.refreshRegions(), throwsA(isA<ObaApiException>()));
    });

    test(
      'drops the current region when the server no longer lists it',
      () async {
        final http = FakeHttp({
          'regions-v3.json': (200, envelope([regionNamed('Spokane')])),
        });
        final store = InMemoryKeyValueStore()
          ..writeJson(RegionsService.currentRegionIdKey, 1)
          ..writeJson(RegionsService.automaticallySelectRegionKey, false);
        final s = make(
          store: store,
          client: RegionsClient(httpClient: http.client),
        );
        expect(s.currentRegion!.id, 1);
        await s.refreshRegions();
        expect(s.currentRegion, isNull);
        expect(store.readInt(RegionsService.currentRegionIdKey), isNull);
      },
    );
  });

  group('custom regions', () {
    final custom = Region.custom(
      id: 1500,
      name: 'My Server',
      obaBaseUrl: Uri.parse('https://oba.example.com/'),
      center: const Coordinate(10, 10),
      latSpan: 1,
      lonSpan: 1,
    );

    test('add, find, persist, select, refuse to delete current', () {
      final store = InMemoryKeyValueStore();
      final s = make(store: store);
      s.addCustomRegion(custom);
      expect(s.find(1500)!.regionName, 'My Server');
      expect(make(store: store).customRegions.single.id, 1500);
      expect(s.regionContaining(10, 10)!.id, 1500);
      s.setCurrentRegion(custom);
      expect(() => s.deleteCustomRegion(1500), throwsStateError);
      s.setCurrentRegion(regionNamed('Spokane'));
      s.deleteCustomRegion(1500);
      expect(s.customRegions, isEmpty);
      expect(make(store: store).find(1500), isNull);
    });

    test('rejects non-custom regions', () {
      expect(
        () => make().addCustomRegion(regionNamed('Spokane')),
        throwsArgumentError,
      );
    });
  });

  test('visibleRegions hides inactive and experimental by default', () {
    final s = make();
    final names = s.visibleRegions().map((r) => r.regionName).toList();
    expect(names, contains('Puget Sound'));
    expect(names, isNot(contains('Atlanta')));
    expect(names, isNot(contains('Mayaguez (beta)')));
    expect(
      names,
      orderedEquals(
        [...names]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
      ),
    );
    expect(
      s.visibleRegions(showExperimental: true).map((r) => r.regionName),
      contains('Mayaguez (beta)'),
    );
    expect(
      s.visibleRegions(showInactive: true, showExperimental: true),
      hasLength(17),
    );
    s.setCurrentRegion(regionNamed('Atlanta'));
    expect(s.visibleRegions().map((r) => r.regionName), contains('Atlanta'));
  });
}
