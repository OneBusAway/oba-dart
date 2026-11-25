import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'oba_localizations_ar.dart';
import 'oba_localizations_en.dart';
import 'oba_localizations_es.dart';
import 'oba_localizations_fil.dart';
import 'oba_localizations_fr.dart';
import 'oba_localizations_it.dart';
import 'oba_localizations_ko.dart';
import 'oba_localizations_pl.dart';
import 'oba_localizations_pt.dart';
import 'oba_localizations_ru.dart';
import 'oba_localizations_vi.dart';
import 'oba_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ObaLocalizations
/// returned by `ObaLocalizations.of(context)`.
///
/// Applications need to include `ObaLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/oba_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ObaLocalizations.localizationsDelegates,
///   supportedLocales: ObaLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the ObaLocalizations.supportedLocales
/// property.
abstract class ObaLocalizations {
  ObaLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ObaLocalizations? of(BuildContext context) {
    return Localizations.of<ObaLocalizations>(context, ObaLocalizations);
  }

  static const LocalizationsDelegate<ObaLocalizations> delegate =
      _ObaLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fil'),
    Locale('fr'),
    Locale('it'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// Button that returns to the previous screen.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Button that closes the current panel or screen.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Button that confirms and closes a screen.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// Button that dismisses without saving.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Button that repeats a failed request.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// Button that moves to the next onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// Button that skips an optional onboarding step.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get commonNotNow;

  /// Link at the end of a home section that opens the full list.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// Spoken by screen readers while content loads.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// Title of the error state shown when content fails to load.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonErrorTitle;

  /// Generic title of an empty list.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get commonEmptyTitle;

  /// Title of a placeholder screen that is not built yet.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// Body of a placeholder screen that is not built yet.
  ///
  /// In en, this message translates to:
  /// **'This screen isn\'t available yet.'**
  String get commonComingSoonBody;

  /// Error body when the device has no network.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Check your connection and try again.'**
  String get commonOffline;

  /// Error body when the OBA server fails.
  ///
  /// In en, this message translates to:
  /// **'The server didn\'t respond as expected. Try again in a moment.'**
  String get commonServerError;

  /// Screen reader label of the draggable panel over the map.
  ///
  /// In en, this message translates to:
  /// **'Panel'**
  String get sheetLabel;

  /// Accessibility action and button that makes the panel over the map taller.
  ///
  /// In en, this message translates to:
  /// **'Expand panel'**
  String get sheetExpand;

  /// Accessibility action and button that makes the panel over the map shorter, showing more map.
  ///
  /// In en, this message translates to:
  /// **'Collapse panel'**
  String get sheetCollapse;

  /// Screen reader hint on the panel's drag handle.
  ///
  /// In en, this message translates to:
  /// **'Drag or double-tap to resize the panel'**
  String get sheetHandleHint;

  /// Title of the first tab on the home panel: bookmarks, nearby departures and recent stops. Short.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabHome;

  /// Title of the tab listing recently viewed stops. Short.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get homeTabRecent;

  /// Title of the tab listing bookmarked stops and trips. Short.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get homeTabBookmarks;

  /// Placeholder of the search field at the top of the home panel.
  ///
  /// In en, this message translates to:
  /// **'Search stops, routes, places'**
  String get homeSearchPlaceholder;

  /// Screen reader label of the search field at the top of the home panel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get homeSearchLabel;

  /// Header of the home section listing departures from nearby stops.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get homeSectionNearby;

  /// Header of the home section listing recently viewed stops.
  ///
  /// In en, this message translates to:
  /// **'Recent stops'**
  String get homeSectionRecent;

  /// Header of the home section listing bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get homeSectionBookmarks;

  /// Header of the home section listing service alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get homeSectionAlerts;

  /// Header of the home section with shortcuts (trip planner, agencies...).
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get homeSectionExplore;

  /// Header of the home section with settings and the More screen.
  ///
  /// In en, this message translates to:
  /// **'Settings and more'**
  String get homeSectionMore;

  /// Screen reader label of the map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapLabel;

  /// Status pill on the map when it is too zoomed out to show stops.
  ///
  /// In en, this message translates to:
  /// **'Zoom in to see stops'**
  String get mapZoomInForStops;

  /// Status pill on the map when the user denied location access.
  ///
  /// In en, this message translates to:
  /// **'Location access is off. Tap to allow.'**
  String get mapLocationDenied;

  /// Status pill on the map when device location services are disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are off'**
  String get mapLocationServicesOff;

  /// Button that centres the map on the user's location.
  ///
  /// In en, this message translates to:
  /// **'Show my location'**
  String get mapRecenter;

  /// Button that opens map settings (map type, labels).
  ///
  /// In en, this message translates to:
  /// **'Map settings'**
  String get mapSettingsButton;

  /// Button that opens a list of the stops currently visible on the map, an accessible alternative to the map.
  ///
  /// In en, this message translates to:
  /// **'Stops on the map'**
  String get mapStopsListButton;

  /// Announced to screen readers when the stops shown on the map change.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No stops on the map} =1{1 stop on the map} other{{count} stops on the map}}'**
  String mapVisibleStopsCount(int count);

  /// Screen reader label of the user location dot.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get mapCurrentLocation;

  /// Name of a place the user marked with a long press on the map.
  ///
  /// In en, this message translates to:
  /// **'Dropped pin'**
  String get mapDroppedPin;

  /// Screen reader label of a vehicle marker on the map.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get mapVehicle;

  /// Appended to a stop marker's screen reader label when it is the selected stop.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get mapSelectedStop;

  /// Appended to a stop marker's screen reader label when the stop is bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get mapBookmarkedStop;

  /// Screen reader label of a stop marker. routeType is e.g. Bus.
  ///
  /// In en, this message translates to:
  /// **'{name}, {routeType} stop'**
  String mapStopMarkerLabel(String name, String routeType);

  /// Screen reader hint on a stop marker.
  ///
  /// In en, this message translates to:
  /// **'Opens the stop\'s departures'**
  String get mapStopMarkerHint;

  /// Map attribution text, e.g. Map data: OpenStreetMap contributors.
  ///
  /// In en, this message translates to:
  /// **'Map data: {attribution}'**
  String mapAttribution(String attribution);

  /// Header of the map type choice in map settings.
  ///
  /// In en, this message translates to:
  /// **'Map type'**
  String get mapTypeTitle;

  /// Standard (street) map type.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get mapTypeStandard;

  /// Satellite imagery map type.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapTypeSatellite;

  /// Satellite imagery with street labels map type.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get mapTypeHybrid;

  /// Map setting: show the scale bar.
  ///
  /// In en, this message translates to:
  /// **'Show scale'**
  String get mapShowScale;

  /// Map setting: show which way the device faces.
  ///
  /// In en, this message translates to:
  /// **'Show heading'**
  String get mapShowHeading;

  /// Map setting: show stop names under pins.
  ///
  /// In en, this message translates to:
  /// **'Show stop labels'**
  String get mapShowStopLabels;

  /// Screen reader label of a marker for a coordinate.
  ///
  /// In en, this message translates to:
  /// **'Location at {lat}, {lon}'**
  String mapPlaceAt(String lat, String lon);

  /// Stop direction.
  ///
  /// In en, this message translates to:
  /// **'Northbound'**
  String get directionN;

  /// Stop direction.
  ///
  /// In en, this message translates to:
  /// **'Northeast bound'**
  String get directionNE;

  /// Stop direction.
  ///
  /// In en, this message translates to:
  /// **'Eastbound'**
  String get directionE;

  /// Stop direction.
  ///
  /// In en, this message translates to:
  /// **'Southeast bound'**
  String get directionSE;

  /// Stop direction.
  ///
  /// In en, this message translates to:
  /// **'Southbound'**
  String get directionS;

  /// Stop direction.
  ///
  /// In en, this message translates to:
  /// **'Southwest bound'**
  String get directionSW;

  /// Stop direction.
  ///
  /// In en, this message translates to:
  /// **'Westbound'**
  String get directionW;

  /// Stop direction.
  ///
  /// In en, this message translates to:
  /// **'Northwest bound'**
  String get directionNW;

  /// GTFS route type.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get routeTypeBus;

  /// GTFS route type (tram, streetcar, light rail).
  ///
  /// In en, this message translates to:
  /// **'Light rail'**
  String get routeTypeLightRail;

  /// GTFS route type.
  ///
  /// In en, this message translates to:
  /// **'Subway'**
  String get routeTypeSubway;

  /// GTFS route type (intercity or commuter rail).
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get routeTypeRail;

  /// GTFS route type.
  ///
  /// In en, this message translates to:
  /// **'Ferry'**
  String get routeTypeFerry;

  /// GTFS route type.
  ///
  /// In en, this message translates to:
  /// **'Cable car'**
  String get routeTypeCableCar;

  /// GTFS route type (aerial lift).
  ///
  /// In en, this message translates to:
  /// **'Gondola'**
  String get routeTypeGondola;

  /// GTFS route type.
  ///
  /// In en, this message translates to:
  /// **'Funicular'**
  String get routeTypeFunicular;

  /// Fallback for an unknown GTFS route type.
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get routeTypeUnknown;

  /// Rider-facing stop number, e.g. Stop 24151.
  ///
  /// In en, this message translates to:
  /// **'Stop {code}'**
  String stopCode(String code);

  /// Screen reader sentence for a stop row: name, then code, direction and routes.
  ///
  /// In en, this message translates to:
  /// **'{name}, {details}'**
  String stopRowLabel(String name, String details);

  /// List of routes serving a stop, e.g. Routes 10, 44.
  ///
  /// In en, this message translates to:
  /// **'Routes {routes}'**
  String stopRoutes(String routes);

  /// Button that reloads the departures.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get stopPageRefresh;

  /// Screen-reader announcement after a manual refresh.
  ///
  /// In en, this message translates to:
  /// **'Departures updated'**
  String get stopPageRefreshed;

  /// Button that bookmarks the stop.
  ///
  /// In en, this message translates to:
  /// **'Bookmark stop'**
  String get stopPageBookmark;

  /// Bookmark button when the stop is already bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked. Edit bookmark'**
  String get stopPageBookmarked;

  /// Overflow menu button on the stop page.
  ///
  /// In en, this message translates to:
  /// **'More stop actions'**
  String get stopPageMoreActions;

  /// Opens the stop schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get stopPageSchedules;

  /// Opens the stop service alerts list.
  ///
  /// In en, this message translates to:
  /// **'Service alerts'**
  String get stopPageServiceAlerts;

  /// Opens stops near this stop.
  ///
  /// In en, this message translates to:
  /// **'Nearby stops'**
  String get stopPageNearbyStops;

  /// Opens walking directions to the stop.
  ///
  /// In en, this message translates to:
  /// **'Walking directions'**
  String get stopPageWalkingDirections;

  /// Opens cycling directions to the stop (bike mode).
  ///
  /// In en, this message translates to:
  /// **'Cycling directions'**
  String get stopPageBikeDirections;

  /// Opens the trip planner starting at the stop.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip from here'**
  String get stopPagePlanTripFrom;

  /// Opens the trip planner ending at the stop.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip to here'**
  String get stopPagePlanTripTo;

  /// Shares a link to the stop.
  ///
  /// In en, this message translates to:
  /// **'Share stop'**
  String get stopPageShareStop;

  /// Opens the stop problem report form.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get stopPageReportProblem;

  /// Opens the per-stop route filter and sort sheet.
  ///
  /// In en, this message translates to:
  /// **'Filter routes'**
  String get stopPageFilterRoutes;

  /// Shown on the filter button when routes are hidden.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 route hidden} other{{count} routes hidden}}'**
  String stopPageRoutesHidden(int count);

  /// Segment: list departures chronologically.
  ///
  /// In en, this message translates to:
  /// **'By time'**
  String get stopPageModeTime;

  /// Segment: group departures by route.
  ///
  /// In en, this message translates to:
  /// **'By route'**
  String get stopPageModeRoute;

  /// Menu button for the real-time/scheduled filter.
  ///
  /// In en, this message translates to:
  /// **'Departure types'**
  String get stopPageDepartureTypes;

  /// Departure-type filter: everything.
  ///
  /// In en, this message translates to:
  /// **'All departures'**
  String get stopPageFilterAll;

  /// Departure-type filter: predicted only.
  ///
  /// In en, this message translates to:
  /// **'Real-time only'**
  String get stopPageFilterRealtime;

  /// Departure-type filter: schedule-only.
  ///
  /// In en, this message translates to:
  /// **'Scheduled only'**
  String get stopPageFilterScheduled;

  /// Toggle that reveals departures that already left.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Show 1 earlier departure} other{Show {count} earlier departures}}'**
  String stopPageEarlier(int count);

  /// Toggle that hides departures that already left.
  ///
  /// In en, this message translates to:
  /// **'Hide earlier departures'**
  String get stopPageHideEarlier;

  /// Button that widens the time window by 30 minutes.
  ///
  /// In en, this message translates to:
  /// **'Load more departures'**
  String get stopPageLoadMore;

  /// Footer describing the time window.
  ///
  /// In en, this message translates to:
  /// **'Showing the next {minutes} minutes'**
  String stopPageWindow(int minutes);

  /// Freshness line, e.g. "Updated 4 min. ago".
  ///
  /// In en, this message translates to:
  /// **'Updated {ago}'**
  String stopPageUpdated(String ago);

  /// Banner title when a refresh failed and the list is stale.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh departures'**
  String get stopPageStaleTitle;

  /// Banner body when the list is stale.
  ///
  /// In en, this message translates to:
  /// **'These times may be out of date.'**
  String get stopPageStaleBody;

  /// Empty state title.
  ///
  /// In en, this message translates to:
  /// **'No upcoming departures'**
  String get stopPageEmptyTitle;

  /// Empty state body.
  ///
  /// In en, this message translates to:
  /// **'Nothing departs in the next {minutes} minutes.'**
  String stopPageEmptyBody(int minutes);

  /// Empty state when hidden routes remove everything.
  ///
  /// In en, this message translates to:
  /// **'Every route with departures here is hidden.'**
  String get stopPageEmptyHiddenRoutes;

  /// Button that clears the hidden routes for this stop.
  ///
  /// In en, this message translates to:
  /// **'Show all routes'**
  String get stopPageShowAllRoutes;

  /// Empty state when the departure-type filter removes everything.
  ///
  /// In en, this message translates to:
  /// **'No departures match the departure-type filter.'**
  String get stopPageEmptyFilter;

  /// Button that resets the departure-type filter.
  ///
  /// In en, this message translates to:
  /// **'Show all departures'**
  String get stopPageShowAllTypes;

  /// Title when the server has no such stop.
  ///
  /// In en, this message translates to:
  /// **'Stop not found'**
  String get stopPageMissingTitle;

  /// Body when the server has no such stop.
  ///
  /// In en, this message translates to:
  /// **'This stop may have been removed or renumbered.'**
  String get stopPageMissingBody;

  /// Walk-time pill.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min walk'**
  String stopPageWalkTime(int minutes);

  /// Bike-time pill (bike mode).
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ride'**
  String stopPageBikeTime(int minutes);

  /// Screen-reader label of the walk pill.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute walk} other{{minutes} minute walk}}, {distance}. Opens directions.'**
  String stopPageWalkTimeLabel(int minutes, String distance);

  /// Screen-reader label of the bike pill.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute ride} other{{minutes} minute ride}}, {distance}. Opens directions.'**
  String stopPageBikeTimeLabel(int minutes, String distance);

  /// Divider between departures you would miss and those you can reach on foot.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min walk to this stop. Departures above leave sooner.'**
  String stopPageWalkDivider(int minutes);

  /// Divider in bike mode.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ride to this stop. Departures above leave sooner.'**
  String stopPageBikeDivider(int minutes);

  /// Agency attribution line.
  ///
  /// In en, this message translates to:
  /// **'Service by {names}'**
  String stopPageAgencies(String names);

  /// Header of the collapsible alerts section.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 service alert} other{{count} service alerts}}'**
  String stopPageAlertsCount(int count);

  /// Unread count in the alerts section header.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unread} other{{count} unread}}'**
  String stopPageAlertsUnread(int count);

  /// Marker on an unread alert.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get stopPageAlertUnread;

  /// Marker on a high-severity alert.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get stopPageAlertImportant;

  /// Title of the maps app chooser.
  ///
  /// In en, this message translates to:
  /// **'Open directions in'**
  String get stopPageDirectionsChooser;

  /// Maps app option.
  ///
  /// In en, this message translates to:
  /// **'Apple Maps'**
  String get stopPageAppleMaps;

  /// Maps app option.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get stopPageGoogleMaps;

  /// Shown when a link fails to open.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open that link.'**
  String get stopPageCannotOpen;

  /// Banner when the stop was opened as a transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer from {route} {headsign}, arriving {time}'**
  String stopPageTransfer(String route, String headsign, String time);

  /// Heading above the departures list.
  ///
  /// In en, this message translates to:
  /// **'Departures'**
  String get stopPageDeparturesHeader;

  /// Countdown for a departure in the current minute.
  ///
  /// In en, this message translates to:
  /// **'NOW'**
  String get stopRowNow;

  /// Countdown, e.g. "5 min".
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String stopRowMinutes(int minutes);

  /// Countdown for a past departure.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String stopRowMinutesAgo(int minutes);

  /// Schedule adherence.
  ///
  /// In en, this message translates to:
  /// **'on time'**
  String get stopRowOnTime;

  /// Schedule adherence.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min late'**
  String stopRowLate(int minutes);

  /// Schedule adherence.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min early'**
  String stopRowEarly(int minutes);

  /// Adherence for a departure with no real-time data.
  ///
  /// In en, this message translates to:
  /// **'scheduled'**
  String get stopRowScheduled;

  /// Status of a canceled trip.
  ///
  /// In en, this message translates to:
  /// **'canceled'**
  String get stopRowCanceled;

  /// Occupancy.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get stopRowOccupancyEmpty;

  /// Occupancy.
  ///
  /// In en, this message translates to:
  /// **'Many seats available'**
  String get stopRowOccupancyManySeats;

  /// Occupancy.
  ///
  /// In en, this message translates to:
  /// **'Few seats available'**
  String get stopRowOccupancyFewSeats;

  /// Occupancy.
  ///
  /// In en, this message translates to:
  /// **'Standing room only'**
  String get stopRowOccupancyStanding;

  /// Occupancy.
  ///
  /// In en, this message translates to:
  /// **'Very crowded'**
  String get stopRowOccupancyCrushed;

  /// Occupancy.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get stopRowOccupancyFull;

  /// Occupancy.
  ///
  /// In en, this message translates to:
  /// **'Not accepting passengers'**
  String get stopRowOccupancyNotAccepting;

  /// Screen-reader ETA.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =0{arriving now} =1{arrives in 1 minute} other{arrives in {minutes} minutes}}'**
  String stopRowA11yArrives(int minutes);

  /// Screen-reader ETA at a first stop.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =0{departing now} =1{departs in 1 minute} other{departs in {minutes} minutes}}'**
  String stopRowA11yDeparts(int minutes);

  /// Screen-reader text for a past arrival.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{arrived 1 minute ago} other{arrived {minutes} minutes ago}}'**
  String stopRowA11yArrived(int minutes);

  /// Screen-reader text for a past departure.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{departed 1 minute ago} other{departed {minutes} minutes ago}}'**
  String stopRowA11yDeparted(int minutes);

  /// Screen-reader sentence for a departure row.
  ///
  /// In en, this message translates to:
  /// **'Route {route} to {headsign}, {eta}, at {time}, {status}'**
  String stopRowA11yLabel(
    String route,
    String headsign,
    String eta,
    String time,
    String status,
  );

  /// Screen-reader status for a real-time departure.
  ///
  /// In en, this message translates to:
  /// **'live tracking, {status}'**
  String stopRowA11yLive(String status);

  /// Screen-reader status for a schedule-only departure.
  ///
  /// In en, this message translates to:
  /// **'scheduled time only, no live data'**
  String get stopRowA11yScheduledOnly;

  /// Appended when the row is the rider's transfer.
  ///
  /// In en, this message translates to:
  /// **'your transfer trip'**
  String get stopRowA11yTransfer;

  /// Appended to rows above the walk divider.
  ///
  /// In en, this message translates to:
  /// **'likely missed, it leaves before you can walk there'**
  String get stopRowA11yMissed;

  /// Appended when an alarm is set.
  ///
  /// In en, this message translates to:
  /// **'alarm set'**
  String get stopRowA11yAlarm;

  /// Overflow button on a departure row.
  ///
  /// In en, this message translates to:
  /// **'More actions for route {route}'**
  String stopRowActions(String route);

  /// Row action.
  ///
  /// In en, this message translates to:
  /// **'Show trip details'**
  String get stopRowShowTrip;

  /// Row action.
  ///
  /// In en, this message translates to:
  /// **'Add alarm'**
  String get stopRowAddAlarm;

  /// Row action.
  ///
  /// In en, this message translates to:
  /// **'Remove alarm'**
  String get stopRowRemoveAlarm;

  /// Row action.
  ///
  /// In en, this message translates to:
  /// **'Bookmark this trip'**
  String get stopRowBookmarkTrip;

  /// Row action.
  ///
  /// In en, this message translates to:
  /// **'Share trip'**
  String get stopRowShareTrip;

  /// Row action.
  ///
  /// In en, this message translates to:
  /// **'Schedule for route'**
  String get stopRowRouteSchedule;

  /// Row action.
  ///
  /// In en, this message translates to:
  /// **'Stops on this route'**
  String get stopRowRouteStops;

  /// Summary of a collapsed route group.
  ///
  /// In en, this message translates to:
  /// **'Next: {times}'**
  String stopRouteGroupNext(String times);

  /// Screen-reader label of a route group header.
  ///
  /// In en, this message translates to:
  /// **'Route {route} to {headsigns}, {count, plural, =1{1 departure} other{{count} departures}}, next {eta}'**
  String stopRouteGroupLabel(
    String route,
    String headsigns,
    int count,
    String eta,
  );

  /// Title of the alarm lead time picker.
  ///
  /// In en, this message translates to:
  /// **'Remind me before it leaves'**
  String get stopAlarmPickerTitle;

  /// Alarm lead time choice.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute before} other{{minutes} minutes before}}'**
  String stopAlarmLeadTime(int minutes);

  /// Confirmation after setting an alarm.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{Alarm set for 1 minute before} other{Alarm set for {minutes} minutes before}}'**
  String stopAlarmSet(int minutes);

  /// Confirmation after removing an alarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm removed'**
  String get stopAlarmRemoved;

  /// Error when creating or removing an alarm fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the alarm.'**
  String get stopAlarmFailed;

  /// Error when push permission is denied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for this app.'**
  String get stopAlarmPermissionDenied;

  /// Title of the per-stop filter sheet.
  ///
  /// In en, this message translates to:
  /// **'Filter routes'**
  String get stopFilterTitle;

  /// Heading of the sort options.
  ///
  /// In en, this message translates to:
  /// **'Sort departures'**
  String get stopFilterSort;

  /// Heading of the route checkboxes.
  ///
  /// In en, this message translates to:
  /// **'Routes shown at this stop'**
  String get stopFilterRoutesHeader;

  /// Button that shows every route.
  ///
  /// In en, this message translates to:
  /// **'Show all routes'**
  String get stopFilterShowAll;

  /// Summary when the vehicle is at the rider's stop.
  ///
  /// In en, this message translates to:
  /// **'Arriving at your stop'**
  String get stopTripArrivingAtYourStop;

  /// Stops between the vehicle and the rider.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{At your stop} =1{1 stop away} other{{count} stops away}}'**
  String stopTripStopsAway(int count);

  /// Distance between the vehicle and the rider's stop.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String stopTripDistanceAway(String distance);

  /// Where the ETA applies.
  ///
  /// In en, this message translates to:
  /// **'At {stop}'**
  String stopTripAtStop(String stop);

  /// Freshness of the vehicle position.
  ///
  /// In en, this message translates to:
  /// **'Position updated {ago}'**
  String stopTripPositionUpdated(String ago);

  /// Shown when there is no live position.
  ///
  /// In en, this message translates to:
  /// **'No real-time position for this vehicle'**
  String get stopTripNoPosition;

  /// Link to the previous trip of the block.
  ///
  /// In en, this message translates to:
  /// **'Starts as {trip}'**
  String stopTripStartsAs(String trip);

  /// Link to the next trip of the block.
  ///
  /// In en, this message translates to:
  /// **'Continues as {trip}'**
  String stopTripContinuesAs(String trip);

  /// Heading of the trip stop list.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stopTripStopsHeader;

  /// Collapsed run of passed stops.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 passed stop} other{{count} passed stops}}'**
  String stopTripRunPassed(int count);

  /// Collapsed run of stops ahead.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 stop before your stop} other{{count} stops before your stop}}'**
  String stopTripRunApproaching(int count);

  /// Time range of a collapsed run.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String stopTripRunRange(String start, String end);

  /// Badge on the rider's stop.
  ///
  /// In en, this message translates to:
  /// **'Your stop'**
  String get stopTripYourStop;

  /// Badge on the boarding stop of a shared trip.
  ///
  /// In en, this message translates to:
  /// **'Boarding'**
  String get stopTripBoarding;

  /// Badge on the vehicle's stop.
  ///
  /// In en, this message translates to:
  /// **'Vehicle is here'**
  String get stopTripVehicleHere;

  /// Badge on the terminal.
  ///
  /// In en, this message translates to:
  /// **'Last stop'**
  String get stopTripTerminal;

  /// Short marker for a passed stop (screen readers).
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get stopTripPassed;

  /// Trip action.
  ///
  /// In en, this message translates to:
  /// **'All stops on this route'**
  String get stopTripRouteStops;

  /// Trip action.
  ///
  /// In en, this message translates to:
  /// **'Report a problem with this trip'**
  String get stopTripReport;

  /// Trip action: the vehicle never came.
  ///
  /// In en, this message translates to:
  /// **'Report ghost bus'**
  String get stopTripGhostBus;

  /// Banner on a canceled trip.
  ///
  /// In en, this message translates to:
  /// **'This trip is canceled'**
  String get stopTripCanceled;

  /// Map marker label for the vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle on route {route}'**
  String stopTripVehicleLabel(String route);

  /// Frequency-based trip.
  ///
  /// In en, this message translates to:
  /// **'Every {minutes} min'**
  String stopTripFrequency(int minutes);

  /// Title of the route stops page.
  ///
  /// In en, this message translates to:
  /// **'Route {route}'**
  String stopRouteStopsTitle(String route);

  /// Label of the direction switcher.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get stopRouteStopsDirection;

  /// Direction option.
  ///
  /// In en, this message translates to:
  /// **'To {name}'**
  String stopRouteStopsToward(String name);

  /// Number of stops in a direction.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 stop} other{{count} stops}}'**
  String stopRouteStopsCount(int count);

  /// Empty state.
  ///
  /// In en, this message translates to:
  /// **'No stops found for this route.'**
  String get stopRouteStopsEmpty;

  /// Date stepper button.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get stopSchedPrevDay;

  /// Date stepper button.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get stopSchedNextDay;

  /// Date picker button label.
  ///
  /// In en, this message translates to:
  /// **'Choose date, {date}'**
  String stopSchedPickDate(String date);

  /// Label of the route picker.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get stopSchedRoute;

  /// Label of the direction picker.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get stopSchedDirection;

  /// Label of the stop picker.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopSchedStop;

  /// Empty state.
  ///
  /// In en, this message translates to:
  /// **'No scheduled service on this day.'**
  String get stopSchedEmpty;

  /// Frequency-based service.
  ///
  /// In en, this message translates to:
  /// **'Every {minutes} min from {start} to {end}'**
  String stopSchedEvery(int minutes, String start, String end);

  /// Direction heading.
  ///
  /// In en, this message translates to:
  /// **'To {headsign}'**
  String stopSchedTo(String headsign);

  /// Departure count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 departure} other{{count} departures}}'**
  String stopSchedDepartures(int count);

  /// Screen-reader sentence for one hour of departures.
  ///
  /// In en, this message translates to:
  /// **'{hour}: {times}'**
  String stopSchedHour(String hour, String times);

  /// Shown when the region has no schedule-for-route.
  ///
  /// In en, this message translates to:
  /// **'Timetables aren\'t available in this region.'**
  String get stopSchedNotSupported;

  /// Timetable view: per-stop list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get stopSchedViewList;

  /// Timetable view: grid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get stopSchedViewGrid;

  /// Grid cell with no time (screen readers).
  ///
  /// In en, this message translates to:
  /// **'No departure'**
  String get stopSchedNoDeparture;

  /// Stop picker entry for the rider's stop.
  ///
  /// In en, this message translates to:
  /// **'{stop} (your stop)'**
  String stopSchedYourStop(String stop);

  /// Screen-reader label of a grid cell.
  ///
  /// In en, this message translates to:
  /// **'{stop}, trip {trip}: {time}'**
  String stopSchedCell(String stop, int trip, String time);

  /// Heading of the problem choices.
  ///
  /// In en, this message translates to:
  /// **'What seems to be the problem?'**
  String get stopReportProblemHeader;

  /// Stop problem.
  ///
  /// In en, this message translates to:
  /// **'The stop name is wrong'**
  String get stopReportStopNameWrong;

  /// Stop problem.
  ///
  /// In en, this message translates to:
  /// **'The stop number is wrong'**
  String get stopReportStopNumberWrong;

  /// Stop problem.
  ///
  /// In en, this message translates to:
  /// **'The stop is in the wrong place'**
  String get stopReportStopLocationWrong;

  /// Stop problem.
  ///
  /// In en, this message translates to:
  /// **'A route or trip is missing'**
  String get stopReportRouteMissing;

  /// Problem: other.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get stopReportOther;

  /// Trip problem.
  ///
  /// In en, this message translates to:
  /// **'The vehicle never came'**
  String get stopReportNeverCame;

  /// Trip problem.
  ///
  /// In en, this message translates to:
  /// **'It came early'**
  String get stopReportCameEarly;

  /// Trip problem.
  ///
  /// In en, this message translates to:
  /// **'It came late'**
  String get stopReportCameLate;

  /// Trip problem.
  ///
  /// In en, this message translates to:
  /// **'The headsign was wrong'**
  String get stopReportWrongHeadsign;

  /// Trip problem.
  ///
  /// In en, this message translates to:
  /// **'It didn\'t stop here'**
  String get stopReportNotStopHere;

  /// Comment field label.
  ///
  /// In en, this message translates to:
  /// **'Additional comments (optional)'**
  String get stopReportComment;

  /// Switch that attaches the location.
  ///
  /// In en, this message translates to:
  /// **'Share my location'**
  String get stopReportShareLocation;

  /// Help under the location switch.
  ///
  /// In en, this message translates to:
  /// **'Sharing your location can help your transit agency fix this problem.'**
  String get stopReportShareLocationHelp;

  /// Switch: rider is aboard.
  ///
  /// In en, this message translates to:
  /// **'I\'m on this vehicle'**
  String get stopReportOnVehicle;

  /// Vehicle id field.
  ///
  /// In en, this message translates to:
  /// **'Vehicle number (optional)'**
  String get stopReportVehicleId;

  /// Submit button.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get stopReportSend;

  /// Shown and announced while sending.
  ///
  /// In en, this message translates to:
  /// **'Sending report'**
  String get stopReportSending;

  /// Success message.
  ///
  /// In en, this message translates to:
  /// **'Thanks! Your report was sent.'**
  String get stopReportSent;

  /// Failure message.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the report. Please try again.'**
  String get stopReportFailed;

  /// Validation error.
  ///
  /// In en, this message translates to:
  /// **'Choose a problem first.'**
  String get stopReportChooseProblem;

  /// Context line on the form.
  ///
  /// In en, this message translates to:
  /// **'Reporting: {name}'**
  String stopReportAbout(String name);

  /// Title of the ghost bus form.
  ///
  /// In en, this message translates to:
  /// **'Report ghost bus'**
  String get stopGhostTitle;

  /// Explanation on the ghost bus form.
  ///
  /// In en, this message translates to:
  /// **'A ghost bus is one that the app showed but that never came.'**
  String get stopGhostExplain;

  /// Wait duration heading.
  ///
  /// In en, this message translates to:
  /// **'How long did you wait past the scheduled time?'**
  String get stopGhostWait;

  /// Wait choice.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String stopGhostWaitMinutes(int minutes);

  /// Wait choice.
  ///
  /// In en, this message translates to:
  /// **'30+ min'**
  String get stopGhostWaitThirtyPlus;

  /// Empty departures card.
  ///
  /// In en, this message translates to:
  /// **'No departures soon'**
  String get stopCardEmpty;

  /// Title of the search screen.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get titleSearch;

  /// Title of the search results screen.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get titleSearchResults;

  /// Title of the nearby stops list.
  ///
  /// In en, this message translates to:
  /// **'Nearby stops'**
  String get titleNearbyStops;

  /// Title of the recent stops list.
  ///
  /// In en, this message translates to:
  /// **'Recent stops'**
  String get titleRecentStops;

  /// Title of the bookmarks list.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get titleBookmarks;

  /// Title of the stop departures screen.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get titleStop;

  /// Title of the trip details screen.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get titleTrip;

  /// Title of the stops along a route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get titleRouteStops;

  /// Title of the a stop's timetable.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get titleStopSchedule;

  /// Title of the a route's timetable.
  ///
  /// In en, this message translates to:
  /// **'Route schedule'**
  String get titleRouteSchedule;

  /// Title of the service alerts list.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get titleAlerts;

  /// Title of the one service alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get titleAlertDetail;

  /// Title of the transit agencies list.
  ///
  /// In en, this message translates to:
  /// **'Agencies'**
  String get titleAgencies;

  /// Title of the region picker.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get titleRegionPicker;

  /// Title of the custom region form.
  ///
  /// In en, this message translates to:
  /// **'Custom region'**
  String get titleCustomRegion;

  /// Title of the settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get titleSettings;

  /// Title of the map settings.
  ///
  /// In en, this message translates to:
  /// **'Map settings'**
  String get titleMapSettings;

  /// Title of the More screen.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get titleMore;

  /// Title of the trip planner.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip'**
  String get titleTripPlanner;

  /// Title of the a searched or dropped place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get titlePlace;

  /// Title of the report a problem with a stop.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get titleReportStopProblem;

  /// Title of the report a problem with a trip or vehicle.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get titleReportTripProblem;

  /// Title of the add or edit a bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get titleBookmarkEditor;

  /// Title of the reorder and group bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Edit bookmarks'**
  String get titleManageBookmarks;

  /// Title of the open-source credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get titleCredits;

  /// Title of the weather forecast.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get titleWeather;

  /// Title of the list of stops visible on the map.
  ///
  /// In en, this message translates to:
  /// **'Stops on the map'**
  String get titleStopsOnMap;

  /// Title of the first onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String onboardingWelcomeTitle(String appName);

  /// Body of the first onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Real-time arrivals for buses, trains and ferries near you.'**
  String get onboardingWelcomeBody;

  /// Title of the onboarding page asking for location access.
  ///
  /// In en, this message translates to:
  /// **'Find stops near you'**
  String get onboardingLocationTitle;

  /// Body of the onboarding page asking for location access.
  ///
  /// In en, this message translates to:
  /// **'Allow location access to see nearby stops and pick your region automatically.'**
  String get onboardingLocationBody;

  /// Button that asks the system for location permission.
  ///
  /// In en, this message translates to:
  /// **'Allow location access'**
  String get onboardingAllowLocation;

  /// Title of the onboarding page where the user picks a region.
  ///
  /// In en, this message translates to:
  /// **'Choose your region'**
  String get onboardingRegionTitle;

  /// Body of the region onboarding page.
  ///
  /// In en, this message translates to:
  /// **'Pick the area whose transit you want to see.'**
  String get onboardingRegionBody;

  /// Settings section title for map options.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get settingsSectionMap;

  /// Settings row that opens the map type screen.
  ///
  /// In en, this message translates to:
  /// **'Map type and layers'**
  String get settingsMapTypeRow;

  /// Helper text under the map type row in Settings.
  ///
  /// In en, this message translates to:
  /// **'Choose how the map looks.'**
  String get settingsMapTypeHelp;

  /// Helper text under the Show heading switch.
  ///
  /// In en, this message translates to:
  /// **'Shows the direction you are facing on the map.'**
  String get settingsHeadingHelp;

  /// Helper text under the Show stop labels switch.
  ///
  /// In en, this message translates to:
  /// **'Shows route names next to stops on the map.'**
  String get settingsStopLabelsHelp;

  /// Label of the setting that picks which app gives walking directions.
  ///
  /// In en, this message translates to:
  /// **'Walking directions'**
  String get settingsWalkingDirections;

  /// Helper text under the walking directions setting.
  ///
  /// In en, this message translates to:
  /// **'The app that opens when you ask for walking directions to a stop.'**
  String get settingsWalkingDirectionsHelp;

  /// Walking directions option: ask which app to use each time.
  ///
  /// In en, this message translates to:
  /// **'Ask every time'**
  String get settingsDirectionsAsk;

  /// Walking directions option: Apple Maps (a product name).
  ///
  /// In en, this message translates to:
  /// **'Apple Maps'**
  String get settingsDirectionsAppleMaps;

  /// Walking directions option: Google Maps (a product name).
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get settingsDirectionsGoogleMaps;

  /// Settings section title for how departures are shown.
  ///
  /// In en, this message translates to:
  /// **'Departures'**
  String get settingsSectionDepartures;

  /// Label of the setting that filters departures by data source.
  ///
  /// In en, this message translates to:
  /// **'Show departures'**
  String get settingsDepartureFilter;

  /// Helper text under the departure filter.
  ///
  /// In en, this message translates to:
  /// **'Choose whether stop pages list every departure or only those with real-time or scheduled data.'**
  String get settingsDepartureFilterHelp;

  /// Departure filter option: show every departure.
  ///
  /// In en, this message translates to:
  /// **'All departures'**
  String get settingsFilterAll;

  /// Departure filter option: only departures with real-time predictions.
  ///
  /// In en, this message translates to:
  /// **'Real-time only'**
  String get settingsFilterRealtime;

  /// Departure filter option: only scheduled departures.
  ///
  /// In en, this message translates to:
  /// **'Scheduled only'**
  String get settingsFilterScheduled;

  /// Label of the switch that shows clock times in the transit region time zone.
  ///
  /// In en, this message translates to:
  /// **'Show times in the region\'s time zone'**
  String get settingsRegionTimeZone;

  /// Helper text under the region time zone switch.
  ///
  /// In en, this message translates to:
  /// **'Clock times use the transit region\'s time zone, with a note when it differs from your device.'**
  String get settingsRegionTimeZoneHelp;

  /// Settings section title for accessibility options.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsSectionAccessibility;

  /// Label of the switch that reduces colour on stop pages.
  ///
  /// In en, this message translates to:
  /// **'Reduce colors on stop pages'**
  String get settingsReducedColors;

  /// Helper text under the reduce colors switch.
  ///
  /// In en, this message translates to:
  /// **'Shows route badges in one neutral style.'**
  String get settingsReducedColorsHelp;

  /// Label of the switch that tightens spacing on stop and trip pages.
  ///
  /// In en, this message translates to:
  /// **'Compact stop and trip pages'**
  String get settingsCompactMode;

  /// Helper text under the compact mode switch.
  ///
  /// In en, this message translates to:
  /// **'Tightens spacing so more fits on screen.'**
  String get settingsCompactModeHelp;

  /// Settings section title for walking speed.
  ///
  /// In en, this message translates to:
  /// **'Walking speed'**
  String get settingsSectionWalking;

  /// Label of the walking speed choice.
  ///
  /// In en, this message translates to:
  /// **'Walking speed'**
  String get settingsWalkingSpeed;

  /// Helper text under the walking speed choice.
  ///
  /// In en, this message translates to:
  /// **'Used for walk-time estimates and arrival times.'**
  String get settingsWalkingSpeedHelp;

  /// Walking speed preset: slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get settingsSpeedSlow;

  /// Walking speed preset: average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get settingsSpeedAverage;

  /// Walking speed preset: fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get settingsSpeedFast;

  /// Walking speed shown when it was set by another app and is not a preset.
  ///
  /// In en, this message translates to:
  /// **'Custom ({speed} m/s)'**
  String settingsSpeedCustom(String speed);

  /// Settings section title for bike mode.
  ///
  /// In en, this message translates to:
  /// **'Bike mode'**
  String get settingsSectionBike;

  /// Label of the bike mode switch.
  ///
  /// In en, this message translates to:
  /// **'Bike mode'**
  String get settingsBikeMode;

  /// Helper text under the bike mode switch.
  ///
  /// In en, this message translates to:
  /// **'Uses a faster travel speed for walk-time estimates, arrival times and the stop page.'**
  String get settingsBikeModeHelp;

  /// Settings section title for surveys.
  ///
  /// In en, this message translates to:
  /// **'Surveys'**
  String get settingsSectionSurveys;

  /// Label of the switch that turns surveys on or off.
  ///
  /// In en, this message translates to:
  /// **'Show surveys'**
  String get settingsSurveysEnabled;

  /// Label of the switch that always shows surveys on stop pages.
  ///
  /// In en, this message translates to:
  /// **'Always show surveys on stops'**
  String get settingsSurveysAlways;

  /// Settings section title for privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsSectionPrivacy;

  /// Label of the switch that lets the app send usage data.
  ///
  /// In en, this message translates to:
  /// **'Send usage data to the developers'**
  String get settingsAnalytics;

  /// Helper text under the usage data switch.
  ///
  /// In en, this message translates to:
  /// **'Helps the developers see which features are used.'**
  String get settingsAnalyticsHelp;

  /// Settings section title for developer options.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get settingsSectionDebug;

  /// Label of the debug mode switch.
  ///
  /// In en, this message translates to:
  /// **'Debug mode'**
  String get settingsDebugMode;

  /// Label of a debug switch that bypasses the feedback prompt rules.
  ///
  /// In en, this message translates to:
  /// **'Always show the feedback prompt'**
  String get settingsDebugAlwaysFeedback;

  /// Label of a debug button that clears the feedback prompt history.
  ///
  /// In en, this message translates to:
  /// **'Reset feedback prompt state'**
  String get settingsDebugResetFeedback;

  /// Label of a debug button that clears the donation card history.
  ///
  /// In en, this message translates to:
  /// **'Reset donation card state'**
  String get settingsDebugResetDonation;

  /// Announced after a debug reset button is used.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settingsDebugResetDone;

  /// Settings section title for the trip planner switch.
  ///
  /// In en, this message translates to:
  /// **'Trip planner'**
  String get settingsSectionTripPlanner;

  /// Home screen row that opens map settings.
  ///
  /// In en, this message translates to:
  /// **'Customize map'**
  String get settingsHomeCustomizeMap;

  /// Default header text on the More screen.
  ///
  /// In en, this message translates to:
  /// **'This app is made and supported by volunteers.'**
  String get moreHeaderSupport;

  /// More screen section title for donations.
  ///
  /// In en, this message translates to:
  /// **'Be a supporter'**
  String get moreSectionDonate;

  /// More screen row that opens the donation page.
  ///
  /// In en, this message translates to:
  /// **'Donate to {appName}'**
  String moreDonate(String appName);

  /// More screen row that opens the donation management website.
  ///
  /// In en, this message translates to:
  /// **'Manage donations'**
  String get moreManageDonations;

  /// More screen section title for alerts.
  ///
  /// In en, this message translates to:
  /// **'Updates and alerts'**
  String get moreSectionUpdates;

  /// More screen row that opens service alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get moreAlerts;

  /// More screen section title for region options.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get moreSectionLocation;

  /// More screen row that opens the region picker.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get moreRegion;

  /// More screen: shown as the region when none is selected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get moreRegionNone;

  /// More screen row that opens the fare payment app.
  ///
  /// In en, this message translates to:
  /// **'Pay my fare'**
  String get morePayFare;

  /// More screen row that opens the list of transit agencies.
  ///
  /// In en, this message translates to:
  /// **'Agencies'**
  String get moreAgencies;

  /// More screen section title for app information.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get moreSectionAbout;

  /// More screen row that opens the store review page.
  ///
  /// In en, this message translates to:
  /// **'Rate {appName}'**
  String moreRateApp(String appName);

  /// More screen row that lets the rider email the developers or the agency.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get moreContactUs;

  /// More screen row that opens the privacy policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get morePrivacy;

  /// More screen row that opens the credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get moreCredits;

  /// More screen line that shows the app version.
  ///
  /// In en, this message translates to:
  /// **'{appName} version {version}'**
  String moreVersion(String appName, String version);

  /// More screen section title for volunteer links.
  ///
  /// In en, this message translates to:
  /// **'Help make the app better'**
  String get moreSectionHelpOut;

  /// More screen row that opens the translation project.
  ///
  /// In en, this message translates to:
  /// **'Help translate the app'**
  String get moreTranslate;

  /// More screen row that opens the source code project.
  ///
  /// In en, this message translates to:
  /// **'Help fix bugs and build new features'**
  String get moreDevelop;

  /// More screen section title for the transit agency contact links.
  ///
  /// In en, this message translates to:
  /// **'Contact and help'**
  String get moreSectionContact;

  /// More screen row that opens the agency tutorial page.
  ///
  /// In en, this message translates to:
  /// **'Tutorials'**
  String get moreTutorials;

  /// More screen row that calls the transit agency.
  ///
  /// In en, this message translates to:
  /// **'Call agency'**
  String get moreCallAgency;

  /// More screen row that opens the agency text message service.
  ///
  /// In en, this message translates to:
  /// **'Message agency'**
  String get moreTextAgency;

  /// More screen section title for links the transit agency added.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get moreSectionResources;

  /// Title of the dialog that asks who to contact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get moreContactTitle;

  /// Contact dialog option: email the app developers.
  ///
  /// In en, this message translates to:
  /// **'Feature request or bug report'**
  String get moreContactDevelopers;

  /// Contact dialog option: email the transit agency.
  ///
  /// In en, this message translates to:
  /// **'Vehicle or schedule problem'**
  String get moreContactAgency;

  /// Subject of the email to the app developers.
  ///
  /// In en, this message translates to:
  /// **'{appName} feedback'**
  String moreEmailSubject(String appName);

  /// Subject of the email to the transit agency.
  ///
  /// In en, this message translates to:
  /// **'Transit rider feedback'**
  String get moreEmailAgencySubject;

  /// First line of the support email.
  ///
  /// In en, this message translates to:
  /// **'How can we help? Please enter your response below:'**
  String get moreEmailIntro;

  /// Explains the debug information at the end of the support email.
  ///
  /// In en, this message translates to:
  /// **'The following information is provided for troubleshooting purposes. If you are uncomfortable sharing any of it you may remove it, however it may affect our ability to assist you.'**
  String get moreEmailDebugIntro;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get moreDebugAppVersion;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'Operating system'**
  String get moreDebugOs;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get moreDebugLocale;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'Bookmark count'**
  String get moreDebugBookmarks;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'Location permission'**
  String get moreDebugLocationPermission;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get moreDebugRegion;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'Region ID'**
  String get moreDebugRegionId;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'Base API URL'**
  String get moreDebugApiUrl;

  /// Label in the support email debug information.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get moreDebugUserId;

  /// Title of the dialog shown when no email app can be opened.
  ///
  /// In en, this message translates to:
  /// **'Can\'t open your email app'**
  String get moreCantEmailTitle;

  /// Body of the dialog shown when no email app can be opened.
  ///
  /// In en, this message translates to:
  /// **'To contact us, send an email to {email}. Copy the debug information and paste it into your message to help us fix the problem.'**
  String moreCantEmailBody(String email);

  /// Button that copies the support email address.
  ///
  /// In en, this message translates to:
  /// **'Copy email address'**
  String get moreCopyEmail;

  /// Button that copies the support message with debug information.
  ///
  /// In en, this message translates to:
  /// **'Copy debug info'**
  String get moreCopyDebug;

  /// Announced after something was copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to the clipboard'**
  String get moreCopied;

  /// Button in the fare payment warning dialog that continues to the payment app.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get moreFareContinue;

  /// Button in the fare payment warning dialog that continues and hides the warning in future.
  ///
  /// In en, this message translates to:
  /// **'Continue and don\'t show again'**
  String get moreFareDontShowAgain;

  /// Shown when a link cannot be opened.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open that link.'**
  String get moreCantOpenLink;

  /// Switch in the region picker that selects the region from the rider location.
  ///
  /// In en, this message translates to:
  /// **'Choose region automatically'**
  String get regionPickerAutomatic;

  /// Helper text under the automatic region switch.
  ///
  /// In en, this message translates to:
  /// **'Switches to the region that contains your location. Choosing a region yourself turns this off.'**
  String get regionPickerAutomaticHelp;

  /// Switch in the region picker that lists experimental regions.
  ///
  /// In en, this message translates to:
  /// **'Show experimental regions'**
  String get regionPickerShowExperimental;

  /// Switch in the region picker that lists inactive regions.
  ///
  /// In en, this message translates to:
  /// **'Show inactive regions'**
  String get regionPickerShowInactive;

  /// Section title above the list of regions.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get regionPickerRegionsSection;

  /// Section title above the list of custom regions.
  ///
  /// In en, this message translates to:
  /// **'Custom regions'**
  String get regionPickerCustomSection;

  /// Spoken and shown marker on the selected region.
  ///
  /// In en, this message translates to:
  /// **'Current region'**
  String get regionPickerCurrent;

  /// Tag on an experimental region.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get regionPickerExperimentalTag;

  /// Tag on an inactive region.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get regionPickerInactiveTag;

  /// Tag on a custom region.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get regionPickerCustomTag;

  /// Spoken description of a region row: name then tags.
  ///
  /// In en, this message translates to:
  /// **'{name}, {details}'**
  String regionPickerRowLabel(String name, String details);

  /// Button that opens the custom region form.
  ///
  /// In en, this message translates to:
  /// **'Add custom region'**
  String get regionPickerAdd;

  /// Button that reloads the list of regions.
  ///
  /// In en, this message translates to:
  /// **'Refresh regions'**
  String get regionPickerRefresh;

  /// Announced after the regions list was refreshed.
  ///
  /// In en, this message translates to:
  /// **'Regions updated'**
  String get regionPickerRefreshed;

  /// Shown when refreshing the regions list failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the regions list. Showing the saved list.'**
  String get regionPickerRefreshFailed;

  /// Announced after the rider picked a region.
  ///
  /// In en, this message translates to:
  /// **'{name} selected'**
  String regionPickerSelected(String name);

  /// Tooltip of the edit button on a custom region.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String regionPickerEdit(String name);

  /// Tooltip of the delete button on a custom region.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String regionPickerDelete(String name);

  /// Title of the dialog that confirms deleting a custom region.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String regionPickerDeleteTitle(String name);

  /// Body of the dialog that confirms deleting a custom region.
  ///
  /// In en, this message translates to:
  /// **'This custom region will be removed from this device.'**
  String get regionPickerDeleteBody;

  /// Button that confirms deleting a custom region.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get regionPickerDeleteConfirm;

  /// Shown when the rider tries to delete the selected custom region.
  ///
  /// In en, this message translates to:
  /// **'Choose another region before deleting this one.'**
  String get regionPickerCantDeleteCurrent;

  /// Title shown when there are no regions to list.
  ///
  /// In en, this message translates to:
  /// **'No regions available'**
  String get regionPickerEmpty;

  /// Message shown when there are no regions to list.
  ///
  /// In en, this message translates to:
  /// **'Turn on experimental or inactive regions, or add a custom region.'**
  String get regionPickerEmptyBody;

  /// Switch that turns the trip planner on or off for the current region.
  ///
  /// In en, this message translates to:
  /// **'Trip planner in this region'**
  String get regionPickerTripPlanner;

  /// Title of the custom region form when editing.
  ///
  /// In en, this message translates to:
  /// **'Edit custom region'**
  String get customRegionEditTitle;

  /// Custom region form field: the region name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get customRegionName;

  /// Custom region form field: the OneBusAway server address.
  ///
  /// In en, this message translates to:
  /// **'OneBusAway server URL'**
  String get customRegionObaUrl;

  /// Helper text under the server URL field.
  ///
  /// In en, this message translates to:
  /// **'The address of the server, for example https://oba.example.com/'**
  String get customRegionObaUrlHelp;

  /// Custom region form field: the sidecar server address.
  ///
  /// In en, this message translates to:
  /// **'Sidecar server URL (optional)'**
  String get customRegionSidecar;

  /// Custom region form field: the OpenTripPlanner address.
  ///
  /// In en, this message translates to:
  /// **'Trip planner URL (optional)'**
  String get customRegionOtp;

  /// Custom region form field: the OpenTripPlanner GraphQL address.
  ///
  /// In en, this message translates to:
  /// **'Trip planner GraphQL URL (optional)'**
  String get customRegionOtpGraphql;

  /// Custom region form section title for the area the region covers.
  ///
  /// In en, this message translates to:
  /// **'Service area'**
  String get customRegionServiceArea;

  /// Helper text under the service area title.
  ///
  /// In en, this message translates to:
  /// **'The area this region covers: a center point and how far it extends.'**
  String get customRegionServiceAreaHelp;

  /// Custom region form field.
  ///
  /// In en, this message translates to:
  /// **'Center latitude'**
  String get customRegionLatitude;

  /// Custom region form field.
  ///
  /// In en, this message translates to:
  /// **'Center longitude'**
  String get customRegionLongitude;

  /// Custom region form field: north-south extent.
  ///
  /// In en, this message translates to:
  /// **'Latitude span (degrees)'**
  String get customRegionLatSpan;

  /// Custom region form field: east-west extent.
  ///
  /// In en, this message translates to:
  /// **'Longitude span (degrees)'**
  String get customRegionLonSpan;

  /// Button that fills the service area from the visible map.
  ///
  /// In en, this message translates to:
  /// **'Use the current map area'**
  String get customRegionUseMap;

  /// Button that saves the custom region.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get customRegionSave;

  /// Custom region form error.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get customRegionErrorRequired;

  /// Custom region form error.
  ///
  /// In en, this message translates to:
  /// **'Enter a web address that starts with http:// or https://'**
  String get customRegionErrorUrl;

  /// Custom region form error.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get customRegionErrorNumber;

  /// Custom region form error.
  ///
  /// In en, this message translates to:
  /// **'This number is out of range'**
  String get customRegionErrorRange;

  /// Shown while the server address is being checked.
  ///
  /// In en, this message translates to:
  /// **'Checking the server'**
  String get customRegionChecking;

  /// Shown when the server address is valid.
  ///
  /// In en, this message translates to:
  /// **'The server responded'**
  String get customRegionServerOk;

  /// Shown when the server address cannot be reached.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach this server'**
  String get customRegionServerUnreachable;

  /// Shown when the address is not a OneBusAway server.
  ///
  /// In en, this message translates to:
  /// **'This server didn\'t answer like OneBusAway'**
  String get customRegionServerNotOba;

  /// Announced after a custom region was saved.
  ///
  /// In en, this message translates to:
  /// **'{name} saved'**
  String customRegionSaved(String name);

  /// Credits section title.
  ///
  /// In en, this message translates to:
  /// **'OneBusAway'**
  String get creditsAbout;

  /// Credits introduction.
  ///
  /// In en, this message translates to:
  /// **'OneBusAway is free, open source transit software, built by volunteers and supported by the Open Transit Software Foundation.'**
  String get creditsAboutBody;

  /// Credits subsection title for the app license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get creditsLicenseTitle;

  /// Credits section title for map attribution.
  ///
  /// In en, this message translates to:
  /// **'Map data'**
  String get creditsMapData;

  /// Credits row that opens the list of library licenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get creditsLicenses;

  /// Helper text under the licenses row.
  ///
  /// In en, this message translates to:
  /// **'The libraries this app is built with.'**
  String get creditsLicensesHelp;

  /// Shown while the license list is built.
  ///
  /// In en, this message translates to:
  /// **'Loading licenses'**
  String get creditsLicensesLoading;

  /// Number of licenses a library has.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 license} other{{count} licenses}}'**
  String creditsLicenseCount(int count);

  /// Footnote on the welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Available in dozens of transit regions worldwide.'**
  String get onboardingWelcomeFootnote;

  /// Location screen benefit title.
  ///
  /// In en, this message translates to:
  /// **'See nearby stops'**
  String get onboardingBenefitNearbyTitle;

  /// Location screen benefit text.
  ///
  /// In en, this message translates to:
  /// **'Buses and trains around you, ranked by distance.'**
  String get onboardingBenefitNearbyBody;

  /// Location screen benefit title.
  ///
  /// In en, this message translates to:
  /// **'Center the map on you'**
  String get onboardingBenefitMapTitle;

  /// Location screen benefit text.
  ///
  /// In en, this message translates to:
  /// **'Open straight to your surroundings without searching.'**
  String get onboardingBenefitMapBody;

  /// Footnote on the location screen.
  ///
  /// In en, this message translates to:
  /// **'{appName} only uses your location while the app is open. You can change this any time in your device settings.'**
  String onboardingLocationFootnote(String appName);

  /// Shown after the rider declined location access.
  ///
  /// In en, this message translates to:
  /// **'Location access is off. You can still choose your region yourself.'**
  String get onboardingLocationDenied;

  /// Label on the region suggested from the rider location.
  ///
  /// In en, this message translates to:
  /// **'Detected near you'**
  String get onboardingRegionDetected;

  /// Button that accepts the suggested region.
  ///
  /// In en, this message translates to:
  /// **'Use {name}'**
  String onboardingRegionUse(String name);

  /// Header above the list of regions when one was suggested.
  ///
  /// In en, this message translates to:
  /// **'Or choose another region'**
  String get onboardingRegionOthers;

  /// Shown when there are no regions to pick in onboarding.
  ///
  /// In en, this message translates to:
  /// **'No regions are available right now. Check your connection and try again.'**
  String get onboardingRegionEmpty;

  /// Title of the survey card.
  ///
  /// In en, this message translates to:
  /// **'Help improve transit'**
  String get surveyCardTitle;

  /// Prompt on the survey card when it has no question.
  ///
  /// In en, this message translates to:
  /// **'Take a short survey to help improve transit.'**
  String get surveyDefaultPrompt;

  /// Button on the survey card that opens the survey.
  ///
  /// In en, this message translates to:
  /// **'Take survey'**
  String get surveyTake;

  /// Button on the survey card that postpones the survey.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get surveyNotNow;

  /// Tooltip of the button that dismisses the survey card for good.
  ///
  /// In en, this message translates to:
  /// **'Dismiss survey'**
  String get surveyDismiss;

  /// Button that sends the first answer and shows the remaining questions.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get surveyNext;

  /// Button that sends the survey answers.
  ///
  /// In en, this message translates to:
  /// **'Submit survey'**
  String get surveySubmit;

  /// Button label while the survey answers are sent.
  ///
  /// In en, this message translates to:
  /// **'Submitting'**
  String get surveySubmitting;

  /// Title of the survey questions page.
  ///
  /// In en, this message translates to:
  /// **'Survey'**
  String get surveyQuestionsTitle;

  /// Hint in a free-text survey answer.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer'**
  String get surveyTextHint;

  /// Marker on a required survey question.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get surveyRequired;

  /// Shown when required survey questions are unanswered.
  ///
  /// In en, this message translates to:
  /// **'Please answer all required questions before submitting.'**
  String get surveyIncomplete;

  /// Shown when sending the survey failed.
  ///
  /// In en, this message translates to:
  /// **'Your answers couldn\'t be sent. Please try again.'**
  String get surveyFailed;

  /// Announced after a survey was sent.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback.'**
  String get surveyThanks;

  /// Button that opens an external survey.
  ///
  /// In en, this message translates to:
  /// **'Open survey'**
  String get surveyOpenSurvey;

  /// Button that opens an external page.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get surveyLearnMore;

  /// Button that opens an external feedback form.
  ///
  /// In en, this message translates to:
  /// **'Share feedback'**
  String get surveyShareFeedback;

  /// Button that opens an external sign-up form.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get surveySignUp;

  /// Shown when an external survey link cannot be opened.
  ///
  /// In en, this message translates to:
  /// **'This survey link couldn\'t be opened. Please try again later.'**
  String get surveyExternalError;

  /// Title of the donation card.
  ///
  /// In en, this message translates to:
  /// **'{appName} needs your help'**
  String donationTitle(String appName);

  /// Body of the donation card.
  ///
  /// In en, this message translates to:
  /// **'This app is built with volunteer labor, and we need you to help us fund future development.'**
  String get donationBody;

  /// Donation card button that shows why donations are needed.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get donationLearnMore;

  /// Donation card button that opens the donation page.
  ///
  /// In en, this message translates to:
  /// **'Donate now'**
  String get donationDonate;

  /// Donation card button that hides the card for two weeks.
  ///
  /// In en, this message translates to:
  /// **'Remind me later'**
  String get donationRemindLater;

  /// Donation card button that hides the card for good.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get donationDismiss;

  /// Heading of the donation explanation.
  ///
  /// In en, this message translates to:
  /// **'Here\'s why we need your help'**
  String get donationHeader;

  /// Explanation shown when the rider asks why donations are needed.
  ///
  /// In en, this message translates to:
  /// **'We have big plans to improve {appName}, but we cannot do it without your help. This app is built with volunteer labor, and we need you to help us fund future development.\n\nAs a key project of the Open Transit Software Foundation, a nonprofit, your donation is tax deductible in the United States.'**
  String donationExplanation(String appName);

  /// Button that opens the donation page.
  ///
  /// In en, this message translates to:
  /// **'Donate on our website'**
  String get donationDonateWebsite;

  /// Title of the donation explanation page.
  ///
  /// In en, this message translates to:
  /// **'Support {appName}'**
  String titleDonation(String appName);

  /// Title of the feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'Enjoying {appName}?'**
  String feedbackTitle(String appName);

  /// Positive answer to the feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'Yes!'**
  String get feedbackYes;

  /// Negative answer to the feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'Not really'**
  String get feedbackNo;

  /// Button that postpones the feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'Ask me later'**
  String get feedbackLater;

  /// Title after a negative answer to the feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'Sorry about that.'**
  String get feedbackNegativeTitle;

  /// Body after a negative answer to the feedback prompt.
  ///
  /// In en, this message translates to:
  /// **'Would you tell us what\'s wrong? We read every message.'**
  String get feedbackNegativeBody;

  /// Button that opens the feedback email.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackSend;

  /// Button that declines sending feedback.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get feedbackDecline;

  /// Shown when the region has no trip planner.
  ///
  /// In en, this message translates to:
  /// **'Trip planning isn\'t available in this region.'**
  String get tripPlanningUnavailable;

  /// Shown when a shared link is for a region other than the current one.
  ///
  /// In en, this message translates to:
  /// **'This link is for another region. Switch regions to open it.'**
  String get deepLinkOtherRegion;

  /// Announced to screen readers when content refreshes.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get dataUpdated;

  /// Minutes until a departure, shown in a compact badge, when it is leaving this minute.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get bookmarksEtaNow;

  /// Minutes until a departure, shown in a compact badge.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String bookmarksEtaMinutes(int minutes);

  /// Spoken form of the time until a departure, read after the route name.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =0{now} =1{in 1 minute} other{in {minutes} minutes}}'**
  String bookmarksEtaSemantic(int minutes);

  /// Real-time status of a departure that is on schedule.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get bookmarksStatusOnTime;

  /// Real-time status of a departure that is behind schedule.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 min late} other{{minutes} min late}}'**
  String bookmarksStatusLate(int minutes);

  /// Real-time status of a departure that is ahead of schedule.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 min early} other{{minutes} min early}}'**
  String bookmarksStatusEarly(int minutes);

  /// Status of a departure that has no real-time prediction, only a timetable time.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get bookmarksStatusScheduled;

  /// Status of a departure whose trip was canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get bookmarksStatusCanceled;

  /// A route and its destination, for example 'Route 10 to Downtown'.
  ///
  /// In en, this message translates to:
  /// **'Route {route} to {headsign}'**
  String bookmarksDepartureRoute(String route, String headsign);

  /// A route name when its destination is unknown, for example 'Route 10'.
  ///
  /// In en, this message translates to:
  /// **'Route {route}'**
  String bookmarksDepartureRouteOnly(String route);

  /// One spoken sentence for a departure row: the route and destination, the time until it leaves, and its status.
  ///
  /// In en, this message translates to:
  /// **'{route}, {eta}, {status}'**
  String bookmarksDepartureSemantics(String route, String eta, String status);

  /// Shown on a bookmark card while its next departures load.
  ///
  /// In en, this message translates to:
  /// **'Loading departures'**
  String get bookmarksLoadingDepartures;

  /// Shown on a bookmark card when the stop has no departures soon.
  ///
  /// In en, this message translates to:
  /// **'No upcoming departures'**
  String get bookmarksNoDepartures;

  /// Shown on a bookmark card when its departures could not be loaded.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load departures'**
  String get bookmarksDeparturesError;

  /// Shown on a bookmark card when a refresh failed but older departures are still shown.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh. Showing earlier times.'**
  String get bookmarksDeparturesStale;

  /// Announced to screen readers after the bookmarks' departures refresh.
  ///
  /// In en, this message translates to:
  /// **'Departures updated'**
  String get bookmarksUpdated;

  /// Tooltip of the button that opens the sort menu on the bookmarks list.
  ///
  /// In en, this message translates to:
  /// **'Sort bookmarks'**
  String get bookmarksSortTooltip;

  /// Menu item: list bookmarks under their group headings.
  ///
  /// In en, this message translates to:
  /// **'Sort by group'**
  String get bookmarksSortByGroup;

  /// Menu item: list bookmarks nearest to the user first.
  ///
  /// In en, this message translates to:
  /// **'Sort by distance'**
  String get bookmarksSortByDistance;

  /// Tooltip of the button that opens the bookmark management screen.
  ///
  /// In en, this message translates to:
  /// **'Edit bookmarks and groups'**
  String get bookmarksManageTooltip;

  /// Tooltip of the button that reloads the departures on the bookmarks list.
  ///
  /// In en, this message translates to:
  /// **'Refresh departures'**
  String get bookmarksRefreshTooltip;

  /// Title shown when the user has no bookmarks in this region.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get bookmarksEmptyTitle;

  /// Explains how to add a bookmark, shown when there are none.
  ///
  /// In en, this message translates to:
  /// **'Open a stop and tap its bookmark button to save it here. From a departure you can also bookmark just that route at the stop.'**
  String get bookmarksEmptyBody;

  /// Button that returns to the map so the user can find a stop to bookmark.
  ///
  /// In en, this message translates to:
  /// **'Find stops on the map'**
  String get bookmarksFindStops;

  /// Heading of the bookmarks that are not in any group, shown when other groups exist.
  ///
  /// In en, this message translates to:
  /// **'Ungrouped'**
  String get bookmarksUngrouped;

  /// Spoken state of a bookmark group heading whose bookmarks are showing.
  ///
  /// In en, this message translates to:
  /// **'expanded'**
  String get bookmarksGroupExpanded;

  /// Spoken state of a bookmark group heading whose bookmarks are hidden.
  ///
  /// In en, this message translates to:
  /// **'collapsed'**
  String get bookmarksGroupCollapsed;

  /// Hint of a bookmark group heading button.
  ///
  /// In en, this message translates to:
  /// **'Shows or hides the bookmarks in this group'**
  String get bookmarksGroupToggleHint;

  /// Tooltip of the menu button on a bookmark card.
  ///
  /// In en, this message translates to:
  /// **'Actions for {name}'**
  String bookmarksActionsFor(String name);

  /// Bookmark action: open the bookmark editor.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get bookmarksActionEdit;

  /// Bookmark action: keep this bookmark at the top of lists.
  ///
  /// In en, this message translates to:
  /// **'Pin to top'**
  String get bookmarksActionPin;

  /// Bookmark action: stop keeping this bookmark at the top.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get bookmarksActionUnpin;

  /// Bookmark action: choose another group for this bookmark.
  ///
  /// In en, this message translates to:
  /// **'Move to group'**
  String get bookmarksActionMove;

  /// Bookmark action: remove this bookmark.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get bookmarksActionDelete;

  /// Spoken label of the pin icon on a pinned bookmark.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get bookmarksPinned;

  /// Snackbar shown after a bookmark was deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted {name}'**
  String bookmarksDeleted(String name);

  /// Snackbar action that restores what was just deleted.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get bookmarksUndo;

  /// Title of the dialog for choosing a bookmark's group.
  ///
  /// In en, this message translates to:
  /// **'Move to group'**
  String get bookmarksMoveTitle;

  /// Choice meaning the bookmark is in no group.
  ///
  /// In en, this message translates to:
  /// **'No group'**
  String get bookmarksNoGroup;

  /// Announced after a bookmark was moved to a group.
  ///
  /// In en, this message translates to:
  /// **'Moved to {group}'**
  String bookmarksMoved(String group);

  /// Spoken label of a bookmark card: its name then its details.
  ///
  /// In en, this message translates to:
  /// **'{name}, {details}'**
  String bookmarksStopLine(String name, String details);

  /// Label of the text field for the bookmark's name.
  ///
  /// In en, this message translates to:
  /// **'Bookmark name'**
  String get bookmarksEditorNameLabel;

  /// Error under the name field when it is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for this bookmark.'**
  String get bookmarksEditorNameRequired;

  /// Error shown when the bookmark would duplicate an existing one.
  ///
  /// In en, this message translates to:
  /// **'You already have a bookmark with this name for this stop and route. Change the name to save another one.'**
  String get bookmarksEditorDuplicate;

  /// Explains what a stop bookmark is, in the editor.
  ///
  /// In en, this message translates to:
  /// **'Stop bookmark: shows the next departures of every route at {stop}.'**
  String bookmarksEditorStopKind(String stop);

  /// Explains what a trip bookmark is, in the editor.
  ///
  /// In en, this message translates to:
  /// **'Trip bookmark: shows the next departures of {route} at {stop}.'**
  String bookmarksEditorTripKind(String route, String stop);

  /// Switch label: bookmark just one route at the stop instead of the whole stop.
  ///
  /// In en, this message translates to:
  /// **'Only {route}'**
  String bookmarksEditorTripOnly(String route);

  /// Label of the group picker in the bookmark editor.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get bookmarksEditorGroup;

  /// Menu entry that creates a new bookmark group.
  ///
  /// In en, this message translates to:
  /// **'New group…'**
  String get bookmarksEditorNewGroup;

  /// Title of the dialog for naming a new group.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get bookmarksEditorNewGroupTitle;

  /// Label of the group name field.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get bookmarksEditorGroupName;

  /// Button that saves the bookmark or group.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get bookmarksEditorSave;

  /// Announced after a bookmark was saved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark saved'**
  String get bookmarksEditorSaved;

  /// Button that deletes the bookmark being edited.
  ///
  /// In en, this message translates to:
  /// **'Delete bookmark'**
  String get bookmarksEditorDelete;

  /// Title of the delete confirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete this bookmark?'**
  String get bookmarksEditorDeleteTitle;

  /// Body of the delete confirmation.
  ///
  /// In en, this message translates to:
  /// **'“{name}” will be removed from your bookmarks.'**
  String bookmarksEditorDeleteBody(String name);

  /// Shown when a bookmark can't be created because no region is selected.
  ///
  /// In en, this message translates to:
  /// **'Choose a region before adding bookmarks.'**
  String get bookmarksEditorNoRegion;

  /// Heading of the list of bookmark groups on the manage screen.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get bookmarksManageGroupsHeader;

  /// Heading above a group's bookmarks on the manage screen.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksManageBookmarksHeader;

  /// Button that creates a bookmark group.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get bookmarksManageAddGroup;

  /// Action and dialog title for renaming a group.
  ///
  /// In en, this message translates to:
  /// **'Rename group'**
  String get bookmarksManageRenameGroup;

  /// Action that deletes a group.
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get bookmarksManageDeleteGroup;

  /// Confirmation text when deleting a group.
  ///
  /// In en, this message translates to:
  /// **'The bookmarks in “{name}” will become ungrouped.'**
  String bookmarksManageDeleteGroupBody(String name);

  /// Tooltip of the button that moves an item earlier in its list.
  ///
  /// In en, this message translates to:
  /// **'Move {name} up'**
  String bookmarksManageMoveUp(String name);

  /// Tooltip of the button that moves an item later in its list.
  ///
  /// In en, this message translates to:
  /// **'Move {name} down'**
  String bookmarksManageMoveDown(String name);

  /// Spoken label of the drag handle for reordering an item.
  ///
  /// In en, this message translates to:
  /// **'Reorder {name}'**
  String bookmarksManageReorder(String name);

  /// Announced after an item was moved.
  ///
  /// In en, this message translates to:
  /// **'{name}, position {position} of {count}'**
  String bookmarksManageMoved(String name, int position, int count);

  /// Shown on the manage screen when there is nothing to manage.
  ///
  /// In en, this message translates to:
  /// **'There are no bookmarks or groups to manage yet.'**
  String get bookmarksManageEmpty;

  /// Heading of the bookmarks in no group, on the manage screen.
  ///
  /// In en, this message translates to:
  /// **'Ungrouped bookmarks'**
  String get bookmarksManageUngrouped;

  /// Title shown when no stop was viewed recently.
  ///
  /// In en, this message translates to:
  /// **'No recent stops'**
  String get recentsEmptyTitle;

  /// Explains the recent stops list when it is empty.
  ///
  /// In en, this message translates to:
  /// **'Stops you look at appear here, newest first.'**
  String get recentsEmptyBody;

  /// Button that returns to the map so the user can find a stop.
  ///
  /// In en, this message translates to:
  /// **'Find stops on the map'**
  String get recentsFindStops;

  /// Button that removes every recent stop.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get recentsClearAll;

  /// Title of the confirmation for clearing recent stops.
  ///
  /// In en, this message translates to:
  /// **'Clear recent stops?'**
  String get recentsClearTitle;

  /// Body of the confirmation for clearing recent stops.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This removes 1 recent stop. Your bookmarks aren\'t affected.} other{This removes all {count} recent stops. Your bookmarks aren\'t affected.}}'**
  String recentsClearBody(int count);

  /// Tooltip and spoken action that removes one recent stop.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from recent stops'**
  String recentsRemove(String name);

  /// Snackbar shown after a recent stop was removed.
  ///
  /// In en, this message translates to:
  /// **'Removed {name}'**
  String recentsRemoved(String name);

  /// Shown in the Recent home section when it is empty.
  ///
  /// In en, this message translates to:
  /// **'Stops you look at appear here.'**
  String get recentsSectionEmpty;

  /// Header of the home section listing the user's departure alarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get alarmsSectionTitle;

  /// Detail line of an alarm: how long before the departure it rings, and the departure time.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute before departure} other{{minutes} minutes before departure}}, at {time}'**
  String alarmsRowDetails(int minutes, String time);

  /// Spoken label of one alarm row.
  ///
  /// In en, this message translates to:
  /// **'Alarm for {title}, {details}'**
  String alarmsRowLabel(String title, String details);

  /// Tooltip and spoken action that deletes one alarm.
  ///
  /// In en, this message translates to:
  /// **'Delete alarm for {title}'**
  String alarmsDelete(String title);

  /// Snackbar shown after an alarm was deleted.
  ///
  /// In en, this message translates to:
  /// **'Alarm deleted'**
  String get alarmsDeleted;

  /// Snackbar shown when deleting an alarm failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the alarm. Check your connection and try again.'**
  String get alarmsDeleteFailed;

  /// Hint of an alarm row.
  ///
  /// In en, this message translates to:
  /// **'Opens the trip'**
  String get alarmsOpen;

  /// Title shown when there are no active alerts.
  ///
  /// In en, this message translates to:
  /// **'No service alerts'**
  String get alertsEmptyTitle;

  /// Body shown when there are no active alerts.
  ///
  /// In en, this message translates to:
  /// **'There are no active service alerts right now.'**
  String get alertsEmptyBody;

  /// Explains which alerts the region-wide list covers.
  ///
  /// In en, this message translates to:
  /// **'Includes alerts for your bookmarked, recent and nearby stops.'**
  String get alertsRegionNote;

  /// Button that marks every alert read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get alertsMarkAllRead;

  /// Announced after marking every alert read.
  ///
  /// In en, this message translates to:
  /// **'All alerts marked as read'**
  String get alertsAllRead;

  /// Label of the marker on an alert that has not been read.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get alertsUnread;

  /// Severity label of a low-impact alert.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get alertsSeverityInfo;

  /// Severity label of a medium-impact alert.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get alertsSeverityWarning;

  /// Severity label of a high-impact alert.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get alertsSeveritySevere;

  /// Label of an alert whose severity is not given.
  ///
  /// In en, this message translates to:
  /// **'Service alert'**
  String get alertsSeverityUnknown;

  /// Title of an alert that has no summary.
  ///
  /// In en, this message translates to:
  /// **'Service alert'**
  String get alertsNoTitle;

  /// Spoken label of an alert row. unread is empty or 'Unread. '.
  ///
  /// In en, this message translates to:
  /// **'{unread}{severity}. {title}'**
  String alertsRowLabel(String unread, String severity, String title);

  /// Prefix of an alert row's spoken label when the alert has not been read.
  ///
  /// In en, this message translates to:
  /// **'Unread. '**
  String get alertsUnreadPrefix;

  /// Summary of how many alerts have not been read.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unread alert} other{{count} unread alerts}}'**
  String alertsUnreadCount(int count);

  /// Link text in the Alerts home section for the alerts not shown.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more alert} other{{count} more alerts}}'**
  String alertsSectionMore(int count);

  /// Heading of the dates an alert is in effect.
  ///
  /// In en, this message translates to:
  /// **'Active period'**
  String get alertsDetailActive;

  /// An alert's active period with an end.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String alertsDetailRange(String start, String end);

  /// An alert's active period that has no end.
  ///
  /// In en, this message translates to:
  /// **'From {start}'**
  String alertsDetailFrom(String start);

  /// Heading of the routes and stops an alert applies to.
  ///
  /// In en, this message translates to:
  /// **'Affects'**
  String get alertsDetailAffects;

  /// Heading of the routes an alert affects.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get alertsDetailRoutes;

  /// Heading of the stops an alert affects.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get alertsDetailStops;

  /// Heading of the agencies an alert affects.
  ///
  /// In en, this message translates to:
  /// **'Agencies'**
  String get alertsDetailAgencies;

  /// Button that opens the alert's web page.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get alertsDetailLearnMore;

  /// Shown when an alert has no description.
  ///
  /// In en, this message translates to:
  /// **'No additional details available.'**
  String get alertsDetailNoDetails;

  /// When an alert was published.
  ///
  /// In en, this message translates to:
  /// **'Issued {date}'**
  String alertsDetailUpdated(String date);

  /// Shown when a web, phone or email link can't be opened.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open that link.'**
  String get alertsCouldNotOpen;

  /// Title shown when the agency list is empty.
  ///
  /// In en, this message translates to:
  /// **'No agencies'**
  String get agenciesEmptyTitle;

  /// Body shown when the agency list is empty.
  ///
  /// In en, this message translates to:
  /// **'This region didn\'t list any transit agencies.'**
  String get agenciesEmptyBody;

  /// Link to an agency's website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get agenciesWebsite;

  /// Link that calls an agency.
  ///
  /// In en, this message translates to:
  /// **'Call {phone}'**
  String agenciesPhone(String phone);

  /// Link that emails an agency.
  ///
  /// In en, this message translates to:
  /// **'Email {email}'**
  String agenciesEmail(String email);

  /// Link to an agency's fare page.
  ///
  /// In en, this message translates to:
  /// **'Fare information'**
  String get agenciesFares;

  /// Heading of an agency's legal disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get agenciesDisclaimer;

  /// Button that centres the map on an agency's service area.
  ///
  /// In en, this message translates to:
  /// **'Show coverage on the map'**
  String get agenciesShowOnMap;

  /// Label of the search text field, read by screen readers.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchFieldLabel;

  /// Placeholder in the empty search field.
  ///
  /// In en, this message translates to:
  /// **'Route, stop number, address or vehicle'**
  String get searchFieldHint;

  /// Tooltip of the button that empties the search field.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClear;

  /// Screen-reader label of the group of search scope chips.
  ///
  /// In en, this message translates to:
  /// **'Search for'**
  String get searchScopeLabel;

  /// Search scope chip: every kind of result.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchScopeAll;

  /// Search scope chip: stops only.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get searchScopeStops;

  /// Search scope chip: routes only.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get searchScopeRoutes;

  /// Search scope chip: places and addresses only.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get searchScopePlaces;

  /// Header above the quick-search rows ("Route: 10", "Stop: 1234").
  ///
  /// In en, this message translates to:
  /// **'Search for'**
  String get searchQuickHeader;

  /// Quick-search row that looks the query up as a route name.
  ///
  /// In en, this message translates to:
  /// **'Route: {query}'**
  String searchQuickRoute(String query);

  /// Quick-search row that looks the query up as a stop number.
  ///
  /// In en, this message translates to:
  /// **'Stop number: {query}'**
  String searchQuickStop(String query);

  /// Quick-search row that looks the query up as an address or place.
  ///
  /// In en, this message translates to:
  /// **'Address: {query}'**
  String searchQuickAddress(String query);

  /// Quick-search row that looks the query up as a vehicle ID.
  ///
  /// In en, this message translates to:
  /// **'Vehicle: {query}'**
  String searchQuickVehicle(String query);

  /// Header of recently viewed stops matching the search.
  ///
  /// In en, this message translates to:
  /// **'Recent stops'**
  String get searchRecentStopsHeader;

  /// Header of bookmarks matching the search.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get searchBookmarksHeader;

  /// Header of the recent search queries.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecentSearchesHeader;

  /// Header of places chosen from earlier searches.
  ///
  /// In en, this message translates to:
  /// **'Recent places'**
  String get searchRecentPlacesHeader;

  /// Header of live place results for the query.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get searchPlacesHeader;

  /// Button that deletes recent searches and places.
  ///
  /// In en, this message translates to:
  /// **'Clear recent searches'**
  String get searchClearRecent;

  /// Title of the confirmation before deleting recent searches.
  ///
  /// In en, this message translates to:
  /// **'Clear your recent searches and places?'**
  String get searchClearRecentConfirm;

  /// Destructive button in the clear-recent-searches confirmation.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClearAction;

  /// Announcement after recent searches were deleted.
  ///
  /// In en, this message translates to:
  /// **'Recent searches cleared'**
  String get searchRecentCleared;

  /// Shown while place results load.
  ///
  /// In en, this message translates to:
  /// **'Searching places'**
  String get searchPlacesLoading;

  /// Shown when the place search matched nothing.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get searchPlacesNone;

  /// Shown when the place search failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search places. Check your connection.'**
  String get searchPlacesError;

  /// Screen-reader text while a search runs.
  ///
  /// In en, this message translates to:
  /// **'Searching'**
  String get searchSearching;

  /// Title when a search matched nothing.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get searchNoResultsTitle;

  /// Message when a search matched nothing.
  ///
  /// In en, this message translates to:
  /// **'No search results were found for “{query}”.'**
  String searchNoResultsBody(String query);

  /// Error when no region is selected so searches cannot run.
  ///
  /// In en, this message translates to:
  /// **'Choose a region before searching.'**
  String get searchUnavailableNoRegion;

  /// Error when no place search provider is configured.
  ///
  /// In en, this message translates to:
  /// **'Address search isn\'t set up in this app.'**
  String get searchUnavailableAddress;

  /// Error when the region has no vehicle search server.
  ///
  /// In en, this message translates to:
  /// **'Vehicle search isn\'t available in this region.'**
  String get searchUnavailableVehicle;

  /// Title of the search page before anything is typed.
  ///
  /// In en, this message translates to:
  /// **'Find routes, stops and places'**
  String get searchEmptyTitle;

  /// Body of the search page before anything is typed.
  ///
  /// In en, this message translates to:
  /// **'Type a route name, a stop number, an address or a vehicle ID.'**
  String get searchEmptyBody;

  /// Button that closes a search error or no-results message.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get searchDismissMessage;

  /// Heading of the search results list.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 result for “{query}”} other{{count} results for “{query}”}}'**
  String searchResultsHeading(int count, String query);

  /// Header of the route results.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get searchResultsRoutes;

  /// Header of the stop results.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get searchResultsStops;

  /// Header of the vehicle results.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get searchResultsVehicles;

  /// Header of the place results.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get searchResultsPlaces;

  /// Screen-reader sentence of a route result row.
  ///
  /// In en, this message translates to:
  /// **'Route {name}, {details}'**
  String searchRouteRowLabel(String name, String details);

  /// Title of a vehicle result row.
  ///
  /// In en, this message translates to:
  /// **'Vehicle {id}'**
  String searchVehicleTitle(String id);

  /// Message when the chosen vehicle has no current trip.
  ///
  /// In en, this message translates to:
  /// **'Vehicle {id} isn\'t serving a trip right now.'**
  String searchVehicleNoTrip(String id);

  /// Screen-reader text while a vehicle's status loads.
  ///
  /// In en, this message translates to:
  /// **'Loading vehicle {id}'**
  String searchVehicleLoading(String id);

  /// Nearby section text when location is not available yet.
  ///
  /// In en, this message translates to:
  /// **'Turn on location to see departures from stops near you.'**
  String get searchNearbyLocationPrompt;

  /// Button that asks for location permission for nearby stops.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get searchNearbyLocationButton;

  /// Nearby text when location permission was denied.
  ///
  /// In en, this message translates to:
  /// **'Location access is off. Turn it on in your device settings to see stops near you.'**
  String get searchNearbyLocationDenied;

  /// Nearby text when the device location service is disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Turn them on to see stops near you.'**
  String get searchNearbyLocationServicesOff;

  /// Nearby text when the host app gives the SDK no location at all (not a permission problem; nothing the rider can turn on).
  ///
  /// In en, this message translates to:
  /// **'This app doesn\'t use your location, so it can\'t show stops near you.'**
  String get searchNearbyLocationUnavailable;

  /// Title when there are no stops near the rider.
  ///
  /// In en, this message translates to:
  /// **'No stops nearby'**
  String get searchNearbyEmpty;

  /// Body when there are no stops near the rider.
  ///
  /// In en, this message translates to:
  /// **'There are no stops within walking distance.'**
  String get searchNearbyEmptyBody;

  /// Note shown when nearby stops are found around the map centre instead of the rider.
  ///
  /// In en, this message translates to:
  /// **'Showing stops near the centre of the map.'**
  String get searchNearbyMapCenter;

  /// Subtitle of a nearby stop with nothing leaving soon.
  ///
  /// In en, this message translates to:
  /// **'No departures in the next hour'**
  String get searchNearbyNoDepartures;

  /// Subtitle of a nearby stop whose departures are loading.
  ///
  /// In en, this message translates to:
  /// **'Loading departures'**
  String get searchNearbyLoadingDepartures;

  /// Screen-reader announcement after nearby departures refreshed.
  ///
  /// In en, this message translates to:
  /// **'Nearby departures updated'**
  String get searchNearbyUpdated;

  /// Screen-reader announcement after the nearby stops list refreshed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No stops nearby} =1{1 stop nearby} other{{count} stops nearby}}'**
  String searchNearbyStopsCount(int count);

  /// Nearby section text while waiting for the first location fix.
  ///
  /// In en, this message translates to:
  /// **'Finding your location…'**
  String get searchNearbyLocating;

  /// Tooltip of the button that reloads nearby stops.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get searchNearbyRefresh;

  /// Distance from the rider to a stop.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String searchNearbyDistance(String distance);

  /// Header for nearby stops with no direction of travel.
  ///
  /// In en, this message translates to:
  /// **'Other stops'**
  String get searchNearbyOtherDirection;

  /// Header grouping nearby stops by direction, e.g. "Northbound stops".
  ///
  /// In en, this message translates to:
  /// **'{direction} stops'**
  String searchNearbyDirectionHeader(String direction);

  /// Screen-reader sentence of a nearby departure row.
  ///
  /// In en, this message translates to:
  /// **'{route} to {headsign}, {eta}, {status}. From {stop}'**
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  );

