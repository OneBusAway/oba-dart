import 'package:onebusaway/onebusaway.dart';

import '../platform/analytics.dart';
import '../platform/location.dart';

class ProblemReportUnavailableException implements Exception {
  const ProblemReportUnavailableException(this.reason);

  final String reason;

  @override
  String toString() => 'ProblemReportUnavailableException: $reason';
}

/// Sends stop, trip and ghost-bus problem reports, attaching the user's
/// location when known, and logs an analytics event for each.
class ProblemReportService {
  ProblemReportService({
    required this._client,
    ObacoClient? Function()? obaco,
    ObaLocation? Function()? currentLocation,
    String Function()? userId,
    this.analytics,
  }) : _obaco = obaco ?? (() => null),
       _location = currentLocation ?? (() => null),
       _userId = userId ?? (() => '');

  final OneBusAwayClient? Function() _client;
  final ObacoClient? Function() _obaco;
  final ObaLocation? Function() _location;
  final String Function() _userId;
  final ObaAnalytics? analytics;

  /// Ghost-bus reports need the region's Obaco server.
  bool get canReportGhostBus => _obaco() != null;

  OneBusAwayClient _requireClient() =>
      _client() ??
      (throw const ProblemReportUnavailableException('No region selected'));

  /// Reports a problem with [stopId]. The user's location is attached
  /// when known and [includeLocation] is true (the form's "Share location"
  /// switch).
  Future<void> reportStopProblem(
    String stopId, {
    required StopProblemCode code,
    String? comment,
    bool includeLocation = true,
  }) async {
    final location = includeLocation ? _location() : null;
    await _requireClient().problemReports.reportStop(
      stopId,
      code: code,
      comment: _clean(comment),
      userLocation: location?.coordinate,
      userLocationAccuracy: location?.accuracy,
    );
    _log('stop:${code.wireValue}');
  }

  /// Reports a problem with the trip of [arrival]. [vehicleId] overrides
  /// the arrival's (the rider may type the number painted on the bus).
  Future<void> reportTripProblem(
    ArrivalAndDeparture arrival, {
    required TripProblemCode code,
    required bool userOnVehicle,
    String? comment,
    String? vehicleId,
    bool includeLocation = true,
  }) => reportTripProblemFor(
    tripId: arrival.tripId,
    serviceDate: arrival.serviceDate,
    code: code,
    userOnVehicle: userOnVehicle,
    vehicleId: _clean(vehicleId) ?? arrival.vehicleId,
    stopId: arrival.stopId,
    comment: comment,
    includeLocation: includeLocation,
  );

  /// Reports a problem with a trip known only by id and service date (a
  /// trip page opened without an arrival).
  Future<void> reportTripProblemFor({
    required String tripId,
    required DateTime serviceDate,
    required TripProblemCode code,
    required bool userOnVehicle,
    String? vehicleId,
    String? stopId,
    String? comment,
    bool includeLocation = true,
  }) async {
    final location = includeLocation ? _location() : null;
    await _requireClient().problemReports.reportTrip(
      tripId: tripId,
      serviceDate: serviceDate,
      code: code,
      userOnVehicle: userOnVehicle,
      vehicleId: _clean(vehicleId),
      stopId: stopId,
      comment: _clean(comment),
      userLocation: location?.coordinate,
      userLocationAccuracy: location?.accuracy,
    );
    _log('trip:${code.wireValue}');
  }

  /// Reports a vehicle that never came, with the arrival's prediction
  /// details, to the Obaco server.
  Future<GhostBusReport> reportGhostBus(
    ArrivalAndDeparture arrival, {
    int waitDurationMinutes = 15,
    String? comment,
    bool includeLocation = true,
  }) async {
    final obaco =
        _obaco() ??
        (throw const ProblemReportUnavailableException(
          'The region has no Obaco server',
        ));
    final location = includeLocation ? _location() : null;
    final scheduled = arrival.scheduledArrivalTime;
    final predicted = arrival.predictedArrivalTime;
    final report = await obaco.postGhostBusReport(
      GhostBusReportDraft(
        tripId: arrival.tripId,
        serviceDate: arrival.serviceDate,
        waitDurationMinutes: waitDurationMinutes,
        routeId: arrival.routeId,
        stopId: arrival.stopId,
        vehicleId: arrival.vehicleId,
        stopSequence: arrival.stopSequence,
        predicted: arrival.predicted,
        scheduledArrivalAt: scheduled,
        predictedArrivalAt: predicted,
        scheduleDeviationMinutes: scheduled != null && predicted != null
            ? predicted.difference(scheduled).inMinutes
            : null,
        predictionLastUpdatedAt: arrival.lastUpdateTime,
        comment: _clean(comment),
        userLatitude: location?.lat,
        userLongitude: location?.lon,
      ),
      userId: _userId(),
    );
    _log('ghost_bus');
    return report;
  }

  static String? _clean(String? s) {
    final t = s?.trim();
    return t == null || t.isEmpty ? null : t;
  }

  void _log(String value) => analytics?.reportEvent(
    pageUrl: 'app://localhost/report_problem',
    label: AnalyticsLabels.reportProblem,
    value: value,
  );
}
