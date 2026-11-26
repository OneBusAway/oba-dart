import '../core/json.dart';
import 'coordinate.dart';
import 'coordinate_json.dart';
import 'frequency.dart';

/// The typed form of [TripStatus.status].
enum TripStatusModifier {
  defaultStatus,
  scheduled,
  canceled,

  /// Any other value; read [TripStatus.status] for the raw string.
  other,
}

/// Real-time status of a trip, as embedded in arrivals, trip details and
/// vehicle responses.
///
/// Stop and trip ids resolve through the response's `References`.
class TripStatus {
  const TripStatus({
    this.status,
    this.phase,
    this.predicted = false,
    this.scheduleDeviation = 0,
    this.vehicleId,
    this.activeTripId,
    this.serviceDate,
    this.blockTripSequence,
    this.closestStopId,
    this.closestStopTimeOffset,
    this.nextStopId,
    this.nextStopTimeOffset,
    this.distanceAlongTrip,
    this.scheduledDistanceAlongTrip,
    this.totalDistanceAlongTrip,
    this.lastKnownDistanceAlongTrip,
    this.position,
    this.orientation,
    this.lastKnownLocation,
    this.lastKnownOrientation,
    this.lastUpdateTime,
    this.lastLocationUpdateTime,
    this.frequency,
    this.situationIds = const [],
  });

  factory TripStatus.fromJson(JsonMap json) {
    final frequency = readOptMap(json, 'frequency');
    final lastKnownDistance = readOptDouble(json, 'lastKnownDistanceAlongTrip');
    return TripStatus(
      status: readOptString(json, 'status'),
      phase: readOptString(json, 'phase'),
      predicted: readBool(json, 'predicted'),
      scheduleDeviation: readOptInt(json, 'scheduleDeviation') ?? 0,
      vehicleId: readOptString(json, 'vehicleId'),
      activeTripId: readOptString(json, 'activeTripId'),
      serviceDate: readEpochMs(json, 'serviceDate'),
      blockTripSequence: readOptInt(json, 'blockTripSequence'),
      closestStopId: readOptString(json, 'closestStop'),
      closestStopTimeOffset: readOptInt(json, 'closestStopTimeOffset'),
      nextStopId: readOptString(json, 'nextStop'),
      nextStopTimeOffset: readOptInt(json, 'nextStopTimeOffset'),
      distanceAlongTrip: readOptDouble(json, 'distanceAlongTrip'),
      scheduledDistanceAlongTrip: readOptDouble(
        json,
        'scheduledDistanceAlongTrip',
      ),
      totalDistanceAlongTrip: readOptDouble(json, 'totalDistanceAlongTrip'),
      // OBA sends 0 when it has no last-known distance.
      lastKnownDistanceAlongTrip: lastKnownDistance == 0
          ? null
          : lastKnownDistance,
      position: readOptCoordinate(json, 'position'),
      orientation: readOptDouble(json, 'orientation'),
      lastKnownLocation: readOptCoordinate(json, 'lastKnownLocation'),
      lastKnownOrientation: readOptDouble(json, 'lastKnownOrientation'),
      lastUpdateTime: readEpochMs(json, 'lastUpdateTime'),
      lastLocationUpdateTime: readEpochMs(json, 'lastLocationUpdateTime'),
      frequency: frequency == null ? null : Frequency.fromJson(frequency),
      situationIds: readStringList(json, 'situationIds'),
    );
  }

  /// e.g. `default`, `SCHEDULED` or `CANCELED`. See [statusModifier].
  final String? status;

  /// e.g. `in_progress`; `""` becomes null.
  final String? phase;

  /// True when the status comes from real-time data.
  final bool predicted;

  /// Seconds; positive means late.
  final int scheduleDeviation;
  final String? vehicleId;
  final String? activeTripId;
  final DateTime? serviceDate;

  /// Index of the active trip within its block.
  final int? blockTripSequence;
  final String? closestStopId;

  /// Seconds between the vehicle's schedule time and the closest stop's;
  /// negative means the stop is behind the vehicle.
  final int? closestStopTimeOffset;
  final String? nextStopId;

  /// Seconds until the next stop, by schedule.
  final int? nextStopTimeOffset;

  /// Meters.
  final double? distanceAlongTrip;
  final double? scheduledDistanceAlongTrip;
  final double? totalDistanceAlongTrip;

  /// Meters; OBA's `0` ("unknown") becomes null.
  final double? lastKnownDistanceAlongTrip;

  /// Best estimate of the vehicle's position (may be interpolated).
  final Coordinate? position;

  /// Degrees, counter-clockwise from east (OBA convention).
  final double? orientation;

  /// The last position the vehicle reported.
  final Coordinate? lastKnownLocation;
  final double? lastKnownOrientation;
  final DateTime? lastUpdateTime;

  /// When the vehicle last reported a location; OBA's `0` becomes null.
  final DateTime? lastLocationUpdateTime;
  final Frequency? frequency;
  final List<String> situationIds;

  /// [status] parsed case-insensitively.
  TripStatusModifier get statusModifier => switch (status?.toUpperCase()) {
    'DEFAULT' => TripStatusModifier.defaultStatus,
    'SCHEDULED' => TripStatusModifier.scheduled,
    'CANCELED' => TripStatusModifier.canceled,
    _ => TripStatusModifier.other,
  };
}