  /// Subtitle of a nearby departure: the stop it leaves from.
  ///
  /// In en, this message translates to:
  /// **'From {stop}'**
  String searchNearbyStopFrom(String stop);

  /// Title of the embeddable nearby departures card.
  ///
  /// In en, this message translates to:
  /// **'Departures near you'**
  String get searchNearbyCardTitle;

  /// Short countdown to a departure.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String searchEtaMinutes(int minutes);

  /// Countdown for a departure leaving this minute.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get searchEtaNow;

  /// Spoken countdown to a departure.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{in 1 minute} other{in {minutes} minutes}}'**
  String searchEtaMinutesSpoken(int minutes);

  /// Spoken countdown for a departure leaving this minute.
  ///
  /// In en, this message translates to:
  /// **'leaving now'**
  String get searchEtaNowSpoken;

  /// Real-time status: on schedule.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get searchStatusOnTime;

  /// Real-time status: behind schedule.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 min late} other{{minutes} min late}}'**
  String searchStatusLate(int minutes);

  /// Real-time status: ahead of schedule.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 min early} other{{minutes} min early}}'**
  String searchStatusEarly(int minutes);

  /// Status of a departure with no real-time prediction.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get searchStatusScheduled;

  /// Explore shortcut that opens the trip planner.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip'**
  String get searchExplorePlanTrip;

