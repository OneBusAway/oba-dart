import 'package:http/http.dart' as http;

import 'errors.dart';
import 'graphql_service.dart';
import 'models.dart';
import 'request.dart';
import 'rest_service.dart';
import 'trip_plan_service.dart';

/// The OTP trip planning client. Prefers the OTP 2.x GraphQL API and falls
/// back to the OTP 1.x REST API.
///
/// Configure it from an OBA region: `otpBaseGraphqlUrl` as [graphqlBaseUrl]
/// and `otpBaseUrl` as [restBaseUrl]. Either may be null, not both.
///
/// When both are set, a request goes to GraphQL first and is retried over
/// REST only if GraphQL *failed* (network, HTTP status, malformed response,
/// GraphQL `errors`). A planner answer such as "no route" is returned as is.
class OtpClient implements TripPlanService {
  OtpClient({
    Uri? graphqlBaseUrl,
    Uri? restBaseUrl,
    http.Client? httpClient,
    Map<String, String> headers = const {},
    Duration timeout = const Duration(seconds: 30),
  }) : assert(
         graphqlBaseUrl != null || restBaseUrl != null,
         'Pass graphqlBaseUrl, restBaseUrl, or both.',
       ),
       _ownsHttpClient = httpClient == null,
       _http = httpClient ?? http.Client() {
    graphql = graphqlBaseUrl == null
        ? null
        : OtpGraphQLService(
            baseUrl: graphqlBaseUrl,
            httpClient: _http,
            headers: headers,
            timeout: timeout,
          );
    rest = restBaseUrl == null
        ? null
        : OtpRestService(
            baseUrl: restBaseUrl,
            httpClient: _http,
            headers: headers,
            timeout: timeout,
          );
  }

  /// Parses the two URL strings an OBA region carries, ignoring blank ones.
  /// Returns null when neither is usable (the region has no trip planner).
  static OtpClient? fromRegion({
    String? otpBaseGraphqlUrl,
    String? otpBaseUrl,
    http.Client? httpClient,
  }) {
    Uri? parse(String? value) {
      if (value == null || value.trim().isEmpty) return null;
      final uri = Uri.tryParse(value.trim());
      return uri != null && uri.hasScheme ? uri : null;
    }

    final graphqlUrl = parse(otpBaseGraphqlUrl);
    final restUrl = parse(otpBaseUrl);
    if (graphqlUrl == null && restUrl == null) return null;
    return OtpClient(
      graphqlBaseUrl: graphqlUrl,
      restBaseUrl: restUrl,
      httpClient: httpClient,
    );
  }

  late final OtpGraphQLService? graphql;
  late final OtpRestService? rest;
  final http.Client _http;
  final bool _ownsHttpClient;

  @override
  bool get supportsVehicleRental => graphql != null;

  @override
  Future<TripPlan> plan(TripPlanRequest request) async {
    final graphql = this.graphql;
    final rest = this.rest;
    if (graphql == null) return rest!.plan(request);
    if (rest == null) return graphql.plan(request);
    try {
      return await graphql.plan(request);
    } on OtpException catch (e) {
      // OTP 1.x REST accepts every mode token, BICYCLE_RENT included, so any
      // request can fall back. If REST fails too, its error is the one thrown.
      if (!e.triggersFallback) rethrow;
      return rest.plan(request);
    }
  }

  /// Closes the HTTP client if this client created it.
  void close() {
    if (_ownsHttpClient) _http.close();
  }
}
