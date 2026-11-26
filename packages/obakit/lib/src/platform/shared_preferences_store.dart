import 'package:obakit_core/obakit_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A [KeyValueStore] over `shared_preferences`.
///
/// It only reads and writes keys that start with [prefix] (`oba.` by
/// default), so it can share the preferences file with a host app without
/// touching the host's keys. Reads come from `SharedPreferences`' in-memory
/// cache, so they are synchronous after [load], as the [KeyValueStore]
/// contract requires.
///
/// In tests, call `SharedPreferences.setMockInitialValues({...})` before
/// [load].
class SharedPreferencesKeyValueStore implements KeyValueStore {
  SharedPreferencesKeyValueStore({
    this.prefix = 'oba.',
    Future<SharedPreferences> Function()? instance,
  }) : _instance = instance ?? SharedPreferences.getInstance;

  /// Creates a store and loads it.
  static Future<SharedPreferencesKeyValueStore> create({
    String prefix = 'oba.',
  }) async {
    final store = SharedPreferencesKeyValueStore(prefix: prefix);
    await store.load();
    return store;
  }

  /// Only keys starting with this are visible through [keys].
  final String prefix;
  final Future<SharedPreferences> Function() _instance;
  SharedPreferences? _prefs;

  SharedPreferences get _p {
    final p = _prefs;
    if (p == null) {
      throw StateError('SharedPreferencesKeyValueStore used before load()');
    }
    return p;
  }

  @override
  Future<void> load() async {
    _prefs ??= await _instance();
  }

  @override
  String? getString(String key) {
    final value = _p.get(key);
    return value is String ? value : null;
  }

  @override
  Future<void> setString(String key, String value) async {
    await _p.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _p.remove(key);
  }

  @override
  Iterable<String> get keys => _p.getKeys().where((k) => k.startsWith(prefix));
}
