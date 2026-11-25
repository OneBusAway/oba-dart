import 'package:onebusaway/onebusaway.dart';

import '../platform/analytics.dart';
import '../platform/place_search.dart';
import '../user_data/bookmark.dart';
import '../user_data/stored_stop.dart';
import '../user_data/user_data_store.dart';

/// What kind of thing a query names (iOS `SearchType`).
enum SearchType { address, route, stopNumber, vehicleId }

/// A search the user asked for.
class SearchRequest {
  const SearchRequest(this.query, this.type);

  final String query;
  final SearchType type;

  @override
  bool operator ==(Object other) =>
      other is SearchRequest && other.query == query && other.type == type;

  @override
  int get hashCode => Object.hash(query, type);

  @override
  String toString() => 'SearchRequest(${type.name}: $query)';
}

/// The outcome of a [SearchRequest]. An empty list means nothing matched.
sealed class SearchResult {
  const SearchResult(this.request);

  final SearchRequest request;

  int get count;

  bool get isEmpty => count == 0;

  /// More (or fewer) than one match: show a list rather than jumping
  /// straight to the result.
  bool get needsDisambiguation => count != 1;
}

final class RouteSearchResult extends SearchResult {
  const RouteSearchResult(super.request, this.routes, this.references);

  final List<Route> routes;
  final References references;

  @override
  int get count => routes.length;
}

final class StopSearchResult extends SearchResult {
  const StopSearchResult(super.request, this.stops, this.references);

  final List<Stop> stops;
  final References references;

  @override
  int get count => stops.length;
}

/// Several vehicles matched; the user picks one, then the UI calls
/// [SearchService.vehicle].
final class VehicleMatchesResult extends SearchResult {
  const VehicleMatchesResult(super.request, this.vehicles);

  final List<AgencyVehicle> vehicles;

  @override
  int get count => vehicles.length;
}

/// Exactly one vehicle matched, with its status.
final class VehicleResult extends SearchResult {
  const VehicleResult(super.request, this.vehicle, this.references);

  final VehicleStatus vehicle;
  final References references;

  @override
  int get count => 1;
}

final class PlaceSearchResult extends SearchResult {
  const PlaceSearchResult(super.request, this.places);

  final List<Place> places;

  @override
  int get count => places.length;
}

/// Thrown when a search type can't run (no region, no Obaco server, no
/// place-search provider).
class SearchUnavailableException implements Exception {
  const SearchUnavailableException(this.type, this.reason);

  final SearchType type;
  final String reason;

  @override
  String toString() => 'SearchUnavailableException(${type.name}): $reason';
}

/// Saved items matching a query.
class LocalSearchMatches {
  const LocalSearchMatches({
    required this.bookmarks,
    required this.recentStops,
  });

  final List<Bookmark> bookmarks;
  final List<StoredStop> recentStops;

  bool get isEmpty => bookmarks.isEmpty && recentStops.isEmpty;
}

/// Runs searches against the current region's servers. Port of iOS
/// `SearchManager` (minus map publishing, which belongs to the UI).
///
/// The client getters are read on every call, so the service follows region
/// changes without being rebuilt.
class SearchService {
  SearchService({
    required this._client,
    required this._region,
    ObacoClient? Function()? obaco,
    this.placeSearchProvider,
    this.userData,
    this.analytics,
  }) : _obaco = obaco ?? (() => null);

  final OneBusAwayClient? Function() _client;
  final Region? Function() _region;
  final ObacoClient? Function() _obaco;
  final PlaceSearchProvider? placeSearchProvider;
  final UserDataStore? userData;
  final ObaAnalytics? analytics;

  /// The search types that can run right now.
  Set<SearchType> get availableTypes => {
    if (_client() != null && _region() != null) ...{
      SearchType.route,
      SearchType.stopNumber,
    },
    if (_obaco() != null && _client() != null) SearchType.vehicleId,
    if (placeSearchProvider != null) SearchType.address,
  };

  /// One request per available type for [query], in the order the iOS
  /// search list offers them: route, address, stop number, vehicle. Empty
  /// for a blank query.
  List<SearchRequest> quickSearchRequests(String query) {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final types = availableTypes;
    return [
      for (final t in const [
        SearchType.route,
        SearchType.address,
        SearchType.stopNumber,
        SearchType.vehicleId,
      ])
        if (types.contains(t)) SearchRequest(q, t),
    ];
  }

