import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/application.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../navigation/presentation.dart';
import '../../widgets/states.dart';

/// Where a search result leads when it needs no list (iOS
/// `SearchResultRouter`): one stop, one route, one vehicle on a trip, or
/// one place. Null when the result needs a list or matched nothing.
ObaRoute? searchResultDestination(SearchResult result) => switch (result) {
  StopSearchResult(:final stops) when stops.length == 1 => StopRoute(
    stops.single.id,
    name: stops.single.name,
  ),
  RouteSearchResult(:final routes) when routes.length == 1 => RouteStopsRoute(
    routes.single.id,
  ),
  PlaceSearchResult(:final places) when places.length == 1 => PlaceRoute(
    places.single,
  ),
  VehicleResult(:final vehicle) => vehicleTripRoute(vehicle),
  _ => null,
};

/// The trip page for a vehicle's current trip, or null when it is not
/// serving one.
TripRoute? vehicleTripRoute(VehicleStatus vehicle) {
  final status = vehicle.tripStatus;
  final tripId = vehicle.tripId ?? status?.activeTripId;
  final serviceDate = status?.serviceDate;
  if (tripId == null || tripId.isEmpty || serviceDate == null) return null;
  return TripRoute(
    TripRef(
      tripId: tripId,
      serviceDate: serviceDate,
      vehicleId: vehicle.vehicleId,
    ),
  );
}

/// Remembers a chosen place for the search page's recent places.
void rememberPlace(ObaApplication app, Place place) {
  app.core.userData.addRecentPlace(
    RecentPlace(
      name: place.name,
      subtitle: place.subtitle,
      lat: place.coordinate.lat,
      lon: place.coordinate.lon,
    ),
  );
}

/// Opens [route] from a search screen. In the shell's sheet or panel the
/// search page is replaced, so Back from the result returns home (as on
/// iOS); anywhere else (a host's navigator, an embedded search) it is
/// pushed, so the host's own page is never replaced.
void openFromSearch(BuildContext context, ObaRoute route) {
  final navigator = ObaNavigator.of(context);
  final presentation = ObaPresentation.of(context);
  final inShell =
      presentation == ObaPresentation.sheet ||
      presentation == ObaPresentation.panel;
  if (inShell && navigator.canPop) {
    navigator.replace(route);
  } else {
    navigator.push(route);
  }
}

/// A rider-facing explanation of a search failure.
String searchErrorText(BuildContext context, Object error) {
  final l10n = context.obaL10n;
  if (error is SearchUnavailableException) {
    return switch (error.type) {
      SearchType.address => l10n.searchUnavailableAddress,
      SearchType.vehicleId when error.reason.contains('Obaco') =>
        l10n.searchUnavailableVehicle,
      _ => l10n.searchUnavailableNoRegion,
    };
  }
  return ObaErrorState.messageFor(context, error);
}

/// The quick-search row title for [request] ("Route: 10").
String quickSearchTitle(ObaLocalizations l10n, SearchRequest request) =>
    switch (request.type) {
      SearchType.route => l10n.searchQuickRoute(request.query),
      SearchType.stopNumber => l10n.searchQuickStop(request.query),
      SearchType.address => l10n.searchQuickAddress(request.query),
      SearchType.vehicleId => l10n.searchQuickVehicle(request.query),
    };

IconData searchTypeIcon(SearchType type) => switch (type) {
  SearchType.route => Icons.route,
  SearchType.stopNumber => Icons.signpost_outlined,
  SearchType.address => Icons.place_outlined,
  SearchType.vehicleId => Icons.directions_bus_outlined,
};
