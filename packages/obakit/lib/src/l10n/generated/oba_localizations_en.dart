// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ObaLocalizationsEn extends ObaLocalizations {
  ObaLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonBack => 'Back';

  @override
  String get commonClose => 'Close';

  @override
  String get commonDone => 'Done';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonNotNow => 'Not now';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonOffline =>
      'You appear to be offline. Check your connection and try again.';

  @override
  String get commonServerError =>
      'The server didn\'t respond as expected. Try again in a moment.';

  @override
  String get sheetLabel => 'Panel';

  @override
  String get sheetExpand => 'Expand panel';

  @override
  String get sheetCollapse => 'Collapse panel';

  @override
  String get sheetHandleHint => 'Drag or double-tap to resize the panel';

  @override
  String get homeTabHome => 'Home';

  @override
  String get homeTabRecent => 'Recent';

  @override
  String get homeTabBookmarks => 'Bookmarks';

  @override
  String get homeSearchPlaceholder => 'Search stops, routes, places';

  @override
  String get homeSearchLabel => 'Search';

  @override
  String get homeSectionNearby => 'Nearby';

  @override
  String get homeSectionRecent => 'Recent stops';

  @override
  String get homeSectionBookmarks => 'Bookmarks';

  @override
  String get homeSectionAlerts => 'Alerts';

  @override
  String get homeSectionExplore => 'Explore';

  @override
  String get homeSectionMore => 'Settings and more';

  @override
  String get mapLabel => 'Map';

  @override
  String get mapZoomInForStops => 'Zoom in to see stops';

  @override
  String get mapLocationDenied => 'Location access is off. Tap to allow.';

  @override
  String get mapLocationServicesOff => 'Location services are off';

  @override
  String get mapRecenter => 'Show my location';

  @override
  String get mapSettingsButton => 'Map settings';

  @override
  String get mapStopsListButton => 'Stops on the map';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops on the map',
      one: '1 stop on the map',
      zero: 'No stops on the map',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'Your location';

  @override
  String get mapDroppedPin => 'Dropped pin';

  @override
  String get mapVehicle => 'Vehicle';

  @override
  String get mapBookmarkedStop => 'Bookmarked';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, $routeType stop';
  }

  @override
  String get mapStopMarkerHint => 'Opens the stop\'s departures';

  @override
  String mapAttribution(String attribution) {
    return 'Map data: $attribution';
  }

  @override
  String get mapTypeTitle => 'Map type';

  @override
  String get mapTypeStandard => 'Standard';

  @override
  String get mapTypeSatellite => 'Satellite';

  @override
  String get mapTypeHybrid => 'Hybrid';

  @override
  String get mapShowHeading => 'Show heading';

  @override
  String get directionN => 'Northbound';

  @override
  String get directionNE => 'Northeast bound';

  @override
  String get directionE => 'Eastbound';

  @override
  String get directionSE => 'Southeast bound';

  @override
  String get directionS => 'Southbound';

  @override
  String get directionSW => 'Southwest bound';

  @override
  String get directionW => 'Westbound';

  @override
  String get directionNW => 'Northwest bound';

  @override
  String get routeTypeBus => 'Bus';

  @override
  String get routeTypeLightRail => 'Light rail';

  @override
  String get routeTypeSubway => 'Subway';

  @override
  String get routeTypeRail => 'Train';

  @override
  String get routeTypeFerry => 'Ferry';

  @override
  String get routeTypeCableCar => 'Cable car';

  @override
  String get routeTypeGondola => 'Gondola';

  @override
  String get routeTypeFunicular => 'Funicular';

  @override
  String get routeTypeUnknown => 'Transit';

  @override
  String stopCode(String code) {
    return 'Stop $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'Routes $routes';
  }

  @override
  String get stopPageRefresh => 'Refresh';

  @override
  String get stopPageRefreshed => 'Departures updated';

  @override
  String get stopPageBookmark => 'Bookmark stop';

  @override
  String get stopPageBookmarked => 'Bookmarked. Edit bookmark';

  @override
  String get stopPageMoreActions => 'More stop actions';

  @override
  String get stopPageSchedules => 'Schedules';

  @override
  String get stopPageServiceAlerts => 'Service alerts';

  @override
  String get stopPageNearbyStops => 'Nearby stops';

  @override
  String get stopPageWalkingDirections => 'Walking directions';

  @override
  String get stopPageBikeDirections => 'Cycling directions';

  @override
  String get stopPagePlanTripFrom => 'Plan a trip from here';

  @override
  String get stopPagePlanTripTo => 'Plan a trip to here';

  @override
  String get stopPageShareStop => 'Share stop';

  @override
  String get stopPageReportProblem => 'Report a problem';

  @override
  String get stopPageFilterRoutes => 'Filter routes';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count routes hidden',
      one: '1 route hidden',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'By time';

  @override
  String get stopPageModeRoute => 'By route';

  @override
  String get stopPageDepartureTypes => 'Departure types';

  @override
  String get stopPageFilterAll => 'All departures';

  @override
  String get stopPageFilterRealtime => 'Real-time only';

  @override
  String get stopPageFilterScheduled => 'Scheduled only';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count earlier departures',
      one: 'Show 1 earlier departure',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Hide earlier departures';

  @override
  String get stopPageLoadMore => 'Load more departures';

  @override
  String stopPageWindow(int minutes) {
    return 'Showing the next $minutes minutes';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Updated $ago';
  }

  @override
  String get stopPageStaleTitle => 'Couldn\'t refresh departures';

  @override
  String get stopPageStaleBody => 'These times may be out of date.';

  @override
  String get stopPageEmptyTitle => 'No upcoming departures';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'Nothing departs in the next $minutes minutes.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Every route with departures here is hidden.';

  @override
  String get stopPageShowAllRoutes => 'Show all routes';

  @override
  String get stopPageEmptyFilter =>
      'No departures match the departure-type filter.';

  @override
  String get stopPageShowAllTypes => 'Show all departures';

  @override
  String get stopPageMissingTitle => 'Stop not found';

  @override
  String get stopPageMissingBody =>
      'This stop may have been removed or renumbered.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes min walk';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes min ride';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minute walk',
      one: '1 minute walk',
    );
    return '$_temp0, $distance. Opens directions.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minute ride',
      one: '1 minute ride',
    );
    return '$_temp0, $distance. Opens directions.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '$minutes min walk to this stop. Departures above leave sooner.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '$minutes min ride to this stop. Departures above leave sooner.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Service by $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count service alerts',
      one: '1 service alert',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread',
      one: '1 unread',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Unread';

  @override
  String get stopPageAlertImportant => 'Important';

  @override
  String get stopPageDirectionsChooser => 'Open directions in';

  @override
  String get stopPageAppleMaps => 'Apple Maps';

  @override
  String get stopPageGoogleMaps => 'Google Maps';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Transfer from $route $headsign, arriving $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Departures';

  @override
  String get stopRowNow => 'NOW';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String get stopRowOnTime => 'on time';

  @override
  String stopRowLate(int minutes) {
    return '$minutes min late';
  }

  @override
  String stopRowEarly(int minutes) {
    return '$minutes min early';
  }

  @override
  String get stopRowScheduled => 'scheduled';

  @override
  String get stopRowCanceled => 'canceled';

  @override
  String get stopRowOccupancyEmpty => 'Empty';

  @override
  String get stopRowOccupancyManySeats => 'Many seats available';

  @override
  String get stopRowOccupancyFewSeats => 'Few seats available';

  @override
  String get stopRowOccupancyStanding => 'Standing room only';

  @override
  String get stopRowOccupancyCrushed => 'Very crowded';

  @override
  String get stopRowOccupancyFull => 'Full';

  @override
  String get stopRowOccupancyNotAccepting => 'Not accepting passengers';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arrives in $minutes minutes',
      one: 'arrives in 1 minute',
      zero: 'arriving now',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'departs in $minutes minutes',
      one: 'departs in 1 minute',
      zero: 'departing now',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arrived $minutes minutes ago',
      one: 'arrived 1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'departed $minutes minutes ago',
      one: 'departed 1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yLabel(
    String route,
    String headsign,
    String eta,
    String time,
    String status,
  ) {
    return 'Route $route to $headsign, $eta, at $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'live tracking, $status';
  }

  @override
  String get stopRowA11yScheduledOnly => 'scheduled time only, no live data';

  @override
  String get stopRowA11yTransfer => 'your transfer trip';

  @override
  String get stopRowA11yMissed =>
      'likely missed, it leaves before you can walk there';

  @override
  String get stopRowA11yAlarm => 'alarm set';

  @override
  String stopRowActions(String route) {
    return 'More actions for route $route';
  }

  @override
  String get stopRowShowTrip => 'Show trip details';

  @override
  String get stopRowAddAlarm => 'Add alarm';

  @override
  String get stopRowRemoveAlarm => 'Remove alarm';

  @override
  String get stopRowBookmarkTrip => 'Bookmark this trip';

  @override
  String get stopRowShareTrip => 'Share trip';

  @override
  String get stopRowRouteSchedule => 'Schedule for route';

  @override
  String get stopRowRouteStops => 'Stops on this route';

  @override
  String stopRouteGroupNext(String times) {
    return 'Next: $times';
  }

  @override
  String stopRouteGroupLabel(
    String route,
    String headsigns,
    int count,
    String eta,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count departures',
      one: '1 departure',
    );
    return 'Route $route to $headsigns, $_temp0, next $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Remind me before it leaves';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes before',
      one: '1 minute before',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Alarm set for $minutes minutes before',
      one: 'Alarm set for 1 minute before',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Alarm removed';

  @override
  String get stopAlarmFailed => 'Couldn\'t update the alarm.';

  @override
  String get stopAlarmPermissionDenied =>
      'Notifications are turned off for this app.';

  @override
  String get stopFilterTitle => 'Filter routes';

  @override
  String get stopFilterSort => 'Sort departures';

  @override
  String get stopFilterRoutesHeader => 'Routes shown at this stop';

  @override
  String get stopFilterShowAll => 'Show all routes';

  @override
  String get stopTripArrivingAtYourStop => 'Arriving at your stop';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops away',
      one: '1 stop away',
      zero: 'At your stop',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return '$distance away';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'At $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Position updated $ago';
  }

  @override
  String get stopTripNoPosition => 'No real-time position for this vehicle';

  @override
  String stopTripStartsAs(String trip) {
    return 'Starts as $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Continues as $trip';
  }

  @override
  String get stopTripStopsHeader => 'Stops';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passed stops',
      one: '1 passed stop',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops before your stop',
      one: '1 stop before your stop',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'Your stop';

  @override
  String get stopTripBoarding => 'Boarding';

  @override
  String get stopTripVehicleHere => 'Vehicle is here';

  @override
  String get stopTripTerminal => 'Last stop';

  @override
  String get stopTripPassed => 'Passed';

  @override
  String get stopTripRouteStops => 'All stops on this route';

  @override
  String get stopTripReport => 'Report a problem with this trip';

  @override
  String get stopTripGhostBus => 'Report ghost bus';

  @override
  String get stopTripCanceled => 'This trip is canceled';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Vehicle on route $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'Every $minutes min';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Route $route';
  }

  @override
  String get stopRouteStopsDirection => 'Direction';

  @override
  String stopRouteStopsToward(String name) {
    return 'To $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '1 stop',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => 'No stops found for this route.';

  @override
  String get stopSchedPrevDay => 'Previous day';

  @override
  String get stopSchedNextDay => 'Next day';

  @override
  String stopSchedPickDate(String date) {
    return 'Choose date, $date';
  }

  @override
  String get stopSchedRoute => 'Route';

  @override
  String get stopSchedDirection => 'Direction';

  @override
  String get stopSchedStop => 'Stop';

  @override
  String get stopSchedEmpty => 'No scheduled service on this day.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'Every $minutes min from $start to $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'To $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count departures',
      one: '1 departure',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported =>
      'Timetables aren\'t available in this region.';

  @override
  String get stopSchedViewList => 'List';

  @override
  String get stopSchedViewGrid => 'Grid';

  @override
  String get stopSchedNoDeparture => 'No departure';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (your stop)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, trip $trip: $time';
  }

  @override
  String get stopReportProblemHeader => 'What seems to be the problem?';

  @override
  String get stopReportStopNameWrong => 'The stop name is wrong';

  @override
  String get stopReportStopNumberWrong => 'The stop number is wrong';

  @override
  String get stopReportStopLocationWrong => 'The stop is in the wrong place';

  @override
  String get stopReportRouteMissing => 'A route or trip is missing';

  @override
  String get stopReportOther => 'Something else';

  @override
  String get stopReportNeverCame => 'The vehicle never came';

  @override
  String get stopReportCameEarly => 'It came early';

  @override
  String get stopReportCameLate => 'It came late';

  @override
  String get stopReportWrongHeadsign => 'The headsign was wrong';

  @override
  String get stopReportNotStopHere => 'It didn\'t stop here';

  @override
  String get stopReportComment => 'Additional comments (optional)';

  @override
  String get stopReportShareLocation => 'Share my location';

  @override
  String get stopReportShareLocationHelp =>
      'Sharing your location can help your transit agency fix this problem.';

  @override
  String get stopReportOnVehicle => 'I\'m on this vehicle';

  @override
  String get stopReportVehicleId => 'Vehicle number (optional)';

  @override
  String get stopReportSend => 'Send report';

  @override
  String get stopReportSending => 'Sending report';

  @override
  String get stopReportSent => 'Thanks! Your report was sent.';

  @override
  String get stopReportFailed => 'Couldn\'t send the report. Please try again.';

  @override
  String get stopReportChooseProblem => 'Choose a problem first.';

  @override
  String stopReportAbout(String name) {
    return 'Reporting: $name';
  }

  @override
  String get stopGhostTitle => 'Report ghost bus';

  @override
  String get stopGhostExplain =>
      'A ghost bus is one that the app showed but that never came.';

  @override
  String get stopGhostWait => 'How long did you wait past the scheduled time?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30+ min';

  @override
  String get stopCardEmpty => 'No departures soon';

  @override
  String get titleSearch => 'Search';

  @override
  String get titleSearchResults => 'Results';

  @override
  String get titleNearbyStops => 'Nearby stops';

  @override
  String get titleRecentStops => 'Recent stops';

  @override
  String get titleBookmarks => 'Bookmarks';

  @override
  String get titleStop => 'Stop';

  @override
  String get titleTrip => 'Trip';

  @override
  String get titleRouteStops => 'Route';

  @override
  String get titleStopSchedule => 'Schedule';

  @override
  String get titleRouteSchedule => 'Route schedule';

  @override
  String get titleAlerts => 'Alerts';

  @override
  String get titleAlertDetail => 'Alert';

  @override
  String get titleAgencies => 'Agencies';

  @override
  String get titleRegionPicker => 'Regions';

  @override
  String get titleCustomRegion => 'Custom region';

  @override
  String get titleSettings => 'Settings';

  @override
  String get titleMapSettings => 'Map settings';

  @override
  String get titleMore => 'More';

  @override
  String get titleTripPlanner => 'Plan a trip';

  @override
  String get titlePlace => 'Place';

  @override
  String get titleReportStopProblem => 'Report a problem';

  @override
  String get titleReportTripProblem => 'Report a problem';

  @override
  String get titleBookmarkEditor => 'Bookmark';

  @override
  String get titleManageBookmarks => 'Edit bookmarks';

  @override
  String get titleCredits => 'Credits';

  @override
  String get titleWeather => 'Weather';

  @override
  String get titleStopsOnMap => 'Stops on the map';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Real-time arrivals for buses, trains and ferries near you.';

  @override
  String get onboardingLocationTitle => 'Find stops near you';

  @override
  String get onboardingLocationBody =>
      'Allow location access to see nearby stops and pick your region automatically.';

  @override
  String get onboardingAllowLocation => 'Allow location access';

  @override
  String get onboardingRegionTitle => 'Choose your region';

  @override
  String get onboardingRegionBody =>
      'Pick the area whose transit you want to see.';

  @override
  String get settingsSectionMap => 'Map';

  @override
  String get settingsMapTypeRow => 'Map type and layers';

  @override
  String get settingsMapTypeHelp => 'Choose how the map looks.';

  @override
  String get settingsHeadingHelp =>
      'Shows the direction you are facing on the map.';

  @override
  String get settingsWalkingDirections => 'Walking directions';

  @override
  String get settingsWalkingDirectionsHelp =>
      'The app that opens when you ask for walking directions to a stop.';

  @override
  String get settingsDirectionsAsk => 'Ask every time';

  @override
  String get settingsDirectionsAppleMaps => 'Apple Maps';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Maps';

  @override
  String get settingsSectionDepartures => 'Departures';

  @override
  String get settingsDepartureFilter => 'Show departures';

  @override
  String get settingsDepartureFilterHelp =>
      'Choose whether stop pages list every departure or only those with real-time or scheduled data.';

  @override
  String get settingsFilterAll => 'All departures';

  @override
  String get settingsFilterRealtime => 'Real-time only';

  @override
  String get settingsFilterScheduled => 'Scheduled only';

  @override
  String get settingsSectionAccessibility => 'Accessibility';

  @override
  String get settingsReducedColors => 'Reduce colors on stop pages';

  @override
  String get settingsReducedColorsHelp =>
      'Shows route badges in one neutral style.';

  @override
  String get settingsSectionWalking => 'Walking speed';

  @override
  String get settingsWalkingSpeed => 'Walking speed';

  @override
  String get settingsWalkingSpeedHelp =>
      'Used for walk-time estimates and arrival times.';

  @override
  String get settingsSpeedSlow => 'Slow';

  @override
  String get settingsSpeedAverage => 'Average';

  @override
  String get settingsSpeedFast => 'Fast';

  @override
  String settingsSpeedCustom(String speed) {
    return 'Custom ($speed m/s)';
  }

  @override
  String get settingsSectionBike => 'Bike mode';

  @override
  String get settingsBikeMode => 'Bike mode';

  @override
  String get settingsBikeModeHelp =>
      'Uses a faster travel speed for walk-time estimates, arrival times and the stop page.';

  @override
  String get settingsSectionSurveys => 'Surveys';

  @override
  String get settingsSurveysEnabled => 'Show surveys';

  @override
  String get settingsSurveysAlways => 'Always show surveys on stops';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsAnalytics => 'Send usage data to the developers';

  @override
  String get settingsAnalyticsHelp =>
      'Helps the developers see which features are used.';

  @override
  String get settingsSectionDebug => 'Debug';

  @override
  String get settingsDebugMode => 'Debug mode';

  @override
  String get settingsDebugAlwaysFeedback => 'Always show the feedback prompt';

  @override
  String get settingsDebugResetFeedback => 'Reset feedback prompt state';

  @override
  String get settingsDebugResetDonation => 'Reset donation card state';

  @override
  String get settingsDebugResetDone => 'Reset';

  @override
  String get settingsSectionTripPlanner => 'Trip planner';

  @override
  String get settingsHomeCustomizeMap => 'Customize map';

  @override
  String get moreHeaderSupport =>
      'This app is made and supported by volunteers.';

  @override
  String get moreSectionDonate => 'Be a supporter';

  @override
  String moreDonate(String appName) {
    return 'Donate to $appName';
  }

  @override
  String get moreManageDonations => 'Manage donations';

  @override
  String get moreSectionUpdates => 'Updates and alerts';

  @override
  String get moreAlerts => 'Alerts';

  @override
  String get moreSectionLocation => 'My location';

  @override
  String get moreRegion => 'Region';

  @override
  String get moreRegionNone => 'Not selected';

  @override
  String get morePayFare => 'Pay my fare';

  @override
  String get moreAgencies => 'Agencies';

  @override
  String get moreSectionAbout => 'About this app';

  @override
  String moreRateApp(String appName) {
    return 'Rate $appName';
  }

  @override
  String get moreContactUs => 'Contact us';

  @override
  String get morePrivacy => 'Privacy policy';

  @override
  String get moreCredits => 'Credits';

  @override
  String moreVersion(String appName, String version) {
    return '$appName version $version';
  }

  @override
  String get moreSectionHelpOut => 'Help make the app better';

  @override
  String get moreTranslate => 'Help translate the app';

  @override
  String get moreDevelop => 'Help fix bugs and build new features';

  @override
  String get moreSectionContact => 'Contact and help';

  @override
  String get moreTutorials => 'Tutorials';

  @override
  String get moreCallAgency => 'Call agency';

  @override
  String get moreTextAgency => 'Message agency';

  @override
  String get moreSectionResources => 'Resources';

  @override
  String get moreContactTitle => 'Contact us';

  @override
  String get moreContactDevelopers => 'Feature request or bug report';

  @override
  String get moreContactAgency => 'Vehicle or schedule problem';

  @override
  String moreEmailSubject(String appName) {
    return '$appName feedback';
  }

  @override
  String get moreEmailAgencySubject => 'Transit rider feedback';

  @override
  String get moreEmailIntro =>
      'How can we help? Please enter your response below:';

  @override
  String get moreEmailDebugIntro =>
      'The following information is provided for troubleshooting purposes. If you are uncomfortable sharing any of it you may remove it, however it may affect our ability to assist you.';

  @override
  String get moreDebugAppVersion => 'App version';

  @override
  String get moreDebugOs => 'Operating system';

  @override
  String get moreDebugLocale => 'Language';

  @override
  String get moreDebugBookmarks => 'Bookmark count';

  @override
  String get moreDebugLocationPermission => 'Location permission';

  @override
  String get moreDebugRegion => 'Region';

  @override
  String get moreDebugRegionId => 'Region ID';

  @override
  String get moreDebugApiUrl => 'Base API URL';

  @override
  String get moreDebugUserId => 'User ID';

  @override
  String get moreCantEmailTitle => 'Can\'t open your email app';

  @override
  String moreCantEmailBody(String email) {
    return 'To contact us, send an email to $email. Copy the debug information and paste it into your message to help us fix the problem.';
  }

  @override
  String get moreCopyEmail => 'Copy email address';

  @override
  String get moreCopyDebug => 'Copy debug info';

  @override
  String get moreCopied => 'Copied to the clipboard';

  @override
  String get moreFareContinue => 'Continue';

  @override
  String get moreFareDontShowAgain => 'Continue and don\'t show again';

  @override
  String get commonCantOpenLink => 'Couldn\'t open that link.';

  @override
  String get regionPickerAutomatic => 'Choose region automatically';

  @override
  String get regionPickerAutomaticHelp =>
      'Switches to the region that contains your location. Choosing a region yourself turns this off.';

  @override
  String get regionPickerShowExperimental => 'Show experimental regions';

  @override
  String get regionPickerShowInactive => 'Show inactive regions';

  @override
  String get regionPickerRegionsSection => 'Regions';

  @override
  String get regionPickerCustomSection => 'Custom regions';

  @override
  String get regionPickerCurrent => 'Current region';

  @override
  String get regionPickerExperimentalTag => 'Experimental';

  @override
  String get regionPickerInactiveTag => 'Inactive';

  @override
  String get regionPickerCustomTag => 'Custom';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Add custom region';

  @override
  String get regionPickerRefresh => 'Refresh regions';

  @override
  String get regionPickerRefreshed => 'Regions updated';

  @override
  String get regionPickerRefreshFailed =>
      'Couldn\'t update the regions list. Showing the saved list.';

  @override
  String regionPickerSelected(String name) {
    return '$name selected';
  }

  @override
  String regionPickerEdit(String name) {
    return 'Edit $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'Delete $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get regionPickerDeleteBody =>
      'This custom region will be removed from this device.';

  @override
  String get regionPickerDeleteConfirm => 'Delete';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Choose another region before deleting this one.';

  @override
  String get regionPickerEmpty => 'No regions available';

  @override
  String get regionPickerEmptyBody =>
      'Turn on experimental or inactive regions, or add a custom region.';

  @override
  String get regionPickerTripPlanner => 'Trip planner in this region';

  @override
  String get customRegionEditTitle => 'Edit custom region';

  @override
  String get customRegionName => 'Name';

  @override
  String get customRegionObaUrl => 'OneBusAway server URL';

  @override
  String get customRegionObaUrlHelp =>
      'The address of the server, for example https://oba.example.com/';

  @override
  String get customRegionSidecar => 'Sidecar server URL (optional)';

  @override
  String get customRegionOtp => 'Trip planner URL (optional)';

  @override
  String get customRegionOtpGraphql => 'Trip planner GraphQL URL (optional)';

  @override
  String get customRegionServiceArea => 'Service area';

  @override
  String get customRegionServiceAreaHelp =>
      'The area this region covers: a center point and how far it extends.';

  @override
  String get customRegionLatitude => 'Center latitude';

  @override
  String get customRegionLongitude => 'Center longitude';

  @override
  String get customRegionLatSpan => 'Latitude span (degrees)';

  @override
  String get customRegionLonSpan => 'Longitude span (degrees)';

  @override
  String get customRegionUseMap => 'Use the current map area';

  @override
  String get customRegionSave => 'Save';

  @override
  String get customRegionErrorRequired => 'This field is required';

  @override
  String get customRegionErrorUrl =>
      'Enter a web address that starts with http:// or https://';

  @override
  String get customRegionErrorNumber => 'Enter a number';

  @override
  String get customRegionErrorRange => 'This number is out of range';

  @override
  String get customRegionChecking => 'Checking the server';

  @override
  String get customRegionServerOk => 'The server responded';

  @override
  String get customRegionServerUnreachable => 'Couldn\'t reach this server';

  @override
  String get customRegionServerNotOba =>
      'This server didn\'t answer like OneBusAway';

  @override
  String customRegionSaved(String name) {
    return '$name saved';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway is free, open source transit software, built by volunteers and supported by the Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'License';

  @override
  String get creditsMapData => 'Map data';

  @override
  String get creditsLicenses => 'Open source licenses';

  @override
  String get creditsLicensesHelp => 'The libraries this app is built with.';

  @override
  String get creditsLicensesLoading => 'Loading licenses';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count licenses',
      one: '1 license',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Available in dozens of transit regions worldwide.';

  @override
  String get onboardingBenefitNearbyTitle => 'See nearby stops';

  @override
  String get onboardingBenefitNearbyBody =>
      'Buses and trains around you, ranked by distance.';

  @override
  String get onboardingBenefitMapTitle => 'Center the map on you';

  @override
  String get onboardingBenefitMapBody =>
      'Open straight to your surroundings without searching.';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName only uses your location while the app is open. You can change this any time in your device settings.';
  }

  @override
  String get onboardingLocationDenied =>
      'Location access is off. You can still choose your region yourself.';

  @override
  String get onboardingRegionDetected => 'Detected near you';

  @override
  String onboardingRegionUse(String name) {
    return 'Use $name';
  }

  @override
  String get onboardingRegionOthers => 'Or choose another region';

  @override
  String get onboardingRegionEmpty =>
      'No regions are available right now. Check your connection and try again.';

  @override
  String get surveyCardTitle => 'Help improve transit';

  @override
  String get surveyDefaultPrompt =>
      'Take a short survey to help improve transit.';

  @override
  String get surveyTake => 'Take survey';

  @override
  String get surveyNotNow => 'Not now';

  @override
  String get surveyDismiss => 'Dismiss survey';

  @override
  String get surveyNext => 'Next';

  @override
  String get surveySubmit => 'Submit survey';

  @override
  String get surveySubmitting => 'Submitting';

  @override
  String get surveyQuestionsTitle => 'Survey';

  @override
  String get surveyTextHint => 'Enter your answer';

  @override
  String get surveyRequired => 'Required';

  @override
  String get surveyIncomplete =>
      'Please answer all required questions before submitting.';

  @override
  String get surveyFailed =>
      'Your answers couldn\'t be sent. Please try again.';

  @override
  String get surveyThanks => 'Thanks for your feedback.';

  @override
  String get surveyOpenSurvey => 'Open survey';

  @override
  String get surveyLearnMore => 'Learn more';

  @override
  String get surveyShareFeedback => 'Share feedback';

  @override
  String get surveySignUp => 'Sign up';

  @override
  String get surveyExternalError =>
      'This survey link couldn\'t be opened. Please try again later.';

  @override
  String donationTitle(String appName) {
    return '$appName needs your help';
  }

  @override
  String get donationBody =>
      'This app is built with volunteer labor, and we need you to help us fund future development.';

  @override
  String get donationLearnMore => 'Learn more';

  @override
  String get donationDonate => 'Donate now';

  @override
  String get donationRemindLater => 'Remind me later';

  @override
  String get donationDismiss => 'No thanks';

  @override
  String get donationHeader => 'Here\'s why we need your help';

  @override
  String donationExplanation(String appName) {
    return 'We have big plans to improve $appName, but we cannot do it without your help. This app is built with volunteer labor, and we need you to help us fund future development.\n\nAs a key project of the Open Transit Software Foundation, a nonprofit, your donation is tax deductible in the United States.';
  }

  @override
  String get donationDonateWebsite => 'Donate on our website';

  @override
  String titleDonation(String appName) {
    return 'Support $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'Enjoying $appName?';
  }

  @override
  String get feedbackYes => 'Yes!';

  @override
  String get feedbackNo => 'Not really';

  @override
  String get feedbackLater => 'Ask me later';

  @override
  String get feedbackNegativeTitle => 'Sorry about that.';

  @override
  String get feedbackNegativeBody =>
      'Would you tell us what\'s wrong? We read every message.';

  @override
  String get feedbackSend => 'Send feedback';

  @override
  String get feedbackDecline => 'No thanks';

  @override
  String get tripPlanningUnavailable =>
      'Trip planning isn\'t available in this region.';

  @override
  String get deepLinkOtherRegion =>
      'This link is for another region. Switch regions to open it.';

  @override
  String get dataUpdated => 'Updated';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Route $route to $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Route $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Loading departures';

  @override
  String get bookmarksNoDepartures => 'No upcoming departures';

  @override
  String get bookmarksDeparturesError => 'Couldn\'t load departures';

  @override
  String get bookmarksDeparturesStale =>
      'Couldn\'t refresh. Showing earlier times.';

  @override
  String get bookmarksUpdated => 'Departures updated';

  @override
  String get bookmarksSortTooltip => 'Sort bookmarks';

  @override
  String get bookmarksSortByGroup => 'Sort by group';

  @override
  String get bookmarksSortByDistance => 'Sort by distance';

  @override
  String get bookmarksManageTooltip => 'Edit bookmarks and groups';

  @override
  String get bookmarksRefreshTooltip => 'Refresh departures';

  @override
  String get bookmarksEmptyTitle => 'No bookmarks yet';

  @override
  String get bookmarksEmptyBody =>
      'Open a stop and tap its bookmark button to save it here. From a departure you can also bookmark just that route at the stop.';

  @override
  String get bookmarksFindStops => 'Find stops on the map';

  @override
  String get bookmarksUngrouped => 'Ungrouped';

  @override
  String get bookmarksGroupExpanded => 'expanded';

  @override
  String get bookmarksGroupCollapsed => 'collapsed';

  @override
  String get bookmarksGroupToggleHint =>
      'Shows or hides the bookmarks in this group';

  @override
  String bookmarksActionsFor(String name) {
    return 'Actions for $name';
  }

  @override
  String get bookmarksActionEdit => 'Edit';

  @override
  String get bookmarksActionPin => 'Pin to top';

  @override
  String get bookmarksActionUnpin => 'Unpin';

  @override
  String get bookmarksActionMove => 'Move to group';

  @override
  String get bookmarksActionDelete => 'Delete';

  @override
  String get bookmarksPinned => 'Pinned';

  @override
  String bookmarksDeleted(String name) {
    return 'Deleted $name';
  }

  @override
  String get bookmarksUndo => 'Undo';

  @override
  String get bookmarksMoveTitle => 'Move to group';

  @override
  String get bookmarksNoGroup => 'No group';

  @override
  String bookmarksMoved(String group) {
    return 'Moved to $group';
  }

  @override
  String get bookmarksEditorNameLabel => 'Bookmark name';

  @override
  String get bookmarksEditorNameRequired => 'Enter a name for this bookmark.';

  @override
  String get bookmarksEditorDuplicate =>
      'You already have a bookmark with this name for this stop and route. Change the name to save another one.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Stop bookmark: shows the next departures of every route at $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Trip bookmark: shows the next departures of $route at $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'Only $route';
  }

  @override
  String get bookmarksEditorGroup => 'Group';

  @override
  String get bookmarksEditorNewGroup => 'New group…';

  @override
  String get bookmarksEditorNewGroupTitle => 'New group';

  @override
  String get bookmarksEditorGroupName => 'Group name';

  @override
  String get bookmarksEditorSave => 'Save';

  @override
  String get bookmarksEditorSaved => 'Bookmark saved';

  @override
  String get bookmarksEditorDelete => 'Delete bookmark';

  @override
  String get bookmarksEditorDeleteTitle => 'Delete this bookmark?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '“$name” will be removed from your bookmarks.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Choose a region before adding bookmarks.';

  @override
  String get bookmarksManageGroupsHeader => 'Groups';

  @override
  String get bookmarksManageAddGroup => 'Add group';

  @override
  String get bookmarksManageRenameGroup => 'Rename group';

  @override
  String get bookmarksManageDeleteGroup => 'Delete group';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'The bookmarks in “$name” will become ungrouped.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Move $name up';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Move $name down';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Reorder $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, position $position of $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'There are no bookmarks or groups to manage yet.';

  @override
  String get bookmarksManageUngrouped => 'Ungrouped bookmarks';

  @override
  String get recentsEmptyTitle => 'No recent stops';

  @override
  String get recentsEmptyBody => 'Stops you look at appear here, newest first.';

  @override
  String get recentsFindStops => 'Find stops on the map';

  @override
  String get recentsClearAll => 'Clear all';

  @override
  String get recentsClearTitle => 'Clear recent stops?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This removes all $count recent stops. Your bookmarks aren\'t affected.',
      one: 'This removes 1 recent stop. Your bookmarks aren\'t affected.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Remove $name from recent stops';
  }

  @override
  String recentsRemoved(String name) {
    return 'Removed $name';
  }

  @override
  String get recentsSectionEmpty => 'Stops you look at appear here.';

  @override
  String get alarmsSectionTitle => 'Alarms';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes before departure',
      one: '1 minute before departure',
    );
    return '$_temp0, at $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Alarm for $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'Delete alarm for $title';
  }

  @override
  String get alarmsDeleted => 'Alarm deleted';

  @override
  String get alarmsDeleteFailed =>
      'Couldn\'t delete the alarm. Check your connection and try again.';

  @override
  String get alertsEmptyTitle => 'No service alerts';

  @override
  String get alertsEmptyBody => 'There are no active service alerts right now.';

  @override
  String get alertsRegionNote =>
      'Includes alerts for your bookmarked, recent and nearby stops.';

  @override
  String get alertsMarkAllRead => 'Mark all as read';

  @override
  String get alertsAllRead => 'All alerts marked as read';

  @override
  String get alertsUnread => 'Unread';

  @override
  String get alertsSeverityInfo => 'Information';

  @override
  String get alertsSeverityWarning => 'Warning';

  @override
  String get alertsSeveritySevere => 'Severe';

  @override
  String get alertsSeverityUnknown => 'Service alert';

  @override
  String get alertsNoTitle => 'Service alert';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Unread. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread alerts',
      one: '1 unread alert',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more alerts',
      one: '1 more alert',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Active period';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'From $start';
  }

  @override
  String get alertsDetailAffects => 'Affects';

  @override
  String get alertsDetailRoutes => 'Routes';

  @override
  String get alertsDetailStops => 'Stops';

  @override
  String get alertsDetailLearnMore => 'Learn more';

  @override
  String get alertsDetailNoDetails => 'No additional details available.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Issued $date';
  }

  @override
  String get agenciesEmptyTitle => 'No agencies';

  @override
  String get agenciesEmptyBody =>
      'This region didn\'t list any transit agencies.';

  @override
  String get agenciesWebsite => 'Website';

  @override
  String agenciesPhone(String phone) {
    return 'Call $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'Email $email';
  }

  @override
  String get agenciesFares => 'Fare information';

  @override
  String get agenciesDisclaimer => 'Disclaimer';

  @override
  String get agenciesShowOnMap => 'Show coverage on the map';

  @override
  String get searchFieldLabel => 'Search';

  @override
  String get searchFieldHint => 'Route, stop number, address or vehicle';

  @override
  String get searchClear => 'Clear search';

  @override
  String get searchScopeLabel => 'Search for';

  @override
  String get searchScopeAll => 'All';

  @override
  String get searchScopeStops => 'Stops';

  @override
  String get searchScopeRoutes => 'Routes';

  @override
  String get searchScopePlaces => 'Places';

  @override
  String get searchQuickHeader => 'Search for';

  @override
  String searchQuickRoute(String query) {
    return 'Route: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Stop number: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Address: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Vehicle: $query';
  }

  @override
  String get searchRecentStopsHeader => 'Recent stops';

  @override
  String get searchBookmarksHeader => 'Bookmarks';

  @override
  String get searchRecentSearchesHeader => 'Recent searches';

  @override
  String get searchRecentPlacesHeader => 'Recent places';

  @override
  String get searchPlacesHeader => 'Places';

  @override
  String get searchClearRecent => 'Clear recent searches';

  @override
  String get searchClearRecentConfirm =>
      'Clear your recent searches and places?';

  @override
  String get searchClearAction => 'Clear';

  @override
  String get searchRecentCleared => 'Recent searches cleared';

  @override
  String get searchPlacesLoading => 'Searching places';

  @override
  String get searchPlacesNone => 'No places found';

  @override
  String get searchPlacesError =>
      'Couldn\'t search places. Check your connection.';

  @override
  String get searchSearching => 'Searching';

  @override
  String get searchNoResultsTitle => 'No results';

  @override
  String searchNoResultsBody(String query) {
    return 'No search results were found for “$query”.';
  }

  @override
  String get searchUnavailableNoRegion => 'Choose a region before searching.';

  @override
  String get searchUnavailableAddress =>
      'Address search isn\'t set up in this app.';

  @override
  String get searchUnavailableVehicle =>
      'Vehicle search isn\'t available in this region.';

  @override
  String get searchEmptyTitle => 'Find routes, stops and places';

  @override
  String get searchEmptyBody =>
      'Type a route name, a stop number, an address or a vehicle ID.';

  @override
  String get searchDismissMessage => 'Dismiss';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results for “$query”',
      one: '1 result for “$query”',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'Routes';

  @override
  String get searchResultsStops => 'Stops';

  @override
  String get searchResultsVehicles => 'Vehicles';

  @override
  String get searchResultsPlaces => 'Places';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Route $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Vehicle $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'Vehicle $id isn\'t serving a trip right now.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Loading vehicle $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'Turn on location to see departures from stops near you.';

  @override
  String get searchNearbyLocationButton => 'Use my location';

  @override
  String get searchNearbyLocationDenied =>
      'Location access is off. Turn it on in your device settings to see stops near you.';

  @override
  String get searchNearbyLocationServicesOff =>
      'Location services are off. Turn them on to see stops near you.';

  @override
  String get searchNearbyLocationUnavailable =>
      'This app doesn\'t use your location, so it can\'t show stops near you.';

  @override
  String get searchNearbyEmpty => 'No stops nearby';

  @override
  String get searchNearbyEmptyBody =>
      'There are no stops within walking distance.';

  @override
  String get searchNearbyMapCenter =>
      'Showing stops near the centre of the map.';

  @override
  String get searchNearbyNoDepartures => 'No departures in the next hour';

  @override
  String get searchNearbyLoadingDepartures => 'Loading departures';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops nearby',
      one: '1 stop nearby',
      zero: 'No stops nearby',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Finding your location…';

  @override
  String get searchNearbyRefresh => 'Refresh';

  @override
  String searchNearbyDistance(String distance) {
    return '$distance away';
  }

  @override
  String get searchNearbyOtherDirection => 'Other stops';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return '$direction stops';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route to $headsign, $eta, $status. From $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'From $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Departures near you';

  @override
  String get searchExplorePlanTrip => 'Plan a trip';

  @override
  String get searchExploreWeather => 'Weather';

  @override
  String get searchExploreAgencies => 'Agencies';

  @override
  String get searchPlaceAddress => 'Address';

  @override
  String get searchPlaceCoordinates => 'Coordinates';

  @override
  String get searchPlaceDistance => 'Distance';

  @override
  String get searchPlaceDirectionsTo => 'Directions to here';

  @override
  String get searchPlaceDirectionsFrom => 'Directions from here';

  @override
  String get searchPlaceNearbyStops => 'Nearby stops';

  @override
  String get searchPlaceShare => 'Share';

  @override
  String get searchPlaceOpenInMaps => 'Open in maps app';

  @override
  String get searchPlaceRemovePin => 'Remove pin';

  @override
  String get searchPlaceOpenFailed => 'Couldn\'t open a maps app.';

  @override
  String get searchPlaceShareFailed => 'Couldn\'t share this place.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Place: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Weather: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Shows the forecast';

  @override
  String get searchWeatherClear => 'Clear';

  @override
  String get searchWeatherPartlyCloudy => 'Partly cloudy';

  @override
  String get searchWeatherCloudy => 'Cloudy';

  @override
  String get searchWeatherRain => 'Rain';

  @override
  String get searchWeatherSleet => 'Sleet';

  @override
  String get searchWeatherSnow => 'Snow';

  @override
  String get searchWeatherWindy => 'Windy';

  @override
  String get searchWeatherFog => 'Fog';

  @override
  String get searchWeatherUnknown => 'Unknown conditions';

  @override
  String searchWeatherDegreesF(int value) {
    return '$value°F';
  }

  @override
  String searchWeatherDegreesC(int value) {
    return '$value°C';
  }

  @override
  String searchWeatherSpokenF(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value degrees Fahrenheit',
      one: '1 degree Fahrenheit',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value degrees Celsius',
      one: '1 degree Celsius',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherMph(int value) {
    return '$value mph';
  }

  @override
  String searchWeatherKmh(int value) {
    return '$value km/h';
  }

  @override
  String searchWeatherMps(int value) {
    return '$value m/s';
  }

  @override
  String searchWeatherPercent(int value) {
    return '$value%';
  }

  @override
  String get searchWeatherFeelsLike => 'Feels like';

  @override
  String get searchWeatherWind => 'Wind';

  @override
  String get searchWeatherPrecip => 'Chance of rain';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'High $high · Low $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'High $high, low $low, over the next 24 hours';
  }

  @override
  String get searchWeatherHourly => 'Next 24 hours';

  @override
  String get searchWeatherNow => 'Now';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, $precip chance of rain';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Temperatures in $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'degrees Fahrenheit (°F)';

  @override
  String get searchWeatherCelsius => 'degrees Celsius (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Forecast from $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'Weather isn\'t available for this region.';

  @override
  String get searchWeatherSummaryLabel => 'Today';

  @override
  String get bookmarksSectionEmpty => 'Bookmarked stops appear here.';

  @override
  String get coreDirectionBoundN => 'Northbound';

  @override
  String get coreDirectionBoundNE => 'NE bound';

  @override
  String get coreDirectionBoundE => 'Eastbound';

  @override
  String get coreDirectionBoundSE => 'SE bound';

  @override
  String get coreDirectionBoundS => 'Southbound';

  @override
  String get coreDirectionBoundSW => 'SW bound';

  @override
  String get coreDirectionBoundW => 'Westbound';

  @override
  String get coreDirectionBoundNW => 'NW bound';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Stop #$code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Stop: \'$code\'';
  }

  @override
  String get coreJustNow => 'Just Now';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds sec. ago';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes min. ago';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours hr. ago';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String coreMeters(String value) {
    return '$value m';
  }

  @override
  String coreKilometers(String value) {
    return '$value km';
  }

  @override
  String coreFeet(String value) {
    return '$value ft';
  }

  @override
  String coreMiles(String value) {
    return '$value mi';
  }

  @override
  String get arrivalsNow => 'now';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '${minutes}m';
  }

  @override
  String get arrivalsCanceled => 'canceled';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'every $minutes min from $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'every $minutes min until $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'North bound';

  @override
  String get arrivalsDirectionBoundNE => 'Northeast bound';

  @override
  String get arrivalsDirectionBoundE => 'East bound';

  @override
  String get arrivalsDirectionBoundSE => 'Southeast bound';

  @override
  String get arrivalsDirectionBoundS => 'South bound';

  @override
  String get arrivalsDirectionBoundSW => 'Southwest bound';

  @override
  String get arrivalsDirectionBoundW => 'West bound';

  @override
  String get arrivalsDirectionBoundNW => 'Northwest bound';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return '$code bound';
  }

  @override
  String get arrivalsRefresh => 'Refresh arrivals';

  @override
  String get arrivalsRetry => 'Retry';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'No arrivals in the next $minutes minutes',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound => 'Stop not found or service unavailable';

  @override
  String get arrivalsNetworkError =>
      'Couldn\'t reach the transit server. Check your connection.';

  @override
  String get arrivalsLoadError => 'Couldn\'t load arrivals.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'Couldn\'t update. Showing results from $time';
  }

  @override
  String get arrivalsArrivingNow => 'arriving now';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arriving in $minutes minutes',
      one: 'arriving in 1 minute',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'real-time';

  @override
  String get arrivalsRowTapHint => 'show details';

  @override
  String arrivalsAtTime(String time) {
    return 'at $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes late',
      one: '1 minute late',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes early',
      one: '1 minute early',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'every $minutes minutes from $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'every $minutes minutes until $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'scheduled time';

  @override
  String get arrivalsLoading => 'Loading arrivals';

  @override
  String get arrivalsRefreshing => 'Refreshing arrivals';

  @override
  String get arrivalsUpdated => 'Arrivals updated';

  @override
  String get tripPlannerOriginLabel => 'From';

  @override
  String get tripPlannerDestinationLabel => 'To';

  @override
  String get tripPlannerChooseOrigin => 'Choose starting point';

  @override
  String get tripPlannerChooseDestination => 'Choose destination';

  @override
  String get tripPlannerCurrentLocation => 'Current Location';

  @override
  String get tripPlannerSwapEndpoints => 'Swap starting point and destination';

  @override
  String get tripPlannerPlanTrip => 'Plan trip';

  @override
  String get tripPlannerPlanningTrip => 'Planning your trip';

  @override
  String get tripPlannerOptions => 'Trip options';

  @override
  String get tripPlannerLeaveNow => 'Leave now';

  @override
  String get tripPlannerDepartAt => 'Depart at';

  @override
  String get tripPlannerArriveBy => 'Arrive by';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Change time, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Transit';

  @override
  String get tripPlannerModeWalk => 'Walk';

  @override
  String get tripPlannerModeBike => 'Bike';

  @override
  String get tripPlannerModeCar => 'Car';

  @override
  String get tripPlannerModeBikeRental => 'Bikeshare Only';

  @override
  String get tripPlannerModeTransitBikeRental => 'Transit + Bikeshare';

  @override
  String get tripPlannerWheelchairAccessible => 'Wheelchair accessible';

  @override
  String get tripPlannerWalkQuarterMile => '0.25 mile';

  @override
  String get tripPlannerWalkHalfMile => '0.5 mile';

  @override
  String get tripPlannerWalkOneMile => '1 mile';

  @override
  String get tripPlannerWalkTwoMiles => '2 miles';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'Walk up to $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'No trips found';

  @override
  String get tripPlannerRetry => 'Retry';

  @override
  String get tripPlannerRealTime => 'Real-time';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours hr';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String tripPlannerTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String tripPlannerTransfers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transfers',
      one: '1 transfer',
      zero: 'No transfers',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return 'Walk $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Departs $time from $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'On time';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '$minutes min late';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '$minutes min early';
  }

  @override
  String get tripPlannerStatusScheduled => 'Scheduled';

  @override
  String get tripPlannerLegBus => 'Bus';

  @override
  String get tripPlannerLegTram => 'Tram';

  @override
  String get tripPlannerLegSubway => 'Subway';

  @override
  String get tripPlannerLegRail => 'Train';

  @override
  String get tripPlannerLegFerry => 'Ferry';

  @override
  String get tripPlannerLegCableCar => 'Cable Car';

  @override
  String get tripPlannerLegGondola => 'Gondola';

  @override
  String get tripPlannerLegFunicular => 'Funicular';

  @override
  String get tripPlannerLegAirplane => 'Plane';

  @override
  String get tripPlannerLegTrolleybus => 'Trolleybus';

  @override
  String get tripPlannerLegMonorail => 'Monorail';

  @override
  String tripPlannerItinerarySemantics(
    String timeRange,
    String duration,
    String legs,
    String details,
  ) {
    return '$timeRange, $duration. $legs. $details';
  }

  @override
  String tripPlannerLegWalkSemantics(String duration) {
    return 'Walk $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return 'Bike $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return 'Rental bike $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return 'Drive $duration';
  }

  @override
  String tripPlannerLegTransitSemantics(String mode, String duration) {
    return '$mode, $duration';
  }

  @override
  String tripPlannerLegTransitRouteSemantics(
    String mode,
    String route,
    String duration,
  ) {
    return '$mode $route, $duration';
  }

  @override
  String get tripPlannerThen => 'then';

  @override
  String get tripPlannerOpenItineraryHint => 'show trip details';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursMinutesSemantics(String hours, String minutes) {
    return '$hours $minutes';
  }

  @override
  String tripPlannerFeetSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value feet',
      one: '1 foot',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value miles',
      one: '1 mile',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value meters',
      one: '1 meter',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value kilometers',
      one: '1 kilometer',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return '$start to $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'real-time, on time';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'real-time, $minutes minutes late',
      one: 'real-time, 1 minute late',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'real-time, $minutes minutes early',
      one: 'real-time, 1 minute early',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'scheduled time';

  @override
  String get tripPlannerResultsHeading => 'Suggested trips';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trips found',
      one: '1 trip found',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places found',
      one: '1 place found',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'Map of the trip. The directions below describe the same trip.';

  @override
  String get tripPlannerTripDetails => 'Trip details';

  @override
  String get tripPlannerMapLabel => 'Map of the trip';

  @override
  String get tripPlannerStart => 'Start';

  @override
  String get tripPlannerDestination => 'Destination';

  @override
  String get tripPlannerUnnamedPlace => 'Unnamed location';

  @override
  String get tripPlannerRentalBike => 'Rental bike';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Walk to $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Bike to $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Ride rental bike to $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Drive to $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Take $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Take $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Take $mode toward $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Take $mode $route toward $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Get off at $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Arrive at $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '1 stop',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count stops',
      one: 'Show 1 stop',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hide $count stops',
      one: 'Hide 1 stop',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps',
      one: '1 step',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count steps',
      one: 'Show 1 step',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hide $count steps',
      one: 'Hide 1 step',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, about $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Head out';

  @override
  String get tripPlannerDirectionHardLeft => 'Turn sharp left';

  @override
  String get tripPlannerDirectionLeft => 'Turn left';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'Bear left';

  @override
  String get tripPlannerDirectionContinue => 'Continue';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Bear right';

  @override
  String get tripPlannerDirectionRight => 'Turn right';

  @override
  String get tripPlannerDirectionHardRight => 'Turn sharp right';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Enter the roundabout clockwise';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Enter the roundabout counterclockwise';

  @override
  String get tripPlannerDirectionElevator => 'Take the elevator';

  @override
  String get tripPlannerDirectionUturnLeft => 'Make a U-turn to the left';

  @override
  String get tripPlannerDirectionUturnRight => 'Make a U-turn to the right';

  @override
  String get tripPlannerDirectionEnterStation => 'Enter the station';

  @override
  String get tripPlannerDirectionExitStation => 'Exit the station';

  @override
  String get tripPlannerDirectionFollowSigns => 'Follow the signs';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Walk along $street for $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction onto $street, walk $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Search for a place';

  @override
  String get tripPlannerSearchNoResults => 'No places found';

  @override
  String get tripPlannerSearchError =>
      'Couldn\'t search for places. Try again.';

  @override
  String get tripPlannerUseCurrentLocation => 'Use current location';

  @override
  String get tripPlannerLocationUnavailable => 'Couldn\'t get your location.';

  @override
  String get tripPlannerClearSearch => 'Clear search';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Please select both origin and destination locations.';

  @override
  String get tripPlannerErrorNetwork =>
      'Couldn\'t reach the trip planner. Check your connection.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'Server returned invalid response';

  @override
  String get tripPlannerErrorUnknown => 'An unknown error occurred.';

  @override
  String get tripPlannerPlannerSystemError =>
      'We couldn’t plan your trip right now. Please try again.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'Trip planning is temporarily unavailable. Try again shortly.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'This location isn’t supported yet.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'No route is available for this trip.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'No transit options are available right now.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'This took longer than expected. Please try again.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'Something went wrong with the request. Please try again.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'We couldn’t find the starting location.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'We couldn’t find the destination.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'We couldn’t find either the starting point or the destination.';

  @override
  String get tripPlannerPlannerTooClose =>
      'The start and destination are too close.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'This route isn’t accessible with the selected option.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'The starting location isn’t clear. Try being more specific.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'The destination isn’t clear. Try being more specific.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Both locations need more detail. Try refining them.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'Some route options are missing.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'The selected route options don’t work together.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Please choose a route preference.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Please adjust the route preferences.';
}
