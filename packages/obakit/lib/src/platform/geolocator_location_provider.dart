import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:obakit_core/obakit_core.dart';

/// The calls [GeolocatorLocationProvider] makes, so tests can replace the
/// platform plugin. The default forwards to `Geolocator`.
class GeolocatorApi {
  const GeolocatorApi();

  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();
  Future<Position?> getLastKnownPosition() => Geolocator.getLastKnownPosition();
  Future<Position> getCurrentPosition(LocationSettings settings) =>
      Geolocator.getCurrentPosition(locationSettings: settings);
  Stream<Position> getPositionStream(LocationSettings settings) =>
      Geolocator.getPositionStream(locationSettings: settings);
}

/// A [LocationProvider] over the `geolocator` plugin.
///
/// It does nothing until asked: creating one never prompts the user or
/// starts the GPS. [positionStream] starts listening on the first
/// subscription and stops when the last one cancels. [lastKnownLocation] is
/// the latest fix this provider has seen; call [warmUp] once at startup to
/// seed it from the platform's cached fix (without prompting).
class GeolocatorLocationProvider implements LocationProvider {
  GeolocatorLocationProvider({
    this.api = const GeolocatorApi(),
    this.settings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
    this.currentPositionTimeout = const Duration(seconds: 10),
  });

  final GeolocatorApi api;
  final LocationSettings settings;
  final Duration currentPositionTimeout;

  ObaLocation? _last;
  StreamController<ObaLocation>? _controller;
  StreamSubscription<Position>? _sub;

  @override
  ObaLocation? get lastKnownLocation => _last;

  /// Seeds [lastKnownLocation] from the platform cache when permission is
  /// already granted. Never prompts. Safe to call more than once.
  Future<void> warmUp() async {
    try {
      if (!(await checkPermission()).isGranted) return;
      final p = await api.getLastKnownPosition();
      if (p != null) _last ??= toObaLocation(p);
    } catch (_) {
      // Location is best-effort.
    }
  }

  /// Maps a plugin [LocationPermission] (plus the service state) to the
  /// core enum.
  static LocationPermissionStatus mapPermission(
    LocationPermission permission, {
    required bool serviceEnabled,
  }) {
    if (!serviceEnabled) return LocationPermissionStatus.serviceDisabled;
    return switch (permission) {
      LocationPermission.denied => LocationPermissionStatus.denied,
      LocationPermission.deniedForever =>
        LocationPermissionStatus.deniedForever,
      LocationPermission.whileInUse => LocationPermissionStatus.whileInUse,
      LocationPermission.always => LocationPermissionStatus.always,
      _ => LocationPermissionStatus.notDetermined,
    };
  }

  /// Converts a plugin fix. A heading of a negative number or NaN (which some
  /// platforms report when unknown) becomes null.
  static ObaLocation toObaLocation(Position p) {
    final heading = p.heading;
    return ObaLocation(
      lat: p.latitude,
      lon: p.longitude,
      accuracy: p.accuracy.isFinite ? p.accuracy : 0,
      heading: heading.isFinite && heading >= 0 ? heading : null,
      timestamp: p.timestamp,
    );
  }

  /// Whether a request in this process came back denied.
  bool _requestDenied = false;

  /// geolocator reports "never asked" as [LocationPermission.denied] on
  /// both iOS and Android, so a plain `denied` from a check means the app
  /// may still ask: [LocationPermissionStatus.notDetermined]. It reads as
  /// denied only after a request here was refused (a refusal the system
  /// remembers comes back as `deniedForever`).
  ///
  /// When the plugin fails (most often because the host declares no
  /// location permission in its manifest or `Info.plist`, which a host that
  /// shows only a card or two may well do), it reads as
  /// [LocationPermissionStatus.denied] instead of throwing: location is
  /// best-effort, and `ObaCoreApplication.start` checks it.
  @override
  Future<LocationPermissionStatus> checkPermission() async {
    final LocationPermissionStatus status;
    try {
      final enabled = await api.isLocationServiceEnabled();
      status = mapPermission(
        await api.checkPermission(),
        serviceEnabled: enabled,
      );
    } catch (_) {
      return LocationPermissionStatus.denied;
    }
    if (status == LocationPermissionStatus.denied && !_requestDenied) {
      return LocationPermissionStatus.notDetermined;
    }
    return status;
  }

  /// Like [checkPermission], a plugin failure reads as
  /// [LocationPermissionStatus.denied].
  @override
  Future<LocationPermissionStatus> requestPermission() async {
    try {
      final enabled = await api.isLocationServiceEnabled();
      if (!enabled) return LocationPermissionStatus.serviceDisabled;
      final status = mapPermission(
        await api.requestPermission(),
        serviceEnabled: true,
      );
      _requestDenied = status == LocationPermissionStatus.denied;
      return status;
    } catch (_) {
      _requestDenied = true;
      return LocationPermissionStatus.denied;
    }
  }

  @override
  Future<ObaLocation?> currentPosition() async {
    try {
      if (!(await checkPermission()).isGranted) return null;
      final p = await api
          .getCurrentPosition(settings)
          .timeout(currentPositionTimeout);
      return _last = toObaLocation(p);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<ObaLocation> get positionStream {
    return (_controller ??= StreamController<ObaLocation>.broadcast(
      onListen: _start,
      onCancel: _stop,
    )).stream;
  }

  void _start() {
    _sub ??= api.getPositionStream(settings).listen(
      (p) {
        final l = toObaLocation(p);
        _last = l;
        _controller?.add(l);
      },
      // Permission revoked or service switched off: stay quiet; the
      // app re-checks permission when it next needs it.
      onError: (Object _) {},
    );
  }

  void _stop() {
    _sub?.cancel();
    _sub = null;
  }
}
