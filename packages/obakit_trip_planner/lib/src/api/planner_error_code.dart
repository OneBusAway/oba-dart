/// OTP planner message keys (OTP 1.x `Message` enum). GraphQL routing error
/// codes are mapped onto these so both flavours report the same codes.
enum PlannerErrorCode {
  systemError('SYSTEM_ERROR'),
  graphUnavailable('GRAPH_UNAVAILABLE'),
  outsideBounds('OUTSIDE_BOUNDS'),
  pathNotFound('PATH_NOT_FOUND'),
  noTransitTimes('NO_TRANSIT_TIMES'),
  requestTimeout('REQUEST_TIMEOUT'),
  bogusParameter('BOGUS_PARAMETER'),
  geocodeFromNotFound('GEOCODE_FROM_NOT_FOUND'),
  geocodeToNotFound('GEOCODE_TO_NOT_FOUND'),
  geocodeFromToNotFound('GEOCODE_FROM_TO_NOT_FOUND'),
  tooClose('TOO_CLOSE'),
  locationNotAccessible('LOCATION_NOT_ACCESSIBLE'),
  geocodeFromAmbiguous('GEOCODE_FROM_AMBIGUOUS'),
  geocodeToAmbiguous('GEOCODE_TO_AMBIGUOUS'),
  geocodeFromToAmbiguous('GEOCODE_FROM_TO_AMBIGUOUS'),
  underspecifiedTriangle('UNDERSPECIFIED_TRIANGLE'),
  triangleNotAffine('TRIANGLE_NOT_AFFINE'),
  triangleOptimizeTypeNotSet('TRIANGLE_OPTIMIZE_TYPE_NOT_SET'),
  triangleValuesNotSet('TRIANGLE_VALUES_NOT_SET'),

  /// A key this client doesn't know.
  unknown('UNKNOWN');

  const PlannerErrorCode(this.wireValue);

  final String wireValue;

  /// Parses an OTP 1.x message key; unknown keys map to [unknown].
  static PlannerErrorCode fromWire(String? value) {
    for (final code in values) {
      if (code != unknown && code.wireValue == value) return code;
    }
    return unknown;
  }

  /// Maps an OTP 2.x GraphQL `RoutingErrorCode`, as OTPKit does.
  static PlannerErrorCode fromGraphQLRoutingError(String code) =>
      switch (code) {
        'OUTSIDE_BOUNDS' => outsideBounds,
        'NO_TRANSIT_CONNECTION' || 'NO_DIRECT_MODE_CONNECTION' => pathNotFound,
        'NO_TRANSIT_CONNECTION_IN_SEARCH_WINDOW' ||
        'OUTSIDE_SERVICE_PERIOD' => noTransitTimes,
        'LOCATION_NOT_FOUND' || 'NO_STOPS_IN_RANGE' => locationNotAccessible,
        _ => unknown,
      };
}
