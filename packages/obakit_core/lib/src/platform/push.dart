import 'dart:async';

/// Push notifications (APNs/FCM through whatever service the host uses).
/// Optional: without one, alarms are unavailable.
abstract interface class PushServiceProvider {
  /// Whether this device can receive pushes at all.
  bool get isAvailable;

  /// Asks the user for permission. Returns whether it was granted.
  Future<bool> requestPermission();

  /// The token the Obaco server should push to, or null before registration.
  Future<String?> pushToken();

  /// Emits whenever the token changes.
  Stream<String> get pushTokenChanges;
}

/// A scriptable [PushServiceProvider] for tests.
class FakePushServiceProvider implements PushServiceProvider {
  FakePushServiceProvider({
    this._token,
    this.isAvailable = true,
    this.grantPermission = true,
  });

  @override
  bool isAvailable;
  bool grantPermission;
  String? _token;
  int permissionRequests = 0;
  final StreamController<String> _changes = StreamController.broadcast(
    sync: true,
  );

  set token(String value) {
    _token = value;
    _changes.add(value);
  }

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grantPermission;
  }

  @override
  Future<String?> pushToken() async => _token;

  @override
  Stream<String> get pushTokenChanges => _changes.stream;
}
