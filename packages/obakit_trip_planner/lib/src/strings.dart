import 'api/api.dart';
import 'display/formatting.dart';
import 'display/itinerary_display.dart';
import 'trip_planner_controller.dart';

/// Every user-facing string in the trip planner. Subclass and override to
/// localize. Wording follows OTPKit's English strings where they exist.
class TripPlannerStrings {
  const TripPlannerStrings();

  // Form.
  String get originLabel => 'From';
  String get destinationLabel => 'To';
  String get chooseOrigin => 'Choose starting point';
  String get chooseDestination => 'Choose destination';
  String get currentLocation => 'Current Location';
  String get swapEndpoints => 'Swap starting point and destination';
  String get planTrip => 'Plan trip';
  String get planningTrip => 'Planning your trip';
  String get options => 'Trip options';

  String timeOption(TripTimeOption option) => switch (option) {
    TripTimeOption.leaveNow => 'Leave now',
    TripTimeOption.departAt => 'Depart at',
    TripTimeOption.arriveBy => 'Arrive by',
  };

  /// [dateTime] is e.g. `Wed, Nov 25, 9:00 AM`.
  String changeTime(String dateTime) => 'Change time, $dateTime';

  String transportMode(TransportMode mode) => switch (mode) {
    TransportMode.transit => 'Transit',
    TransportMode.walk => 'Walk',
    TransportMode.bike => 'Bike',
    TransportMode.car => 'Car',
    TransportMode.bikeRental => 'Bikeshare Only',
    TransportMode.transitBikeRental => 'Transit + Bikeshare',
  };

  String get wheelchairAccessible => 'Wheelchair accessible';

  String walkingDistance(WalkingDistance distance) => switch (distance) {
    WalkingDistance.quarterMile => '0.25 mile',
    WalkingDistance.halfMile => '0.5 mile',
    WalkingDistance.oneMile => '1 mile',
    WalkingDistance.twoMiles => '2 miles',
  };

  String maxWalk(String distance) => 'Walk up to $distance';

  // Results.
  String get noTripsFound => 'No trips found';
  String get retry => 'Retry';
  String get realTime => 'Real-time';

  String duration(int seconds) {
    final parts = durationParts(seconds);
    if (parts.hours == 0) return '${parts.minutes} min';
    if (parts.minutes == 0) return '${parts.hours} hr';
    return '${parts.hours} hr ${parts.minutes} min';
  }

  String distance(double meters, DistanceUnits units) {
    final parts = distanceParts(meters, units);
    final value = formatNumber(parts.value);
    return switch (parts.unit) {
      DistanceUnit.feet => '$value ft',
      DistanceUnit.miles => '$value mi',
      DistanceUnit.meters => '$value m',
      DistanceUnit.kilometers => '$value km',
    };
  }

  String timeRange(String start, String end) => '$start – $end';

  String transfers(int count) => switch (count) {
    0 => 'No transfers',
    1 => '1 transfer',
    _ => '$count transfers',
  };

  String walkDistance(String distance) => 'Walk $distance';
  String fare(String amount) => amount;
  String departsAt(String time, String place) => 'Departs $time from $place';

  String realTimeStatus(RealTimeStatus status) => switch (status) {
    OnTimeStatus() => 'On time',
    LateStatus(:final minutes) => '$minutes min late',
    EarlyStatus(:final minutes) => '$minutes min early',
    ScheduledStatus() => 'Scheduled',
  };

  String legMode(LegMode mode) => switch (mode) {
    LegMode.walk => 'Walk',
    LegMode.bicycle => 'Bike',
    LegMode.car => 'Car',
    LegMode.transit => 'Transit',
    LegMode.bus => 'Bus',
    LegMode.tram => 'Tram',
    LegMode.subway => 'Subway',
    LegMode.rail => 'Train',
    LegMode.ferry => 'Ferry',
    LegMode.cableCar => 'Cable Car',
    LegMode.gondola => 'Gondola',
    LegMode.funicular => 'Funicular',
    LegMode.airplane => 'Plane',
    LegMode.trolleybus => 'Trolleybus',
    LegMode.monorail => 'Monorail',
  };

  /// The mode name for [leg], humanizing unknown tokens.
  String legModeName(Leg leg) {
    final mode = leg.legMode;
    return mode == null ? humanizeOtpToken(leg.mode) : legMode(mode);
  }

  // Accessibility.
  String itinerarySemantics({
    required String timeRange,
    required String duration,
    required String legs,
    required String details,
  }) => '$timeRange, $duration. $legs. $details';

