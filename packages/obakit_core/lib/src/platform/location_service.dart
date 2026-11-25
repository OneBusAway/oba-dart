import 'dart:async';

import '../foundation/change_notifier.dart';
import 'location.dart';

/// A claim on live location from [LocationService.acquire]. Call [release]
/// when the consumer no longer needs updates (it is hidden, the app went to
/// the background, or it is disposed). Releasing twice does nothing.
class LocationLease {
  LocationLease._(this._service);

  LocationService? _service;

  /// False once released.
  bool get isActive => _service != null;

  void release() {
    final service = _service;
    _service = null;
    service?._release();
  }
}

/// Demand-driven device location. The provider's continuous
/// [LocationProvider.positionStream] is subscribed only while at least one
/// [LocationLease] is held and permission is granted, and is cancelled when
/// the last lease is released. So the GPS runs only while something on
/// screen needs it (the map's location dot, a visible nearby section, walk
/// times on a visible stop page).
///
/// [currentLocation] (the last known fix) stays readable without a lease.
/// [requestFix] takes a one-shot fix without holding a subscription.
///
/// ```dart
/// final lease = app.locationService.acquire(); // starts updates (if permitted)
/// app.locationService.currentLocation;          // latest fix, or null
/// lease.release();                              // the last release stops them
/// ```
///
/// Notifies listeners when [permission] changes. Listen to
/// [locationListenable] for fixes.
class LocationService extends ObaChangeNotifier {
  LocationService(this.provider)
    : isAvailable = provider is! NoLocationProvider;

  final LocationProvider provider;

  /// False when the host gave the SDK no location at all
  /// ([NoLocationProvider]). Screens then say location isn't available
  /// instead of asking for it.
  final bool isAvailable;

  final ObaValueNotifier<ObaLocation?> _location = ObaValueNotifier(null);
  LocationPermissionStatus _permission = LocationPermissionStatus.notDetermined;
  StreamSubscription<ObaLocation>? _sub;
  int _holders = 0;
  Future<void>? _checking;

  /// The permission as last checked or requested.
  LocationPermissionStatus get permission => _permission;

  /// The latest known fix. Notifies when it changes.
  ObaValueListenable<ObaLocation?> get locationListenable => _location;

  /// The latest known fix, or null. Reading it never starts the GPS.
  ObaLocation? get currentLocation => _location.value;

  /// How many leases are held now.
  int get holderCount => _holders;

  /// Whether the continuous subscription is open now.
  bool get isUpdating => _sub != null;

  /// Copies the provider's last known fix when it is newer than ours.
  /// Never prompts and never starts the GPS.
  void readLastKnown() {
    final last = provider.lastKnownLocation;
    final mine = _location.value;
    if (last != null &&
        (mine == null || !last.timestamp.isBefore(mine.timestamp))) {
      _location.value = last;
    }
  }

  /// Checks the permission (never prompts) and updates [permission].
  Future<LocationPermissionStatus> checkPermission() async {
    if (!isAvailable) return _setPermission(LocationPermissionStatus.denied);
    try {
      return _setPermission(await provider.checkPermission());
    } catch (_) {
      return _setPermission(LocationPermissionStatus.denied);
    }
  }

  /// Asks for permission. When granted, takes a one-shot fix (which centres
  /// the map and selects the region) and starts updates if a lease is held.
  Future<LocationPermissionStatus> requestPermission() async {
    if (!isAvailable) return _setPermission(LocationPermissionStatus.denied);
    final status = _setPermission(await provider.requestPermission());
    if (status.isGranted) await requestFix();
    return status;
  }

  /// A one-shot fix (null without permission or when none arrives). It
  /// updates [currentLocation] but holds no subscription.
  Future<ObaLocation?> requestFix() async {
    if (!_permission.isGranted || isDisposed) return null;
    final fix = await provider.currentPosition();
    if (fix != null && !isDisposed) _location.value = fix;
    return fix;
  }

  /// Claims live location until the lease is released. Starts the
  /// subscription when this is the first lease and permission is granted.
  /// Without permission it re-checks it (never prompting), so updates start
  /// when the rider has since granted it in the system settings.
  LocationLease acquire() {
    assert(!isDisposed, 'LocationService used after dispose()');
    _holders++;
    if (_permission.isGranted) {
      _sync();
    } else if (isAvailable) {
      unawaited(_recheck());
    }
    return LocationLease._(this);
  }

  void _release() {
    if (_holders > 0) _holders--;
    _sync();
  }

  Future<void> _recheck() => _checking ??= checkPermission()
      .then<void>((_) {}, onError: (Object _) {})
      .whenComplete(() => _checking = null);

  LocationPermissionStatus _setPermission(LocationPermissionStatus status) {
    if (isDisposed) return status;
    final changed = status != _permission;
    _permission = status;
    _sync();
    if (changed) notifyListeners();
    return status;
  }

  void _sync() {
    final want = !isDisposed && _holders > 0 && _permission.isGranted;
    if (want && _sub == null) {
      readLastKnown();
      _sub = provider.positionStream.listen(
        (fix) {
          if (!isDisposed) _location.value = fix;
        },
        // Permission revoked or the service switched off: keep the last
        // fix; the permission is re-checked on the next acquire.
        onError: (Object _) {},
      );
    } else if (!want && _sub != null) {
      _sub!.cancel();
      _sub = null;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _sub = null;
    _holders = 0;
    super.dispose();
    _location.dispose();
  }
}
