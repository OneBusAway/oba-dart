import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'errors.dart';
import 'json.dart';

/// Sends [send] with a timeout and returns the decoded JSON object, mapping
/// every failure onto an [OtpException]. Only HTTP 200 is accepted, as in
/// OTPKit's `validatedData`.
Future<JsonMap> sendForJson(
  Future<http.Response> Function() send, {
  required Duration timeout,
}) async {
  final http.Response response;
  try {
    response = await send().timeout(timeout);
  } on TimeoutException catch (e) {
    throw OtpNetworkException('Request timed out after $timeout', e);
  } on http.ClientException catch (e) {
    throw OtpNetworkException(e.message, e);
  } on OtpException {
    rethrow;
  } catch (e) {
    // SocketException, HandshakeException, ... (dart:io isn't imported so
    // this file also runs on the web).
    throw OtpNetworkException(e.toString(), e);
  }

  if (response.statusCode != 200) {
    throw OtpHttpException(response.statusCode);
  }

  final Object? decoded;
  try {
    decoded = jsonDecode(utf8.decode(response.bodyBytes));
  } on FormatException catch (e) {
    throw OtpFormatException('Response is not JSON', e);
  }
  final map = asOptMap(decoded);
  if (map == null) throw const OtpFormatException('Response is not an object');
  return map;
}

/// Parses with [parse], converting decoder crashes (a field of the wrong
/// type deep in a payload) into [OtpFormatException].
T parseOrThrow<T>(T Function() parse) {
  try {
    return parse();
  } on OtpException {
    rethrow;
  } on Object catch (e) {
    throw OtpFormatException('Unexpected response shape: $e', e);
  }
}

/// `path` joined to [base]'s path with exactly one slash.
Uri appendPath(Uri base, String path) {
  final basePath = base.path.replaceAll(RegExp(r'/+$'), '');
  return base.replace(path: '$basePath/$path');
}

final _routerSuffix = RegExp(r'/routers/[^/]+/?$');

/// True if the URL path ends with an OTP REST router segment.
bool hasOtpRouterPath(Uri url) => _routerSuffix.hasMatch(url.path);

/// [url] with any trailing `routers/<id>` segment removed.
Uri stripOtpRouterPath(Uri url) =>
    url.replace(path: url.path.replaceFirst(_routerSuffix, '/'));
