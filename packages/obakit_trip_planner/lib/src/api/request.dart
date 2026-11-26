/// A travel mode the rider can request. Mirrors OTPKit's `TransportMode`:
/// the UI-level modes, each of which expands to wire modes via [apiModes].
enum TransportMode {
  transit('TRANSIT'),
  walk('WALK'),
  bike('BIKE'),
  car('CAR'),

  /// Bikeshare without transit. REST token `BICYCLE_RENT`; GraphQL sends
  /// `{mode: BICYCLE, qualifier: RENT}`.
  bikeRental('BICYCLE_RENT'),

  /// Transit combined with bikeshare. Composite: never sent as itself.
  transitBikeRental('TRANSIT_BICYCLE_RENT');

  const TransportMode(this.wireValue);

  /// The OTP 1.x REST `mode` token.
  final String wireValue;

  /// The modes a request for this UI mode puts on the wire. Transit needs
  /// walking to reach stops, and so on.
  List<TransportMode> get apiModes => switch (this) {
    transit => const [transit, walk],
    walk => const [walk],
    bike => const [bike, walk],
    car => const [car],
    bikeRental => const [bikeRental, walk],
    transitBikeRental => const [transit, walk, bikeRental],
  };

  /// The primitive modes this mode serializes as: composites expand to
  /// their [apiModes], primitives are themselves.
  List<TransportMode> get wireModes =>
      this == transitBikeRental ? apiModes : [this];

  /// Modes that only work against a rental-capable (GraphQL) backend.
  bool get requiresVehicleRentalSupport =>
      this == bikeRental || this == transitBikeRental;
}

/// Maximum walking distance presets, in meters (OTPKit `WalkingDistance`).
enum WalkingDistance {
  quarterMile(402),
  halfMile(805),
  oneMile(1609),
  twoMiles(3219);

  const WalkingDistance(this.meters);

  final int meters;
}

/// A coordinate in degrees.
class OtpCoordinate {
  const OtpCoordinate(this.lat, this.lon);

  final double lat;
  final double lon;

  bool get isValid => lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;

  /// `lat,lon` with four decimals, the OTP 1.x place format.
  String get formattedForApi =>
      '${lat.toStringAsFixed(4)},${lon.toStringAsFixed(4)}';

  @override
  bool operator ==(Object other) =>
      other is OtpCoordinate && other.lat == lat && other.lon == lon;

  @override
  int get hashCode => Object.hash(lat, lon);

  @override
  String toString() => 'OtpCoordinate($lat, $lon)';
}

/// A trip planning request, shared by both API flavours.
class TripPlanRequest {
  TripPlanRequest({
    required this.origin,
    required this.destination,
    required this.dateTime,
    this.transportModes = const [TransportMode.transit, TransportMode.walk],
    this.maxWalkDistance = 1000,
    this.wheelchairAccessible = false,
    this.arriveBy = false,
    this.viaPoint,
  });

  final OtpCoordinate origin;
  final OtpCoordinate destination;

  /// Departure time, or arrival time when [arriveBy]. Sent as wall-clock
  /// date and time in the device's zone, as OTPKit does.
  final DateTime dateTime;
  final List<TransportMode> transportModes;

  /// Meters.
  final int maxWalkDistance;
  final bool wheelchairAccessible;
  final bool arriveBy;

  /// A point every trip must pass through (e.g. a rental vehicle).
  final OtpCoordinate? viaPoint;

  /// Primitive modes, composites expanded, deduplicated in first-seen order.
  List<TransportMode> get wireTransportModes {
    final seen = <TransportMode>{};
    return [
      for (final mode in transportModes)
        for (final wire in mode.wireModes)
          if (seen.add(wire)) wire,
    ];
  }

  /// The OTP 1.x REST `mode` parameter, e.g. `TRANSIT,WALK`.
  String get transportModesString =>
      wireTransportModes.map((m) => m.wireValue).join(',');

  /// The `date` parameter: `MM-dd-yyyy`, Gregorian, ASCII digits.
  String get formattedDate {
    final local = dateTime.toLocal();
    return '${_two(local.month)}-${_two(local.day)}-'
        '${local.year.toString().padLeft(4, '0')}';
  }

  /// The `time` parameter: `h:mm AM` (12-hour, POSIX AM/PM symbols).
  String get formattedTime {
    final local = dateTime.toLocal();
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final period = local.hour < 12 ? 'AM' : 'PM';
    return '$hour12:${_two(local.minute)} $period';
  }

  bool get isValid =>
      origin.isValid &&
      destination.isValid &&
      maxWalkDistance > 0 &&
      transportModes.isNotEmpty;

  static String _two(int value) => value.toString().padLeft(2, '0');
}
