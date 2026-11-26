import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

class _Places implements PlaceSearchProvider {
  String? lastQuery;
  Coordinate? lastNear;
  RegionRect? lastWithin;

  @override
  Future<List<Place>> search(
    String query, {
    Coordinate? near,
    RegionRect? within,
  }) async {
    lastQuery = query;
    lastNear = near;
    lastWithin = within;
    return [
      const Place(name: 'Space Needle', coordinate: Coordinate(47.62, -122.35)),
    ];
  }
}

class _RecordingAnalytics extends NoopAnalytics {
  final queries = <String>[];
  @override
  void reportSearchQuery(String query) => queries.add(query);
}

void main() {
  final region = regionNamed('Puget Sound');
  late FakeHttp http;
  late OneBusAwayClient client;
  late ObacoClient obaco;
  late UserDataStore userData;
  late _Places places;
  late _RecordingAnalytics analytics;

  SearchService service({bool withObaco = true, bool withRegion = true}) =>
      SearchService(
        client: () => withRegion ? client : null,
        region: () => withRegion ? region : null,
        obaco: () => withObaco ? obaco : null,
        placeSearchProvider: places,
        userData: userData,
        analytics: analytics,
      );

  setUp(() {
    http = FakeHttp({
      'routes-for-location': (200, fixture('routes_for_location_query.json')),
      'stops-for-location': (200, fixture('stops_for_location_query.json')),
      'api/where/vehicle/': (200, fixture('api_where_vehicle_1_4351.json')),
      'query=1_1': (200, fixture('vehicles-query-1_1.json')),
      'query=one': (200, '[{"id":"1","name":"Metro","vehicle_id":"1_4351"}]'),
      'query=none': (200, '[]'),
    });
    client = OneBusAwayClient(
      baseUrl: region.obaBaseUrl,
      apiKey: 'k',
      httpClient: http.client,
    );
    obaco = ObacoClient(
      baseUrl: region.sidecarBaseUrl!,
      regionId: 1,
      httpClient: http.client,
    );
    userData = UserDataStore(InMemoryKeyValueStore());
    places = _Places();
    analytics = _RecordingAnalytics();
  });

  test('route search uses the map centre and a wide radius', () async {
    final r = await service().search(
      const SearchRequest('10', SearchType.route),
      mapCenter: const Coordinate(47.6, -122.3),
    ) as RouteSearchResult;
    expect(r.routes, isNotEmpty);
    final url = http.requests.single.url;
    expect(url.queryParameters['lat'], '47.6');
    expect(url.queryParameters['query'], '10');
    expect(
      double.parse(url.queryParameters['radius']!),
      greaterThanOrEqualTo(40000),
    );
    expect(analytics.queries, ['10']);
    expect(userData.recentSearches, ['10']);
  });

  test('stop number search spans the region service rect', () async {
    final r = await service().search(
      const SearchRequest('75403', SearchType.stopNumber),
    ) as StopSearchResult;
    expect(r.count, 1);
    expect(r.needsDisambiguation, isFalse);
    final q = http.requests.single.url.queryParameters;
    expect(
      double.parse(q['latSpan']!),
      closeTo(region.serviceRect.maxLat - region.serviceRect.minLat, 1e-6),
    );
    expect(q['query'], '75403');
  });

  test('vehicle search: many, one, none', () async {
    final many = await service().search(
      const SearchRequest('1_1', SearchType.vehicleId),
    );
    expect(many, isA<VehicleMatchesResult>());
    expect(many.needsDisambiguation, isTrue);

    final one = await service().search(
      const SearchRequest('one', SearchType.vehicleId),
    ) as VehicleResult;
    expect(one.vehicle.vehicleId, '1_4351');
    expect(http.requests.last.url.path, contains('vehicle/1_4351'));

    final none = await service().search(
      const SearchRequest('none', SearchType.vehicleId),
    );
    expect(none.isEmpty, isTrue);
  });

  test('address search goes to the provider with region bias', () async {
    final r = await service().search(
      const SearchRequest('needle', SearchType.address),
    ) as PlaceSearchResult;
    expect(r.places.single.name, 'Space Needle');
    expect(places.lastNear, region.centerCoordinate);
    expect(places.lastWithin!.minLat, region.serviceRect.minLat);
  });

  test('unavailable types throw', () async {
    expect(
      () =>
          service(withObaco: false)
              .search(const SearchRequest('1', SearchType.vehicleId)),
      throwsA(isA<SearchUnavailableException>()),
    );
    expect(
      () =>
          service(withRegion: false)
              .search(const SearchRequest('1', SearchType.route)),
      throwsA(isA<SearchUnavailableException>()),
    );
    expect(service(withRegion: false).availableTypes, {SearchType.address});
  });

  test('quick search requests follow the iOS order', () {
    expect(service().quickSearchRequests('  10 ').map((r) => r.type), [
      SearchType.route,
      SearchType.address,
      SearchType.stopNumber,
      SearchType.vehicleId,
    ]);
    expect(service().quickSearchRequests('10').first.query, '10');
    expect(service(withObaco: false).quickSearchRequests('10'), hasLength(3));
    expect(service().quickSearchRequests(' '), isEmpty);
  });

  test('local matches cover bookmarks and recent stops by region', () {
    final stop = storedStop(id: '1_1', name: 'Pine St');
    userData.addBookmark(
      Bookmark.forStop(name: 'Home', regionId: 1, stop: stop),
    );
    userData.addRecentStop(stop, regionId: 1);
    final m = service().localMatches('pine', regionId: 1);
    expect(m.bookmarks, hasLength(1));
    expect(m.recentStops, hasLength(1));
    expect(service().localMatches('pine', regionId: 2).bookmarks, isEmpty);
    expect(service().localMatches(' ').isEmpty, isTrue);
  });
}
