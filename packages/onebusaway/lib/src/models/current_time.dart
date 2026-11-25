import '../core/errors.dart';
import '../core/json.dart';

/// Entry of `current-time`.
class CurrentTime {
  const CurrentTime({required this.time, this.readableTime});

  factory CurrentTime.fromJson(JsonMap json) => CurrentTime(
    time:
        readEpochMs(json, 'time') ??
        (throw const ObaFormatException('Missing "time"')),
    readableTime: readOptString(json, 'readableTime'),
  );

  final DateTime time;

  /// ISO 8601 in the server's zone, e.g. `2012-07-29T11:37:48-07:00`.
  final String? readableTime;
}