  /// Bookmarks and recent stops that match [query] (in [regionId] when
  /// given).
  LocalSearchMatches localMatches(String query, {int? regionId}) {
    final store = userData;
    if (store == null || query.trim().isEmpty) {
      return const LocalSearchMatches(bookmarks: [], recentStops: []);
    }
    return LocalSearchMatches(
      bookmarks: store
          .findBookmarks(query)
          .where((b) => regionId == null || b.regionId == regionId)
          .toList(),
      recentStops: store.findRecentStops(query, regionId: regionId),
    );
  }

  /// Runs [request]. [mapCenter] centres route searches (default: the
  /// region's centre); [visibleRect] biases address searches. Throws
  /// [SearchUnavailableException] or the client's `ObaException`s.
  Future<SearchResult> search(
    SearchRequest request, {
    Coordinate? mapCenter,
    RegionRect? visibleRect,
  }) async {
    analytics?.reportSearchQuery(request.query);
    userData?.addRecentSearch(request.query);
    return switch (request.type) {
      SearchType.route => _route(request, mapCenter),
      SearchType.stopNumber => _stopNumber(request),
      SearchType.vehicleId => _vehicle(request),
      SearchType.address => _address(request, mapCenter, visibleRect),
    };
  }

  Future<SearchResult> _route(SearchRequest r, Coordinate? center) async {
    final (client, region) = _requireRest(r.type);
    final response = await client.routes.forLocation(
      center ?? region.centerCoordinate,
      query: r.query,
    );
    return RouteSearchResult(r, response.list, response.references);
  }

  /// Searches the region's whole service rect, so equal stop codes at
  /// distant agencies all reach disambiguation (onebusaway-ios#1432).
  Future<SearchResult> _stopNumber(SearchRequest r) async {
    final (client, region) = _requireRest(r.type);
    final rect = region.serviceRect;
    final response = await client.stops.forLocation(
      rect.center,
      latSpan: rect.maxLat - rect.minLat,
      lonSpan: rect.maxLon - rect.minLon,
      query: r.query,
    );
    return StopSearchResult(r, response.list, response.references);
  }

  Future<SearchResult> _vehicle(SearchRequest r) async {
    final obaco = _obaco();
    if (obaco == null) {
      throw const SearchUnavailableException(
        SearchType.vehicleId,
        'The current region has no Obaco server',
      );
    }
    final matches = await obaco.getVehicles(r.query);
    if (matches.length > 1) return VehicleMatchesResult(r, matches);
    final id = matches.firstOrNull?.vehicleId;
    if (id == null) return VehicleMatchesResult(r, const []);
    return vehicle(id, request: r);
  }

  /// Looks up one vehicle's status (after the user picks from
  /// [VehicleMatchesResult]).
  Future<VehicleResult> vehicle(
    String vehicleId, {
    SearchRequest? request,
  }) async {
    final client = _client();
    if (client == null) {
      throw const SearchUnavailableException(
        SearchType.vehicleId,
        'No region selected',
      );
    }
    final response = await client.vehicles.byId(vehicleId);
    return VehicleResult(
      request ?? SearchRequest(vehicleId, SearchType.vehicleId),
      response.entry,
      response.references,
    );
  }

  Future<SearchResult> _address(
    SearchRequest r,
    Coordinate? center,
    RegionRect? rect,
  ) async {
    final provider = placeSearchProvider;
    if (provider == null) {
      throw const SearchUnavailableException(
        SearchType.address,
        'No place search provider configured',
      );
    }
    final region = _region();
    final places = await provider.search(
      r.query,
      near: center ?? region?.centerCoordinate,
      within: rect ?? region?.serviceRect,
    );
    return PlaceSearchResult(r, places);
  }

  (OneBusAwayClient, Region) _requireRest(SearchType type) {
    final client = _client();
    final region = _region();
    if (client == null || region == null) {
      throw SearchUnavailableException(type, 'No region selected');
    }
    return (client, region);
  }
}
