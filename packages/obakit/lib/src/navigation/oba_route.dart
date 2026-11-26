import 'package:flutter/widgets.dart';
import 'package:obakit_core/obakit_core.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import 'sheet_detents.dart';

/// The trip the rider was on when they tapped a transfer stop (iOS
/// `TransferContext`). Not part of a [StopRoute]'s identity.
@immutable
class ObaTransferContext {
  const ObaTransferContext({
    required this.arrivalTime,
    required this.fromRouteShortName,
    required this.fromTripHeadsign,
    this.fromTripId,
  });

  final DateTime arrivalTime;
  final String fromRouteShortName;
  final String fromTripHeadsign;
  final String? fromTripId;
}

/// Identifies one run of a trip, as the trip page needs it (iOS
/// `TripConvertible`): the trip and service date, plus the vehicle and the
/// stop the rider came from when known.
@immutable
class TripRef {
  const TripRef({
    required this.tripId,
    required this.serviceDate,
    this.vehicleId,
    this.stopId,
    this.stopSequence,
    this.destinationStopId,
  });

  /// From an arrival on a stop page.
  factory TripRef.fromArrival(ArrivalAndDeparture a) => TripRef(
    tripId: a.tripId,
    serviceDate: a.serviceDate,
    vehicleId: a.vehicleId,
    stopId: a.stopId,
    stopSequence: a.stopSequence,
  );

  /// From a shared trip link.
  factory TripRef.fromDeepLink(TripDeepLink link) => TripRef(
    tripId: link.tripId,
    serviceDate: link.serviceDate,
    vehicleId: link.vehicleId,
    stopId: link.stopId,
    stopSequence: link.stopSequence,
    destinationStopId: link.destinationStopId,
  );

  final String tripId;
  final DateTime serviceDate;
  final String? vehicleId;
  final String? stopId;
  final int? stopSequence;
  final String? destinationStopId;

  @override
  bool operator ==(Object other) =>
      other is TripRef &&
      other.tripId == tripId &&
      other.serviceDate == serviceDate &&
      other.vehicleId == vehicleId &&
      other.stopId == stopId &&
      other.stopSequence == stopSequence &&
      other.destinationStopId == destinationStopId;

  @override
  int get hashCode => Object.hash(
    tripId,
    serviceDate,
    vehicleId,
    stopId,
    stopSequence,
    destinationStopId,
  );
}

/// An onboarding page (shown full screen by the onboarding gate, before the
/// shell).
enum OnboardingStep {
  welcome(1),
  location(1),
  region(1);

  const OnboardingStep(this.version);

  /// Bump to show the step again to users who saw an older version.
  final int version;

  /// The key `ObaSettings.markOnboardingStepSeen` stores.
  String get settingsKey => 'onboarding.$name';
}

/// Every destination of the SDK. Mirrors iOS `AppSheetRoute` for the
/// ported features.
///
/// A route is a value: two routes with the same [id] are the same page (the
/// sheet navigator goes back to an open copy instead of stacking a second).
/// Its [detents] say how tall the sheet opens for it; they are ignored when
/// the page is shown outside the sheet (side panel, host navigator).
///
/// Which file builds each route is fixed by `ObaRouteBuilder`; see the
/// "Contributing a screen" section of the README. A feature that needs a
/// route nobody else uses can extend [ObaCustomRoute] in its own file
/// instead of editing this one.
@immutable
sealed class ObaRoute {
  const ObaRoute();

  /// Stable identity, also used as the analytics page name. Never contains
  /// coordinates or other personal data.
  String get id;

  /// Sheet heights for this route.
  ObaSheetDetents get detents;

  @override
  bool operator ==(Object other) =>
      other is ObaRoute && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @override
  String toString() => 'ObaRoute($id)';
}

// -- Base layer (home sheet) --------------------------------------------------

/// The home sheet (search field and Home / Recent / Bookmarks tabs).
final class HomeRoute extends ObaRoute {
  const HomeRoute();
  @override
  String get id => 'home';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.home;
}