  /// Explore shortcut that opens the weather forecast.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get searchExploreWeather;

  /// Explore shortcut that opens the list of transit agencies.
  ///
  /// In en, this message translates to:
  /// **'Agencies'**
  String get searchExploreAgencies;

  /// Label of a place's address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get searchPlaceAddress;

  /// Label of a place's latitude and longitude.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get searchPlaceCoordinates;

  /// Label of the distance from the rider to a place.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get searchPlaceDistance;

  /// Button that plans a trip to this place.
  ///
  /// In en, this message translates to:
  /// **'Directions to here'**
  String get searchPlaceDirectionsTo;

  /// Button that plans a trip from this place.
  ///
  /// In en, this message translates to:
  /// **'Directions from here'**
  String get searchPlaceDirectionsFrom;

  /// Button that lists the stops near this place.
  ///
  /// In en, this message translates to:
  /// **'Nearby stops'**
  String get searchPlaceNearbyStops;

  /// Button that shares this place.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get searchPlaceShare;

  /// Button that opens this place in the device's maps app.
  ///
  /// In en, this message translates to:
  /// **'Open in maps app'**
  String get searchPlaceOpenInMaps;

  /// Button that removes a dropped pin from the map.
  ///
  /// In en, this message translates to:
  /// **'Remove pin'**
  String get searchPlaceRemovePin;

