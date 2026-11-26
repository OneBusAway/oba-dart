import 'package:http/http.dart' as http;

import 'errors.dart';
import 'http_support.dart';
import 'json.dart';
import 'models.dart';
import 'planner_error_code.dart';
import 'request.dart';
import 'trip_plan_service.dart';

/// OTP 1.x REST planner (`GET {base}/routers/default/plan`). Port of
/// OTPKit's `RestAPIService`.
class OtpRestService implements TripPlanService {
  /// [baseUrl] is the OTP root (`https://host/otp/`) or a router URL
  /// (`https://host/otp/routers/default/`); `routers/default` is appended
  /// when no router segment is present.
  OtpRestService({
    required Uri baseUrl,
    required http.Client httpClient,
    this.headers = const {},
    this.timeout = const Duration(seconds: 30),
  }) : baseUrl = normalizeBaseUrl(baseUrl),
       _http = httpClient;

  /// The normalized router URL.
  final Uri baseUrl;
  final Map<String, String> headers;
  final Duration timeout;
  final http.Client _http;

  static Uri normalizeBaseUrl(Uri url) =>
      hasOtpRouterPath(url) ? url : appendPath(url, 'routers/default');

  @override
  bool get supportsVehicleRental => false;

  /// The GET URL for [request]. Parameter order and encoding match OTPKit.
  Uri buildUri(TripPlanRequest request) {
    final params = <(String, String)>[
      ('fromPlace', request.origin.formattedForApi),
      ('toPlace', request.destination.formattedForApi),
      ('time', request.formattedTime),
      ('date', request.formattedDate),
      ('mode', request.transportModesString),
      ('arriveBy', '${request.arriveBy}'),
      ('maxWalkDistance', '${request.maxWalkDistance}'),
      ('wheelchair', '${request.wheelchairAccessible}'),
      ('showIntermediateStops', 'true'),
      if (request.viaPoint case final via?)
        ('intermediatePlaces', via.formattedForApi),
    ];
    // Percent-encoding (space as %20) rather than form encoding (+), as
    // URLComponents does on iOS.
    final query = params
        .map((p) => '${p.$1}=${Uri.encodeComponent(p.$2)}')
        .join('&');
    return appendPath(baseUrl, 'plan').replace(query: query);
  }

  @override
  Future<TripPlan> plan(TripPlanRequest request) async {
    final json = await sendForJson(
      () => _http.get(buildUri(request), headers: headers),
      timeout: timeout,
    );
    return parseOrThrow(() => parseRestPlanResponse(json));
  }
}

/// Decodes an OTP 1.x `/plan` response, throwing [OtpPlannerException] for
/// its `error` object.
TripPlan parseRestPlanResponse(JsonMap json) {
  final error = asOptMap(json['error']);
  if (error != null) {
    throw OtpPlannerException(
      PlannerErrorCode.fromWire(readOptString(error, 'message')),
      readOptString(error, 'msg') ?? 'Planner error',
      id: readOptInt(error, 'id'),
    );
  }
  final plan = asOptMap(json['plan']);
  if (plan == null) throw const OtpFormatException('Response has no plan');
  return TripPlan(
    date: readEpochMillis(plan, 'date'),
    from: _place(asMap(plan['from'], 'from')),
    to: _place(asMap(plan['to'], 'to')),
    itineraries: [
      for (final itinerary in readMapList(plan, 'itineraries'))
        _itinerary(itinerary),
    ],
    source: OtpApiFlavor.rest,
  );
}

Itinerary _itinerary(JsonMap json) => Itinerary(
  duration: readInt(json, 'duration'),
  startTime: readEpochMillis(json, 'startTime'),
  endTime: readEpochMillis(json, 'endTime'),
  walkTime: readOptInt(json, 'walkTime') ?? 0,
  transitTime: readOptInt(json, 'transitTime') ?? 0,
  waitingTime: readOptInt(json, 'waitingTime') ?? 0,
  walkDistance: readOptDouble(json, 'walkDistance') ?? 0,
  walkLimitExceeded: readOptBool(json, 'walkLimitExceeded') ?? false,
  elevationLost: readOptDouble(json, 'elevationLost') ?? 0,
  elevationGained: readOptDouble(json, 'elevationGained') ?? 0,
  transfers: readOptInt(json, 'transfers') ?? 0,
  fare: _fare(asOptMap(json['fare'])),
  legs: [for (final leg in readMapList(json, 'legs')) _leg(leg)],
);

