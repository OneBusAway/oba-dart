import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'errors.dart';
import 'json.dart';
import 'references.dart';
import 'responses.dart';

/// A decoded, successful (`code == 200`) OBA response envelope.
class ObaEnvelope {
  const ObaEnvelope({
    required this.currentTime,
    required this.version,
    required this.data,
  });

  final DateTime currentTime;
  final int version;
  final JsonMap data;

  ObaEntryResponse<T> toEntry<T>(T Function(JsonMap json) parse) =>
      ObaEntryResponse(
        entry: parse(readMap(data, 'entry')),
        references: References.fromJson(readOptMap(data, 'references')),
        currentTime: currentTime,
        version: version,
      );

  ObaListResponse<T> toList<T>(T Function(JsonMap json) parse) =>
      ObaListResponse(
        list: readList(
          data,
          'list',
          (item) => parse(asJsonMap(item, 'list[]')),
        ),
        references: References.fromJson(readOptMap(data, 'references')),
        currentTime: currentTime,
        version: version,
        limitExceeded: readBool(data, 'limitExceeded'),
        outOfRange: readBool(data, 'outOfRange'),
      );
}

/// Builds OBA URLs, performs GETs and decodes the shared envelope.
/// Every resource class goes through this; endpoints never touch HTTP directly.
class Transport {
  Transport({
    required Uri baseUrl,
    required this.apiKey,
    required this.httpClient,
    required this.timeout,
  }) : baseUrl = baseUrl.path.endsWith('/')
           ? baseUrl
           : baseUrl.replace(path: '${baseUrl.path}/');

  /// The OBA server root; endpoints live under `{baseUrl}api/where/`.
  final Uri baseUrl;
  final String apiKey;
  final http.Client httpClient;
  final Duration timeout;

  Uri buildUri(
    String method, {
    String? id,
    Map<String, String> params = const {},
  }) {
    final file = id == null
        ? '$method.json'
        : '$method/${Uri.encodeComponent(id)}.json';
    return baseUrl
        .resolve('api/where/$file')
        .replace(queryParameters: {'key': apiKey, ...params});
  }

  Future<ObaEnvelope> get(
    String method, {
    String? id,
    Map<String, String> params = const {},
  }) async {
    final uri = buildUri(method, id: id, params: params);
    final http.Response response;
    try {
      // Note: the timeout stops waiting but does not abort the request.
      response = await httpClient
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(timeout);
    } on Exception catch (e) {
      // TimeoutException, http.ClientException, and anything a client doesn't
      // wrap (e.g. a TLS HandshakeException raised while the body is read).
      throw ObaNetworkException(e);
    }
    return decode(response);
  }

  static ObaEnvelope decode(http.Response response) {
    final status = response.statusCode;
    if (status < 200 || status >= 300) {
      throw ObaApiException(ObaApiErrorKind.httpStatus, code: status);
    }
    final Object? decoded;
    try {
      final body = utf8.decode(response.bodyBytes);
      if (body.trim().isEmpty) {
        throw const ObaApiException(ObaApiErrorKind.emptyResponse);
      }
      decoded = jsonDecode(body);
    } on FormatException catch (e) {
      throw ObaFormatException('Response is not valid JSON: ${e.message}');
    }
    final json = asJsonMap(decoded, 'response');
    final code = readInt(json, 'code');
    if (code != 200) {
      throw ObaApiException(
        ObaApiErrorKind.envelope,
        code: code,
        text: readOptString(json, 'text'),
      );
    }
    return ObaEnvelope(
      currentTime:
          readEpochMs(json, 'currentTime') ??
          (throw const ObaFormatException('Missing "currentTime"')),
      version: readOptInt(json, 'version') ?? 1,
      data: readMap(json, 'data'),
    );
  }
}