  /// Message when no maps app could be opened.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open a maps app.'**
  String get searchPlaceOpenFailed;

  /// Message when sharing failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share this place.'**
  String get searchPlaceShareFailed;

  /// Screen-reader label of a place marker on the map.
  ///
  /// In en, this message translates to:
  /// **'Place: {name}'**
  String searchPlaceMarkerLabel(String name);

  /// Screen-reader label of the map weather button.
  ///
  /// In en, this message translates to:
  /// **'Weather: {temperature}, {condition}'**
  String searchWeatherButtonLabel(String temperature, String condition);

  /// Screen-reader hint of the map weather button.
  ///
  /// In en, this message translates to:
  /// **'Shows the forecast'**
  String get searchWeatherButtonHint;

  /// Weather condition: clear skies.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchWeatherClear;

  /// Weather condition: partly cloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get searchWeatherPartlyCloudy;

  /// Weather condition: cloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get searchWeatherCloudy;

  /// Weather condition: rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get searchWeatherRain;

  /// Weather condition: sleet.
  ///
  /// In en, this message translates to:
  /// **'Sleet'**
  String get searchWeatherSleet;

  /// Weather condition: snow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get searchWeatherSnow;

  /// Weather condition: windy.
  ///
  /// In en, this message translates to:
  /// **'Windy'**
  String get searchWeatherWindy;

