import 'package:http/http.dart' as http;

import 'core/transport.dart';
import 'resources/arrivals_and_departures.dart';
import 'resources/misc.dart';
import 'resources/problem_reports.dart';
import 'resources/routes.dart';
import 'resources/schedules.dart';
import 'resources/stops.dart';
import 'resources/trips.dart';

/// Entry point to the OneBusAway REST API.
///
/// ```dart
/// final client = OneBusAwayClient(
///   baseUrl: Uri.parse('https://realtime.sdmts.com/api/'), // server root
///   apiKey: 'org.onebusaway.iphone',
/// );
/// final r = await client.arrivalsAndDepartures.forStop('MTS_24151');
/// ```
class OneBusAwayClient {
  factory OneBusAwayClient({
    required Uri baseUrl,
    required String apiKey,
    http.Client? httpClient,
    Duration timeout = const Duration(seconds: 15),
  }) {
    final client = httpClient ?? http.Client();
    return OneBusAwayClient._(
      Transport(
        baseUrl: baseUrl,
        apiKey: apiKey,
        httpClient: client,
        timeout: timeout,
      ),
      httpClient == null,
    );
  }

  OneBusAwayClient._(this._transport, this._ownsHttpClient)
    : arrivalsAndDepartures = ArrivalsAndDeparturesResource(_transport),
      agencies = AgenciesResource(_transport),
      config = ConfigResource(_transport),
      currentTime = CurrentTimeResource(_transport),
      problemReports = ProblemReportsResource(_transport),
      routes = RoutesResource(_transport),
      schedules = SchedulesResource(_transport),
      shapes = ShapesResource(_transport),
      stops = StopsResource(_transport),
      trips = TripsResource(_transport),
      vehicles = VehiclesResource(_transport);

  final Transport _transport;
  final bool _ownsHttpClient;

  final ArrivalsAndDeparturesResource arrivalsAndDepartures;

  /// `agencies-with-coverage`.
  final AgenciesResource agencies;

  /// `config` (server identity).
  final ConfigResource config;

  /// `current-time`.
  final CurrentTimeResource currentTime;

  /// `report-problem-with-stop` and `report-problem-with-trip`.
  final ProblemReportsResource problemReports;

  /// `routes-for-location`.
  final RoutesResource routes;

  /// `schedule-for-stop` and `schedule-for-route`.
  final SchedulesResource schedules;

  /// `shape`.
  final ShapesResource shapes;

  /// `stops-for-location`, `stop` and `stops-for-route`.
  final StopsResource stops;

  /// `trip-details` and `trip-for-vehicle`.
  final TripsResource trips;

  /// `vehicle`.
  final VehiclesResource vehicles;

  /// Closes the underlying HTTP client if this instance created it.
  void close() {
    if (_ownsHttpClient) _transport.httpClient.close();
  }
}
