import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/errors.dart';
import '../core/json.dart';

/// Joins [path] onto [base], keeping any path prefix already on [base].
Uri joinUrl(Uri base, String path, [Map<String, String> query = const {}]) {
  final prefix = base.path.endsWith('/')
      ? base.path.substring(0, base.path.length - 1)
      : base.path;
  final suffix = path.startsWith('/') ? path : '/$path';
  final params = {...base.queryParameters, ...query};
  return base.replace(
    path: '$prefix$suffix',
    queryParameters: params.isEmpty ? null : params,
  );
}

/// Sends requests and maps every failure to an [ObaException].
class HttpSupport {
  HttpSupport({required this.httpClient, required this.timeout});

  final http.Client httpClient;
  final Duration timeout;

  Future<http.Response> send(
    String method,
    Uri uri, {
    Map<String, String>? form,
    Object? jsonBody,
  }) async {
    final request = http.Request(method, uri);
    request.headers['Accept'] = 'application/json';
    if (form != null) {
      request.bodyFields = form;
    } else if (jsonBody != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(jsonBody);
    }
    final http.Response response;
    try {
      response = await http.Response.fromStream(
        await httpClient.send(request).timeout(timeout),
      ).timeout(timeout);
    } on Exception catch (e) {
      throw ObaNetworkException(e);
    }
    final status = response.statusCode;
    if (status < 200 || status >= 300) {
      throw ObaApiException(ObaApiErrorKind.httpStatus, code: status);
    }
    return response;
  }

  /// Decodes a 2xx body as JSON of any shape.
  static Object? decodeJson(http.Response response) {
    try {
      // Decoding the bytes is inside the `try` too: a body that is not
      // UTF-8 is a format error like any other, not a bare FormatException.
      final body = utf8.decode(response.bodyBytes);
      if (body.trim().isEmpty) {
        throw const ObaApiException(ObaApiErrorKind.emptyResponse);
      }
      return jsonDecode(body);
    } on FormatException catch (e) {
      throw ObaFormatException('Response is not valid JSON: ${e.message}');
    }
  }

  static JsonMap decodeObject(http.Response response) =>
      asJsonMap(decodeJson(response), 'response');
}
