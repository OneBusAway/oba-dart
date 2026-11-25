// Connects the lower packages' English strings classes to the SDK's ARB
// strings, so a screen built from obakit_core, oba_arrivals and
// obakit_trip_planner pieces is translated as a whole.
//
// How each package gets its strings:
// - obakit_core: formatters are pure Dart and built outside the widget
//   tree, so obakit never uses `ObaCoreApplication.formatters` (English
//   only). Screens call `context.obaFormatters`, which wraps the current
//   locale's strings; a test fails if obakit reads the English formatters.
// - oba_arrivals: `ObaScope` puts an `ObaArrivalsStringsScope` in the tree
//   that resolves strings at each panel's own context, so a panel embedded
//   anywhere under the scope (even with the scope above the host's
//   `MaterialApp`) follows the locale. Strings passed to a panel explicitly
//   still win.
// - obakit_trip_planner: obakit builds the trip planner widgets itself and
//   passes `context.obaTripPlannerStrings`.
//
// Every member of each strings class is overridden here (a test checks
// that against the classes' source), except the few listed in that test
// that only combine other members.

import 'package:flutter/widgets.dart';
import 'package:oba_arrivals/oba_arrivals.dart' show ObaArrivalsStrings;
import 'package:obakit_core/obakit_core.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import 'l10n.dart';

/// Strings for the current locale, plus formatters that use them.
extension ObaStringsBridgeContext on BuildContext {
  /// [ObaFormatters] that speak the current locale. Use this instead of
  /// `ObaCoreApplication.formatters`, which is English only.
  ObaFormatters get obaFormatters => ObaFormatters(obaCoreStrings);

  /// `obakit_core` strings from the SDK's localizations.
  ObaCoreStrings get obaCoreStrings => ObaL10nCoreStrings(obaL10n);

  /// `oba_arrivals` strings from the SDK's localizations.
  ObaArrivalsStrings get obaArrivalsStrings => ObaL10nArrivalsStrings(obaL10n);

  /// `obakit_trip_planner` strings from the SDK's localizations.
  tp.TripPlannerStrings get obaTripPlannerStrings =>
      ObaL10nTripPlannerStrings(obaL10n);
}

/// [ObaCoreStrings] read from [l10n].
class ObaL10nCoreStrings extends ObaCoreStrings {
  const ObaL10nCoreStrings(this.l10n);

  final ObaLocalizations l10n;

  @override
  bool operator ==(Object other) =>
      other is ObaL10nCoreStrings && identical(other.l10n, l10n);

  @override
  int get hashCode => identityHashCode(l10n);

  @override
  String directionName(StopDirection d) => switch (d) {
    StopDirection.n => l10n.coreDirectionNameN,
    StopDirection.ne => l10n.coreDirectionNameNE,
    StopDirection.e => l10n.coreDirectionNameE,
    StopDirection.se => l10n.coreDirectionNameSE,
    StopDirection.s => l10n.coreDirectionNameS,
    StopDirection.sw => l10n.coreDirectionNameSW,
    StopDirection.w => l10n.coreDirectionNameW,
    StopDirection.nw => l10n.coreDirectionNameNW,
    StopDirection.unknown => '',
  };

  @override
  String directionAbbreviation(StopDirection d) => switch (d) {
    StopDirection.n => l10n.coreDirectionAbbrN,
    StopDirection.ne => l10n.coreDirectionAbbrNE,
    StopDirection.e => l10n.coreDirectionAbbrE,
    StopDirection.se => l10n.coreDirectionAbbrSE,
    StopDirection.s => l10n.coreDirectionAbbrS,
    StopDirection.sw => l10n.coreDirectionAbbrSW,
    StopDirection.w => l10n.coreDirectionAbbrW,
    StopDirection.nw => l10n.coreDirectionAbbrNW,
    StopDirection.unknown => '',
  };

  @override
  String directionAdjective(StopDirection d) => switch (d) {
    StopDirection.n => l10n.coreDirectionBoundN,
    StopDirection.ne => l10n.coreDirectionBoundNE,
    StopDirection.e => l10n.coreDirectionBoundE,
    StopDirection.se => l10n.coreDirectionBoundSE,
    StopDirection.s => l10n.coreDirectionBoundS,
    StopDirection.sw => l10n.coreDirectionBoundSW,
    StopDirection.w => l10n.coreDirectionBoundW,
    StopDirection.nw => l10n.coreDirectionBoundNW,
    StopDirection.unknown => '',
  };

