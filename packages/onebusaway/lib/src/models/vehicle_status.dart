import '../core/json.dart';
import 'coordinate.dart';
import 'coordinate_json.dart';
import 'trip_status.dart';

/// Entry of `vehicle/{id}`.
class VehicleStatus {
  const VehicleStatus({
    required this.vehicleId,
    this.lastUpdateTime,
    this.lastLocationUpdateTime,
    this.location,
    this.tripId,
    this.phase,
    this.status,
    this.tripStatus,
  });

  factory VehicleStatus.fromJson(JsonMap json) {
    final tripStatus = readOptMap(json, 'tripStatus');
    return VehicleStatus(
      vehicleId: readString(json, 'vehicleId'),
      lastUpdateTime: readEpochMs(json, 'lastUpdateTime'),
      lastLocationUpdateTime: readEpochMs(json, 'lastLocationUpdateTime'),
      location: readOptCoordinate(json, 'location'),
      tripId: readOptString(json, 'tripId'),
      phase: readOptString(json, 'phase'),
      status: readOptString(json, 'status'),
      tripStatus: tripStatus == null ? null : TripStatus.fromJson(tripStatus),
    );
  }

  final String vehicleId;
  final DateTime? lastUpdateTime;

  /// Null when OBA sends 0 (no location report).
  final DateTime? lastLocationUpdateTime;
  final Coordinate? location;

  /// The vehicle's current trip; `""` becomes null.
  final String? tripId;
  final String? phase;
  final String? status;

  /// Null when the vehicle isn't serving a trip.
  final TripStatus? tripStatus;
}
