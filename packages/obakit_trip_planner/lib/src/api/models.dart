import 'polyline.dart';

/// Which OTP API produced a [TripPlan].
enum OtpApiFlavor {
  /// OTP 2.x GTFS GraphQL API (`gtfs/v1`).
  graphql,

  /// OTP 1.x REST API (`routers/default/plan`).
  rest,
}

/// A place in a plan: the trip's endpoints, a leg's endpoints, or an
/// intermediate stop.
class Place {
  const Place({
    required this.name,
    required this.lat,
    required this.lon,
    this.vertexType = 'NORMAL',
    this.stopId,
    this.stopCode,
    this.bikeShareId,
  });

  final String name;
  final double lat;
  final double lon;

  /// `NORMAL`, `TRANSIT`, `BIKESHARE`, ...
  final String vertexType;

  /// GTFS stop id, agency-prefixed (`1:1234`).
  final String? stopId;
  final String? stopCode;

  /// Rental station or free-floating vehicle id at this place.
  final String? bikeShareId;

  GeoPoint get point => (lat: lat, lon: lon);

  @override
  bool operator ==(Object other) =>
      other is Place &&
      other.name == name &&
      other.lat == lat &&
      other.lon == lon &&
      other.vertexType == vertexType &&
      other.stopId == stopId &&
      other.stopCode == stopCode &&
      other.bikeShareId == bikeShareId;

  @override
  int get hashCode =>
      Object.hash(name, lat, lon, vertexType, stopId, stopCode, bikeShareId);

  @override
  String toString() => 'Place($name, $lat, $lon)';
}

/// One turn-by-turn instruction within a walk or bike leg.
class LegStep {
  const LegStep({
    required this.distance,
    required this.streetName,
    required this.lat,
    required this.lon,
    this.relativeDirection,
    this.elevationChange,
  });

  /// Meters.
  final double distance;
  final String streetName;

  /// OTP token such as `LEFT` or `HARD_RIGHT`; see [RelativeDirection].
  final String? relativeDirection;
  final double? elevationChange;
  final double lat;
  final double lon;
}

/// A fare amount. Only OTP 1.x REST responses carry fares here.
class Money {
  const Money({
    required this.cents,
    required this.currencyCode,
    this.symbol,
    this.fractionDigits = 2,
  });

  /// Amount in the currency's minor unit.
  final int cents;

  /// ISO 4217 code, e.g. `USD`.
  final String currencyCode;
  final String? symbol;
  final int fractionDigits;

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.cents == cents &&
      other.currencyCode == currencyCode &&
      other.symbol == symbol &&
      other.fractionDigits == fractionDigits;

  @override
  int get hashCode => Object.hash(cents, currencyCode, symbol, fractionDigits);
}

/// GTFS `route_type` values OTP reports.
enum RouteType {
  tram(0),
  subway(1),
  rail(2),
  bus(3),
  ferry(4),
  cableCar(5),
  gondola(6),
  funicular(7),
  trolleybus(11),
  monorail(12);

  const RouteType(this.gtfsValue);

  final int gtfsValue;

  static RouteType? fromGtfs(int? value) {
    if (value == null) return null;
    for (final type in values) {
      if (type.gtfsValue == value) return type;
    }
    return null;
  }
}

/// The conveyance for a [Leg], parsed from OTP's mode token.
enum LegMode {
  walk('WALK'),
  bicycle('BICYCLE'),
  car('CAR'),
  bus('BUS'),
  tram('TRAM'),
  subway('SUBWAY'),
  rail('RAIL'),
  ferry('FERRY'),
  cableCar('CABLE_CAR'),
  gondola('GONDOLA'),
  funicular('FUNICULAR'),
  transit('TRANSIT'),
  airplane('AIRPLANE'),
  trolleybus('TROLLEYBUS'),
  monorail('MONORAIL');

  const LegMode(this.wireValue);

  final String wireValue;

  static const _aliases = {'BIKE': bicycle, 'TRAIN': rail};

  /// Tolerates casing, spaces for underscores, and the `BIKE`/`TRAIN`
  /// aliases. Returns null for tokens this client doesn't know.
  static LegMode? fromOtp(String token) {
    final normalized = token.trim().toUpperCase().replaceAll(' ', '_');
    for (final mode in values) {
      if (mode.wireValue == normalized) return mode;
    }
    return _aliases[normalized];
  }

  bool get isTransit => switch (this) {
    walk || bicycle || car => false,
    _ => true,
  };
}

/// One segment of an [Itinerary].
class Leg {
  const Leg({
    required this.startTime,
    required this.endTime,
    required this.mode,
    required this.from,
    required this.to,
    this.routeShortName,
    this.routeLongName,
    this.routeType,
    this.routeColor,
    this.routeTextColor,
    this.agencyName,
    this.headsign,
    this.encodedGeometry = '',
    this.distance = 0,
    this.duration = 0,
    this.transitLeg = false,
    this.rentedBike = false,
    this.realTime = false,
    this.departureDelay,
    this.arrivalDelay,
    this.intermediateStops = const [],
    this.steps = const [],
  });

  final DateTime startTime;
  final DateTime endTime;

