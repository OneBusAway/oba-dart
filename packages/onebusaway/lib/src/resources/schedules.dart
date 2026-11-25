import '../core/responses.dart';
import '../core/transport.dart';
import '../models/schedule_for_route.dart';
import '../models/schedule_for_stop.dart';

/// `schedule-for-stop/{id}` and `schedule-for-route/{id}`.
class SchedulesResource {
  SchedulesResource(this._transport);

  final Transport _transport;

  /// The full day's schedule at a stop. [date] defaults to the server's
  /// today; only its year, month and day are sent (`yyyy-MM-dd`), read in
  /// whatever zone the `DateTime` is in.
  Future<ObaEntryResponse<ScheduleForStop>> forStop(
    String stopId, {
    DateTime? date,
  }) async {
    final envelope = await _transport.get(
      'schedule-for-stop',
      id: stopId,
      params: {if (date != null) 'date': formatServiceDate(date)},
    );
    return envelope.toEntry(ScheduleForStop.fromJson);
  }

  /// The full day's schedule of a route. See [forStop] for [date].
  Future<ObaEntryResponse<ScheduleForRoute>> forRoute(
    String routeId, {
    DateTime? date,
  }) async {
    final envelope = await _transport.get(
      'schedule-for-route',
      id: routeId,
      params: {if (date != null) 'date': formatServiceDate(date)},
    );
    return envelope.toEntry(ScheduleForRoute.fromJson);
  }

  /// `yyyy-MM-dd` from [date]'s own calendar fields.
  static String formatServiceDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-'
        '${two(date.month)}-${two(date.day)}';
  }
}
