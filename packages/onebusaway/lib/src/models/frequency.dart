import '../core/errors.dart';
import '../core/json.dart';

class Frequency {
  const Frequency({
    required this.startTime,
    required this.endTime,
    required this.headway,
  });

  factory Frequency.fromJson(JsonMap json) => Frequency(
        startTime: _requireTime(json, 'startTime'),
        endTime: _requireTime(json, 'endTime'),
        headway: readInt(json, 'headway'),
      );

  static DateTime _requireTime(JsonMap json, String key) =>
      readEpochMs(json, key) ??
      (throw ObaFormatException('Missing "$key" in frequency'));

  final DateTime startTime;
  final DateTime endTime;

  /// Seconds between departures.
  final int headway;
}
