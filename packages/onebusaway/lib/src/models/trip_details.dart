import '../core/errors.dart';
import '../core/json.dart';
import 'frequency.dart';
import 'trip_status.dart';

/// Entry of `trip-details` and `trip-for-vehicle`.
class TripDetails {
  const TripDetails({
    required this.tripId,
    required this.serviceDate,
    this.frequency,
    this.status,
    this.schedule,
    this.situationIds = const [],
  });

  factory TripDetails.fromJson(JsonMap json) {
    final frequency = readOptMap(json, 'frequency');
    final status = readOptMap(json, 'status');
    final schedule = readOptMap(json, 'schedule');
    return TripDetails(
      tripId: readString(json, 'tripId'),
      serviceDate:
          readEpochMs(json, 'serviceDate') ??
          (throw const ObaFormatException('Missing "serviceDate"')),
      frequency: frequency == null ? null : Frequency.fromJson(frequency),
      status: status == null ? null : TripStatus.fromJson(status),
      schedule: schedule == null ? null : TripSchedule.fromJson(schedule),
      situationIds: readStringList(json, 'situationIds'),
    );
  }

  final String tripId;

  /// Midnight (agency time) of the service day, as an instant.
  final DateTime serviceDate;
  final Frequency? frequency;

  /// Null when the server has no real-time status (or wasn't asked for it).
  final TripStatus? status;

  /// Null when the server omits it, e.g. `trip-for-vehicle` by default.
  final TripSchedule? schedule;
  final List<String> situationIds;

  /// Shortcut for `schedule?.stopTimes ?? const []`.
  List<TripStopTime> get stopTimes => schedule?.stopTimes ?? const [];

  /// The instant [stopTime] arrives, on this trip's [serviceDate].
  DateTime arrivalDate(TripStopTime stopTime) =>
      stopTime.arrivalDate(serviceDate);

  /// The instant [stopTime] departs, on this trip's [serviceDate].
  DateTime departureDate(TripStopTime stopTime) =>
      stopTime.departureDate(serviceDate);
}

class TripSchedule {
  const TripSchedule({
    this.timeZone,
    this.stopTimes = const [],
    this.previousTripId,
    this.nextTripId,
    this.frequency,
  });

  factory TripSchedule.fromJson(JsonMap json) {
    final frequency = readOptMap(json, 'frequency');
    return TripSchedule(
      timeZone: readOptString(json, 'timeZone'),
      stopTimes: readObjectList(json, 'stopTimes', TripStopTime.fromJson),
      previousTripId: readOptString(json, 'previousTripId'),
      nextTripId: readOptString(json, 'nextTripId'),
      frequency: frequency == null ? null : Frequency.fromJson(frequency),
    );
  }

  final String? timeZone;
  final List<TripStopTime> stopTimes;

  /// The previous trip in the block; resolve with `References.trip`.
  final String? previousTripId;
  final String? nextTripId;
  final Frequency? frequency;
}

/// One stop of a trip's schedule.
class TripStopTime {
  const TripStopTime({
    required this.stopId,
    required this.arrivalTime,
    required this.departureTime,
    this.distanceAlongTrip,
    this.stopHeadsign,
  });

  factory TripStopTime.fromJson(JsonMap json) => TripStopTime(
    stopId: readString(json, 'stopId'),
    arrivalTime: readInt(json, 'arrivalTime'),
    departureTime: readInt(json, 'departureTime'),
    distanceAlongTrip: readOptDouble(json, 'distanceAlongTrip'),
    stopHeadsign: readOptString(json, 'stopHeadsign'),
  );

  final String stopId;

  /// Seconds after the service date (may exceed 24 h for late trips).
  final int arrivalTime;

  /// Seconds after the service date.
  final int departureTime;

  /// Meters.
  final double? distanceAlongTrip;
  final String? stopHeadsign;

  DateTime arrivalDate(DateTime serviceDate) =>
      serviceDate.add(Duration(seconds: arrivalTime));

  DateTime departureDate(DateTime serviceDate) =>
      serviceDate.add(Duration(seconds: departureTime));
}
