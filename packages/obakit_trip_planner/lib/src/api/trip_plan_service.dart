import 'models.dart';
import 'request.dart';

/// Anything that can plan a trip. [OtpClient] is the production
/// implementation; tests and hosts with their own backend can supply others.
abstract interface class TripPlanService {
  /// Plans [request]. Throws an `OtpException` on failure, including an
  /// `OtpPlannerException` when the planner found no route.
  Future<TripPlan> plan(TripPlanRequest request);

  /// Whether rental modes (`TransportMode.requiresVehicleRentalSupport`)
  /// can be planned. The UI hides them otherwise.
  bool get supportsVehicleRental;
}