  @override
  String routeTypeName(RouteType t) => switch (t) {
    RouteType.lightRail => l10n.coreRouteTypeLightRail,
    RouteType.subway => l10n.coreRouteTypeSubway,
    RouteType.rail => l10n.coreRouteTypeRail,
    RouteType.bus => l10n.coreRouteTypeBus,
    RouteType.ferry => l10n.coreRouteTypeFerry,
    RouteType.cableCar => l10n.coreRouteTypeCableCar,
    RouteType.gondola => l10n.coreRouteTypeGondola,
    RouteType.funicular => l10n.coreRouteTypeFunicular,
    RouteType.unknown => '',
  };

  @override
  String stopCodeNumeric(String code) => l10n.coreStopCodeNumeric(code);
  @override
  String stopCodeNonNumeric(String code) => l10n.coreStopCodeNonNumeric(code);
  @override
  String stopId(String code) => l10n.coreStopId(code);
  @override
  String routesLabel(String list) => l10n.coreRoutesLabel(list);
  @override
  String routesLabelPlusMore(String list, int more) =>
      l10n.coreRoutesLabelPlusMore(list, more);
  @override
  String mapRoutesOverflow(String list) => l10n.coreMapRoutesOverflow(list);
  @override
  String searchPlaceholder(String regionName) =>
      l10n.coreSearchPlaceholder(regionName);

  @override
  String get now => l10n.coreNow;
  @override
  String shortMinutes(int minutes) => l10n.coreShortMinutes(minutes);
  @override
  String get oneMinute => l10n.coreOneMinute;
  @override
  String get oneMinuteAgo => l10n.coreOneMinuteAgo;
  @override
  String minutes(int minutes) => l10n.coreMinutes(minutes);
  @override
  String get justNow => l10n.coreJustNow;
  @override
  String secondsAgo(int n) => l10n.coreSecondsAgo(n);
  @override
  String minutesAgo(int n) => l10n.coreMinutesAgo(n);
  @override
  String hoursAgo(int n) => l10n.coreHoursAgo(n);
  @override
  String daysAgo(int n) => l10n.coreDaysAgo(n);
  @override
  String updatedAt(String ago) => l10n.coreUpdatedAt(ago);

  @override
  String get scheduledNotRealTime => l10n.coreScheduledNotRealTime;

  @override
  String arrivedMinAgo(int m) => l10n.coreArrivedMinAgo(m);
  @override
  String departedMinAgo(int m) => l10n.coreDepartedMinAgo(m);
  @override
  String get arrivingNow => l10n.coreArrivingNow;
  @override
  String get departingNow => l10n.coreDepartingNow;
  @override
  String arrivesInMin(int m) => l10n.coreArrivesInMin(m);
  @override
  String departsInMin(int m) => l10n.coreDepartsInMin(m);

  @override
  String arrivedLate(int m) => l10n.coreArrivedLate(m);
  @override
  String arrivedEarly(int m) => l10n.coreArrivedEarly(m);
  @override
  String get arrivedOnTime => l10n.coreArrivedOnTime;
  @override
  String departedLate(int m) => l10n.coreDepartedLate(m);
  @override
  String departedEarly(int m) => l10n.coreDepartedEarly(m);
  @override
  String get departedOnTime => l10n.coreDepartedOnTime;
  @override
  String arrivesLate(int m) => l10n.coreArrivesLate(m);
  @override
  String arrivesEarly(int m) => l10n.coreArrivesEarly(m);
  @override
  String get arrivesOnTime => l10n.coreArrivesOnTime;
  @override
  String departsLate(int m) => l10n.coreDepartsLate(m);
  @override
  String departsEarly(int m) => l10n.coreDepartsEarly(m);
  @override
  String get departsOnTime => l10n.coreDepartsOnTime;

  @override
  String meters(String n) => l10n.coreMeters(n);
  @override
  String kilometers(String n) => l10n.coreKilometers(n);
  @override
  String feet(String n) => l10n.coreFeet(n);
  @override
  String miles(String n) => l10n.coreMiles(n);

  @override
  String alarmMinutes(int m) => l10n.coreAlarmMinutes(m);
}

