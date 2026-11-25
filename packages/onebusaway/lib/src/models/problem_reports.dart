/// What's wrong with a stop, for `report-problem-with-stop`.
enum StopProblemCode {
  nameWrong('stop_name_wrong'),
  numberWrong('stop_number_wrong'),
  locationWrong('stop_location_wrong'),
  routeOrTripMissing('route_or_trip_missing'),
  other('other');

  const StopProblemCode(this.wireValue);

  /// The `code` query parameter value.
  final String wireValue;
}

/// What's wrong with a trip, for `report-problem-with-trip`.
enum TripProblemCode {
  neverCame('vehicle_never_came'),
  cameEarly('vehicle_came_early'),
  cameLate('vehicle_came_late'),
  wrongHeadsign('wrong_headsign'),
  doesNotStopHere('vehicle_does_not_stop_here'),
  other('other');

  const TripProblemCode(this.wireValue);

  /// The `code` query parameter value.
  final String wireValue;
}
