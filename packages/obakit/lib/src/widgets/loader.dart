import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that ignores [notifyListeners] after [dispose], for
/// controllers whose requests can finish after their owner is gone. Check
/// [isDisposed] before applying an async result.
mixin ObaDisposeSafeNotifier on ChangeNotifier {
  bool _disposed = false;

  /// Whether [dispose] has been called.
  bool get isDisposed => _disposed;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Loads one value with [load], keeping the latest result or error. A newer
/// [load] wins over an older one still in flight.
class ObaLoader<T> extends ChangeNotifier with ObaDisposeSafeNotifier {
  ObaLoader(this._load);

  final Future<T> Function() _load;
  T? value;
  Object? error;
  bool loading = false;
  int _generation = 0;

  Future<void> load() async {
    final g = ++_generation;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final v = await _load();
      if (isDisposed || g != _generation) return;
      value = v;
    } catch (e) {
      if (isDisposed || g != _generation) return;
      error = e;
    }
    loading = false;
    notifyListeners();
  }
}
