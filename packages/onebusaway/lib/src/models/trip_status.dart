import '../core/json.dart';

class TripStatus {
  const TripStatus({
    this.status,
    this.phase,
    this.predicted = false,
    this.scheduleDeviation = 0,
    this.vehicleId,
    this.activeTripId,
    this.serviceDate,
  });

  factory TripStatus.fromJson(JsonMap json) => TripStatus(
    status: readOptString(json, 'status'),
    phase: readOptString(json, 'phase'),
    predicted: readBool(json, 'predicted'),
    scheduleDeviation: readOptInt(json, 'scheduleDeviation') ?? 0,
    vehicleId: readOptString(json, 'vehicleId'),
    activeTripId: readOptString(json, 'activeTripId'),
    serviceDate: readEpochMs(json, 'serviceDate'),
  );

  /// e.g. `default` or `CANCELED`.
  final String? status;
  final String? phase;
  final bool predicted;

  /// Seconds; positive means late.
  final int scheduleDeviation;
  final String? vehicleId;
  final String? activeTripId;
  final DateTime? serviceDate;
}