  /// Spoken summary of one leg, e.g. `Walk 5 minutes`,
  /// `Tram Blue, 32 minutes`.
  String legChipSemantics(LegSummaryItem item) {
    final duration = durationSemantics(item.durationSeconds);
    return switch (item.kind) {
      LegKind.walk => 'Walk $duration',
      LegKind.bike => 'Bike $duration',
      LegKind.rentalBike => 'Rental bike $duration',
      LegKind.car => 'Drive $duration',
      LegKind.transit =>
        '${[legModeName(item.leg), ?item.routeName].join(' ')}, $duration',
    };
  }

  String get then => 'then';
  String get openItineraryHint => 'show trip details';

  /// [duration] for screen readers: `41 minutes`, `1 hour 5 minutes`.
  String durationSemantics(int seconds) {
    final parts = durationParts(seconds);
    String unit(int n, String one, String many) =>
        n == 1 ? '1 $one' : '$n $many';
    if (parts.hours == 0) return unit(parts.minutes, 'minute', 'minutes');
    final hours = unit(parts.hours, 'hour', 'hours');
    if (parts.minutes == 0) return hours;
    return '$hours ${unit(parts.minutes, 'minute', 'minutes')}';
  }

  /// [distance] for screen readers: `610 feet`, `1.5 miles`.
  String distanceSemantics(double meters, DistanceUnits units) {
    final parts = distanceParts(meters, units);
    final value = formatNumber(parts.value);
    final one = parts.value == 1;
    return switch (parts.unit) {
      DistanceUnit.feet => one ? '1 foot' : '$value feet',
      DistanceUnit.miles => one ? '1 mile' : '$value miles',
      DistanceUnit.meters => one ? '1 meter' : '$value meters',
      DistanceUnit.kilometers => one ? '1 kilometer' : '$value kilometers',
    };
  }

  /// [timeRange] for screen readers: `9:04 AM to 9:46 AM`.
  String timeRangeSemantics(String start, String end) => '$start to $end';

  /// [realTimeStatus] for screen readers, with real-time vs scheduled made
  /// explicit: `real-time, 2 minutes late`, `scheduled time`.
  String realTimeStatusSemantics(RealTimeStatus status) => switch (status) {
    OnTimeStatus() => 'real-time, on time',
    LateStatus(:final minutes) =>
      minutes == 1
          ? 'real-time, 1 minute late'
          : 'real-time, $minutes minutes late',
    EarlyStatus(:final minutes) =>
      minutes == 1
          ? 'real-time, 1 minute early'
          : 'real-time, $minutes minutes early',
    ScheduledStatus() => 'scheduled time',
  };

  /// Heading above the results list.
  String get resultsHeading => 'Suggested trips';

  /// Announced when a plan finishes.
  String tripsFound(int count) =>
      count == 1 ? '1 trip found' : '$count trips found';

  /// Announced when a place search finishes.
  String placesFound(int count) =>
      count == 1 ? '1 place found' : '$count places found';

  /// The map's screen-reader label. The steps below the map are its text
  /// alternative.
  String get mapSemanticsLabel =>
      '$mapLabel. The directions below describe the same trip.';

  // Detail.
  String get tripDetails => 'Trip details';
  String get mapLabel => 'Map of the trip';
  String get start => 'Start';
  String get destination => 'Destination';
  String get unnamedPlace => 'Unnamed location';
  String get rentalBike => 'Rental bike';

  String walkTo(String place) => 'Walk to $place';
  String bikeTo(String place) => 'Bike to $place';
  String rideRentalBikeTo(String place) => 'Ride rental bike to $place';
  String driveTo(String place) => 'Drive to $place';

  /// e.g. `Take Bus 30 toward Old Town`.
  String board(String mode, String? route, String? headsign) {
    final vehicle = route == null ? mode : '$mode $route';
    return headsign == null
        ? 'Take $vehicle'
        : 'Take $vehicle toward $headsign';
  }

  String getOffAt(String place) => 'Get off at $place';
  String arriveAt(String place) => 'Arrive at $place';
  String stopCount(int count) => count == 1 ? '1 stop' : '$count stops';
  String showStops(int count) => 'Show ${stopCount(count)}';
  String hideStops(int count) => 'Hide ${stopCount(count)}';
  String stepCount(int count) => count == 1 ? '1 step' : '$count steps';
  String showSteps(int count) => 'Show ${stepCount(count)}';
  String hideSteps(int count) => 'Hide ${stepCount(count)}';
  String legDistanceDuration(String distance, String duration) =>
      '$distance, about $duration';

