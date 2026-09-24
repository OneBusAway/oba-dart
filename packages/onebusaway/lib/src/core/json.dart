import 'errors.dart';

typedef JsonMap = Map<String, Object?>;

Never _wrongType(String key, String expected, Object? value) =>
    throw ObaFormatException(
        'Expected $expected at "$key", got ${value.runtimeType}');

String readString(JsonMap json, String key) {
  final value = json[key];
  if (value is String) return value;
  _wrongType(key, 'string', value);
}

/// Reads an optional string. OBA servers send `""` for absent values
/// (e.g. `textColor`, `direction`), so empty strings become null.
String? readOptString(JsonMap json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
  _wrongType(key, 'string', value);
}

int readInt(JsonMap json, String key) {
  final value = json[key];
  if (value is num) return value.toInt();
  _wrongType(key, 'number', value);
}

int? readOptInt(JsonMap json, String key) =>
    json[key] == null ? null : readInt(json, key);

double? readOptDouble(JsonMap json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is num) return value.toDouble();
  _wrongType(key, 'number', value);
}

bool readBool(JsonMap json, String key, {bool defaultValue = false}) {
  final value = json[key];
  if (value == null) return defaultValue;
  if (value is bool) return value;
  _wrongType(key, 'bool', value);
}

JsonMap asJsonMap(Object? value, String context) {
  if (value is Map<String, Object?>) return value;
  _wrongType(context, 'object', value);
}

JsonMap readMap(JsonMap json, String key) => asJsonMap(json[key], key);

JsonMap? readOptMap(JsonMap json, String key) =>
    json[key] == null ? null : readMap(json, key);

List<T> readList<T>(JsonMap json, String key, T Function(Object? item) parse) {
  final value = json[key];
  if (value == null) return const [];
  if (value is List) return List.unmodifiable(value.map(parse));
  _wrongType(key, 'list', value);
}

List<String> readStringList(JsonMap json, String key) =>
    readList(json, key, (item) {
      if (item is String) return item;
      _wrongType(key, 'list of strings', item);
    });

/// Reads epoch milliseconds as a UTC [DateTime]. OBA uses 0 for "no value".
DateTime? readEpochMs(JsonMap json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! num) _wrongType(key, 'epoch milliseconds', value);
  if (value == 0) return null;
  return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
}
