import 'dart:async';

import 'package:clock/clock.dart';
import 'package:onebusaway/onebusaway.dart';

/// A device position fix.
class ObaLocation {
  const ObaLocation({
    required this.lat,
    required this.lon,
    this.accuracy = 0,
    this.heading,
    required this.timestamp,
  });

  final double lat;
  final double lon;

  /// Horizontal accuracy radius in metres.
  final double accuracy;

  /// Degrees clockwise from true north, when known.
  final double? heading;
  final DateTime timestamp;

  Coordinate get coordinate => Coordinate(lat, lon);

  @override
  bool operator ==(Object other) =>
      other is ObaLocation &&
      other.lat == lat &&
      other.lon == lon &&
      other.accuracy == accuracy &&
      other.heading == heading &&
      other.timestamp == timestamp;

  @override
  int get hashCode => Object.hash(lat, lon, accuracy, heading, timestamp);

  @override
  String toString() => 'ObaLocation($lat, $lon ±${accuracy}m)';
}

enum LocationPermissionStatus {
  /// The user has not been asked yet.
  notDetermined,
  denied,

  /// Denied, and the system will not ask again; send the user to settings.
  deniedForever,
  whileInUse,
  always,

  /// Location services are switched off for the whole device.
  serviceDisabled;

  bool get isGranted => this == whileInUse || this == always;
}

/// Device location. A host implements it over `geolocator` or similar.
abstract interface class LocationProvider {
  Future<LocationPermissionStatus> checkPermission();
  Future<LocationPermissionStatus> requestPermission();

  /// A fresh fix, or null when permission is missing or no fix arrives.
  Future<ObaLocation?> currentPosition();

  /// Fixes as they arrive. Only meaningful while permission is granted.
  Stream<ObaLocation> get positionStream;

  /// The most recent fix known without waiting, or null.
  ObaLocation? get lastKnownLocation;
}

/// A [LocationProvider] that always reports one point, for a host that
/// wants the SDK to work "near campus" without the device's location (no
/// permission prompt, no platform location API, no `Info.plist` key).
///
/// Permission reads as granted, so screens behave as if the rider stood
/// at [coordinate]: the map's location dot, walk times and nearby stops
/// all use it. To show stops near a point in one widget only, pass
/// `around:` to that widget instead.
///
/// ```dart
/// ObaPlatformServices(
///   keyValueStore: store,
///   locationProvider: FixedLocationProvider(const Coordinate(32.8801, -117.2340)),
/// )
/// ```
class FixedLocationProvider implements LocationProvider {
  FixedLocationProvider(Coordinate coordinate, {double accuracy = 0})
    : _location = ObaLocation(
        lat: coordinate.lat,
        lon: coordinate.lon,
        accuracy: accuracy,
        timestamp: clock.now(),
      );

  ObaLocation _location;

  /// The reported point.
  Coordinate get coordinate => _location.coordinate;

  /// Moves the reported point and tells current listeners.
  set coordinate(Coordinate value) {
    _location = ObaLocation(
      lat: value.lat,
      lon: value.lon,
      accuracy: _location.accuracy,
      timestamp: clock.now(),
    );
    for (final c in List.of(_listeners)) {
      c.addSync(_location);
    }
  }

  final Set<MultiStreamController<ObaLocation>> _listeners = {};

  @override
  Future<LocationPermissionStatus> checkPermission() async =>
      LocationPermissionStatus.whileInUse;

  @override
  Future<LocationPermissionStatus> requestPermission() async =>
      LocationPermissionStatus.whileInUse;

  @override
  Future<ObaLocation?> currentPosition() async => _location;

  /// Emits the point once on listen, then again only when [coordinate]
  /// changes. Nothing runs in between.
  @override
  Stream<ObaLocation> get positionStream => Stream.multi((c) {
    _listeners.add(c);
    c.onCancel = () => _listeners.remove(c);
    c.addSync(_location);
  });

  @override
  ObaLocation? get lastKnownLocation => _location;
}

/// A [LocationProvider] for a host that deliberately gives the SDK no
/// location at all. Nothing is ever reported, nothing is ever asked, and
/// screens that need a location say that it isn't available in this app
/// (instead of "Location access is off") and hide their location actions.
/// Check it with `ObaCoreApplication.isLocationAvailable`.
class NoLocationProvider implements LocationProvider {
  const NoLocationProvider();

  @override
  Future<LocationPermissionStatus> checkPermission() async =>
      LocationPermissionStatus.denied;

  @override
  Future<LocationPermissionStatus> requestPermission() async =>
      LocationPermissionStatus.denied;

  @override
  Future<ObaLocation?> currentPosition() async => null;

  @override
  Stream<ObaLocation> get positionStream => const Stream.empty();

  @override
  ObaLocation? get lastKnownLocation => null;
}

/// A scriptable [LocationProvider] for tests. (A host that wants a fixed
/// point uses [FixedLocationProvider]; one with no location at all uses
/// [NoLocationProvider].)
class FakeLocationProvider implements LocationProvider {
  FakeLocationProvider({
    this._location,
    this.permission = LocationPermissionStatus.notDetermined,
    this.permissionAfterRequest = LocationPermissionStatus.whileInUse,
  });

  LocationPermissionStatus permission;

  /// What [requestPermission] changes [permission] to.
  LocationPermissionStatus permissionAfterRequest;

  ObaLocation? _location;
  final StreamController<ObaLocation> _controller = StreamController.broadcast(
    sync: true,
  );

  int requestCount = 0;

  /// How many [positionStream] subscriptions are open now: the number of
  /// "GPS is running" holders a real provider would have.
  int get activeSubscriptions => _active;
  int _active = 0;

  /// How many [positionStream] subscriptions were ever opened.
  int subscribeCount = 0;

  /// How many [currentPosition] calls were made (one-shot fixes).
  int currentPositionCount = 0;

  /// Sets the current fix and emits it on [positionStream].
  void setLocation(ObaLocation location) {
    _location = location;
    _controller.add(location);
  }

  @override
  Future<LocationPermissionStatus> checkPermission() async => permission;

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    requestCount++;
    permission = permissionAfterRequest;
    return permission;
  }

  @override
  Future<ObaLocation?> currentPosition() async {
    currentPositionCount++;
    return permission.isGranted ? _location : null;
  }

  @override
  Stream<ObaLocation> get positionStream => Stream.multi((c) {
    _active++;
    subscribeCount++;
    final sub = _controller.stream.listen(c.addSync, onError: c.addErrorSync);
    c.onCancel = () {
      _active--;
      return sub.cancel();
    };
  });

  @override
  ObaLocation? get lastKnownLocation => _location;

  Future<void> close() => _controller.close();
}
