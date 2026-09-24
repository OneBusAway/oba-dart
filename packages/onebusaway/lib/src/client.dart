import 'package:http/http.dart' as http;

import 'core/transport.dart';
import 'resources/arrivals_and_departures.dart';

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
    : arrivalsAndDepartures = ArrivalsAndDeparturesResource(_transport);

  final Transport _transport;
  final bool _ownsHttpClient;

  final ArrivalsAndDeparturesResource arrivalsAndDepartures;

  /// Closes the underlying HTTP client if this instance created it.
  void close() {
    if (_ownsHttpClient) _transport.httpClient.close();
  }
}
