import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:obakit_core/obakit_core.dart';

import '../../widgets/loader.dart';
import '../../app/polling.dart';
import '../../navigation/oba_route.dart';

/// A snapshot of a trip page's data.
@immutable
class TripState {
  const TripState({
    this.details,
    this.arrival,
    this.references = References.empty,
    this.updatedAt,
    this.error,
    this.isRefreshing = false,
  });

  final TripDetails? details;

  /// The trip's visit to the rider's stop, when the trip page was opened
  /// from one.
  final ArrivalAndDeparture? arrival;
  final References references;
  final DateTime? updatedAt;
  final Object? error;
  final bool isRefreshing;

  bool get hasData => details != null;
  bool get isStale => hasData && error != null;

  /// The freshest real-time status: the arrival's, else the trip's.
  TripStatus? get status => arrival?.tripStatus ?? details?.status;

  TripState copyWith({Object? error, bool? isRefreshing}) => TripState(
    details: details,
    arrival: arrival,
    references: references,
    updatedAt: updatedAt,
    error: error ?? this.error,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );
}

/// Fetches and polls `trip-details` and, when the trip was opened from a
/// stop, `arrival-and-departure-for-stop` (iOS `TripViewController`'s
/// data loading).
class TripController extends ChangeNotifier
    with ObaDisposeSafeNotifier, ObaPollingController {
  TripController({
    required this.trip,
    required this._client,
    this.refreshInterval = const Duration(seconds: 30),
  });

  final TripRef trip;
  final OneBusAwayClient? Function() _client;
  @override
  final Duration refreshInterval;

  TripState _state = const TripState();
  TripState get state => _state;

  @override
  Future<void> refresh() async {
    final generation = beginFetch();
    _emit(_state.copyWith(isRefreshing: true));
    final client = _client();
    TripState next;
    try {
      if (client == null) throw const ObaNoRegionException();
      final stopId = trip.stopId;
      final results = await Future.wait([
        client.trips.details(
          trip.tripId,
          serviceDate: trip.serviceDate,
          vehicleId: trip.vehicleId,
        ),
        if (stopId != null)
          client.arrivalsAndDepartures
              .forTripAtStop(
                stopId,
                tripId: trip.tripId,
                serviceDate: trip.serviceDate,
                vehicleId: trip.vehicleId,
                stopSequence: trip.stopSequence ?? 0,
              )
              .then<ObaEntryResponse<ArrivalAndDeparture>?>((r) => r)
              // The arrival is optional; the stop list stands alone.
              .catchError((Object _) => null),
      ]);
      if (!isCurrent(generation)) return;
      final details = results[0]! as ObaEntryResponse<TripDetails>;
      final arrival = results.length > 1
          ? results[1] as ObaEntryResponse<ArrivalAndDeparture>?
          : null;
      updateServerTime(details.currentTime);
      next = TripState(
        details: details.entry,
        arrival: arrival?.entry,
        references: arrival == null
            ? details.references
            : details.references.merge(arrival.references),
        updatedAt: details.currentTime,
      );
    } catch (e) {
      if (!isCurrent(generation)) return;
      next = _state.hasData
          ? _state.copyWith(error: e, isRefreshing: false)
          : TripState(error: e);
    }
    _emit(next);
    scheduleNextPoll();
  }

  void _emit(TripState s) {
    if (isDisposed) return;
    _state = s;
    notifyListeners();
  }
}

extension on References {
  References merge(References other) => References(
    agencies: {...agencies, ...other.agencies},
    routes: {...routes, ...other.routes},
    stops: {...stops, ...other.stops},
    trips: {...trips, ...other.trips},
    situations: {...situations, ...other.situations},
  );
}
