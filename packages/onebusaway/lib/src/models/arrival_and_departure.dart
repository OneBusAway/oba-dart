import '../core/errors.dart';
import '../core/json.dart';
import 'frequency.dart';
import 'trip_status.dart';

class ArrivalAndDeparture {
  const ArrivalAndDeparture({
    required this.routeId,
    required this.tripId,
    required this.serviceDate,
    required this.stopId,
    required this.stopSequence,
    this.totalStopsInTrip,
    this.blockTripSequence,
    this.routeShortName,
    this.routeLongName,
    this.tripHeadsign,
    this.scheduledArrivalTime,
    this.predictedArrivalTime,
    this.scheduledDepartureTime,
    this.predictedDepartureTime,
    this.predicted = false,
    this.arrivalEnabled = true,
    this.departureEnabled = true,
    this.vehicleId,
    this.numberOfStopsAway,
    this.distanceFromStop,
    this.status,
    this.frequency,
    this.tripStatus,
  });

  factory ArrivalAndDeparture.fromJson(JsonMap json) {
    final frequency = readOptMap(json, 'frequency');
    final tripStatus = readOptMap(json, 'tripStatus');
    return ArrivalAndDeparture(
      routeId: readString(json, 'routeId'),
      tripId: readString(json, 'tripId'),
      serviceDate:
          readEpochMs(json, 'serviceDate') ??
          (throw const ObaFormatException('Missing "serviceDate"')),
      stopId: readString(json, 'stopId'),
      stopSequence: readInt(json, 'stopSequence'),
      totalStopsInTrip: readOptInt(json, 'totalStopsInTrip'),
      blockTripSequence: readOptInt(json, 'blockTripSequence'),
      routeShortName: readOptString(json, 'routeShortName'),
      routeLongName: readOptString(json, 'routeLongName'),
      tripHeadsign: readOptString(json, 'tripHeadsign'),
      scheduledArrivalTime: readEpochMs(json, 'scheduledArrivalTime'),
      predictedArrivalTime: readEpochMs(json, 'predictedArrivalTime'),
      scheduledDepartureTime: readEpochMs(json, 'scheduledDepartureTime'),
      predictedDepartureTime: readEpochMs(json, 'predictedDepartureTime'),
      predicted: readBool(json, 'predicted'),
      arrivalEnabled: readBool(json, 'arrivalEnabled', defaultValue: true),
      departureEnabled: readBool(json, 'departureEnabled', defaultValue: true),
      vehicleId: readOptString(json, 'vehicleId'),
      numberOfStopsAway: readOptInt(json, 'numberOfStopsAway'),
      distanceFromStop: readOptDouble(json, 'distanceFromStop'),
      status: readOptString(json, 'status'),
      frequency: frequency == null ? null : Frequency.fromJson(frequency),
      tripStatus: tripStatus == null ? null : TripStatus.fromJson(tripStatus),
    );
  }

  final String routeId;
  final String tripId;
  final DateTime serviceDate;
  final String stopId;

  /// Zero-based index of this stop in the trip.
  final int stopSequence;
  final int? totalStopsInTrip;
  final int? blockTripSequence;
  final String? routeShortName;
  final String? routeLongName;
  final String? tripHeadsign;
  final DateTime? scheduledArrivalTime;
  final DateTime? predictedArrivalTime;
  final DateTime? scheduledDepartureTime;
  final DateTime? predictedDepartureTime;

  /// True when real-time data is available for this trip.
  final bool predicted;
  final bool arrivalEnabled;
  final bool departureEnabled;
  final String? vehicleId;
  final int? numberOfStopsAway;
  final double? distanceFromStop;
  final String? status;
  final Frequency? frequency;
  final TripStatus? tripStatus;
}
