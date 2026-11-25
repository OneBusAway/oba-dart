import 'package:flutter/foundation.dart';
import 'package:obakit_core/obakit_core.dart';

/// Adapts a pure-Dart [ObaListenable] (`ObaChangeNotifier`, a service, a
/// store) to Flutter's [Listenable], for `ListenableBuilder`,
/// `AnimatedBuilder` and `Listenable.merge`.
///
/// ```dart
/// ListenableBuilder(
///   listenable: ObaListenableAdapter(app.core.userData),
///   builder: (context, _) => Text('${app.core.userData.bookmarks.length}'),
/// )
/// ```
///
/// The adapter holds no state, so creating one in `build` is fine; equal
/// adapters compare equal, so builders do not resubscribe.
class ObaListenableAdapter implements Listenable {
  const ObaListenableAdapter(this.source);

  final ObaListenable source;

  @override
  void addListener(VoidCallback listener) => source.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => source.removeListener(listener);

  @override
  bool operator ==(Object other) =>
      other is ObaListenableAdapter && identical(other.source, source);

  @override
  int get hashCode => identityHashCode(source);
}

/// Adapts an [ObaValueListenable] to Flutter's [ValueListenable], for
/// `ValueListenableBuilder`.
class ObaValueListenableAdapter<T> extends ObaListenableAdapter
    implements ValueListenable<T> {
  const ObaValueListenableAdapter(ObaValueListenable<T> super.source);

  @override
  T get value => (source as ObaValueListenable<T>).value;
}

/// `.listenable` / `.valueListenable` shorthands.
extension ObaListenableX on ObaListenable {
  Listenable get listenable => ObaListenableAdapter(this);
}

extension ObaValueListenableX<T> on ObaValueListenable<T> {
  ValueListenable<T> get valueListenable => ObaValueListenableAdapter<T>(this);
}
