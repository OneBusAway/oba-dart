// OWNER: search agent (search, search results, nearby stops, places, trip
// planner, weather, and the Nearby / Explore home sections). Replace the
// placeholders; keep the function and public class names. Extra files go
// in lib/src/features/search/.
//
// `buildHomeRoute` returns the scaffold's home sheet (tabs + search
// field); contribute Home tab content through `searchHomeSections`.

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../l10n/strings_bridge.dart';
import '../../navigation/home_sections.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../map/map_coordinator.dart';
import '../map/map_logic.dart';
import '../../platform/trip_place_search_bridge.dart';
import '../../shell/home_sheet.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'explore_section.dart';
import 'nearby.dart';
import 'place_page.dart';
import 'search_page.dart';
import 'search_results_page.dart';
import 'weather.dart';

export 'explore_section.dart' show ExploreSection;
export 'nearby.dart'
    show
        NearbyStopsSection,
        NearbyStopsPage,
        ObaNearbyStopsCard,
        NearbyDepartureTile,
        NearbyDeparturesController;
export 'place_page.dart' show PlacePage;
export 'search_page.dart' show SearchPage, SearchScope, SearchSessionController;
export 'search_results_page.dart' show SearchResultsPage;
export 'weather.dart'
    show WeatherPage, ObaWeatherButton, ObaWeatherIcon, obaWeatherService;

Widget buildHomeRoute(BuildContext context, HomeRoute route) =>
    const ObaHomeSheet();

Widget buildSearchRoute(BuildContext context, SearchRoute route) =>
    SearchPage(initialQuery: route.initialQuery);

Widget buildSearchResultsRoute(
  BuildContext context,
  SearchResultsRoute route,
) => SearchResultsPage(request: route.request, result: route.result);

Widget buildNearbyStopsRoute(BuildContext context, NearbyStopsRoute route) =>
    NearbyStopsPage(coordinate: route.coordinate);

Widget buildPlaceRoute(BuildContext context, PlaceRoute route) =>
    PlacePage(place: route.place, isDroppedPin: route.isDroppedPin);

Widget buildTripPlannerRoute(BuildContext context, TripPlannerRoute route) =>
    TripPlannerPage(origin: route.origin, destination: route.destination);

Widget buildWeatherRoute(BuildContext context, WeatherRoute route) =>
    const WeatherPage();

/// The weather button in the map's top-start corner (the shell's weather
/// slot). It hides itself when the region has no weather server or the
/// forecast fails to load.
Widget? buildWeatherAccessory(BuildContext context) => const ObaWeatherButton();

List<ObaHomeSection> get searchHomeSections => [
  ObaHomeSection(
    id: 'nearby',
    order: 20,
    builder: (_) => const NearbyStopsSection(excludeBookmarkedTrips: true),
  ),
  ObaHomeSection(
    id: 'explore',
    order: 40,
    builder: (_) => const ExploreSection(),
  ),
];

/// The OTP trip planner for the current region, wired to the app's place
/// search, location and map tiles. Embeddable: needs only an `ObaScope`.
class TripPlannerPage extends StatelessWidget {
  const TripPlannerPage({super.key, this.origin, this.destination});

