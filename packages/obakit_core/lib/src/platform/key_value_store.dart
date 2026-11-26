import 'dart:async';
import 'dart:convert';

/// String key/value persistence (`UserDefaults` on iOS). A host implements
/// it over `shared_preferences` or similar.
///
/// Contract: [load] is awaited once before any read. After that, reads are
/// synchronous and must reflect every earlier [setString]/[remove] at once
/// (keep an in-memory copy); the returned futures only report when the
/// write reached disk. obakit_core stores JSON strings under keys that start
/// with `oba.`.
abstract interface class KeyValueStore {
  Future<void> load();
  String? getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
  Iterable<String> get keys;
}

/// A [KeyValueStore] kept in memory. For tests, and for hosts that do not
/// want persistence.
class InMemoryKeyValueStore implements KeyValueStore {
  InMemoryKeyValueStore([Map<String, String>? initial])
    : _values = {...?initial};

  final Map<String, String> _values;

  /// A copy of everything stored.
  Map<String, String> get values => Map.unmodifiable(_values);

  @override
  Future<void> load() async {}

  @override
  String? getString(String key) => _values[key];

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Iterable<String> get keys => _values.keys;
}

/// JSON helpers over a [KeyValueStore]. Writes are fire-and-forget: the
/// store is responsible for reflecting them synchronously.
extension KeyValueStoreJson on KeyValueStore {
  Object? readJson(String key) {
    final raw = getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }

  void writeJson(String key, Object? value) {
    if (value == null) {
      unawaited(remove(key));
    } else {
      unawaited(setString(key, jsonEncode(value)));
    }
  }

  bool? readBool(String key) {
    final v = readJson(key);
    return v is bool ? v : null;
  }

  int? readInt(String key) {
    final v = readJson(key);
    return v is num ? v.toInt() : null;
  }

  double? readDouble(String key) {
    final v = readJson(key);
    return v is num ? v.toDouble() : null;
  }

  String? readStringValue(String key) {
    final v = readJson(key);
    return v is String ? v : null;
  }

  List<Object?> readList(String key) {
    final v = readJson(key);
    return v is List ? v : const [];
  }

  Map<String, Object?> readMap(String key) {
    final v = readJson(key);
    return v is Map<String, Object?> ? v : const {};
  }
}