final class SearchRoute extends ObaRoute {
  const SearchRoute({this.initialQuery});
  final String? initialQuery;
  @override
  String get id => 'search';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

/// The outcome of a search: the request, and the result when the search
/// screen already ran it.
final class SearchResultsRoute extends ObaRoute {
  const SearchResultsRoute(this.request, {this.result});
  final SearchRequest request;
  final SearchResult? result;
  @override
  String get id => 'searchResults-${request.type.name}-${request.query}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

/// Stops near [coordinate], or near the user (then the map centre) when
/// null.
final class NearbyStopsRoute extends ObaRoute {
  const NearbyStopsRoute({this.coordinate});
  final Coordinate? coordinate;
  @override
  String get id => coordinate == null ? 'nearbyAll' : 'nearbyStops';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

final class RecentStopsRoute extends ObaRoute {
  const RecentStopsRoute();
  @override
  String get id => 'recentStopsAll';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

final class BookmarksRoute extends ObaRoute {
  const BookmarksRoute();
  @override
  String get id => 'bookmarksAll';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

/// Weather forecast for the current region (Obaco).
final class WeatherRoute extends ObaRoute {
  const WeatherRoute();
  @override
  String get id => 'weather';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLarge;
}

/// A geocoded place or a dropped pin.
final class PlaceRoute extends ObaRoute {
  const PlaceRoute(this.place, {this.isDroppedPin = false});
  final Place place;
  final bool isDroppedPin;
  @override
  String get id => 'mapItem-${place.id ?? place.name}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumOnly;
}

final class TripPlannerRoute extends ObaRoute {
  const TripPlannerRoute({
    this.origin,
    this.destination,
    this.onItinerarySelected,
  });
  final Place? origin;
  final Place? destination;

  /// See `TripPlannerPage.onItinerarySelected`. Not part of [id] or
  /// equality: the planner is one page whoever listens to it.
  ///
  /// In the full-app shell (`ObaApp`), pushing this route while a trip
  /// planner with the same [id] is already open returns to that page, which
  /// keeps the callback and places it was opened with. A host that handles
  /// every route in `ObaScope.onNavigate` builds a new page each time and
  /// isn't affected.
  final void Function(BuildContext context, tp.Itinerary itinerary)?
  onItinerarySelected;
  @override
  String get id =>
      'tripPlanner_${[if (origin != null) 'origin', if (destination != null) 'destination'].join('_').ifEmpty('blank')}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.tripPlanner;
}

// -- Stop, trip, schedules, reporting -----------------------------------------

final class StopRoute extends ObaRoute {
  const StopRoute(this.stopId, {this.transfer});
  final String stopId;

  /// Not part of [id]: a stop is one page however it was reached.
  final ObaTransferContext? transfer;
  @override
  String get id => 'stopDetails-$stopId';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.stop;
}

final class TripRoute extends ObaRoute {
  const TripRoute(this.trip);
  final TripRef trip;
  @override
  String get id =>
      'tripDetails-${trip.tripId}${trip.destinationStopId == null ? '' : '-${trip.destinationStopId}'}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLarge;
}

/// The stops of a route, by direction, with its shape on the map.
final class RouteStopsRoute extends ObaRoute {
  const RouteStopsRoute(this.routeId);
  final String routeId;
  @override
  String get id => 'routeStops-$routeId';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLarge;
}

final class StopScheduleRoute extends ObaRoute {
  const StopScheduleRoute(this.stopId, {this.date});
  final String stopId;
  final DateTime? date;
  @override
  String get id => 'stopSchedule-$stopId';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

final class RouteScheduleRoute extends ObaRoute {
  const RouteScheduleRoute(this.routeId, {this.date, this.stopId});
  final String routeId;
  final DateTime? date;

