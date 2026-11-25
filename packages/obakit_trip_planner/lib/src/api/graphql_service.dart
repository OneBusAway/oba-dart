import 'dart:convert';

import 'package:http/http.dart' as http;

import 'errors.dart';
import 'http_support.dart';
import 'json.dart';
import 'models.dart';
import 'planner_error_code.dart';
import 'request.dart';
import 'trip_plan_service.dart';

/// OTP 2.x GTFS GraphQL planner (`POST {base}/gtfs/v1`). Port of OTPKit's
/// `GraphQLAPIService` (trip planning only; vehicle rental browsing is not
/// ported).
class OtpGraphQLService implements TripPlanService {
  /// [baseUrl] is the OTP root (`https://host/otp/`). A trailing
  /// `routers/<id>` segment is stripped and `gtfs/v1` appended, so either
  /// flavour of server URL works.
  OtpGraphQLService({
    required Uri baseUrl,
    required http.Client httpClient,
    this.headers = const {},
    this.timeout = const Duration(seconds: 30),
  }) : endpoint = normalizeEndpoint(baseUrl),
       _http = httpClient;

  /// The GraphQL endpoint requests are POSTed to.
  final Uri endpoint;
  final Map<String, String> headers;
  final Duration timeout;
  final http.Client _http;

  static Uri normalizeEndpoint(Uri url) {
    final stripped = stripOtpRouterPath(url);
    final path = stripped.path.replaceAll(RegExp(r'/+$'), '');
    if (path.endsWith('/gtfs/v1')) return stripped.replace(path: path);
    return stripped.replace(path: '$path/gtfs/v1');
  }

  @override
  bool get supportsVehicleRental => true;

  /// The POST body for [request]: `{query, variables}`.
  Map<String, Object?> buildBody(TripPlanRequest request) => {
    'query': planQuery(includingVia: request.viaPoint != null),
    'variables': planVariables(request),
  };

  static Map<String, Object?> planVariables(TripPlanRequest request) => {
    'from': {'lat': request.origin.lat, 'lon': request.origin.lon},
    'to': {'lat': request.destination.lat, 'lon': request.destination.lon},
    'date': request.formattedDate,
    'time': request.formattedTime,
    'transportModes': [
      for (final mode in request.wireTransportModes) _graphQLMode(mode),
    ],
    'arriveBy': request.arriveBy,
    'wheelchair': request.wheelchairAccessible,
    'maxWalkDistance': request.maxWalkDistance.toDouble(),
    // Omitted when absent: null and missing `via` aren't treated alike by
    // every OTP build.
    if (request.viaPoint case final via?)
      'via': [
        {
          'visit': {
            'coordinate': {'latitude': via.lat, 'longitude': via.lon},
          },
        },
      ],
  };

  static Map<String, String> _graphQLMode(TransportMode mode) => switch (mode) {
    TransportMode.bike => const {'mode': 'BICYCLE'},
    TransportMode.bikeRental => const {'mode': 'BICYCLE', 'qualifier': 'RENT'},
    // Unreachable: wireTransportModes expands composites first.
    TransportMode.transitBikeRental => const {'mode': 'TRANSIT'},
    TransportMode.transit ||
    TransportMode.walk ||
    TransportMode.car => {'mode': mode.wireValue},
  };

  @override
  Future<TripPlan> plan(TripPlanRequest request) async {
    final json = await sendForJson(
      () => _http.post(
        endpoint,
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode(buildBody(request)),
      ),
      timeout: timeout,
    );
    return parseOrThrow(() => parseGraphQLPlanResponse(json));
  }

  /// The GTFS GraphQL `plan` query. `via` is declared only when used: its
  /// input type exists only on OTP 2.7+, and GraphQL validates documents
  /// statically. Adds `route.longName` to OTPKit's field set.
  static String planQuery({required bool includingVia}) {
    final viaDeclaration = includingVia
        ? '\n  \$via: [PlanViaLocationInput!]'
        : '';
    final viaArgument = includingVia ? '\n    via: \$via' : '';
    return '''
query TripPlan(
  \$from: InputCoordinates!
  \$to: InputCoordinates!
  \$date: String!
  \$time: String!
  \$transportModes: [TransportMode!]
  \$arriveBy: Boolean
  \$wheelchair: Boolean
  \$maxWalkDistance: Float$viaDeclaration
) {
  plan(
    from: \$from
    to: \$to
    date: \$date
    time: \$time
    transportModes: \$transportModes
    arriveBy: \$arriveBy
    wheelchair: \$wheelchair
    maxWalkDistance: \$maxWalkDistance$viaArgument
  ) {
    date
    from { name lon lat vertexType }
    to { name lon lat vertexType }
    routingErrors { code description }
    itineraries {
      duration
      startTime
      endTime
      walkTime
      waitingTime
      walkDistance
      elevationLost
      elevationGained
      numberOfTransfers
      legs {
        startTime
        endTime
        mode
        route { shortName longName type color textColor agency { name } }
        from {
          name lon lat vertexType stop { gtfsId code }
          vehicleRentalStation { stationId }
          rentalVehicle { vehicleId }
        }
        to {
          name lon lat vertexType stop { gtfsId code }
          vehicleRentalStation { stationId }
          rentalVehicle { vehicleId }
        }
        legGeometry { points length }
        distance
        transitLeg
        rentedBike
        duration
        realTime
        departureDelay
        arrivalDelay
        headsign
        intermediatePlaces { name lon lat vertexType stop { gtfsId code } }
        steps { distance streetName relativeDirection lon lat }
      }
    }
  }
}''';
  }
}

