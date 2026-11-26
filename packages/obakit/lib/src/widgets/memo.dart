/// Remembers one computed value and recomputes it only when its inputs
/// change (compared with `==`, which is identity for most objects).
///
/// Pages use it for values they would otherwise rebuild on every `build`,
/// such as a map overlay: an unchanged overlay instance lets
/// `ObaMapOverlays` skip re-applying it.
class ObaMemo<T> {
  List<Object?>? _inputs;
  T? _value;

  /// How many times [compute] ran (for tests).
  int computeCount = 0;

  T call(List<Object?> inputs, T Function() compute) {
    final previous = _inputs;
    if (previous != null && _sameInputs(previous, inputs)) return _value as T;
    computeCount++;
    _inputs = inputs;
    return _value = compute();
  }

  /// Forgets the value; the next call recomputes.
  void reset() {
    _inputs = null;
    _value = null;
  }

  static bool _sameInputs(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