/// [ObaArrivalsStrings] read from [l10n].
class ObaL10nArrivalsStrings extends ObaArrivalsStrings {
  const ObaL10nArrivalsStrings(this.l10n);

  final ObaLocalizations l10n;

  @override
  bool operator ==(Object other) =>
      other is ObaL10nArrivalsStrings && identical(other.l10n, l10n);

  @override
  int get hashCode => identityHashCode(l10n);

  @override
  String get now => l10n.arrivalsNow;
  @override
  String minutesCompact(int minutes) => l10n.arrivalsMinutesCompact(minutes);
  @override
  String minLate(int minutes) => l10n.stopRowLate(minutes);
  @override
  String minEarly(int minutes) => l10n.stopRowEarly(minutes);
  @override
  String get onTime => l10n.stopRowOnTime;
  @override
  String get scheduled => l10n.stopRowScheduled;
  @override
  String get canceled => l10n.arrivalsCanceled;
  @override
  String everyMinutesFrom(int minutes, String time) =>
      l10n.arrivalsEveryMinutesFrom(minutes, time);
  @override
  String everyMinutesUntil(int minutes, String time) =>
      l10n.arrivalsEveryMinutesUntil(minutes, time);

  @override
  String stopNumber(String code) => l10n.coreStopCodeNumeric(code);

  @override
  String directionBound(String code) => switch (code) {
    'N' => l10n.arrivalsDirectionBoundN,
    'NE' => l10n.arrivalsDirectionBoundNE,
    'E' => l10n.arrivalsDirectionBoundE,
    'SE' => l10n.arrivalsDirectionBoundSE,
    'S' => l10n.arrivalsDirectionBoundS,
    'SW' => l10n.arrivalsDirectionBoundSW,
    'W' => l10n.arrivalsDirectionBoundW,
    'NW' => l10n.arrivalsDirectionBoundNW,
    _ => l10n.arrivalsDirectionBoundOther(code),
  };

  @override
  String get refresh => l10n.arrivalsRefresh;
  @override
  String get retry => l10n.arrivalsRetry;
  @override
  String noArrivals(int minutes) => l10n.arrivalsNoArrivals(minutes);
  @override
  String get stopNotFound => l10n.arrivalsStopNotFound;
  @override
  String get networkError => l10n.arrivalsNetworkError;
  @override
  String get loadError => l10n.arrivalsLoadError;
  @override
  String staleNotice(String time) => l10n.arrivalsStaleNotice(time);

  @override
  String get arrivingNow => l10n.arrivalsArrivingNow;
  @override
  String arrivingInMinutes(int minutes) =>
      l10n.arrivalsArrivingInMinutes(minutes);
  @override
  String get realtime => l10n.arrivalsRealtime;
  @override
  String get rowTapHint => l10n.arrivalsRowTapHint;
  @override
  String routeSemantics(String label) =>
      l10n.bookmarksDepartureRouteOnly(label);
  @override
  String atTime(String time) => l10n.arrivalsAtTime(time);
  @override
  String minutesLateSemantics(int minutes) =>
      l10n.arrivalsMinutesLateSemantics(minutes);
  @override
  String minutesEarlySemantics(int minutes) =>
      l10n.arrivalsMinutesEarlySemantics(minutes);
  @override
  String everyMinutesFromSemantics(int minutes, String time) =>
      l10n.arrivalsEveryMinutesFromSemantics(minutes, time);
  @override
  String everyMinutesUntilSemantics(int minutes, String time) =>
      l10n.arrivalsEveryMinutesUntilSemantics(minutes, time);
  @override
  String get scheduledSemantics => l10n.arrivalsScheduledSemantics;
  @override
  String get loadingArrivals => l10n.arrivalsLoading;
  @override
  String get refreshing => l10n.arrivalsRefreshing;
  @override
  String get arrivalsUpdated => l10n.arrivalsUpdated;
}

/// [tp.TripPlannerStrings] read from [l10n].
class ObaL10nTripPlannerStrings extends tp.TripPlannerStrings {
  const ObaL10nTripPlannerStrings(this.l10n);

  final ObaLocalizations l10n;

  @override
  bool operator ==(Object other) =>
      other is ObaL10nTripPlannerStrings && identical(other.l10n, l10n);

  @override
  int get hashCode => identityHashCode(l10n);