/// Decodes a GraphQL `plan` response. Top-level `errors` throw
/// [OtpGraphQLException]; an empty result with a routing error throws
/// [OtpPlannerException] (`WALKING_BETTER_THAN_TRANSIT` is advisory and
/// ignored).
TripPlan parseGraphQLPlanResponse(JsonMap json) {
  final errors = readMapList(json, 'errors');
  if (errors.isNotEmpty) {
    throw OtpGraphQLException([
      for (final error in errors) readOptString(error, 'message') ?? 'Error',
    ]);
  }
  final plan = asOptMap(asOptMap(json['data'])?['plan']);
  if (plan == null) throw const OtpFormatException('Response has no plan');

  final itineraries = [
    for (final itinerary in readMapList(plan, 'itineraries'))
      _itinerary(itinerary),
  ];
  if (itineraries.isEmpty) {
    for (final error in readMapList(plan, 'routingErrors')) {
      final code = readOptString(error, 'code') ?? '';
      if (code == 'WALKING_BETTER_THAN_TRANSIT') continue;
      throw OtpPlannerException(
        PlannerErrorCode.fromGraphQLRoutingError(code),
        readOptString(error, 'description') ?? code,
      );
    }
  }

  return TripPlan(
    date: readEpochMillis(plan, 'date'),
    from: _place(asMap(plan['from'], 'from')),
    to: _place(asMap(plan['to'], 'to')),
    itineraries: itineraries,
    source: OtpApiFlavor.graphql,
  );
}

Itinerary _itinerary(JsonMap json) {
  final duration = readInt(json, 'duration');
  final walkTime = readOptInt(json, 'walkTime') ?? 0;
  final waitingTime = readOptInt(json, 'waitingTime') ?? 0;
  return Itinerary(
    duration: duration,
    startTime: readEpochMillis(json, 'startTime'),
    endTime: readEpochMillis(json, 'endTime'),
    walkTime: walkTime,
    waitingTime: waitingTime,
    transitTime: duration - walkTime - waitingTime < 0
        ? 0
        : duration - walkTime - waitingTime,
    walkDistance: readOptDouble(json, 'walkDistance') ?? 0,
    elevationLost: readOptDouble(json, 'elevationLost') ?? 0,
    elevationGained: readOptDouble(json, 'elevationGained') ?? 0,
    transfers: readOptInt(json, 'numberOfTransfers') ?? 0,
    legs: [for (final leg in readMapList(json, 'legs')) _leg(leg)],
  );
}

Leg _leg(JsonMap json) {
  final route = asOptMap(json['route']);
  final geometry = asOptMap(json['legGeometry']);
  final agency = route == null ? null : asOptMap(route['agency']);
  return Leg(
    startTime: readEpochMillis(json, 'startTime'),
    endTime: readEpochMillis(json, 'endTime'),
    mode: readOptString(json, 'mode') ?? 'WALK',
    routeShortName: route == null ? null : readOptString(route, 'shortName'),
    routeLongName: route == null ? null : readOptString(route, 'longName'),
    routeType: route == null
        ? null
        : RouteType.fromGtfs(readOptInt(route, 'type')),
    routeColor: route == null ? null : readOptString(route, 'color'),
    routeTextColor: route == null ? null : readOptString(route, 'textColor'),
    agencyName: agency == null ? null : readOptString(agency, 'name'),
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
      for (final stop in readMapList(json, 'intermediatePlaces')) _place(stop),
    ],
    steps: [for (final step in readMapList(json, 'steps')) _step(step)],
  );
}

Place _place(JsonMap json) {
  final stop = asOptMap(json['stop']);
  final station = asOptMap(json['vehicleRentalStation']);
  final vehicle = asOptMap(json['rentalVehicle']);
  return Place(
    name: readOptString(json, 'name') ?? '',
    lat: readDouble(json, 'lat'),
    lon: readDouble(json, 'lon'),
    vertexType: readOptString(json, 'vertexType') ?? 'NORMAL',
    stopId: stop == null ? null : readOptString(stop, 'gtfsId'),
    stopCode: stop == null ? null : readOptString(stop, 'code'),
    bikeShareId:
        (station == null ? null : readOptString(station, 'stationId')) ??
        (vehicle == null ? null : readOptString(vehicle, 'vehicleId')),
  );
}

LegStep _step(JsonMap json) => LegStep(
  distance: readOptDouble(json, 'distance') ?? 0,
  streetName: readOptString(json, 'streetName') ?? '',
  relativeDirection: readOptString(json, 'relativeDirection'),
  lat: readDouble(json, 'lat'),
  lon: readDouble(json, 'lon'),
);
