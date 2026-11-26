import 'package:http/http.dart' as http;

import '../obaco/http_support.dart';
import 'region.dart';

/// Fetches the OneBusAway region list.
class RegionsClient {
  RegionsClient({
    Uri? baseUrl,
    this.path = '/regions-v3.json',
    this.apiKey,
    http.Client? httpClient,
    Duration timeout = const Duration(seconds: 30),
  }) : baseUrl = baseUrl ?? Uri.parse('https://regions.onebusaway.org'),
       _ownsClient = httpClient == null,
       _http = HttpSupport(
         httpClient: httpClient ?? http.Client(),
         timeout: timeout,
       );

  final Uri baseUrl;
  final String path;

  /// Sent as the `key` query parameter when set.
  final String? apiKey;

  final bool _ownsClient;
  final HttpSupport _http;

  Uri get regionsUri => joinUrl(baseUrl, path, {'key': ?apiKey});

  Future<List<Region>> fetch() async {
    final response = await _http.send('GET', regionsUri);
    return Region.listFromEnvelope(HttpSupport.decodeObject(response));
  }

  /// Closes the HTTP client only if this client created it.
  void close() {
    if (_ownsClient) _http.httpClient.close();
  }
}