  // Form.
  @override
  String get originLabel => l10n.tripPlannerOriginLabel;
  @override
  String get destinationLabel => l10n.tripPlannerDestinationLabel;
  @override
  String get chooseOrigin => l10n.tripPlannerChooseOrigin;
  @override
  String get chooseDestination => l10n.tripPlannerChooseDestination;
  @override
  String get currentLocation => l10n.tripPlannerCurrentLocation;
  @override
  String get swapEndpoints => l10n.tripPlannerSwapEndpoints;
  @override
  String get planTrip => l10n.tripPlannerPlanTrip;
  @override
  String get planningTrip => l10n.tripPlannerPlanningTrip;
  @override
  String get options => l10n.tripPlannerOptions;

  @override
  String timeOption(tp.TripTimeOption option) => switch (option) {
    tp.TripTimeOption.leaveNow => l10n.tripPlannerLeaveNow,
    tp.TripTimeOption.departAt => l10n.tripPlannerDepartAt,
    tp.TripTimeOption.arriveBy => l10n.tripPlannerArriveBy,
  };

  @override
  String changeTime(String dateTime) => l10n.tripPlannerChangeTime(dateTime);

  @override
  String transportMode(tp.TransportMode mode) => switch (mode) {
    tp.TransportMode.transit => l10n.tripPlannerModeTransit,
    tp.TransportMode.walk => l10n.tripPlannerModeWalk,
    tp.TransportMode.bike => l10n.tripPlannerModeBike,
    tp.TransportMode.car => l10n.tripPlannerModeCar,
    tp.TransportMode.bikeRental => l10n.tripPlannerModeBikeRental,
    tp.TransportMode.transitBikeRental => l10n.tripPlannerModeTransitBikeRental,
  };

  @override
  String get wheelchairAccessible => l10n.tripPlannerWheelchairAccessible;

  @override
  String walkingDistance(tp.WalkingDistance distance) => switch (distance) {
    tp.WalkingDistance.quarterMile => l10n.tripPlannerWalkQuarterMile,
    tp.WalkingDistance.halfMile => l10n.tripPlannerWalkHalfMile,
    tp.WalkingDistance.oneMile => l10n.tripPlannerWalkOneMile,
    tp.WalkingDistance.twoMiles => l10n.tripPlannerWalkTwoMiles,
  };

  @override
  String maxWalk(String distance) => l10n.tripPlannerMaxWalk(distance);

  // Results.
  @override
  String get noTripsFound => l10n.tripPlannerNoTripsFound;
  @override
  String get retry => l10n.tripPlannerRetry;
  @override
  String get realTime => l10n.tripPlannerRealTime;

  @override
  String duration(int seconds) {
    final parts = tp.durationParts(seconds);
    if (parts.hours == 0) return l10n.tripPlannerDurationMinutes(parts.minutes);
    if (parts.minutes == 0) return l10n.tripPlannerDurationHours(parts.hours);
    return l10n.tripPlannerDurationHoursMinutes(parts.hours, parts.minutes);
  }

  @override
  String distance(double meters, tp.DistanceUnits units) {
    final parts = tp.distanceParts(meters, units);
    final value = tp.formatNumber(parts.value);
    return switch (parts.unit) {
      tp.DistanceUnit.feet => l10n.coreFeet(value),
      tp.DistanceUnit.miles => l10n.coreMiles(value),
      tp.DistanceUnit.meters => l10n.coreMeters(value),
      tp.DistanceUnit.kilometers => l10n.coreKilometers(value),
    };
  }

  @override
  String timeRange(String start, String end) =>
      l10n.tripPlannerTimeRange(start, end);
  @override
  String transfers(int count) => l10n.tripPlannerTransfers(count);
  @override
  String walkDistance(String distance) =>
      l10n.tripPlannerWalkDistance(distance);
  @override
  String departsAt(String time, String place) =>
      l10n.tripPlannerDepartsAt(time, place);

  @override
  String realTimeStatus(tp.RealTimeStatus status) => switch (status) {
    tp.OnTimeStatus() => l10n.tripPlannerStatusOnTime,
    tp.LateStatus(:final minutes) => l10n.tripPlannerStatusLate(minutes),
    tp.EarlyStatus(:final minutes) => l10n.tripPlannerStatusEarly(minutes),
    tp.ScheduledStatus() => l10n.tripPlannerStatusScheduled,
  };

