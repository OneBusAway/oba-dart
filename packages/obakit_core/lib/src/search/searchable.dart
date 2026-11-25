import 'package:onebusaway/onebusaway.dart';

import '../user_data/stored_stop.dart';

bool _has(String? haystack, String needle) =>
    haystack != null && haystack.toLowerCase().contains(needle.toLowerCase());

/// Case-insensitive match on a route's description, long or short name
/// (iOS `Route.matchesQuery`).
bool routeMatchesQuery(Route route, String? query) =>
    query == null ||
    _has(route.description, query) ||
    _has(route.longName, query) ||
    _has(route.shortName, query);

bool storedRouteMatchesQuery(StoredRoute route, String? query) =>
    query == null ||
    _has(route.description, query) ||
    _has(route.longName, query) ||
    _has(route.shortName, query);

/// Case-insensitive match on the stop name or any of its embedded routes
/// (iOS `Stop.matchesQuery`).
bool stopMatchesQuery(StoredStop stop, String? query) =>
    query == null ||
    _has(stop.name, query) ||
    stop.routes.any((r) => storedRouteMatchesQuery(r, query));
