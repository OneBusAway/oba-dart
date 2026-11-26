import 'dart:async';

/// A pure-Dart counterpart of Flutter's `Listenable`.
///
/// The method signatures match Flutter's, so a Flutter package can adapt any
/// [ObaListenable] with a few lines:
///
/// ```dart
/// class ObaListenableAdapter implements Listenable {
///   ObaListenableAdapter(this.source);
///   final ObaListenable source;
///   @override
///   void addListener(VoidCallback l) => source.addListener(l);
///   @override
///   void removeListener(VoidCallback l) => source.removeListener(l);
/// }
/// ```
abstract interface class ObaListenable {
  void addListener(void Function() listener);
  void removeListener(void Function() listener);
}

/// An [ObaListenable] that also exposes a current [value].
abstract interface class ObaValueListenable<T> implements ObaListenable {
  T get value;
}

/// A minimal `ChangeNotifier` without Flutter. Listeners are called
/// synchronously, in registration order; a listener added or removed during
/// a notification takes effect from the next one. An exception thrown by a
/// listener is passed to [onListenerError] (default: rethrown asynchronously
/// via [Zone.handleUncaughtError]) and does not stop the other listeners.
class ObaChangeNotifier implements ObaListenable {
  final List<void Function()> _listeners = [];
  bool _disposed = false;

  /// Reports listener exceptions. Override in tests if needed.
  static void Function(Object error, StackTrace stack) onListenerError =
      _defaultOnListenerError;

  static void _defaultOnListenerError(Object error, StackTrace stack) =>
      Zone.current.handleUncaughtError(error, stack);

  bool get hasListeners => _listeners.isNotEmpty;

  /// Whether [dispose] has been called.
  bool get isDisposed => _disposed;

  @override
  void addListener(void Function() listener) {
    assert(!_disposed, '$runtimeType used after dispose()');
    _listeners.add(listener);
  }

  @override
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  /// Calls every registered listener.
  void notifyListeners() {
    if (_disposed) return;
    for (final listener in List.of(_listeners)) {
      if (!_listeners.contains(listener)) continue;
      try {
        listener();
      } catch (e, st) {
        onListenerError(e, st);
      }
    }
  }

  /// Drops every listener. Further notifications are ignored.
  void dispose() {
    _disposed = true;
    _listeners.clear();
  }
}

/// Holds a value and notifies when it changes (by `==`).
class ObaValueNotifier<T> extends ObaChangeNotifier
    implements ObaValueListenable<T> {
  ObaValueNotifier(this._value);

  T _value;

  @override
  T get value => _value;

  set value(T newValue) {
    if (newValue == _value) return;
    _value = newValue;
    notifyListeners();
  }
}