  @override
  String legMode(tp.LegMode mode) => switch (mode) {
    tp.LegMode.walk => l10n.tripPlannerModeWalk,
    tp.LegMode.bicycle => l10n.tripPlannerModeBike,
    tp.LegMode.car => l10n.tripPlannerModeCar,
    tp.LegMode.transit => l10n.tripPlannerModeTransit,
    tp.LegMode.bus => l10n.tripPlannerLegBus,
    tp.LegMode.tram => l10n.tripPlannerLegTram,
    tp.LegMode.subway => l10n.tripPlannerLegSubway,
    tp.LegMode.rail => l10n.tripPlannerLegRail,
    tp.LegMode.ferry => l10n.tripPlannerLegFerry,
    tp.LegMode.cableCar => l10n.tripPlannerLegCableCar,
    tp.LegMode.gondola => l10n.tripPlannerLegGondola,
    tp.LegMode.funicular => l10n.tripPlannerLegFunicular,
    tp.LegMode.airplane => l10n.tripPlannerLegAirplane,
    tp.LegMode.trolleybus => l10n.tripPlannerLegTrolleybus,
    tp.LegMode.monorail => l10n.tripPlannerLegMonorail,
  };

  // Accessibility.
  @override
  String itinerarySemantics({
    required String timeRange,
    required String duration,
    required String legs,
    required String details,
  }) => l10n.tripPlannerItinerarySemantics(timeRange, duration, legs, details);

  @override
  String legChipSemantics(tp.LegSummaryItem item) {
    final duration = durationSemantics(item.durationSeconds);
    return switch (item.kind) {
      tp.LegKind.walk => l10n.tripPlannerLegWalkSemantics(duration),
      tp.LegKind.bike => l10n.tripPlannerLegBikeSemantics(duration),
      tp.LegKind.rentalBike => l10n.tripPlannerLegRentalBikeSemantics(duration),
      tp.LegKind.car => l10n.tripPlannerLegCarSemantics(duration),
      tp.LegKind.transit => switch (item.routeName) {
        final route? => l10n.tripPlannerLegTransitRouteSemantics(
          legModeName(item.leg),
          route,
          duration,
        ),
        null => l10n.tripPlannerLegTransitSemantics(
          legModeName(item.leg),
          duration,
        ),
      },
    };
  }

  @override
  String get then => l10n.tripPlannerThen;
  @override
  String get openItineraryHint => l10n.tripPlannerOpenItineraryHint;

  @override
  String durationSemantics(int seconds) {
    final parts = tp.durationParts(seconds);
    final minutes = l10n.tripPlannerMinutesSemantics(parts.minutes);
    if (parts.hours == 0) return minutes;
    final hours = l10n.tripPlannerHoursSemantics(parts.hours);
    if (parts.minutes == 0) return hours;
    return l10n.tripPlannerHoursMinutesSemantics(hours, minutes);
  }

  @override
  String distanceSemantics(double meters, tp.DistanceUnits units) {
    final parts = tp.distanceParts(meters, units);
    final value = tp.formatNumber(parts.value);
    // An exact count, so "1 foot" stays singular and "1.5 miles" plural.
    final count = parts.value == parts.value.roundToDouble()
        ? parts.value.round()
        : parts.value;
    return switch (parts.unit) {
      tp.DistanceUnit.feet => l10n.tripPlannerFeetSemantics(count, value),
      tp.DistanceUnit.miles => l10n.tripPlannerMilesSemantics(count, value),
      tp.DistanceUnit.meters => l10n.tripPlannerMetersSemantics(count, value),
      tp.DistanceUnit.kilometers => l10n.tripPlannerKilometersSemantics(
        count,
        value,
      ),
    };
  }

  @override
  String timeRangeSemantics(String start, String end) =>
      l10n.tripPlannerTimeRangeSemantics(start, end);

  @override
  String realTimeStatusSemantics(tp.RealTimeStatus status) => switch (status) {
    tp.OnTimeStatus() => l10n.tripPlannerStatusOnTimeSemantics,
    tp.LateStatus(:final minutes) => l10n.tripPlannerStatusLateSemantics(
      minutes,
    ),
    tp.EarlyStatus(:final minutes) => l10n.tripPlannerStatusEarlySemantics(
      minutes,
    ),
    tp.ScheduledStatus() => l10n.tripPlannerStatusScheduledSemantics,
  };

