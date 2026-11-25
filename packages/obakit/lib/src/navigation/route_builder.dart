import 'package:flutter/widgets.dart';

import '../features/bookmarks/bookmarks_routes.dart';
import '../features/map/map_routes.dart';
import '../features/search/search_routes.dart';
import '../features/settings/settings_routes.dart';
import '../features/stop/stop_routes.dart';
import 'oba_route.dart';

/// Maps every [ObaRoute] to its page. The switch is exhaustive, so adding a
/// route variant without a page fails to compile.
///
/// Each feature area owns one file (see the README's "Contributing a
/// screen"); this registry only forwards. Feature agents edit their own
/// file, not this one.
abstract final class ObaRouteBuilder {
  static Widget build(BuildContext context, ObaRoute route) => switch (route) {
    // search_routes.dart
    HomeRoute() => buildHomeRoute(context, route),
    SearchRoute() => buildSearchRoute(context, route),
    SearchResultsRoute() => buildSearchResultsRoute(context, route),
    NearbyStopsRoute() => buildNearbyStopsRoute(context, route),
    PlaceRoute() => buildPlaceRoute(context, route),
    TripPlannerRoute() => buildTripPlannerRoute(context, route),
    WeatherRoute() => buildWeatherRoute(context, route),
    // stop_routes.dart
    StopRoute() => buildStopRoute(context, route),
    TripRoute() => buildTripRoute(context, route),
    RouteStopsRoute() => buildRouteStopsRoute(context, route),
    StopScheduleRoute() => buildStopScheduleRoute(context, route),
    RouteScheduleRoute() => buildRouteScheduleRoute(context, route),
    ReportStopProblemRoute() => buildReportStopProblemRoute(context, route),
    ReportTripProblemRoute() => buildReportTripProblemRoute(context, route),
    // bookmarks_routes.dart
    RecentStopsRoute() => buildRecentStopsRoute(context, route),
    BookmarksRoute() => buildBookmarksRoute(context, route),
    BookmarkEditorRoute() => buildBookmarkEditorRoute(context, route),
    ManageBookmarksRoute() => buildManageBookmarksRoute(context, route),
    AlertsListRoute() => buildAlertsListRoute(context, route),
    AlertDetailRoute() => buildAlertDetailRoute(context, route),
    AgenciesRoute() => buildAgenciesRoute(context, route),
    // settings_routes.dart
    SettingsRoute() => buildSettingsRoute(context, route),
    MoreRoute() => buildMoreRoute(context, route),
    RegionPickerRoute() => buildRegionPickerRoute(context, route),
    CustomRegionRoute() => buildCustomRegionRoute(context, route),
    CreditsRoute() => buildCreditsRoute(context, route),
    OnboardingRoute() => buildOnboardingRoute(context, route),
    // map_routes.dart (scaffold-owned)
    MapSettingsRoute() => buildMapSettingsRoute(context, route),
    StopsOnMapRoute() => buildStopsOnMapRoute(context, route),
    // Extension point.
    ObaCustomRoute() => route.build(context),
  };
}
