import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import '../chosen_trip.dart';
import 'embed_frame.dart';

/// A full-screen host route: the host's own app bar over one embedded OBA
/// page.
///
/// The app's single `ObaScope` sits above the navigator (see `app.dart`),
/// so this route needs no scope of its own. The page is marked embedded, so
/// it drops its own Scaffold and AppBar and the host's app bar is the only
/// one.
class HostObaPage extends StatelessWidget {
  const HostObaPage({
    super.key,
    required this.title,
    required this.sdkWidget,
    required this.child,
    this.showsHeader = false,
  });

  final String title;

  /// The SDK widget's name, for the embed overlay.
  final String sdkWidget;
  final Widget child;

  /// Whether the page shows its own compact header (title and actions).
  final bool showsHeader;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    // OBA embed: a whole SDK page under the host app bar.
    body: EmbedFrame(
      sdkWidget: sdkWidget,
      fills: true,
      child: ObaPresentationScope.embedded(
        showsHeader: showsHeader,
        child: child,
      ),
    ),
  );
}

/// How the host presents one SDK route: its app bar title, whether the SDK
/// page keeps its own header, and the page's name for the embed overlay.
///
/// Pages whose title is data (a stop's name, a trip, a route, a place) keep
/// the SDK header, and the host app bar names the section the rider came
/// from, so the title shows once. Pages with a fixed title drop the SDK
/// header and the host app bar carries that title instead.
typedef HostChrome = ({String title, bool showsHeader, String sdkWidget});

HostChrome hostChromeFor(ObaRoute route) => switch (route) {
  StopRoute() => (title: 'Transit', showsHeader: true, sdkWidget: 'StopPage'),
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
  TripPlannerRoute(:final destination) => (
    title: destination == null
        ? 'Trip planner'
        : 'Directions to ${destination.name}',
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
    title: 'Nearby stops',
    showsHeader: false,
    sdkWidget: 'NearbyStopsPage',
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

/// A host route for any SDK [route]: [HostObaPage] around the page
/// `ObaRouteBuilder` builds for it.
///
/// The route's settings carry the [ObaRoute], as the SDK's own page routes
/// do, so `ObaNavigator.popToRoot` pops these and stops at the host's
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

/// The trip planner, as its own route, to [name] at [coordinate] (or with
/// no destination when they are null).
///
/// Goes through `ObaNavigator`, so it reaches the host's `onNavigate` and
/// opens under the host app bar like any other SDK destination. When the
/// student opens an itinerary, `onItinerarySelected` keeps it in the app's
/// [ChosenTrip], and Today shows when to leave.
Future<void> openTripPlanner(
  BuildContext context, {
  String? name,
  Coordinate? coordinate,
}) => ObaNavigator.of(context).push<void>(
  // OBA embed: the OTP trip planner, destination prefilled.
  TripPlannerRoute(
    destination: name == null || coordinate == null
        ? null
        : Place(name: name, coordinate: coordinate),
    onItinerarySelected: (context, itinerary) =>
        ChosenTripScope.read(context)?.choose(
          itinerary,
          destination: tripDestinationName(
            itinerary,
            name: name,
            coordinate: coordinate,
          ),
        ),
  ),
);

/// What Today calls the end of [itinerary]. The student can change the
/// destination in the planner, so the prefilled [name] is used only when
/// the trip ends within 100 m of [coordinate] (campus buildings are only
/// 200 to 300 m apart, so a wider radius would keep the old name after the
/// student picks a neighbouring building). Otherwise it's the last
/// place's name, unless OTP gave only its generic "Destination".
String tripDestinationName(
  tp.Itinerary itinerary, {
  String? name,
  Coordinate? coordinate,
}) {
  if (itinerary.legs.isEmpty) return name ?? 'your destination';
  final end = itinerary.legs.last.to;
  if (name != null &&
      coordinate != null &&
      distanceBetween(Coordinate(end.lat, end.lon), coordinate) <= 100) {
    return name;
  }
  final last = end.name.trim();
  return last.isEmpty || last == 'Destination' ? 'your destination' : last;
}
