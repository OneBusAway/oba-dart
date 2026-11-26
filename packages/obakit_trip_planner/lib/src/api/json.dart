// Tolerant JSON readers shared by the REST and GraphQL decoders. OTP servers
// differ in which optional fields they send and whether they send `null`,
// `""`, or omit a key, so every reader accepts all three.

import 'errors.dart';

typedef JsonMap = Map<String, dynamic>;

JsonMap asMap(Object? value, String field) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  throw OtpFormatException('Expected an object for "$field"');
}

JsonMap? asOptMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return null;
}

List<JsonMap> readMapList(JsonMap json, String key) {
  final value = json[key];
  if (value is! List) return const [];
  return [for (final item in value) ?asOptMap(item)];
}

double readDouble(JsonMap json, String key) {
  final value = json[key];
  if (value is num) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw OtpFormatException('Missing or invalid number "$key"');
}

double? readOptDouble(JsonMap json, String key) {
  final value = json[key];
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? readOptInt(JsonMap json, String key) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) return int.tryParse(value);
  return null;
}

int readInt(JsonMap json, String key) =>
    readOptInt(json, key) ??
    (throw OtpFormatException('Missing or invalid integer "$key"'));

bool? readOptBool(JsonMap json, String key) {
  final value = json[key];
  if (value is bool) return value;
  if (value is String) {
    if (value == 'true') return true;
    if (value == 'false') return false;
  }
  return null;
}

/// Returns null for absent, non-string, or blank values. OTP 1.x sends `""`
/// for the route of a walk leg, which should read as "no route".
String? readOptString(JsonMap json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) return value;
  return null;
}

/// Epoch milliseconds, the date encoding of both OTP API flavours.
DateTime readEpochMillis(JsonMap json, String key) {
  final millis = readOptInt(json, key);
  if (millis == null) {
    throw OtpFormatException('Missing or invalid timestamp "$key"');
  }
  return DateTime.fromMillisecondsSinceEpoch(millis);
}