  final Place? origin;
  final Place? destination;

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context);
    final l10n = context.obaL10n;
    final otp = app.otpClient();
    if (otp == null) {
      return ObaSheetPage(
        title: l10n.titleTripPlanner,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: ObaEmptyState(
              icon: Icons.directions_outlined,
              title: l10n.tripPlanningUnavailable,
            ),
          ),
        ],
      );
    }
    final strings = context.obaTripPlannerStrings;
    final map = app.map;
    final mapConfig = tp.TripMapConfig(
      userAgentPackageName: map.userAgentPackageName,
      tileUrlTemplate: map.standard.urlTemplate,
      attribution: map.standard.attribution,
      tileProvider: map.tileProvider,
    );
    return ObaSheetPage(
      title: l10n.titleTripPlanner,
      body: tp.TripPlannerView(
        service: otp,
        strings: strings,
        placeSearch: app.tripPlaceSearch ?? const _NoPlaceSearch(),
        mapConfig: mapConfig,
        distanceUnits: obaDistanceUnits(context) == DistanceUnits.imperial
            ? tp.DistanceUnits.imperial
            : tp.DistanceUnits.metric,
        // Through ObaNavigator, so in the shell the details open as a sheet
        // page with the trip drawn on the main map (not a second map under
        // a full-screen app bar), and a host's onNavigate can take over.
        onItineraryTap: (context, itinerary) =>
            ObaNavigator.of(context)
                .push(ItineraryRoute(itinerary, mapConfig: mapConfig)),
        initialOrigin: origin == null
            ? null
            : PlaceSearchTripBridge.toTripPlace(origin!),
        initialDestination: destination == null
            ? null
            : PlaceSearchTripBridge.toTripPlace(destination!),
        currentLocation: () async {
          final l = app.core.currentLocation;
          if (l == null) return null;
          return tp.TripPlace(
            name: strings.currentLocation,
            lat: l.lat,
            lon: l.lon,
            isCurrentLocation: true,
          );
        },
      ),
    );
  }
}

/// One planned itinerary's step-by-step directions. With a map (the shell)
/// the trip is drawn on it and the page shows the steps only; without one
/// the page shows its own map above the steps.
class ItineraryRoute extends ObaCustomRoute {
  const ItineraryRoute(this.itinerary, {required this.mapConfig});

  final tp.Itinerary itinerary;
  final tp.TripMapConfig mapConfig;

  @override
  String get id =>
      'itinerary/${itinerary.startTime.millisecondsSinceEpoch}-'
      '${itinerary.endTime.millisecondsSinceEpoch}-${itinerary.legs.length}';

  @override
  Widget build(BuildContext context) =>
      _ItineraryPage(itinerary: itinerary, mapConfig: mapConfig);
}

class _ItineraryPage extends StatelessWidget {
  const _ItineraryPage({required this.itinerary, required this.mapConfig});

  final tp.Itinerary itinerary;
  final tp.TripMapConfig mapConfig;

  @override
  Widget build(BuildContext context) {
    final strings = context.obaTripPlannerStrings;
    final hasMap = ObaMapCoordinator.maybeOf(context) != null;
    final tripTheme = tp.TripPlannerTheme.of(context);
    Coordinate c(tp.GeoPoint p) => Coordinate(p.lat, p.lon);
    final legs = itinerary.legs;
    final lines = [
      for (final leg in legs)
        ObaMapPolyline(
          points: [for (final p in leg.geometry) c(p)],
          color: tripTheme.colorForLeg(leg),
          dashed: tp.LegKind.of(leg) == tp.LegKind.walk,
        ),
    ];
    final markers = [
      if (legs.isNotEmpty) ...[
        ObaMapMarker(
          coordinate: c(legs.first.from.point),
          label: legs.first.from.name,
          kind: ObaMapMarkerKind.origin,
        ),
        ObaMapMarker(
          coordinate: c(legs.last.to.point),
          label: legs.last.to.name,
          kind: ObaMapMarkerKind.destination,
        ),
      ],
    ];
    return ObaMapOverlays(
      overlay: ObaMapOverlay(
        polylines: lines,
        markers: markers,
        hideStopPins: true,
        fitBounds: ObaMapLogic.boundsOf([for (final l in lines) ...l.points]),
      ),
      child: ObaSheetPage(
        title: strings.tripDetails,
        body: tp.ItineraryDetailView(
          itinerary: itinerary,
          mapConfig: mapConfig,
          distanceUnits: obaDistanceUnits(context) == DistanceUnits.imperial
              ? tp.DistanceUnits.imperial
              : tp.DistanceUnits.metric,
          showMap: !hasMap,
          strings: strings,
        ),
      ),
    );
  }
}

class _NoPlaceSearch implements tp.TripPlaceSearch {
  const _NoPlaceSearch();

  @override
  Future<List<tp.TripPlace>> search(String query, {tp.TripPlace? near}) async =>
      const [];
}
