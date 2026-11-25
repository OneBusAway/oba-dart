import '../core/responses.dart';
import '../core/transport.dart';
import '../models/trip_details.dart';
import '../models/vehicle_status.dart';

/// `trip-details/{id}` and `trip-for-vehicle/{id}`.
class TripsResource {
  TripsResource(this._transport);

  final Transport _transport;

  /// Schedule and real-time status of a trip. Pass [serviceDate] (and
  /// [vehicleId] when known) to pick a specific instance of the trip.
  Future<ObaEntryResponse<TripDetails>> details(
    String tripId, {
    DateTime? serviceDate,
    String? vehicleId,
  }) async {
    final envelope = await _transport.get(
      'trip-details',
      id: tripId,
      params: {
        if (serviceDate != null)
          'serviceDate': '${serviceDate.millisecondsSinceEpoch}',
        'vehicleId': ?vehicleId,
      },
    );
    return envelope.toEntry(TripDetails.fromJson);
  }

  /// The trip a vehicle is currently serving.
  Future<ObaEntryResponse<TripDetails>> forVehicle(String vehicleId) async =>
      (await _transport.get(
        'trip-for-vehicle',
        id: vehicleId,
      )).toEntry(TripDetails.fromJson);
}

/// `vehicle/{id}`.
class VehiclesResource {
  VehiclesResource(this._transport);

  final Transport _transport;

  /// A vehicle's status. Vehicle ids are agency-prefixed (`1_1234`) and
  /// seldom match the number painted on the bus.
  Future<ObaEntryResponse<VehicleStatus>> byId(String vehicleId) async =>
      (await _transport.get(
        'vehicle',
        id: vehicleId,
      )).toEntry(VehicleStatus.fromJson);
}
