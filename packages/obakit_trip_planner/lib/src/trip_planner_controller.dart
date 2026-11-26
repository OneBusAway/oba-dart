import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import 'api/api.dart';
import 'place_search.dart';

/// When the trip should happen (OTPKit `TimePreference`).
enum TripTimeOption { leaveNow, departAt, arriveBy }

enum TripPlannerStatus {
  /// Nothing planned for the current inputs yet.
  idle,
  loading,

  /// [TripPlannerState.plan] holds the answer (possibly no itineraries).
  loaded,

  /// [TripPlannerState.error] says why planning failed.
  error,
}

/// Raised in state, not thrown, when planning is attempted without both
/// endpoints (OTPKit `missingOriginOrDestination`).
class MissingTripEndpointsError implements Exception {
  const MissingTripEndpointsError();

  @override
  String toString() => 'MissingTripEndpointsError';
}

const _unset = Object();

/// Immutable snapshot of the planner form and its results.
@immutable
class TripPlannerState {
  const TripPlannerState({
    this.origin,
    this.destination,
    this.timeOption = TripTimeOption.leaveNow,
    this.dateTime,
    this.mode = TransportMode.transit,
    this.wheelchairAccessible = false,
    this.maxWalkDistance = WalkingDistance.oneMile,
    this.status = TripPlannerStatus.idle,
    this.plan,
    this.error,
    this.selectedIndex,
  });

  final TripPlace? origin;
  final TripPlace? destination;
  final TripTimeOption timeOption;

  /// The chosen departure or arrival time. Ignored for
  /// [TripTimeOption.leaveNow], where the request time is "now".
  final DateTime? dateTime;
  final TransportMode mode;
  final bool wheelchairAccessible;
  final WalkingDistance maxWalkDistance;
  final TripPlannerStatus status;

  /// The latest answer for the current inputs. Cleared when inputs change.
  final TripPlan? plan;

  /// Set when [status] is [TripPlannerStatus.error]: an [OtpException],
  /// [MissingTripEndpointsError], or whatever a custom service threw.
  final Object? error;

  /// Index into [itineraries] of the itinerary the rider opened.
  final int? selectedIndex;

  bool get canPlan => origin != null && destination != null;
  bool get isLoading => status == TripPlannerStatus.loading;
  List<Itinerary> get itineraries => plan?.itineraries ?? const [];

  TripPlannerState copyWith({
    Object? origin = _unset,
    Object? destination = _unset,
    TripTimeOption? timeOption,
    Object? dateTime = _unset,
    TransportMode? mode,
    bool? wheelchairAccessible,
    WalkingDistance? maxWalkDistance,
    TripPlannerStatus? status,
    Object? plan = _unset,
    Object? error = _unset,
    Object? selectedIndex = _unset,
  }) => TripPlannerState(
    origin: identical(origin, _unset) ? this.origin : origin as TripPlace?,
    destination: identical(destination, _unset)
        ? this.destination
        : destination as TripPlace?,
    timeOption: timeOption ?? this.timeOption,
    dateTime: identical(dateTime, _unset)
        ? this.dateTime
        : dateTime as DateTime?,
    mode: mode ?? this.mode,
    wheelchairAccessible: wheelchairAccessible ?? this.wheelchairAccessible,
    maxWalkDistance: maxWalkDistance ?? this.maxWalkDistance,
    status: status ?? this.status,
    plan: identical(plan, _unset) ? this.plan : plan as TripPlan?,
    error: identical(error, _unset) ? this.error : error,
    selectedIndex: identical(selectedIndex, _unset)
        ? this.selectedIndex
        : selectedIndex as int?,
  );
}

/// Owns the trip planner form and plans trips through a [TripPlanService].
///
/// Changing any input (endpoints, time, mode, options) clears the results
/// and drops any request in flight, so the results on screen always match
/// the form. Planning is explicit: call [plan].
class TripPlannerController extends ChangeNotifier {
  TripPlannerController({
    required this.service,
    TripPlace? origin,
    TripPlace? destination,
    List<TransportMode> enabledModes = defaultModes,
    TransportMode? initialMode,
    bool wheelchairAccessible = false,
    WalkingDistance maxWalkDistance = WalkingDistance.oneMile,
    this.onError,
  }) : enabledModes = List.unmodifiable(enabledModes) {
    final modes = availableModes;
    final mode = initialMode != null && modes.contains(initialMode)
        ? initialMode
        : (modes.isEmpty ? TransportMode.transit : modes.first);
    _state = TripPlannerState(
      origin: origin,
      destination: destination,
      mode: mode,
      wheelchairAccessible: wheelchairAccessible,
      maxWalkDistance: maxWalkDistance,
    );
  }

  /// OTPKit's defaults. Rental modes are opt-in.
  static const defaultModes = [
    TransportMode.transit,
    TransportMode.walk,
    TransportMode.bike,
    TransportMode.car,
  ];

  final TripPlanService service;

  /// Modes configured by the host; see [availableModes].
  final List<TransportMode> enabledModes;

