import '../core/errors.dart';
import '../core/responses.dart';
import '../core/transport.dart';
import '../models/arrival_and_departure.dart';
import '../models/stop.dart';
import '../models/stop_with_arrivals_and_departures.dart';

/// `arrivals-and-departures-for-stop` and `arrival-and-departure-for-stop`.
class ArrivalsAndDeparturesResource {
  ArrivalsAndDeparturesResource(this._transport);

  final Transport _transport;

  /// Real-time arrivals and departures for [stopId].
  ///
  /// [minutesBefore] / [minutesAfter] widen the window (server defaults 5 / 35).
  /// [time] queries the system as of that instant instead of "now".
  ///
  /// Java OBA servers answer `null` for a stop with no service today. When
  /// that happens this method fetches `stop/{stopId}`: if the stop exists, it
  /// returns an entry with no arrivals and the stop in `references`; if the
  /// stop is missing (a `null` body, an HTTP 404 or an envelope 404), it
  /// throws the original `ObaApiException(emptyResponse, isNullBody: true)`.
  /// Any other failure of the stop request is thrown as is.
  Future<ObaEntryResponse<StopWithArrivalsAndDepartures>> forStop(
    String stopId, {
    int? minutesBefore,
    int? minutesAfter,
    DateTime? time,
  }) async {
    final ObaEnvelope envelope;
    try {
      envelope = await _transport.get(
        'arrivals-and-departures-for-stop',
        id: stopId,
        params: {
          if (minutesBefore != null) 'minutesBefore': '$minutesBefore',
          if (minutesAfter != null) 'minutesAfter': '$minutesAfter',
          if (time != null) 'time': '${time.millisecondsSinceEpoch}',
        },
      );
    } on ObaApiException catch (e) {
      if (!e.isNullBody) rethrow;
      return _noServiceArrivals(stopId, e);
    }
    return envelope.toEntry(StopWithArrivalsAndDepartures.fromJson);
  }

  Future<ObaEntryResponse<StopWithArrivalsAndDepartures>> _noServiceArrivals(
    String stopId,
    ObaApiException nullBodyError,
  ) async {
    final ObaEnvelope stopEnvelope;
    try {
      stopEnvelope = await _transport.get('stop', id: stopId);
    } on ObaApiException catch (e) {
      final missing =
          e.isNullBody ||
          (e.kind != ObaApiErrorKind.emptyResponse && e.code == 404);
      if (missing) throw nullBodyError;
      rethrow;
    }
    if (stopEnvelope.data['entry'] == null) throw nullBodyError;
    final stop = stopEnvelope.toEntry(Stop.fromJson);
    return ObaEntryResponse(
      entry: StopWithArrivalsAndDepartures(stopId: stop.entry.id),
      references: stop.references.withStop(stop.entry),
      currentTime: stop.currentTime,
      version: stop.version,
    );
  }

  /// One trip's arrival at [stopId] (`arrival-and-departure-for-stop`).
  ///
  /// [stopSequence] disambiguates loop trips that visit the stop twice; it is
  /// sent only when greater than 0.
  Future<ObaEntryResponse<ArrivalAndDeparture>> forTripAtStop(
    String stopId, {
    required String tripId,
    required DateTime serviceDate,
    String? vehicleId,
    int stopSequence = 0,
  }) async {
    final envelope = await _transport.get(
      'arrival-and-departure-for-stop',
      id: stopId,
      params: {
        'tripId': tripId,
        'serviceDate': '${serviceDate.millisecondsSinceEpoch}',
        'vehicleId': ?vehicleId,
        if (stopSequence > 0) 'stopSequence': '$stopSequence',
      },
    );
    return envelope.toEntry(ArrivalAndDeparture.fromJson);
  }
}
