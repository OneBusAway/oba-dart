import '../core/errors.dart';
import '../core/json.dart';
import 'frequency.dart';
import 'trip_status.dart';

/// GTFS-realtime occupancy, as OBA sends it in `occupancyStatus` and
/// `historicalOccupancy`.
enum OccupancyStatus {
  unknown(''),
  empty('EMPTY'),
  manySeatsAvailable('MANY_SEATS_AVAILABLE'),
  fewSeatsAvailable('FEW_SEATS_AVAILABLE'),
  standingRoomOnly('STANDING_ROOM_ONLY'),
  crushedStandingRoomOnly('CRUSHED_STANDING_ROOM_ONLY'),
  full('FULL'),
  notAcceptingPassengers('NOT_ACCEPTING_PASSENGERS'),
  noDataAvailable('NO_DATA_AVAILABLE'),
  notBoardable('NOT_BOARDABLE');

  const OccupancyStatus(this.wireValue);

  final String wireValue;

  /// Null for a missing value; [unknown] for `""` or a value this client
  /// doesn't know.
  static OccupancyStatus? parse(String? value) {
    if (value == null) return null;
    return OccupancyStatus.values.firstWhere(
      (o) => o.wireValue == value,
      orElse: () => unknown,
    );
  }
}

/// Predicted times before 2001-01-01T00:00:01Z are sentinels for "no
/// prediction" (OBA sends 0), matching the iOS app.
const _earliestPlausibleMs = 978307201000;

DateTime? _readPrediction(JsonMap json, String key) {
  final time = readEpochMs(json, key);
  if (time == null || time.millisecondsSinceEpoch < _earliestPlausibleMs) {
    return null;
  }
  return time;
}

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
    this.situationIds = const [],
    this.lastUpdateTime,
    this.occupancyStatus,
    this.historicalOccupancyStatus,
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
      predictedArrivalTime: _readPrediction(json, 'predictedArrivalTime'),
      scheduledDepartureTime: readEpochMs(json, 'scheduledDepartureTime'),
      predictedDepartureTime: _readPrediction(json, 'predictedDepartureTime'),
      predicted: readBool(json, 'predicted'),
      arrivalEnabled: readBool(json, 'arrivalEnabled', defaultValue: true),
      departureEnabled: readBool(json, 'departureEnabled', defaultValue: true),
      vehicleId: readOptString(json, 'vehicleId'),
      numberOfStopsAway: readOptInt(json, 'numberOfStopsAway'),
      distanceFromStop: readOptDouble(json, 'distanceFromStop'),
      status: readOptString(json, 'status'),
      frequency: frequency == null ? null : Frequency.fromJson(frequency),
      tripStatus: tripStatus == null ? null : TripStatus.fromJson(tripStatus),
      situationIds: readStringList(json, 'situationIds'),
      lastUpdateTime: readEpochMs(json, 'lastUpdateTime'),
      occupancyStatus: OccupancyStatus.parse(
        json['occupancyStatus'] == null
            ? null
            : readString(json, 'occupancyStatus'),
      ),
      historicalOccupancyStatus: OccupancyStatus.parse(
        json['historicalOccupancy'] == null
            ? null
            : readString(json, 'historicalOccupancy'),
      ),
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

  /// Null when there is no prediction (OBA sends 0).
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

  /// Ids of service alerts for this arrival; resolve them with
  /// `References.situation`.
  final List<String> situationIds;

  /// When the real-time data was last updated; null when OBA sends 0.
  final DateTime? lastUpdateTime;

  /// Real-time occupancy, or null when the server sent none.
  final OccupancyStatus? occupancyStatus;

  /// Typical occupancy for this trip (`historicalOccupancy` on the wire).
  final OccupancyStatus? historicalOccupancyStatus;

  /// True for the first stop of the trip, where the vehicle departs rather
  /// than arrives.
  bool get isDeparture => stopSequence == 0;

  /// Whether this is the trip's last stop; null when the server didn't send
  /// [totalStopsInTrip].
  bool? get isLastStopOnTrip =>
      totalStopsInTrip == null ? null : stopSequence == totalStopsInTrip! - 1;
}