  /// The stop the rider came from, to highlight.
  final String? stopId;
  @override
  String get id => 'routeSchedule-$routeId';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

final class ReportStopProblemRoute extends ObaRoute {
  const ReportStopProblemRoute(this.stopId);
  final String stopId;
  @override
  String get id => 'reportStopProblem-$stopId';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

final class ReportTripProblemRoute extends ObaRoute {
  const ReportTripProblemRoute(this.trip, {this.arrival});
  final TripRef trip;

  /// The arrival the report is about, when reported from a stop page.
  final ArrivalAndDeparture? arrival;
  @override
  String get id => 'reportTripProblem-${trip.tripId}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

// -- Bookmarks, recents, alerts, agencies -------------------------------------

/// Create a bookmark for [stop] (optionally for one trip of it, via
/// [arrival]), or edit [bookmark].
final class BookmarkEditorRoute extends ObaRoute {
  const BookmarkEditorRoute({this.bookmark, this.stop, this.arrival})
    : assert(bookmark != null || stop != null);
  final Bookmark? bookmark;
  final Stop? stop;
  final ArrivalAndDeparture? arrival;
  @override
  String get id =>
      'bookmarkEditor-${bookmark?.id ?? '${stop?.id}-${arrival?.tripId ?? ''}'}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

final class ManageBookmarksRoute extends ObaRoute {
  const ManageBookmarksRoute();
  @override
  String get id => 'manageBookmarks';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

/// Service alerts: all of the region's, or those for [stopId] / [routeId].
final class AlertsListRoute extends ObaRoute {
  const AlertsListRoute({this.stopId, this.routeId});
  final String? stopId;
  final String? routeId;
  @override
  String get id => 'alerts-${stopId ?? ''}-${routeId ?? ''}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

final class AlertDetailRoute extends ObaRoute {
  const AlertDetailRoute(this.situation);
  final Situation situation;
  @override
  String get id => 'transitAlert-${situation.id}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

final class AgenciesRoute extends ObaRoute {
  const AgenciesRoute();
  @override
  String get id => 'agencies';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

// -- Settings, regions, more --------------------------------------------------

final class SettingsRoute extends ObaRoute {
  const SettingsRoute();
  @override
  String get id => 'settings';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

final class MapSettingsRoute extends ObaRoute {
  const MapSettingsRoute();
  @override
  String get id => 'mapSettings';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLarge;
}

final class MoreRoute extends ObaRoute {
  const MoreRoute();
  @override
  String get id => 'more';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

final class RegionPickerRoute extends ObaRoute {
  const RegionPickerRoute();
  @override
  String get id => 'regionPicker';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

/// Add a custom region (prefilled from an add-region link) or edit one.
final class CustomRegionRoute extends ObaRoute {
  const CustomRegionRoute({this.prefill, this.editRegionId});
  final AddRegionData? prefill;
  final int? editRegionId;
  @override
  String get id => 'customRegion-${editRegionId ?? 'new'}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

final class CreditsRoute extends ObaRoute {
  const CreditsRoute();
  @override
  String get id => 'credits';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

/// One onboarding page, when shown as a route (e.g. re-run from Settings).
final class OnboardingRoute extends ObaRoute {
  const OnboardingRoute(this.step);
  final OnboardingStep step;
  @override
  String get id => 'onboarding-${step.name}';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;
}

// -- Map ----------------------------------------------------------------------

/// The stops currently on the map, as a list: the accessible alternative to
/// the map's pins.
final class StopsOnMapRoute extends ObaRoute {
  const StopsOnMapRoute();
  @override
  String get id => 'stopsOnMap';
  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLargeOpenLarge;
}

// -- Extension point ----------------------------------------------------------

/// A route defined outside this file, by a feature or a host. Subclasses
/// implement [id], [detents] and [build]; `ObaRouteBuilder` calls [build].
abstract class ObaCustomRoute extends ObaRoute {
  const ObaCustomRoute();

  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLarge;

  /// Builds the page (normally an `ObaSheetPage`).
  Widget build(BuildContext context);
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