  /// Weather condition: fog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get searchWeatherFog;

  /// Weather condition the app does not recognise.
  ///
  /// In en, this message translates to:
  /// **'Unknown conditions'**
  String get searchWeatherUnknown;

  /// A temperature in degrees Fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'{value}°F'**
  String searchWeatherDegreesF(int value);

  /// A temperature in degrees Celsius.
  ///
  /// In en, this message translates to:
  /// **'{value}°C'**
  String searchWeatherDegreesC(int value);

  /// A temperature in Fahrenheit, spoken.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 degree Fahrenheit} other{{value} degrees Fahrenheit}}'**
  String searchWeatherSpokenF(int value);

  /// A temperature in Celsius, spoken.
  ///
  /// In en, this message translates to:
  /// **'{value, plural, =1{1 degree Celsius} other{{value} degrees Celsius}}'**
  String searchWeatherSpokenC(int value);

  /// A wind speed in miles per hour.
  ///
  /// In en, this message translates to:
  /// **'{value} mph'**
  String searchWeatherMph(int value);

  /// A wind speed in kilometres per hour.
  ///
  /// In en, this message translates to:
  /// **'{value} km/h'**
  String searchWeatherKmh(int value);

  /// A wind speed in metres per second.
  ///
  /// In en, this message translates to:
  /// **'{value} m/s'**
  String searchWeatherMps(int value);