  @override
  String get resultsHeading => l10n.tripPlannerResultsHeading;
  @override
  String tripsFound(int count) => l10n.tripPlannerTripsFound(count);
  @override
  String placesFound(int count) => l10n.tripPlannerPlacesFound(count);
  @override
  String get mapSemanticsLabel => l10n.tripPlannerMapSemanticsLabel;

  // Detail.
  @override
  String get tripDetails => l10n.tripPlannerTripDetails;
  @override
  String get mapLabel => l10n.tripPlannerMapLabel;
  @override
  String get start => l10n.tripPlannerStart;
  @override
  String get destination => l10n.tripPlannerDestination;
  @override
  String get unnamedPlace => l10n.tripPlannerUnnamedPlace;
  @override
  String get rentalBike => l10n.tripPlannerRentalBike;

  @override
  String walkTo(String place) => l10n.tripPlannerWalkTo(place);
  @override
  String bikeTo(String place) => l10n.tripPlannerBikeTo(place);
  @override
  String rideRentalBikeTo(String place) =>
      l10n.tripPlannerRideRentalBikeTo(place);
  @override
  String driveTo(String place) => l10n.tripPlannerDriveTo(place);

  @override
  String board(String mode, String? route, String? headsign) =>
      switch ((route, headsign)) {
        (null, null) => l10n.tripPlannerBoard(mode),
        (final r?, null) => l10n.tripPlannerBoardRoute(mode, r),
        (null, final h?) => l10n.tripPlannerBoardHeadsign(mode, h),
        (final r?, final h?) => l10n.tripPlannerBoardRouteHeadsign(mode, r, h),
      };

  @override
  String getOffAt(String place) => l10n.tripPlannerGetOffAt(place);
  @override
  String arriveAt(String place) => l10n.tripPlannerArriveAt(place);
  @override
  String stopCount(int count) => l10n.tripPlannerStopCount(count);
  @override
  String showStops(int count) => l10n.tripPlannerShowStops(count);
  @override
  String hideStops(int count) => l10n.tripPlannerHideStops(count);
  @override
  String stepCount(int count) => l10n.tripPlannerStepCount(count);
  @override
  String showSteps(int count) => l10n.tripPlannerShowSteps(count);
  @override
  String hideSteps(int count) => l10n.tripPlannerHideSteps(count);
  @override
  String legDistanceDuration(String distance, String duration) =>
      l10n.tripPlannerLegDistanceDuration(distance, duration);

  @override
  String relativeDirection(
    tp.RelativeDirection direction,
  ) => switch (direction) {
    tp.RelativeDirection.depart => l10n.tripPlannerDirectionDepart,
    tp.RelativeDirection.hardLeft => l10n.tripPlannerDirectionHardLeft,
    tp.RelativeDirection.left => l10n.tripPlannerDirectionLeft,
    tp.RelativeDirection.slightlyLeft => l10n.tripPlannerDirectionSlightlyLeft,
    tp.RelativeDirection.continueStraight => l10n.tripPlannerDirectionContinue,
    tp.RelativeDirection.slightlyRight =>
      l10n.tripPlannerDirectionSlightlyRight,
    tp.RelativeDirection.right => l10n.tripPlannerDirectionRight,
    tp.RelativeDirection.hardRight => l10n.tripPlannerDirectionHardRight,
    tp.RelativeDirection.circleClockwise =>
      l10n.tripPlannerDirectionCircleClockwise,
    tp.RelativeDirection.circleCounterclockwise =>
      l10n.tripPlannerDirectionCircleCounterclockwise,
    tp.RelativeDirection.elevator => l10n.tripPlannerDirectionElevator,
    tp.RelativeDirection.uturnLeft => l10n.tripPlannerDirectionUturnLeft,
    tp.RelativeDirection.uturnRight => l10n.tripPlannerDirectionUturnRight,
    tp.RelativeDirection.enterStation => l10n.tripPlannerDirectionEnterStation,
    tp.RelativeDirection.exitStation => l10n.tripPlannerDirectionExitStation,
    tp.RelativeDirection.followSigns => l10n.tripPlannerDirectionFollowSigns,
  };

