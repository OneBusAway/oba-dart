import 'package:onebusaway/onebusaway.dart';

import '../strings.dart';

/// `MTS_24151` -> `24151`. Keeps everything after the first underscore.
String stripAgencyPrefix(String id) {
  final i = id.indexOf('_');
  return i < 0 ? id : id.substring(i + 1);
}

/// Short names of routes that serve [stop], sorted. References can include
/// routes that don't serve the stop, so only `stop.routeIds` count.
List<String> routeShortNamesForStop(Stop stop, References refs) => [
  for (final id in stop.routeIds)
    if (refs.route(id) case final route?)
      route.shortName ?? stripAgencyPrefix(route.id),
]..sort();

/// `Stop #24151 · Southwest bound · 101, 30, IL, S`
String stopSubtitle(Stop stop, References refs, ObaArrivalsStrings strings) {
  final routes = routeShortNamesForStop(stop, refs);
  return [
    strings.stopNumber(stop.code ?? stripAgencyPrefix(stop.id)),
    if (stop.direction case final direction?) strings.directionBound(direction),
    if (routes.isNotEmpty) routes.join(', '),
  ].join(' · ');
}
