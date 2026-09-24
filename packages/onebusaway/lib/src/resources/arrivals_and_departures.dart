import '../core/responses.dart';
import '../core/transport.dart';
import '../models/stop_with_arrivals_and_departures.dart';

/// `arrivals-and-departures-for-stop` and (later) related endpoints.
class ArrivalsAndDeparturesResource {
  ArrivalsAndDeparturesResource(this._transport);

  final Transport _transport;

  /// Real-time arrivals and departures for [stopId].
  ///
  /// [minutesBefore] / [minutesAfter] widen the window (server defaults 5 / 35).
  /// [time] queries the system as of that instant instead of "now".
  Future<ObaEntryResponse<StopWithArrivalsAndDepartures>> forStop(
    String stopId, {
    int? minutesBefore,
    int? minutesAfter,
    DateTime? time,
  }) async {
    final envelope = await _transport.get(
      'arrivals-and-departures-for-stop',
      id: stopId,
      params: {
        if (minutesBefore != null) 'minutesBefore': '$minutesBefore',
        if (minutesAfter != null) 'minutesAfter': '$minutesAfter',
        if (time != null) 'time': '${time.millisecondsSinceEpoch}',
      },
    );
    return envelope.toEntry(StopWithArrivalsAndDepartures.fromJson);
  }
}
