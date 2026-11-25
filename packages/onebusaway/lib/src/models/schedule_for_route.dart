import '../core/json.dart';

/// Entry of `schedule-for-route/{id}`.
class ScheduleForRoute {
  const ScheduleForRoute({
    required this.routeId,
    required this.scheduleDate,
    this.serviceIds = const [],
    this.stopTripGroupings = const [],
  });

  factory ScheduleForRoute.fromJson(JsonMap json) => ScheduleForRoute(
    routeId: readString(json, 'routeId'),
    scheduleDate: readRequiredEpochMs(json, 'scheduleDate'),
    serviceIds: readStringList(json, 'serviceIds'),
    stopTripGroupings: readObjectList(
      json,
      'stopTripGroupings',
      StopTripGrouping.fromJson,
    ),
  );

  final String routeId;

  /// The day the schedule is for, as an instant (agency midnight).
  final DateTime scheduleDate;
  final List<String> serviceIds;
  final List<StopTripGrouping> stopTripGroupings;
}

/// The trips of one direction of the route.
class StopTripGrouping {
  const StopTripGrouping({
    this.directionId,
    this.stopIds = const [],
    this.tripHeadsigns = const [],
    this.tripIds = const [],
    this.tripsWithStopTimes = const [],
  });

  factory StopTripGrouping.fromJson(JsonMap json) => StopTripGrouping(
    directionId: readOptString(json, 'directionId'),
    stopIds: readStringList(json, 'stopIds'),
    tripHeadsigns: readStringList(json, 'tripHeadsigns'),
    tripIds: readStringList(json, 'tripIds'),
    tripsWithStopTimes: readObjectList(
      json,
      'tripsWithStopTimes',
      TripWithStopTimes.fromJson,
    ),
  );

  final String? directionId;
  final List<String> stopIds;
  final List<String> tripHeadsigns;
  final List<String> tripIds;
  final List<TripWithStopTimes> tripsWithStopTimes;
}

class TripWithStopTimes {
  const TripWithStopTimes({required this.tripId, this.stopTimes = const []});

  factory TripWithStopTimes.fromJson(JsonMap json) => TripWithStopTimes(
    tripId: readString(json, 'tripId'),
    stopTimes: readObjectList(
      json,
      'stopTimes',
      RouteScheduleStopTime.fromJson,
    ),
  );

  final String tripId;
  final List<RouteScheduleStopTime> stopTimes;
}

/// A stop time in a route schedule. Unlike `schedule-for-stop`
/// entries, times here are **seconds since midnight** of the schedule date in
/// the agency's time zone, not epoch values.
class RouteScheduleStopTime {
  const RouteScheduleStopTime({
    required this.stopId,
    required this.tripId,
    required this.arrivalTime,
    required this.departureTime,
    this.arrivalEnabled = true,
    this.departureEnabled = true,
    this.serviceId,
    this.stopHeadsign,
  });

  factory RouteScheduleStopTime.fromJson(JsonMap json) => RouteScheduleStopTime(
    stopId: readString(json, 'stopId'),
    tripId: readString(json, 'tripId'),
    arrivalTime: readInt(json, 'arrivalTime'),
    departureTime: readInt(json, 'departureTime'),
    arrivalEnabled: readBool(json, 'arrivalEnabled', defaultValue: true),
    departureEnabled: readBool(json, 'departureEnabled', defaultValue: true),
    serviceId: readOptString(json, 'serviceId'),
    stopHeadsign: readOptString(json, 'stopHeadsign'),
  );

  final String stopId;
  final String tripId;

  /// Seconds since agency-local midnight; may exceed 86400.
  final int arrivalTime;
  final int departureTime;
  final bool arrivalEnabled;
  final bool departureEnabled;
  final String? serviceId;
  final String? stopHeadsign;
}
