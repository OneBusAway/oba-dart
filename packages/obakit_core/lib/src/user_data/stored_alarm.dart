import '../deep_links/trip_deep_link.dart';
import '../foundation/json.dart';

/// A locally recorded arrival alarm created on the Obaco server.
class StoredAlarm {
  const StoredAlarm({
    required this.url,
    this.tripDate,
    this.alarmDate,
    this.leadTimeMinutes,
    this.deepLink,
  });

  factory StoredAlarm.fromJson(JsonObject j) {
    final link = jObject(j, 'deepLink');
    return StoredAlarm(
      url: jUri(j, 'url') ?? (throw const FormatException('alarm url')),
      tripDate: jDate(j, 'tripDate'),
      alarmDate: jDate(j, 'alarmDate'),
      leadTimeMinutes: jInt(j, 'leadTimeMinutes'),
      deepLink: link == null ? null : TripDeepLink.fromJson(link),
    );
  }

  /// DELETE this to cancel the alarm; also its identity.
  final Uri url;

  /// When the vehicle is expected.
  final DateTime? tripDate;

  /// When the push fires.
  final DateTime? alarmDate;
  final int? leadTimeMinutes;

  /// The departure the alarm is for.
  final TripDeepLink? deepLink;

  /// Without a trip date an alarm can't be shown, so it counts as expired.
  bool isExpiredAt(DateTime now) => tripDate == null || tripDate!.isBefore(now);

  JsonObject toJson() => {
    'url': url.toString(),
    if (tripDate != null) 'tripDate': isoDate(tripDate!),
    if (alarmDate != null) 'alarmDate': isoDate(alarmDate!),
    'leadTimeMinutes': ?leadTimeMinutes,
    if (deepLink != null) 'deepLink': deepLink!.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is StoredAlarm &&
      other.url == url &&
      other.tripDate == tripDate &&
      other.alarmDate == alarmDate &&
      other.leadTimeMinutes == leadTimeMinutes &&
      other.deepLink == deepLink;

  @override
  int get hashCode =>
      Object.hash(url, tripDate, alarmDate, leadTimeMinutes, deepLink);
}