  /// OTP mode token as sent (`WALK`, `BUS`, `TRAM`...). See [legMode].
  final String mode;
  final String? routeShortName;
  final String? routeLongName;
  final RouteType? routeType;

  /// Hex without `#`, as GTFS stores it.
  final String? routeColor;
  final String? routeTextColor;
  final String? agencyName;
  final String? headsign;
  final Place from;
  final Place to;

  /// Google-encoded polyline; see [geometry].
  final String encodedGeometry;

  /// Meters.
  final double distance;

  /// Seconds.
  final int duration;
  final bool transitLeg;

  /// True when ridden on a rented vehicle. A rental ride's [mode] is plain
  /// `BICYCLE`, so this is the only reliable rental discriminator.
  final bool rentedBike;

  /// Whether the times come from real-time data.
  final bool realTime;

  /// Seconds behind schedule (negative is early). Real-time legs only.
  final int? departureDelay;
  final int? arrivalDelay;
  final List<Place> intermediateStops;

  /// Turn-by-turn steps; walk and bike legs only.
  final List<LegStep> steps;

  LegMode? get legMode => LegMode.fromOtp(mode);

  bool get isWalk => legMode == LegMode.walk;

  /// The route's rider-facing short name, falling back to the long name.
  String? get routeName => routeShortName ?? routeLongName;

  /// The decoded leg geometry, or the straight segment between [from] and
  /// [to] when the server sent none.
  List<GeoPoint> get geometry {
    final decoded = decodePolyline(encodedGeometry);
    return decoded.isNotEmpty ? decoded : [from.point, to.point];
  }

  Leg copyWith({
    DateTime? startTime,
    DateTime? endTime,
    Place? from,
    Place? to,
    double? distance,
    int? duration,
    int? arrivalDelay,
    String? encodedGeometry,
    List<Place>? intermediateStops,
  }) => Leg(
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    mode: mode,
    from: from ?? this.from,
    to: to ?? this.to,
    routeShortName: routeShortName,
    routeLongName: routeLongName,
    routeType: routeType,
    routeColor: routeColor,
    routeTextColor: routeTextColor,
    agencyName: agencyName,
    headsign: headsign,
    encodedGeometry: encodedGeometry ?? this.encodedGeometry,
    distance: distance ?? this.distance,
    duration: duration ?? this.duration,
    transitLeg: transitLeg,
    rentedBike: rentedBike,
    realTime: realTime,
    departureDelay: departureDelay,
    arrivalDelay: arrivalDelay ?? this.arrivalDelay,
    intermediateStops: intermediateStops ?? this.intermediateStops,
    steps: steps,
  );
}

/// One way to make the trip.
class Itinerary {
  const Itinerary({
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.legs,
    this.walkTime = 0,
    this.transitTime = 0,
    this.waitingTime = 0,
    this.walkDistance = 0,
    this.walkLimitExceeded = false,
    this.elevationLost = 0,
    this.elevationGained = 0,
    this.transfers = 0,
    this.fare,
  });

  /// Seconds.
  final int duration;
  final DateTime startTime;
  final DateTime endTime;

  /// Seconds.
  final int walkTime;
  final int transitTime;
  final int waitingTime;

  /// Meters.
  final double walkDistance;
  final bool walkLimitExceeded;
  final double elevationLost;
  final double elevationGained;
  final int transfers;

  /// The regular adult fare, when the server reports one.
  final Money? fare;
  final List<Leg> legs;

  /// The decoded geometry of every leg, in order.
  List<GeoPoint> get geometry => [for (final leg in legs) ...leg.geometry];

  /// The legs to show in summaries: walks of a minute or less dropped and
  /// consecutive legs on the same route merged (OTPKit `relevantLegs`).
  List<Leg> get relevantLegs {
    final merged = <Leg>[];
    for (final leg in legs) {
      if (leg.isWalk && leg.duration <= 60) continue;
      if (merged.isNotEmpty && _shouldMerge(merged.last, leg)) {
        merged[merged.length - 1] = _merge(merged.last, leg);
      } else {
        merged.add(leg);
      }
    }
    return merged;
  }

  static bool _shouldMerge(Leg a, Leg b) =>
      a.rentedBike == b.rentedBike &&
      a.routeName != null &&
      a.routeName == b.routeName &&
      a.transitLeg &&
      b.transitLeg;

  static Leg _merge(Leg a, Leg b) => a.copyWith(
    endTime: b.endTime,
    to: b.to,
    distance: a.distance + b.distance,
    duration: a.duration + b.duration,
    arrivalDelay: b.arrivalDelay,
    intermediateStops: [...a.intermediateStops, ...b.intermediateStops],
  );
}

/// A planner response with at least the endpoints; [itineraries] may be
/// empty when the planner found nothing but reported no error.
class TripPlan {
  const TripPlan({
    required this.date,
    required this.from,
    required this.to,
    required this.itineraries,
    required this.source,
  });

  final DateTime date;
  final Place from;
  final Place to;
  final List<Itinerary> itineraries;

  /// The API that answered, useful when a client falls back.
  final OtpApiFlavor source;
}