  /// Called for each failed plan the controller applies, after [state]
  /// records it. Useful for logging. Not called for stale requests.
  final void Function(Object error, StackTrace stackTrace)? onError;

  late TripPlannerState _state;
  int _generation = 0;
  bool _disposed = false;

  TripPlannerState get state => _state;

  /// [enabledModes] minus rental modes when [service] can't plan them.
  List<TransportMode> get availableModes => [
    for (final mode in enabledModes)
      if (!mode.requiresVehicleRentalSupport || service.supportsVehicleRental)
        mode,
  ];

  void _set(TripPlannerState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  /// Applies an input change, invalidating results and in-flight requests.
  void _edit(TripPlannerState next) {
    _generation++;
    _set(
      next.copyWith(
        status: TripPlannerStatus.idle,
        plan: null,
        error: null,
        selectedIndex: null,
      ),
    );
  }

  void setOrigin(TripPlace? place) => _edit(_state.copyWith(origin: place));

  void setDestination(TripPlace? place) =>
      _edit(_state.copyWith(destination: place));

  /// Sets the origin only if it is still empty: for filling in the current
  /// location after an async lookup without overwriting the rider's choice.
  void setOriginIfEmpty(TripPlace place) {
    if (_state.origin == null) setOrigin(place);
  }

  void swapEndpoints() => _edit(
    _state.copyWith(origin: _state.destination, destination: _state.origin),
  );

  /// Switching to depart-at or arrive-by without a time picks "now",
  /// rounded down to the minute.
  void setTimeOption(TripTimeOption option) {
    final needsTime = option != TripTimeOption.leaveNow;
    _edit(
      _state.copyWith(
        timeOption: option,
        dateTime: needsTime && _state.dateTime == null
            ? _minute(clock.now())
            : _state.dateTime,
      ),
    );
  }

  /// Sets the departure/arrival time, switching from leave-now to
  /// depart-at if needed.
  void setDateTime(DateTime dateTime) => _edit(
    _state.copyWith(
      dateTime: dateTime,
      timeOption: _state.timeOption == TripTimeOption.leaveNow
          ? TripTimeOption.departAt
          : null,
    ),
  );

  void setMode(TransportMode mode) {
    if (mode == _state.mode) return;
    _edit(_state.copyWith(mode: mode));
  }

  void setWheelchairAccessible(bool value) =>
      _edit(_state.copyWith(wheelchairAccessible: value));

  void setMaxWalkDistance(WalkingDistance value) =>
      _edit(_state.copyWith(maxWalkDistance: value));

  /// Opens (or, with null, closes) an itinerary from the results.
  void selectItinerary(int? index) {
    if (index == _state.selectedIndex) return;
    _set(_state.copyWith(selectedIndex: index));
  }

  /// Clears the endpoints, results, and time choice. Mode and options stay.
  void reset() => _edit(
    _state.copyWith(
      origin: null,
      destination: null,
      timeOption: TripTimeOption.leaveNow,
      dateTime: null,
    ),
  );

  /// The request [plan] would send now, or null without both endpoints.
  TripPlanRequest? buildRequest() {
    final origin = _state.origin;
    final destination = _state.destination;
    if (origin == null || destination == null) return null;
    final when = _state.timeOption == TripTimeOption.leaveNow
        ? clock.now()
        : (_state.dateTime ?? clock.now());
    return TripPlanRequest(
      origin: origin.coordinate,
      destination: destination.coordinate,
      dateTime: when,
      transportModes: _state.mode.apiModes,
      maxWalkDistance: _state.maxWalkDistance.meters,
      wheelchairAccessible: _state.wheelchairAccessible,
      arriveBy: _state.timeOption == TripTimeOption.arriveBy,
    );
  }

  /// Plans the trip for the current inputs. Completes when the result (or
  /// error) is in [state]; never throws.
  Future<void> plan() async {
    final request = buildRequest();
    if (request == null) {
      _generation++;
      _set(
        _state.copyWith(
          status: TripPlannerStatus.error,
          plan: null,
          error: const MissingTripEndpointsError(),
          selectedIndex: null,
        ),
      );
      return;
    }

    final generation = ++_generation;
    _set(
      _state.copyWith(
        status: TripPlannerStatus.loading,
        plan: null,
        error: null,
        selectedIndex: null,
      ),
    );

    try {
      final plan = await service.plan(request);
      if (_disposed || generation != _generation) return;
      _set(_state.copyWith(status: TripPlannerStatus.loaded, plan: plan));
    } catch (error, stackTrace) {
      if (_disposed || generation != _generation) return;
      _set(_state.copyWith(status: TripPlannerStatus.error, error: error));
      _reportError(error, stackTrace);
    }
  }

  void _reportError(Object error, StackTrace stackTrace) {
    final callback = onError;
    if (callback == null) return;
    try {
      callback(error, stackTrace);
    } catch (e, s) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: s,
          library: 'obakit_trip_planner',
          context: ErrorDescription(
            'while calling TripPlannerController.onError',
          ),
        ),
      );
    }
  }

  static DateTime _minute(DateTime t) =>
      DateTime(t.year, t.month, t.day, t.hour, t.minute);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