  String relativeDirection(RelativeDirection direction) => switch (direction) {
    RelativeDirection.depart => 'Head out',
    RelativeDirection.hardLeft => 'Turn sharp left',
    RelativeDirection.left => 'Turn left',
    RelativeDirection.slightlyLeft => 'Bear left',
    RelativeDirection.continueStraight => 'Continue',
    RelativeDirection.slightlyRight => 'Bear right',
    RelativeDirection.right => 'Turn right',
    RelativeDirection.hardRight => 'Turn sharp right',
    RelativeDirection.circleClockwise => 'Enter the roundabout clockwise',
    RelativeDirection.circleCounterclockwise =>
      'Enter the roundabout counterclockwise',
    RelativeDirection.elevator => 'Take the elevator',
    RelativeDirection.uturnLeft => 'Make a U-turn to the left',
    RelativeDirection.uturnRight => 'Make a U-turn to the right',
    RelativeDirection.enterStation => 'Enter the station',
    RelativeDirection.exitStation => 'Exit the station',
    RelativeDirection.followSigns => 'Follow the signs',
  };

  /// e.g. `Turn right onto Pine St, walk 610 ft.`
  String stepInstruction(LegStep step, DistanceUnits units) {
    final distance = this.distance(step.distance, units);
    final street = step.streetName.isEmpty ? unnamedPlace : step.streetName;
    final token = step.relativeDirection;
    if (token == null) return 'Walk along $street for $distance.';
    final known = RelativeDirection.fromOtp(token);
    final direction = known == null
        ? humanizeOtpToken(token)
        : relativeDirection(known);
    return '$direction onto $street, walk $distance.';
  }

  /// The rider-facing name of [place].
  String placeName(Place place) {
    if (!isPlaceholderPlaceName(place)) return place.name.trim();
    return place.bikeShareId != null ? rentalBike : unnamedPlace;
  }

  // Place search.
  String get searchHint => 'Search for a place';
  String get searchNoResults => 'No places found';
  String get searchError => "Couldn't search for places. Try again.";
  String get useCurrentLocation => 'Use current location';
  String get locationUnavailable => "Couldn't get your location.";
  String get clearSearch => 'Clear search';

  /// Visible label of the place search field.
  String get searchLabel => searchHint;

  // Errors.
  String errorMessage(Object error) => switch (error) {
    MissingTripEndpointsError() =>
      'Please select both origin and destination locations.',
    OtpPlannerException(:final code) => plannerError(code),
    OtpNetworkException() =>
      "Couldn't reach the trip planner. Check your connection.",
    OtpHttpException() ||
    OtpFormatException() ||
    OtpGraphQLException() => 'Server returned invalid response',
    _ => 'An unknown error occurred.',
  };

  String plannerError(PlannerErrorCode code) => switch (code) {
    PlannerErrorCode.systemError =>
      'We couldn’t plan your trip right now. Please try again.',
    PlannerErrorCode.graphUnavailable =>
      'Trip planning is temporarily unavailable. Try again shortly.',
    PlannerErrorCode.outsideBounds => 'This location isn’t supported yet.',
    PlannerErrorCode.pathNotFound => 'No route is available for this trip.',
    PlannerErrorCode.noTransitTimes =>
      'No transit options are available right now.',
    PlannerErrorCode.requestTimeout =>
      'This took longer than expected. Please try again.',
    PlannerErrorCode.bogusParameter =>
      'Something went wrong with the request. Please try again.',
    PlannerErrorCode.geocodeFromNotFound =>
      'We couldn’t find the starting location.',
    PlannerErrorCode.geocodeToNotFound => 'We couldn’t find the destination.',
    PlannerErrorCode.geocodeFromToNotFound =>
      'We couldn’t find either the starting point or the destination.',
    PlannerErrorCode.tooClose => 'The start and destination are too close.',
    PlannerErrorCode.locationNotAccessible =>
      'This route isn’t accessible with the selected option.',
    PlannerErrorCode.geocodeFromAmbiguous =>
      'The starting location isn’t clear. Try being more specific.',
    PlannerErrorCode.geocodeToAmbiguous =>
      'The destination isn’t clear. Try being more specific.',
    PlannerErrorCode.geocodeFromToAmbiguous =>
      'Both locations need more detail. Try refining them.',
    PlannerErrorCode.underspecifiedTriangle =>
      'Some route options are missing.',
    PlannerErrorCode.triangleNotAffine =>
      'The selected route options don’t work together.',
    PlannerErrorCode.triangleOptimizeTypeNotSet =>
      'Please choose a route preference.',
    PlannerErrorCode.triangleValuesNotSet =>
      'Please adjust the route preferences.',
    PlannerErrorCode.unknown => 'An unknown error occurred.',
  };
}