/// `fare.fare.regular`, OTP 1.x's adult cash fare.
Money? _fare(JsonMap? json) {
  final regular = asOptMap(asOptMap(json?['fare'])?['regular']);
  if (regular == null) return null;
  final cents = readOptInt(regular, 'cents');
  final currency = asOptMap(regular['currency']);
  final code = currency == null
      ? null
      : readOptString(currency, 'currencyCode') ??
            readOptString(currency, 'currency');
  if (cents == null || cents < 0 || code == null) return null;
  return Money(
    cents: cents,
    currencyCode: code,
    symbol: readOptString(currency!, 'symbol'),
    fractionDigits: readOptInt(currency, 'defaultFractionDigits') ?? 2,
  );
}

Leg _leg(JsonMap json) {
  final geometry = asOptMap(json['legGeometry']);
  final route = readOptString(json, 'route');
  final shortName = readOptString(json, 'routeShortName');
  final longName = readOptString(json, 'routeLongName');
  return Leg(
    startTime: readEpochMillis(json, 'startTime'),
    endTime: readEpochMillis(json, 'endTime'),
    mode: readOptString(json, 'mode') ?? 'WALK',
    // OTP 1.x `route` is the short name, or the long name when the route
    // has none; older servers send only `route`.
    routeShortName: shortName ?? (longName == null ? route : null),
    routeLongName: longName,
    routeType: RouteType.fromGtfs(readOptInt(json, 'routeType')),
    routeColor: readOptString(json, 'routeColor'),
    routeTextColor: readOptString(json, 'routeTextColor'),
    agencyName: readOptString(json, 'agencyName'),
    headsign: readOptString(json, 'headsign'),
    from: _place(asMap(json['from'], 'from')),
    to: _place(asMap(json['to'], 'to')),
    encodedGeometry: geometry == null
        ? ''
        : readOptString(geometry, 'points') ?? '',
    distance: readOptDouble(json, 'distance') ?? 0,
    duration: (readOptDouble(json, 'duration') ?? 0).round(),
    transitLeg: readOptBool(json, 'transitLeg') ?? false,
    rentedBike: readOptBool(json, 'rentedBike') ?? false,
    realTime: readOptBool(json, 'realTime') ?? false,
    departureDelay: readOptInt(json, 'departureDelay'),
    arrivalDelay: readOptInt(json, 'arrivalDelay'),
    intermediateStops: [
      for (final stop in readMapList(json, 'intermediateStops')) _place(stop),
    ],
    steps: [for (final step in readMapList(json, 'steps')) _step(step)],
  );
}

Place _place(JsonMap json) => Place(
  name: readOptString(json, 'name') ?? '',
  lat: readDouble(json, 'lat'),
  lon: readDouble(json, 'lon'),
  vertexType: readOptString(json, 'vertexType') ?? 'NORMAL',
  stopId: _stopId(json['stopId']),
  stopCode: readOptString(json, 'stopCode'),
  bikeShareId: readOptString(json, 'bikeShareId'),
);

/// OTP 1.x sends `stopId` as `"1:1234"`, or as `{agencyId, id}` on older
/// builds.
String? _stopId(Object? value) {
  if (value is String && value.isNotEmpty) return value;
  final map = asOptMap(value);
  if (map == null) return null;
  final id = readOptString(map, 'id');
  final agency = readOptString(map, 'agencyId');
  if (id == null) return null;
  return agency == null ? id : '$agency:$id';
}

LegStep _step(JsonMap json) => LegStep(
  distance: readOptDouble(json, 'distance') ?? 0,
  streetName: readOptString(json, 'streetName') ?? '',
  relativeDirection: readOptString(json, 'relativeDirection'),
  elevationChange: readOptDouble(json, 'elevationChange'),
  lat: readDouble(json, 'lat'),
  lon: readDouble(json, 'lon'),
);
