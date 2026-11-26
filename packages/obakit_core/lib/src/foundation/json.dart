/// Tolerant JSON readers for locally persisted data. Each returns the
/// fallback rather than throwing when a value is missing or the wrong type,
/// so older or hand-edited data degrades instead of crashing.
library;

typedef JsonObject = Map<String, Object?>;

String? jString(JsonObject j, String key) {
  final v = j[key];
  return v is String ? v : null;
}

int? jInt(JsonObject j, String key) {
  final v = j[key];
  if (v is int) return v;
  if (v is num && v.isFinite) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

double? jDouble(JsonObject j, String key) {
  final v = j[key];
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

bool? jBool(JsonObject j, String key) {
  final v = j[key];
  return v is bool ? v : null;
}

DateTime? jDate(JsonObject j, String key) {
  final v = j[key];
  if (v is String) return DateTime.tryParse(v);
  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v, isUtc: true);
  return null;
}

Uri? jUri(JsonObject j, String key) {
  final v = jString(j, key);
  return v == null || v.isEmpty ? null : Uri.tryParse(v);
}

List<String> jStringList(JsonObject j, String key) {
  final v = j[key];
  if (v is! List) return const [];
  return [
    for (final e in v)
      if (e is String) e,
  ];
}

JsonObject? jObject(JsonObject j, String key) {
  final v = j[key];
  return v is Map<String, Object?> ? v : null;
}

/// Maps each object in the list at [key] with [parse], skipping entries that
/// are not objects or that [parse] rejects by throwing.
List<T> jObjectList<T>(JsonObject j, String key, T Function(JsonObject) parse) {
  final v = j[key];
  if (v is! List) return const [];
  return parseObjects(v, parse);
}

List<T> parseObjects<T>(List<Object?> list, T Function(JsonObject) parse) {
  final out = <T>[];
  for (final e in list) {
    if (e is! Map<String, Object?>) continue;
    try {
      out.add(parse(e));
    } catch (_) {
      // Skip unreadable entries.
    }
  }
  return out;
}

String isoDate(DateTime d) => d.toUtc().toIso8601String();
