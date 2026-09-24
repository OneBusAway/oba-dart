/// Base class for every error thrown by the OneBusAway client.
sealed class ObaException implements Exception {
  const ObaException();

  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

enum ObaApiErrorKind {
  /// The server answered with a non-2xx HTTP status.
  httpStatus,

  /// The server answered 2xx with an empty body. SDMTS does this for an
  /// unknown id and for a rejected API key; the two can't be told apart.
  emptyResponse,

  /// The JSON envelope's `code` was not 200.
  envelope,
}

final class ObaApiException extends ObaException {
  const ObaApiException(this.kind, {this.code, this.text});

  final ObaApiErrorKind kind;
  final int? code;
  final String? text;

  @override
  String get message => switch (kind) {
        ObaApiErrorKind.httpStatus => 'HTTP status $code',
        ObaApiErrorKind.emptyResponse =>
          'Empty response (unknown id or rejected API key)',
        ObaApiErrorKind.envelope => 'OneBusAway error $code: ${text ?? ''}',
      };
}

final class ObaNetworkException extends ObaException {
  const ObaNetworkException(this.cause);

  final Object cause;

  /// Describes [cause] with the `key` query parameter of any URL in it
  /// replaced by `REDACTED`, so the API key never reaches logs.
  @override
  String get message {
    final text = cause.toString().replaceAll(_apiKeyParam, 'key=REDACTED');
    final type = '${cause.runtimeType}';
    return text.startsWith(type) ? text : '$type: $text';
  }

  static final _apiKeyParam = RegExp(r'key=[^&\s]+');
}

final class ObaFormatException extends ObaException {
  const ObaFormatException(this.message);

  @override
  final String message;
}
