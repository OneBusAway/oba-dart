import '../core/transport.dart';
import '../models/coordinate.dart';
import '../models/problem_reports.dart';

/// `report-problem-with-stop/{id}` and `report-problem-with-trip`.
///
/// Both are GETs that return an empty `data`. They complete normally on
/// success and throw an `ObaException` otherwise.
class ProblemReportsResource {
  ProblemReportsResource(this._transport);

  final Transport _transport;

  Future<void> reportStop(
    String stopId, {
    required StopProblemCode code,
    String? comment,
    Coordinate? userLocation,
    double? userLocationAccuracy,
  }) async {
    await _transport.get(
      'report-problem-with-stop',
      id: stopId,
      params: {
        'code': code.wireValue,
        'userComment': ?comment,
        ..._location(userLocation, userLocationAccuracy),
      },
    );
  }

  /// [userOnVehicle] is whether the reporter is riding the vehicle.
  Future<void> reportTrip({
    required String tripId,
    required DateTime serviceDate,
    required TripProblemCode code,
    required bool userOnVehicle,
    String? vehicleId,
    String? stopId,
    String? comment,
    Coordinate? userLocation,
    double? userLocationAccuracy,
  }) async {
    await _transport.get(
      'report-problem-with-trip',
      params: {
        'tripId': tripId,
        'serviceDate': '${serviceDate.millisecondsSinceEpoch}',
        'code': code.wireValue,
        'userOnVehicle': '$userOnVehicle',
        'vehicleId': ?vehicleId,
        'stopId': ?stopId,
        'userComment': ?comment,
        ..._location(userLocation, userLocationAccuracy),
      },
    );
  }

  /// `userLat`/`userLon`, plus `userLocationAccuracy` (meters) when given.
  static Map<String, String> _location(Coordinate? at, double? accuracy) => {
    if (at != null) ...{
      'userLat': '${at.lat}',
      'userLon': '${at.lon}',
      if (accuracy != null) 'userLocationAccuracy': '$accuracy',
    },
  };
}
