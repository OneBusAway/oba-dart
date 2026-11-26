import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import 'embed_frame.dart';

/// A full-screen Tapline route: Tapline's own app bar over one embedded
/// SDK page.
///
/// The app's single `ObaScope` sits above the navigator (see `app.dart`),
/// so this route needs no scope of its own. The page is marked embedded,
/// so it drops its own Scaffold and AppBar and Tapline's app bar is the
/// only one.
class HostObaPage extends StatelessWidget {
  const HostObaPage({
    super.key,
    required this.title,
    required this.sdkWidget,
    required this.child,
    this.showsHeader = false,
  });

  final String title;

  /// The SDK page's name, for the embed overlay.
  final String sdkWidget;
  final Widget child;

  /// Whether the page shows its own compact header (title and actions).
  final bool showsHeader;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    // OBA embed: a whole SDK page under Tapline's app bar.
    body: EmbedFrame(
      sdkWidget: sdkWidget,
      child: ObaPresentationScope.embedded(
        showsHeader: showsHeader,
        child: child,
      ),
    ),
  );
}

/// How Tapline presents one SDK route: its app bar title, whether the SDK
/// page keeps its own header, and the page's name for the embed overlay.
///
/// Pages whose title is data (a stop's name, a trip, a route, a place)
/// keep the SDK header, and Tapline's app bar names the section, so the
/// title shows once. Pages with a fixed title drop the SDK header and
/// Tapline's app bar carries that title instead.
typedef HostChrome = ({String title, bool showsHeader, String sdkWidget});

HostChrome hostChromeFor(ObaRoute route) => switch (route) {
  StopRoute(:final name) => (
    title: name ?? 'Transit',
    showsHeader: true,
    sdkWidget: 'StopPage',
  ),
  TripRoute() => (title: 'Transit', showsHeader: true, sdkWidget: 'TripPage'),
  RouteStopsRoute() => (
    title: 'Transit',
    showsHeader: true,
    sdkWidget: 'RouteStopsPage',
  ),
  StopScheduleRoute() => (
    title: 'Schedule',
    showsHeader: true,
    sdkWidget: 'StopSchedulePage',
  ),
  RouteScheduleRoute() => (
    title: 'Schedule',
    showsHeader: true,
    sdkWidget: 'RouteSchedulePage',
  ),
  PlaceRoute() => (title: 'Transit', showsHeader: true, sdkWidget: 'PlacePage'),
  TripPlannerRoute() => (
    title: 'Plan a trip',
    showsHeader: false,
    sdkWidget: 'TripPlannerPage',
  ),
  BookmarksRoute() => (
    title: 'Saved stops',
    showsHeader: false,
    sdkWidget: 'BookmarksPage',
  ),
  RecentStopsRoute() => (
    title: 'Recent stops',
    showsHeader: false,
    sdkWidget: 'RecentStopsPage',
  ),
  NearbyStopsRoute() => (
    title: 'Departures near you',
    showsHeader: false,
    sdkWidget: 'NearbyStopsPage',
  ),
  StopsOnMapRoute() => (
    title: 'Stops on the map',
    showsHeader: false,
    sdkWidget: 'StopsOnMapPage',
  ),
  AlertsListRoute() => (
    title: 'Service alerts',
    showsHeader: false,
    sdkWidget: 'AlertsListPage',
  ),
  AlertDetailRoute() => (
    title: 'Service alert',
    showsHeader: false,
    sdkWidget: 'AlertDetailPage',
  ),
  ReportStopProblemRoute() || ReportTripProblemRoute() => (
    title: 'Report a problem',
    showsHeader: false,
    sdkWidget: 'Report problem page',
  ),
  // Anything else (settings, custom routes such as an itinerary's
  // details): keep the SDK page's own header under a section title.
  _ => (title: 'Transit', showsHeader: true, sdkWidget: 'SDK page'),
};

/// A Tapline route for any SDK [route]: [HostObaPage] around the page
/// `ObaRouteBuilder` builds for it.
///
/// The route's settings carry the [ObaRoute], as the SDK's own page routes
/// do, so `ObaNavigator.popToRoot` pops these and stops at Tapline's
/// screens. Building the page only builds a widget: it never navigates, so
/// it can't call back into `onNavigate` for itself.
Route<T> hostObaRoute<T>(ObaRoute route) => MaterialPageRoute<T>(
  settings: RouteSettings(name: route.id, arguments: route),
  builder: (context) {
    final chrome = hostChromeFor(route);
    return HostObaPage(
      title: chrome.title,
      sdkWidget: chrome.sdkWidget,
      showsHeader: chrome.showsHeader,
      child: ObaRouteBuilder.build(context, route),
    );
  },
);
