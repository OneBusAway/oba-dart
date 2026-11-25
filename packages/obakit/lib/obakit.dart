/// The OneBusAway app as an embeddable Flutter SDK (the counterpart of iOS
/// OBAKit): application object and scope, theme, localization, navigation
/// shell, map, and every screen.
///
/// Re-exports `obakit_core` (and through it the `onebusaway` client), with
/// these names hidden because they clash:
/// - `Route` (Flutter's navigator `Route`): import
///   `package:onebusaway/onebusaway.dart` with a prefix for the model;
/// - `Polyline` (the encoded-polyline codec; flutter_map has a `Polyline`
///   widget): use `ObaMapPolyline.encoded`, or import `onebusaway` with a
///   prefix.
///
/// `Place` (a geocoded place) is exported; `obakit_trip_planner` also has a
/// `Place` model, so import the trip planner with a prefix if you use both.
library;

export 'package:obakit_core/obakit_core.dart' hide Route, Polyline;

export 'src/app/application.dart';
export 'src/app/deep_links.dart';
export 'src/app/location_holder.dart';
export 'src/app/map_config.dart';
export 'src/app/oba_app.dart';
export 'src/app/onboarding_gate.dart';
export 'src/app/polling.dart' show ObaPollable, ObaPollingHolder;
export 'src/app/scope.dart';
export 'src/features/bookmarks/bookmarks_routes.dart'
    show
        AlarmsSection,
        AlertsLoader,
        BookmarksSection,
        ObaBookmarksCard,
        ObaUrlOpener,
        RecentStopsSection,
        ServiceAlertsSection,
        RecentStopsPage,
        BookmarksPage,
        BookmarkEditorPage,
        ManageBookmarksPage,
        AlertsListPage,
        AlertDetailPage,
        AgenciesPage;
export 'src/features/map/camera_store.dart';
export 'src/features/map/map_coordinator.dart';
export 'src/features/map/map_logic.dart';
export 'src/features/map/map_markers.dart' show ObaStopPin, kObaMarkerTarget;
export 'src/features/map/map_routes.dart' show MapSettingsPage, StopsOnMapPage;
export 'src/features/map/map_view.dart';
export 'src/features/search/search_routes.dart'
    show
        NearbyStopsSection,
        SearchPage,
        SearchResultsPage,
        NearbyStopsPage,
        PlacePage,
        TripPlannerPage,
        ItineraryRoute,
        WeatherPage,
        ExploreSection,
        ObaNearbyStopsCard,
        NearbyDepartureTile,
        NearbyDeparturesController,
        SearchScope,
        SearchSessionController,
        ObaWeatherButton,
        ObaWeatherIcon,
        obaWeatherService;
export 'src/features/settings/settings_routes.dart'
    show
        SettingsPage,
        MorePage,
        RegionPickerPage,
        CustomRegionPage,
        CreditsPage,
        OnboardingStepPage,
        SettingsAndMoreSection,
        ObaSurveyCard,
        ObaSurveyPage,
        ObaSurveyRoute,
        SurveyQuestionField,
        ObaDonationCard,
        ObaDonationPage,
        ObaDonationRoute,
        ObaFeedbackPrompt,
        ObaLicensesPage,
        ObaLicensesRoute,
        ObaLinkOpener,
        ObaLinkOpenerScope,
        UrlLauncherLinkOpener,
        ObaSupport,
        ObaSettingSwitch,
        ObaChoiceGroup;
export 'src/features/stop/stop_routes.dart'
    show
        StopPage,
        TripPage,
        RouteStopsPage,
        StopSchedulePage,
        RouteSchedulePage,
        ReportStopProblemPage,
        ReportTripProblemPage,
        ObaDepartureRow,
        ObaDepartureAction,
        ObaDepartureRowStyle,
        StopArrivalsController,
        StopArrivalsState,
        StopArrivalsStatus,
        StopHeader,
        ObaStopDeparturesCard,
        TripController,
        TripState,
        TripStopTile,
        GhostBusReportRoute,
        GhostBusReportPage,
        StopAlertsSection,
        StopStaleBanner,
        StopFooter,
        WalkTimeDivider,
        RouteGroupHeader,
        StopFilterSheet,
        ScheduleHourRow,
        ScheduleDateBar;
export 'src/l10n/l10n.dart';
export 'src/l10n/strings_bridge.dart';
export 'src/navigation/home_sections.dart';
export 'src/navigation/oba_navigator.dart';
export 'src/navigation/oba_route.dart';
export 'src/navigation/presentation.dart';
export 'src/navigation/route_builder.dart';
export 'src/navigation/sheet_controller.dart';
export 'src/navigation/sheet_detents.dart';
export 'src/platform/geolocator_location_provider.dart' hide GeolocatorApi;
export 'src/platform/listenable_adapter.dart';
export 'src/platform/nominatim_place_search.dart';
export 'src/platform/shared_preferences_store.dart';
export 'src/platform/trip_place_search_bridge.dart';
export 'src/shell/home_sheet.dart' show ObaHomeSheet, ObaSearchFieldButton;
export 'src/shell/home_shell.dart';
export 'src/theme/oba_theme.dart';
export 'src/widgets/heading.dart';
export 'src/widgets/rows.dart';
export 'src/widgets/sheet_page.dart' hide ObaMeasureSize, RenderObaMeasureSize;
export 'src/widgets/states.dart';