  @override
  String stepInstruction(tp.LegStep step, tp.DistanceUnits units) {
    final distance = this.distance(step.distance, units);
    final street = step.streetName.isEmpty ? unnamedPlace : step.streetName;
    final token = step.relativeDirection;
    if (token == null) return l10n.tripPlannerStepAlong(street, distance);
    final known = tp.RelativeDirection.fromOtp(token);
    final direction = known == null
        ? tp.humanizeOtpToken(token)
        : relativeDirection(known);
    return l10n.tripPlannerStepTurn(direction, street, distance);
  }

  // Place search.
  @override
  String get searchHint => l10n.tripPlannerSearchHint;
  @override
  String get searchNoResults => l10n.tripPlannerSearchNoResults;
  @override
  String get searchError => l10n.tripPlannerSearchError;
  @override
  String get useCurrentLocation => l10n.tripPlannerUseCurrentLocation;
  @override
  String get locationUnavailable => l10n.tripPlannerLocationUnavailable;
  @override
  String get clearSearch => l10n.tripPlannerClearSearch;
  @override
  String get searchLabel => l10n.tripPlannerSearchHint;

  // Errors.
  @override
  String errorMessage(Object error) => switch (error) {
    tp.MissingTripEndpointsError() => l10n.tripPlannerErrorMissingEndpoints,
    tp.OtpPlannerException(:final code) => plannerError(code),
    tp.OtpNetworkException() => l10n.tripPlannerErrorNetwork,
    tp.OtpHttpException() ||
    tp.OtpFormatException() ||
    tp.OtpGraphQLException() => l10n.tripPlannerErrorInvalidResponse,
    _ => l10n.tripPlannerErrorUnknown,
  };

  @override
  String plannerError(tp.PlannerErrorCode code) => switch (code) {
    tp.PlannerErrorCode.systemError => l10n.tripPlannerPlannerSystemError,
    tp.PlannerErrorCode.graphUnavailable =>
      l10n.tripPlannerPlannerGraphUnavailable,
    tp.PlannerErrorCode.outsideBounds => l10n.tripPlannerPlannerOutsideBounds,
    tp.PlannerErrorCode.pathNotFound => l10n.tripPlannerPlannerPathNotFound,
    tp.PlannerErrorCode.noTransitTimes => l10n.tripPlannerPlannerNoTransitTimes,
    tp.PlannerErrorCode.requestTimeout => l10n.tripPlannerPlannerRequestTimeout,
    tp.PlannerErrorCode.bogusParameter => l10n.tripPlannerPlannerBogusParameter,
    tp.PlannerErrorCode.geocodeFromNotFound =>
      l10n.tripPlannerPlannerGeocodeFromNotFound,
    tp.PlannerErrorCode.geocodeToNotFound =>
      l10n.tripPlannerPlannerGeocodeToNotFound,
    tp.PlannerErrorCode.geocodeFromToNotFound =>
      l10n.tripPlannerPlannerGeocodeFromToNotFound,
    tp.PlannerErrorCode.tooClose => l10n.tripPlannerPlannerTooClose,
    tp.PlannerErrorCode.locationNotAccessible =>
      l10n.tripPlannerPlannerLocationNotAccessible,
    tp.PlannerErrorCode.geocodeFromAmbiguous =>
      l10n.tripPlannerPlannerGeocodeFromAmbiguous,
    tp.PlannerErrorCode.geocodeToAmbiguous =>
      l10n.tripPlannerPlannerGeocodeToAmbiguous,
    tp.PlannerErrorCode.geocodeFromToAmbiguous =>
      l10n.tripPlannerPlannerGeocodeFromToAmbiguous,
    tp.PlannerErrorCode.underspecifiedTriangle =>
      l10n.tripPlannerPlannerUnderspecifiedTriangle,
    tp.PlannerErrorCode.triangleNotAffine =>
      l10n.tripPlannerPlannerTriangleNotAffine,
    tp.PlannerErrorCode.triangleOptimizeTypeNotSet =>
      l10n.tripPlannerPlannerTriangleOptimizeTypeNotSet,
    tp.PlannerErrorCode.triangleValuesNotSet =>
      l10n.tripPlannerPlannerTriangleValuesNotSet,
    tp.PlannerErrorCode.unknown => l10n.tripPlannerErrorUnknown,
  };
}
