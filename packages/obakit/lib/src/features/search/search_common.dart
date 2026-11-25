import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/application.dart';
import '../../l10n/l10n.dart';
import '../../l10n/strings_bridge.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../navigation/presentation.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/states.dart';

/// Where a search result leads when it needs no list (iOS
/// `SearchResultRouter`): one stop, one route, one vehicle on a trip, or
/// one place. Null when the result needs a list or matched nothing.
ObaRoute? searchResultDestination(SearchResult result) => switch (result) {
  StopSearchResult(:final stops) when stops.length == 1 => StopRoute(
    stops.single.id,
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

// -- Departure display ----------------------------------------------------------

/// Short and spoken countdowns and the real-time status of a departure,
/// with the status colour. Status is always carried by text as well as
/// colour.
class DepartureDisplay {
  DepartureDisplay._({
    required this.eta,
    required this.etaSpoken,
    required this.status,
    required this.statusColor,
    required this.isRealTime,
  });

  factory DepartureDisplay.of(
    BuildContext context,
    ArrivalAndDeparture a,
    DateTime now,
  ) {
    final l10n = context.obaL10n;
    final theme = ObaTheme.of(context);
    final minutes = (a.minutesUntil(now) ?? 0).clamp(0, 9999);
    final status = a.scheduleStatus;
    final deviation = a.deviationFromScheduleInMinutes.abs();
    return DepartureDisplay._(
      eta: minutes == 0 ? l10n.searchEtaNow : l10n.searchEtaMinutes(minutes),
      etaSpoken: minutes == 0
          ? l10n.searchEtaNowSpoken
          : l10n.searchEtaMinutesSpoken(minutes),
      status: switch (status) {
        ScheduleStatus.unknown => l10n.searchStatusScheduled,
        ScheduleStatus.onTime => l10n.searchStatusOnTime,
        ScheduleStatus.delayed => l10n.searchStatusLate(deviation),
        ScheduleStatus.early => l10n.searchStatusEarly(deviation),
      },
      statusColor: switch (status) {
        ScheduleStatus.unknown => theme.scheduled,
        ScheduleStatus.onTime => theme.onTime,
        ScheduleStatus.delayed => theme.late,
        ScheduleStatus.early => theme.early,
      },
      isRealTime: status != ScheduleStatus.unknown,
    );
  }

  final String eta;
  final String etaSpoken;
  final String status;
  final Color statusColor;
  final bool isRealTime;
}

// -- Distance -------------------------------------------------------------------

/// "350 m" or "0.2 mi", following the locale's measurement system.
String formatDistance(BuildContext context, double meters) {
  return context.obaFormatters.distance(
    meters,
    units: obaDistanceUnits(context),
  );
}
