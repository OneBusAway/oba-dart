import 'planner_error_code.dart';

/// Every failure the OTP client raises. Switch on the subtype to decide what
/// to show; [TripPlannerStrings.errorMessage] does that for the bundled UI.
sealed class OtpException implements Exception {
  const OtpException(this.message);

  /// Developer-facing detail. Not localized; don't show it to riders.
  final String message;

  /// Whether retrying the same request might succeed.
  bool get isRetryable => true;

  /// Whether a client configured with both API flavours should retry the
  /// request against the other one. Planner errors ("no route") are answers,
  /// not failures, so they never trigger a fallback.
  bool get triggersFallback => true;

  @override
  String toString() => '$runtimeType: $message';
}

/// The server answered with a status other than 200.
final class OtpHttpException extends OtpException {
  const OtpHttpException(this.statusCode, [String? message])
    : super(message ?? 'HTTP $statusCode');

  final int statusCode;
}

/// The request never got an answer: DNS, TLS, connection reset, timeout.
final class OtpNetworkException extends OtpException {
  const OtpNetworkException(super.message, [this.cause]);

  final Object? cause;
}

/// The response was not the JSON shape the decoder expects.
final class OtpFormatException extends OtpException {
  const OtpFormatException(super.message, [this.cause]);

  final Object? cause;
}

/// The GraphQL endpoint returned a top-level `errors` array (bad query,
/// schema mismatch, server fault). [messages] holds every message; [message]
/// is the first, matching OTPKit.
final class OtpGraphQLException extends OtpException {
  OtpGraphQLException(List<String> messages)
    : messages = List.unmodifiable(messages),
      super(messages.isEmpty ? 'GraphQL error' : messages.first);

  final List<String> messages;
}

/// The planner ran but could not produce a trip: a REST `error` object or a
/// GraphQL `routingErrors` entry. Riders see [code]'s message.
final class OtpPlannerException extends OtpException {
  const OtpPlannerException(this.code, super.message, {this.id});

  final PlannerErrorCode code;

  /// OTP 1.x error id; GraphQL routing errors have none.
  final int? id;

  @override
  bool get triggersFallback => false;

  @override
  bool get isRetryable => switch (code) {
    PlannerErrorCode.systemError ||
    PlannerErrorCode.graphUnavailable ||
    PlannerErrorCode.requestTimeout ||
    PlannerErrorCode.unknown => true,
    _ => false,
  };
}