  /// A percentage (chance of precipitation).
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String searchWeatherPercent(int value);

  /// Label of the apparent temperature.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get searchWeatherFeelsLike;

  /// Label of the wind speed.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get searchWeatherWind;

  /// Label of the chance of precipitation.
  ///
  /// In en, this message translates to:
  /// **'Chance of rain'**
  String get searchWeatherPrecip;

  /// Highest and lowest temperature over the next 24 hours.
  ///
  /// In en, this message translates to:
  /// **'High {high} · Low {low}'**
  String searchWeatherHighLow(String high, String low);

  /// Spoken high and low temperature.
  ///
  /// In en, this message translates to:
  /// **'High {high}, low {low}, over the next 24 hours'**
  String searchWeatherHighLowSpoken(String high, String low);

  /// Header of the hourly forecast list.
  ///
  /// In en, this message translates to:
  /// **'Next 24 hours'**
  String get searchWeatherHourly;

  /// Label of the current hour in the hourly forecast.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get searchWeatherNow;

  /// Screen-reader sentence of one hour of the forecast.
  ///
  /// In en, this message translates to:
  /// **'{time}: {temperature}, {condition}, {precip} chance of rain'**
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  );

  /// Note naming the temperature unit used.
  ///
  /// In en, this message translates to:
  /// **'Temperatures in {unit}'**
  String searchWeatherUnitsNote(String unit);

  /// Unit name for the temperature note.
  ///
  /// In en, this message translates to:
  /// **'degrees Fahrenheit (°F)'**
  String get searchWeatherFahrenheit;

  /// Unit name for the temperature note.
  ///
  /// In en, this message translates to:
  /// **'degrees Celsius (°C)'**
  String get searchWeatherCelsius;

  /// When the forecast was retrieved.
  ///
  /// In en, this message translates to:
  /// **'Forecast from {time}'**
  String searchWeatherUpdated(String time);

  /// Shown when the region has no weather server.
  ///
  /// In en, this message translates to:
  /// **'Weather isn\'t available for this region.'**
  String get searchWeatherUnavailable;

  /// Header of the day's weather summary.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get searchWeatherSummaryLabel;

  /// Shown in the Bookmarks home section when there are no bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked stops appear here.'**
  String get bookmarksSectionEmpty;

  /// Compass direction a stop faces (N), spoken in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get coreDirectionNameN;

  /// Compass direction a stop faces (NE), spoken in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get coreDirectionNameNE;

  /// Compass direction a stop faces (E), spoken in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get coreDirectionNameE;

  /// Compass direction a stop faces (SE), spoken in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get coreDirectionNameSE;

  /// Compass direction a stop faces (S), spoken in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get coreDirectionNameS;

  /// Compass direction a stop faces (SW), spoken in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get coreDirectionNameSW;

  /// Compass direction a stop faces (W), spoken in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get coreDirectionNameW;

  /// Compass direction a stop faces (NW), spoken in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get coreDirectionNameNW;

  /// Short compass direction (North) after a stop name, e.g. 'Pine St & 3rd Ave (N)'.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get coreDirectionAbbrN;

  /// Short compass direction (Northeast) after a stop name, e.g. 'Pine St & 3rd Ave (NE)'.
  ///
  /// In en, this message translates to:
  /// **'NE'**
  String get coreDirectionAbbrNE;

  /// Short compass direction (East) after a stop name, e.g. 'Pine St & 3rd Ave (E)'.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get coreDirectionAbbrE;

  /// Short compass direction (Southeast) after a stop name, e.g. 'Pine St & 3rd Ave (SE)'.
  ///
  /// In en, this message translates to:
  /// **'SE'**
  String get coreDirectionAbbrSE;

  /// Short compass direction (South) after a stop name, e.g. 'Pine St & 3rd Ave (S)'.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get coreDirectionAbbrS;

  /// Short compass direction (Southwest) after a stop name, e.g. 'Pine St & 3rd Ave (SW)'.
  ///
  /// In en, this message translates to:
  /// **'SW'**
  String get coreDirectionAbbrSW;

  /// Short compass direction (West) after a stop name, e.g. 'Pine St & 3rd Ave (W)'.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get coreDirectionAbbrW;

  /// Short compass direction (Northwest) after a stop name, e.g. 'Pine St & 3rd Ave (NW)'.
  ///
  /// In en, this message translates to:
  /// **'NW'**
  String get coreDirectionAbbrNW;

  /// Direction of travel at a stop facing North, e.g. 'Stop #1234 — Northbound'. Short forms follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'Northbound'**
  String get coreDirectionBoundN;

  /// Direction of travel at a stop facing Northeast, e.g. 'Stop #1234 — NE bound'. Short forms follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'NE bound'**
  String get coreDirectionBoundNE;

  /// Direction of travel at a stop facing East, e.g. 'Stop #1234 — Eastbound'. Short forms follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'Eastbound'**
  String get coreDirectionBoundE;

  /// Direction of travel at a stop facing Southeast, e.g. 'Stop #1234 — SE bound'. Short forms follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'SE bound'**
  String get coreDirectionBoundSE;

  /// Direction of travel at a stop facing South, e.g. 'Stop #1234 — Southbound'. Short forms follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'Southbound'**
  String get coreDirectionBoundS;

  /// Direction of travel at a stop facing Southwest, e.g. 'Stop #1234 — SW bound'. Short forms follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'SW bound'**
  String get coreDirectionBoundSW;

  /// Direction of travel at a stop facing West, e.g. 'Stop #1234 — Westbound'. Short forms follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'Westbound'**
  String get coreDirectionBoundW;

  /// Direction of travel at a stop facing Northwest, e.g. 'Stop #1234 — NW bound'. Short forms follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'NW bound'**
  String get coreDirectionBoundNW;

  /// Kind of transit route, shown instead of route numbers when a route has none (e.g. ferries).
  ///
  /// In en, this message translates to:
  /// **'Light Rail'**
  String get coreRouteTypeLightRail;

  /// Kind of transit route, shown instead of route numbers when a route has none (e.g. ferries).
  ///
  /// In en, this message translates to:
  /// **'Subway'**
  String get coreRouteTypeSubway;

  /// Kind of transit route, shown instead of route numbers when a route has none (e.g. ferries).
  ///
  /// In en, this message translates to:
  /// **'Rail'**
  String get coreRouteTypeRail;

  /// Kind of transit route, shown instead of route numbers when a route has none (e.g. ferries).
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get coreRouteTypeBus;

  /// Kind of transit route, shown instead of route numbers when a route has none (e.g. ferries).
  ///
  /// In en, this message translates to:
  /// **'Ferry'**
  String get coreRouteTypeFerry;

  /// Kind of transit route, shown instead of route numbers when a route has none (e.g. ferries).
  ///
  /// In en, this message translates to:
  /// **'Cable Car'**
  String get coreRouteTypeCableCar;

  /// Kind of transit route, shown instead of route numbers when a route has none (e.g. ferries).
  ///
  /// In en, this message translates to:
  /// **'Gondola'**
  String get coreRouteTypeGondola;

  /// Kind of transit route, shown instead of route numbers when a route has none (e.g. ferries).
  ///
  /// In en, this message translates to:
  /// **'Funicular'**
  String get coreRouteTypeFunicular;

  /// Numeric stop code, e.g. 'Stop #1234'.
  ///
  /// In en, this message translates to:
  /// **'Stop #{code}'**
  String coreStopCodeNumeric(String code);

  /// Stop code that is not a number, e.g. Stop: 'Old Library'.
  ///
  /// In en, this message translates to:
  /// **'Stop: \'{code}\''**
  String coreStopCodeNonNumeric(String code);

  /// Stop code in a stop's screen-reader label.
  ///
  /// In en, this message translates to:
  /// **'Stop ID: {code}'**
  String coreStopId(String code);

  /// Routes serving a stop; routes is a comma-separated list such as '10, 12, 49'.
  ///
  /// In en, this message translates to:
  /// **'Routes: {routes}'**
  String coreRoutesLabel(String routes);

  /// Routes serving a stop when the list is cut short; count is how many routes are not listed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Routes: {routes}, + {count} more}}'**
  String coreRoutesLabelPlusMore(String routes, int count);

  /// Route list on a map pin when more routes are not shown.
  ///
  /// In en, this message translates to:
  /// **'{routes}…'**
  String coreMapRoutesOverflow(String routes);

  /// Placeholder of the search field; region is the transit region's name.
  ///
  /// In en, this message translates to:
  /// **'Search in {region}'**
  String coreSearchPlaceholder(String region);

  /// Compact countdown for a vehicle arriving or departing now. Capitals follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'NOW'**
  String get coreNow;

  /// Compact countdown in minutes, e.g. '7m' (negative for a past departure).
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String coreShortMinutes(int minutes);

  /// Spoken countdown of one minute.
  ///
  /// In en, this message translates to:
  /// **'One minute'**
  String get coreOneMinute;

  /// Spoken time of a departure one minute ago.
  ///
  /// In en, this message translates to:
  /// **'One minute ago'**
  String get coreOneMinuteAgo;

  /// Spoken countdown in minutes (never one: that has its own string).
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, other{{minutes} minutes}}'**
  String coreMinutes(int minutes);

  /// Relative time under five seconds ago. Capitals follow the iOS app.
  ///
  /// In en, this message translates to:
  /// **'Just Now'**
  String get coreJustNow;

  /// Relative time in seconds, e.g. 'Updated 31 sec. ago'.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec. ago'**
  String coreSecondsAgo(int seconds);

  /// Relative time in minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min. ago'**
  String coreMinutesAgo(int minutes);

  /// Relative time in hours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr. ago'**
  String coreHoursAgo(int hours);

  /// Relative time in days.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day ago} other{{days} days ago}}'**
  String coreDaysAgo(int days);

  /// When data was last updated; ago is a relative time such as '4 min. ago'.
  ///
  /// In en, this message translates to:
  /// **'Updated: {ago}'**
  String coreUpdatedAt(String ago);

  /// Status of a departure with no real-time prediction.
  ///
  /// In en, this message translates to:
  /// **'Scheduled/not real-time'**
  String get coreScheduledNotRealTime;

  /// A vehicle that already arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived {minutes} min ago'**
  String coreArrivedMinAgo(int minutes);

  /// A vehicle that already departed.
  ///
  /// In en, this message translates to:
  /// **'Departed {minutes} min ago'**
  String coreDepartedMinAgo(int minutes);

  /// A vehicle arriving now.
  ///
  /// In en, this message translates to:
  /// **'Arriving now'**
  String get coreArrivingNow;

  /// A vehicle departing now.
  ///
  /// In en, this message translates to:
  /// **'Departing now'**
  String get coreDepartingNow;

  /// A vehicle arriving in some minutes.
  ///
  /// In en, this message translates to:
  /// **'Arrives in {minutes} min'**
  String coreArrivesInMin(int minutes);

  /// A vehicle departing in some minutes.
  ///
  /// In en, this message translates to:
  /// **'Departs in {minutes} min'**
  String coreDepartsInMin(int minutes);

  /// Schedule deviation: arrived behind schedule.
  ///
  /// In en, this message translates to:
  /// **'arrived {minutes} min late'**
  String coreArrivedLate(int minutes);

  /// Schedule deviation: arrived ahead of schedule.
  ///
  /// In en, this message translates to:
  /// **'arrived {minutes} min early'**
  String coreArrivedEarly(int minutes);

  /// Schedule deviation: arrived on schedule.
  ///
  /// In en, this message translates to:
  /// **'arrived on time'**
  String get coreArrivedOnTime;

  /// Schedule deviation: departed behind schedule.
  ///
  /// In en, this message translates to:
  /// **'departed {minutes} min late'**
  String coreDepartedLate(int minutes);

  /// Schedule deviation: departed ahead of schedule.
  ///
  /// In en, this message translates to:
  /// **'departed {minutes} min early'**
  String coreDepartedEarly(int minutes);

  /// Schedule deviation: departed on schedule.
  ///
  /// In en, this message translates to:
  /// **'departed on time'**
  String get coreDepartedOnTime;

  /// Schedule deviation: arrives behind schedule.
  ///
  /// In en, this message translates to:
  /// **'arrives {minutes} min late'**
  String coreArrivesLate(int minutes);

  /// Schedule deviation: arrives ahead of schedule.
  ///
  /// In en, this message translates to:
  /// **'arrives {minutes} min early'**
  String coreArrivesEarly(int minutes);

  /// Schedule deviation: arrives on schedule.
  ///
  /// In en, this message translates to:
  /// **'arrives on time'**
  String get coreArrivesOnTime;

  /// Schedule deviation: departs behind schedule.
  ///
  /// In en, this message translates to:
  /// **'departs {minutes} min late'**
  String coreDepartsLate(int minutes);

  /// Schedule deviation: departs ahead of schedule.
  ///
  /// In en, this message translates to:
  /// **'departs {minutes} min early'**
  String coreDepartsEarly(int minutes);

  /// Schedule deviation: departs on schedule.
  ///
  /// In en, this message translates to:
  /// **'departs on time'**
  String get coreDepartsOnTime;

  /// A distance in metres; value is already formatted, e.g. '350 m'.
  ///
  /// In en, this message translates to:
  /// **'{value} m'**
  String coreMeters(String value);

  /// A distance in kilometres, e.g. '1.2 km'.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String coreKilometers(String value);

  /// A distance in feet, e.g. '500 ft'.
  ///
  /// In en, this message translates to:
  /// **'{value} ft'**
  String coreFeet(String value);

  /// A distance in miles, e.g. '0.3 mi'.
  ///
  /// In en, this message translates to:
  /// **'{value} mi'**
  String coreMiles(String value);

  /// Alarm lead time: how long before a departure the alarm rings.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute} other{{minutes} minutes}}'**
  String coreAlarmMinutes(int minutes);

  /// Arrivals panel countdown for a vehicle arriving now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get arrivalsNow;

  /// Arrivals panel compact countdown, e.g. '5m'.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String arrivalsMinutesCompact(int minutes);

  /// Arrivals panel status of a canceled trip.
  ///
  /// In en, this message translates to:
  /// **'canceled'**
  String get arrivalsCanceled;

  /// Frequency-based service that has not started yet; time is a clock time.
  ///
  /// In en, this message translates to:
  /// **'every {minutes} min from {time}'**
  String arrivalsEveryMinutesFrom(int minutes, String time);

  /// Frequency-based service running now; time is a clock time.
  ///
  /// In en, this message translates to:
  /// **'every {minutes} min until {time}'**
  String arrivalsEveryMinutesUntil(int minutes, String time);

  /// Arrivals panel header: the direction of travel at a stop facing North.
  ///
  /// In en, this message translates to:
  /// **'North bound'**
  String get arrivalsDirectionBoundN;

  /// Arrivals panel header: the direction of travel at a stop facing Northeast.
  ///
  /// In en, this message translates to:
  /// **'Northeast bound'**
  String get arrivalsDirectionBoundNE;

  /// Arrivals panel header: the direction of travel at a stop facing East.
  ///
  /// In en, this message translates to:
  /// **'East bound'**
  String get arrivalsDirectionBoundE;

  /// Arrivals panel header: the direction of travel at a stop facing Southeast.
  ///
  /// In en, this message translates to:
  /// **'Southeast bound'**
  String get arrivalsDirectionBoundSE;

  /// Arrivals panel header: the direction of travel at a stop facing South.
  ///
  /// In en, this message translates to:
  /// **'South bound'**
  String get arrivalsDirectionBoundS;

  /// Arrivals panel header: the direction of travel at a stop facing Southwest.
  ///
  /// In en, this message translates to:
  /// **'Southwest bound'**
  String get arrivalsDirectionBoundSW;

  /// Arrivals panel header: the direction of travel at a stop facing West.
  ///
  /// In en, this message translates to:
  /// **'West bound'**
  String get arrivalsDirectionBoundW;

  /// Arrivals panel header: the direction of travel at a stop facing Northwest.
  ///
  /// In en, this message translates to:
  /// **'Northwest bound'**
  String get arrivalsDirectionBoundNW;

  /// Arrivals panel header for a direction code the app doesn't know; code is shown as received.
  ///
  /// In en, this message translates to:
  /// **'{code} bound'**
  String arrivalsDirectionBoundOther(String code);

  /// Arrivals panel refresh button label.
  ///
  /// In en, this message translates to:
  /// **'Refresh arrivals'**
  String get arrivalsRefresh;

  /// Arrivals panel button that repeats a failed request.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get arrivalsRetry;

  /// Arrivals panel empty state.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, other{No arrivals in the next {minutes} minutes}}'**
  String arrivalsNoArrivals(int minutes);

  /// Arrivals panel error when the server returns nothing for the stop.
  ///
  /// In en, this message translates to:
  /// **'Stop not found or service unavailable'**
  String get arrivalsStopNotFound;

  /// Arrivals panel error when the network fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the transit server. Check your connection.'**
  String get arrivalsNetworkError;

  /// Arrivals panel generic error.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load arrivals.'**
  String get arrivalsLoadError;

  /// Arrivals panel notice after a failed refresh; time is a clock time.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update. Showing results from {time}'**
  String arrivalsStaleNotice(String time);

  /// Spoken by screen readers for an arrival happening now.
  ///
  /// In en, this message translates to:
  /// **'arriving now'**
  String get arrivalsArrivingNow;

  /// Spoken by screen readers for an upcoming arrival.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{arriving in 1 minute} other{arriving in {minutes} minutes}}'**
  String arrivalsArrivingInMinutes(int minutes);

  /// Spoken by screen readers for an arrival with a live prediction.
  ///
  /// In en, this message translates to:
  /// **'real-time'**
  String get arrivalsRealtime;

  /// Screen reader hint on a tappable arrival row ("double-tap to show details").
  ///
  /// In en, this message translates to:
  /// **'show details'**
  String get arrivalsRowTapHint;

  /// Spoken arrival clock time, e.g. 'at 10:47 PM'.
  ///
  /// In en, this message translates to:
  /// **'at {time}'**
  String arrivalsAtTime(String time);

  /// Spoken schedule deviation.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute late} other{{minutes} minutes late}}'**
  String arrivalsMinutesLateSemantics(int minutes);

  /// Spoken schedule deviation.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute early} other{{minutes} minutes early}}'**
  String arrivalsMinutesEarlySemantics(int minutes);

  /// Spoken form of the frequency line for service not yet started.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, other{every {minutes} minutes from {time}}}'**
  String arrivalsEveryMinutesFromSemantics(int minutes, String time);

  /// Spoken form of the frequency line for service running now.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, other{every {minutes} minutes until {time}}}'**
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time);

  /// Spoken for an arrival without a real-time prediction.
  ///
  /// In en, this message translates to:
  /// **'scheduled time'**
  String get arrivalsScheduledSemantics;

  /// Spoken by screen readers while the first request is in flight.
  ///
  /// In en, this message translates to:
  /// **'Loading arrivals'**
  String get arrivalsLoading;

  /// Label of the refresh button's progress indicator.
  ///
  /// In en, this message translates to:
  /// **'Refreshing arrivals'**
  String get arrivalsRefreshing;

  /// Announced after a refresh the rider asked for succeeds.
  ///
  /// In en, this message translates to:
  /// **'Arrivals updated'**
  String get arrivalsUpdated;

  /// Trip planner: label of the starting point field.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get tripPlannerOriginLabel;

  /// Trip planner: label of the destination field.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get tripPlannerDestinationLabel;

  /// Trip planner: placeholder of an empty starting point.
  ///
  /// In en, this message translates to:
  /// **'Choose starting point'**
  String get tripPlannerChooseOrigin;

  /// Trip planner: placeholder of an empty destination.
  ///
  /// In en, this message translates to:
  /// **'Choose destination'**
  String get tripPlannerChooseDestination;

  /// Trip planner: name of the rider's current location as a trip endpoint.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get tripPlannerCurrentLocation;

  /// Trip planner: button that swaps the two endpoints.
  ///
  /// In en, this message translates to:
  /// **'Swap starting point and destination'**
  String get tripPlannerSwapEndpoints;

  /// Trip planner: button that plans the trip.
  ///
  /// In en, this message translates to:
  /// **'Plan trip'**
  String get tripPlannerPlanTrip;

  /// Trip planner: shown and spoken while a trip is being planned.
  ///
  /// In en, this message translates to:
  /// **'Planning your trip'**
  String get tripPlannerPlanningTrip;

  /// Trip planner: heading of the options section.
  ///
  /// In en, this message translates to:
  /// **'Trip options'**
  String get tripPlannerOptions;

  /// Trip planner time option.
  ///
  /// In en, this message translates to:
  /// **'Leave now'**
  String get tripPlannerLeaveNow;

  /// Trip planner time option: leave at a chosen time.
  ///
  /// In en, this message translates to:
  /// **'Depart at'**
  String get tripPlannerDepartAt;

  /// Trip planner time option: arrive by a chosen time.
  ///
  /// In en, this message translates to:
  /// **'Arrive by'**
  String get tripPlannerArriveBy;

  /// Trip planner: button that changes the trip time; dateTime is e.g. 'Wed, Nov 25, 9:00 AM'.
  ///
  /// In en, this message translates to:
  /// **'Change time, {dateTime}'**
  String tripPlannerChangeTime(String dateTime);

  /// Trip planner: a way of travelling the rider can choose (also the name of a walking, cycling, driving or transit leg).
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get tripPlannerModeTransit;

  /// Trip planner: a way of travelling the rider can choose (also the name of a walking, cycling, driving or transit leg).
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get tripPlannerModeWalk;

  /// Trip planner: a way of travelling the rider can choose (also the name of a walking, cycling, driving or transit leg).
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get tripPlannerModeBike;

  /// Trip planner: a way of travelling the rider can choose (also the name of a walking, cycling, driving or transit leg).
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get tripPlannerModeCar;

  /// Trip planner: a way of travelling the rider can choose (also the name of a walking, cycling, driving or transit leg).
  ///
  /// In en, this message translates to:
  /// **'Bikeshare Only'**
  String get tripPlannerModeBikeRental;

  /// Trip planner: a way of travelling the rider can choose (also the name of a walking, cycling, driving or transit leg).
  ///
  /// In en, this message translates to:
  /// **'Transit + Bikeshare'**
  String get tripPlannerModeTransitBikeRental;

  /// Trip planner option: only wheelchair-accessible trips.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair accessible'**
  String get tripPlannerWheelchairAccessible;

  /// Trip planner: maximum walking distance choice.
  ///
  /// In en, this message translates to:
  /// **'0.25 mile'**
  String get tripPlannerWalkQuarterMile;

  /// Trip planner: maximum walking distance choice.
  ///
  /// In en, this message translates to:
  /// **'0.5 mile'**
  String get tripPlannerWalkHalfMile;

  /// Trip planner: maximum walking distance choice.
  ///
  /// In en, this message translates to:
  /// **'1 mile'**
  String get tripPlannerWalkOneMile;

  /// Trip planner: maximum walking distance choice.
  ///
  /// In en, this message translates to:
  /// **'2 miles'**
  String get tripPlannerWalkTwoMiles;

  /// Trip planner: maximum walking distance setting, e.g. 'Walk up to 0.5 mile'.
  ///
  /// In en, this message translates to:
  /// **'Walk up to {distance}'**
  String tripPlannerMaxWalk(String distance);

  /// Trip planner: no itineraries were found.
  ///
  /// In en, this message translates to:
  /// **'No trips found'**
  String get tripPlannerNoTripsFound;

  /// Trip planner: button that repeats a failed request.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get tripPlannerRetry;

  /// Trip planner: badge on a leg with live data.
  ///
  /// In en, this message translates to:
  /// **'Real-time'**
  String get tripPlannerRealTime;

  /// Trip planner: compact trip duration under an hour.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String tripPlannerDurationMinutes(int minutes);

  /// Trip planner: compact trip duration in whole hours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr'**
  String tripPlannerDurationHours(int hours);

  /// Trip planner: compact trip duration, e.g. '1 hr 5 min'.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr {minutes} min'**
  String tripPlannerDurationHoursMinutes(int hours, int minutes);

  /// Trip planner: start and end clock times of a trip.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String tripPlannerTimeRange(String start, String end);

  /// Trip planner: number of transfers in a trip.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transfers} =1{1 transfer} other{{count} transfers}}'**
  String tripPlannerTransfers(int count);

  /// Trip planner: total walking in a trip, e.g. 'Walk 0.4 mi'.
  ///
  /// In en, this message translates to:
  /// **'Walk {distance}'**
  String tripPlannerWalkDistance(String distance);

  /// Trip planner: when and where a trip starts.
  ///
  /// In en, this message translates to:
  /// **'Departs {time} from {place}'**
  String tripPlannerDepartsAt(String time, String place);

  /// Trip planner: real-time status of a transit leg.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get tripPlannerStatusOnTime;

  /// Trip planner: real-time status of a transit leg.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min late'**
  String tripPlannerStatusLate(int minutes);

  /// Trip planner: real-time status of a transit leg.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min early'**
  String tripPlannerStatusEarly(int minutes);

  /// Trip planner: status of a transit leg with no live data.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get tripPlannerStatusScheduled;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get tripPlannerLegBus;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Tram'**
  String get tripPlannerLegTram;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Subway'**
  String get tripPlannerLegSubway;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get tripPlannerLegRail;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Ferry'**
  String get tripPlannerLegFerry;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Cable Car'**
  String get tripPlannerLegCableCar;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Gondola'**
  String get tripPlannerLegGondola;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Funicular'**
  String get tripPlannerLegFunicular;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Plane'**
  String get tripPlannerLegAirplane;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Trolleybus'**
  String get tripPlannerLegTrolleybus;

  /// Trip planner: kind of vehicle for a transit leg, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Monorail'**
  String get tripPlannerLegMonorail;

  /// Trip planner: screen-reader summary of a trip; each part is already formatted.
  ///
  /// In en, this message translates to:
  /// **'{timeRange}, {duration}. {legs}. {details}'**
  String tripPlannerItinerarySemantics(
    String timeRange,
    String duration,
    String legs,
    String details,
  );

  /// Trip planner: spoken walking leg, e.g. 'Walk 5 minutes'.
  ///
  /// In en, this message translates to:
  /// **'Walk {duration}'**
  String tripPlannerLegWalkSemantics(String duration);

  /// Trip planner: spoken cycling leg.
  ///
  /// In en, this message translates to:
  /// **'Bike {duration}'**
  String tripPlannerLegBikeSemantics(String duration);

  /// Trip planner: spoken bikeshare leg.
  ///
  /// In en, this message translates to:
  /// **'Rental bike {duration}'**
  String tripPlannerLegRentalBikeSemantics(String duration);

  /// Trip planner: spoken driving leg.
  ///
  /// In en, this message translates to:
  /// **'Drive {duration}'**
  String tripPlannerLegCarSemantics(String duration);

  /// Trip planner: spoken transit leg with no route name, e.g. 'Ferry, 32 minutes'.
  ///
  /// In en, this message translates to:
  /// **'{mode}, {duration}'**
  String tripPlannerLegTransitSemantics(String mode, String duration);

  /// Trip planner: spoken transit leg, e.g. 'Tram Blue, 32 minutes'.
  ///
  /// In en, this message translates to:
  /// **'{mode} {route}, {duration}'**
  String tripPlannerLegTransitRouteSemantics(
    String mode,
    String route,
    String duration,
  );

  /// Trip planner: spoken between legs of a trip ('Walk 5 minutes, then Bus 10').
  ///
  /// In en, this message translates to:
  /// **'then'**
  String get tripPlannerThen;

  /// Trip planner: screen reader hint on a trip ("double-tap to show trip details").
  ///
  /// In en, this message translates to:
  /// **'show trip details'**
  String get tripPlannerOpenItineraryHint;

  /// Trip planner: spoken duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute} other{{minutes} minutes}}'**
  String tripPlannerMinutesSemantics(int minutes);

  /// Trip planner: spoken duration in hours.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{1 hour} other{{hours} hours}}'**
  String tripPlannerHoursSemantics(int hours);

  /// Trip planner: spoken duration of hours and minutes, e.g. '1 hour 5 minutes'; both parts are already formatted.
  ///
  /// In en, this message translates to:
  /// **'{hours} {minutes}'**
  String tripPlannerHoursMinutesSemantics(String hours, String minutes);

  /// Trip planner: spoken distance in feet; count is the amount, value the same amount already formatted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 foot} other{{value} feet}}'**
  String tripPlannerFeetSemantics(num count, String value);

  /// Trip planner: spoken distance in miles; count is the amount, value the same amount already formatted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 mile} other{{value} miles}}'**
  String tripPlannerMilesSemantics(num count, String value);

  /// Trip planner: spoken distance in meters; count is the amount, value the same amount already formatted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 meter} other{{value} meters}}'**
  String tripPlannerMetersSemantics(num count, String value);

  /// Trip planner: spoken distance in kilometers; count is the amount, value the same amount already formatted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 kilometer} other{{value} kilometers}}'**
  String tripPlannerKilometersSemantics(num count, String value);

  /// Trip planner: spoken start and end clock times.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String tripPlannerTimeRangeSemantics(String start, String end);

  /// Trip planner: spoken real-time status.
  ///
  /// In en, this message translates to:
  /// **'real-time, on time'**
  String get tripPlannerStatusOnTimeSemantics;

  /// Trip planner: spoken real-time status.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{real-time, 1 minute late} other{real-time, {minutes} minutes late}}'**
  String tripPlannerStatusLateSemantics(int minutes);

  /// Trip planner: spoken real-time status.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{real-time, 1 minute early} other{real-time, {minutes} minutes early}}'**
  String tripPlannerStatusEarlySemantics(int minutes);

  /// Trip planner: spoken status of a leg with no live data.
  ///
  /// In en, this message translates to:
  /// **'scheduled time'**
  String get tripPlannerStatusScheduledSemantics;

  /// Trip planner: heading above the results.
  ///
  /// In en, this message translates to:
  /// **'Suggested trips'**
  String get tripPlannerResultsHeading;

  /// Trip planner: announced when a plan finishes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 trip found} other{{count} trips found}}'**
  String tripPlannerTripsFound(int count);

  /// Trip planner: announced when a place search finishes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 place found} other{{count} places found}}'**
  String tripPlannerPlacesFound(int count);

  /// Trip planner: screen-reader label of the trip map.
  ///
  /// In en, this message translates to:
  /// **'Map of the trip. The directions below describe the same trip.'**
  String get tripPlannerMapSemanticsLabel;

  /// Trip planner: title of a trip's directions page.
  ///
  /// In en, this message translates to:
  /// **'Trip details'**
  String get tripPlannerTripDetails;

  /// Trip planner: short label of the trip map.
  ///
  /// In en, this message translates to:
  /// **'Map of the trip'**
  String get tripPlannerMapLabel;

  /// Trip planner: name of the trip's starting point when it has no name.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get tripPlannerStart;

  /// Trip planner: name of the trip's destination when it has no name.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get tripPlannerDestination;

  /// Trip planner: a place or street with no name.
  ///
  /// In en, this message translates to:
  /// **'Unnamed location'**
  String get tripPlannerUnnamedPlace;

  /// Trip planner: a bikeshare station with no name.
  ///
  /// In en, this message translates to:
  /// **'Rental bike'**
  String get tripPlannerRentalBike;

  /// Trip planner direction.
  ///
  /// In en, this message translates to:
  /// **'Walk to {place}'**
  String tripPlannerWalkTo(String place);

  /// Trip planner direction.
  ///
  /// In en, this message translates to:
  /// **'Bike to {place}'**
  String tripPlannerBikeTo(String place);

  /// Trip planner direction.
  ///
  /// In en, this message translates to:
  /// **'Ride rental bike to {place}'**
  String tripPlannerRideRentalBikeTo(String place);

  /// Trip planner direction.
  ///
  /// In en, this message translates to:
  /// **'Drive to {place}'**
  String tripPlannerDriveTo(String place);

  /// Trip planner direction; mode is a vehicle kind such as 'Bus'.
  ///
  /// In en, this message translates to:
  /// **'Take {mode}'**
  String tripPlannerBoard(String mode);

  /// Trip planner direction, e.g. 'Take Bus 30'.
  ///
  /// In en, this message translates to:
  /// **'Take {mode} {route}'**
  String tripPlannerBoardRoute(String mode, String route);

  /// Trip planner direction, e.g. 'Take Ferry toward Bainbridge'.
  ///
  /// In en, this message translates to:
  /// **'Take {mode} toward {headsign}'**
  String tripPlannerBoardHeadsign(String mode, String headsign);

  /// Trip planner direction, e.g. 'Take Bus 30 toward Old Town'.
  ///
  /// In en, this message translates to:
  /// **'Take {mode} {route} toward {headsign}'**
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  );

  /// Trip planner direction.
  ///
  /// In en, this message translates to:
  /// **'Get off at {place}'**
  String tripPlannerGetOffAt(String place);

  /// Trip planner direction.
  ///
  /// In en, this message translates to:
  /// **'Arrive at {place}'**
  String tripPlannerArriveAt(String place);

  /// Trip planner: stops passed on a transit leg.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 stop} other{{count} stops}}'**
  String tripPlannerStopCount(int count);

  /// Trip planner: button that lists the stops of a leg.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Show 1 stop} other{Show {count} stops}}'**
  String tripPlannerShowStops(int count);

  /// Trip planner: button that hides the stops of a leg.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Hide 1 stop} other{Hide {count} stops}}'**
  String tripPlannerHideStops(int count);

  /// Trip planner: turn-by-turn steps of a walking leg.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 step} other{{count} steps}}'**
  String tripPlannerStepCount(int count);

  /// Trip planner: button that lists the steps of a leg.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Show 1 step} other{Show {count} steps}}'**
  String tripPlannerShowSteps(int count);

  /// Trip planner: button that hides the steps of a leg.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Hide 1 step} other{Hide {count} steps}}'**
  String tripPlannerHideSteps(int count);

  /// Trip planner: length and time of a leg, e.g. '0.4 mi, about 8 min'.
  ///
  /// In en, this message translates to:
  /// **'{distance}, about {duration}'**
  String tripPlannerLegDistanceDuration(String distance, String duration);

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Head out'**
  String get tripPlannerDirectionDepart;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Turn sharp left'**
  String get tripPlannerDirectionHardLeft;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Turn left'**
  String get tripPlannerDirectionLeft;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Bear left'**
  String get tripPlannerDirectionSlightlyLeft;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get tripPlannerDirectionContinue;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Bear right'**
  String get tripPlannerDirectionSlightlyRight;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Turn right'**
  String get tripPlannerDirectionRight;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Turn sharp right'**
  String get tripPlannerDirectionHardRight;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Enter the roundabout clockwise'**
  String get tripPlannerDirectionCircleClockwise;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Enter the roundabout counterclockwise'**
  String get tripPlannerDirectionCircleCounterclockwise;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Take the elevator'**
  String get tripPlannerDirectionElevator;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Make a U-turn to the left'**
  String get tripPlannerDirectionUturnLeft;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Make a U-turn to the right'**
  String get tripPlannerDirectionUturnRight;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Enter the station'**
  String get tripPlannerDirectionEnterStation;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Exit the station'**
  String get tripPlannerDirectionExitStation;

  /// Trip planner: a turn-by-turn instruction, followed by 'onto <street>'.
  ///
  /// In en, this message translates to:
  /// **'Follow the signs'**
  String get tripPlannerDirectionFollowSigns;

  /// Trip planner: walking step with no turn.
  ///
  /// In en, this message translates to:
  /// **'Walk along {street} for {distance}.'**
  String tripPlannerStepAlong(String street, String distance);

  /// Trip planner: walking step, e.g. 'Turn right onto Pine St, walk 610 ft.'.
  ///
  /// In en, this message translates to:
  /// **'{direction} onto {street}, walk {distance}.'**
  String tripPlannerStepTurn(String direction, String street, String distance);

  /// Trip planner: place search field label and placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search for a place'**
  String get tripPlannerSearchHint;

  /// Trip planner: place search found nothing.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get tripPlannerSearchNoResults;

  /// Trip planner: place search failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search for places. Try again.'**
  String get tripPlannerSearchError;

  /// Trip planner: button that uses the rider's location as an endpoint.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get tripPlannerUseCurrentLocation;

  /// Trip planner: the rider's location is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location.'**
  String get tripPlannerLocationUnavailable;

  /// Trip planner: button that clears the place search field.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get tripPlannerClearSearch;

  /// Trip planner error: an endpoint is missing.
  ///
  /// In en, this message translates to:
  /// **'Please select both origin and destination locations.'**
  String get tripPlannerErrorMissingEndpoints;

  /// Trip planner error: the network failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the trip planner. Check your connection.'**
  String get tripPlannerErrorNetwork;

  /// Trip planner error: the server's reply couldn't be read.
  ///
  /// In en, this message translates to:
  /// **'Server returned invalid response'**
  String get tripPlannerErrorInvalidResponse;

  /// Trip planner error with no specific message.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get tripPlannerErrorUnknown;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t plan your trip right now. Please try again.'**
  String get tripPlannerPlannerSystemError;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'Trip planning is temporarily unavailable. Try again shortly.'**
  String get tripPlannerPlannerGraphUnavailable;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'This location isn’t supported yet.'**
  String get tripPlannerPlannerOutsideBounds;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'No route is available for this trip.'**
  String get tripPlannerPlannerPathNotFound;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'No transit options are available right now.'**
  String get tripPlannerPlannerNoTransitTimes;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'This took longer than expected. Please try again.'**
  String get tripPlannerPlannerRequestTimeout;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with the request. Please try again.'**
  String get tripPlannerPlannerBogusParameter;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t find the starting location.'**
  String get tripPlannerPlannerGeocodeFromNotFound;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t find the destination.'**
  String get tripPlannerPlannerGeocodeToNotFound;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t find either the starting point or the destination.'**
  String get tripPlannerPlannerGeocodeFromToNotFound;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'The start and destination are too close.'**
  String get tripPlannerPlannerTooClose;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'This route isn’t accessible with the selected option.'**
  String get tripPlannerPlannerLocationNotAccessible;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'The starting location isn’t clear. Try being more specific.'**
  String get tripPlannerPlannerGeocodeFromAmbiguous;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'The destination isn’t clear. Try being more specific.'**
  String get tripPlannerPlannerGeocodeToAmbiguous;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'Both locations need more detail. Try refining them.'**
  String get tripPlannerPlannerGeocodeFromToAmbiguous;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'Some route options are missing.'**
  String get tripPlannerPlannerUnderspecifiedTriangle;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'The selected route options don’t work together.'**
  String get tripPlannerPlannerTriangleNotAffine;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'Please choose a route preference.'**
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet;

  /// Trip planner error returned by the trip planning server.
  ///
  /// In en, this message translates to:
  /// **'Please adjust the route preferences.'**
  String get tripPlannerPlannerTriangleValuesNotSet;
}

class _ObaLocalizationsDelegate
    extends LocalizationsDelegate<ObaLocalizations> {
  const _ObaLocalizationsDelegate();

  @override
  Future<ObaLocalizations> load(Locale locale) {
    return SynchronousFuture<ObaLocalizations>(lookupObaLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fil',
    'fr',
    'it',
    'ko',
    'pl',
    'pt',
    'ru',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_ObaLocalizationsDelegate old) => false;
}

ObaLocalizations lookupObaLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return ObaLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return ObaLocalizationsAr();
    case 'en':
      return ObaLocalizationsEn();
    case 'es':
      return ObaLocalizationsEs();
    case 'fil':
      return ObaLocalizationsFil();
    case 'fr':
      return ObaLocalizationsFr();
    case 'it':
      return ObaLocalizationsIt();
    case 'ko':
      return ObaLocalizationsKo();
    case 'pl':
      return ObaLocalizationsPl();
    case 'pt':
      return ObaLocalizationsPt();
    case 'ru':
      return ObaLocalizationsRu();
    case 'vi':
      return ObaLocalizationsVi();
    case 'zh':
      return ObaLocalizationsZh();
  }

  throw FlutterError(
    'ObaLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
