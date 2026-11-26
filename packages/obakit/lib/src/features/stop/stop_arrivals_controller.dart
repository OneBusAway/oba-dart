import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:obakit_core/obakit_core.dart';

import '../../widgets/loader.dart';
import '../../app/polling.dart';

enum StopArrivalsStatus { loading, loaded, error }

/// An immutable snapshot of a stop's departures.
@immutable
class StopArrivalsState {
  const StopArrivalsState({
    this.status = StopArrivalsStatus.loading,
    this.stop,
    this.entry,
    this.references = References.empty,
    this.updatedAt,
    this.error,
    this.isRefreshing = false,
    this.stopIsMissing = false,
  });

  final StopArrivalsStatus status;

  /// The stop, from the response references.
  final Stop? stop;
  final StopWithArrivalsAndDepartures? entry;
  final References references;

  /// Server time of the last successful fetch.
  final DateTime? updatedAt;

  /// The latest fetch's failure. With data ([hasData]) the data is stale.
  final Object? error;
  final bool isRefreshing;

  /// The server has no stop with this id.
  final bool stopIsMissing;

  bool get hasData => updatedAt != null;
  bool get isStale => hasData && error != null;

  List<ArrivalAndDeparture> get rawArrivals =>
      entry?.arrivalsAndDepartures ?? const [];

  StopArrivalsState copyWith({
    StopArrivalsStatus? status,
    Object? error,
    bool clearError = false,
    bool? isRefreshing,
  }) => StopArrivalsState(
    status: status ?? this.status,
    stop: stop,
    entry: entry,
    references: references,
    updatedAt: updatedAt,
    error: clearError ? null : (error ?? this.error),
    isRefreshing: isRefreshing ?? this.isRefreshing,
    stopIsMissing: stopIsMissing,
  );
}

/// Fetches and polls one stop's departures for the stop page (iOS
/// `StopViewModel`'s data half).
///
/// - Window: [minutesBefore] in the past and [minutesAfter] ahead.
///   [loadMore] extends the window by 30 minutes, up to 12 hours; an empty
///   response extends it automatically (by 60, then 120 minutes).
/// - Polling: every [refreshInterval] while held ([acquire]/[release]);
///   the stop page holds it while visible and the app is in the
///   foreground.
/// - Time: [now] is the server's clock (offset from the latest response).
/// - Failures keep the last data and set `state.error` (stale).
class StopArrivalsController extends ChangeNotifier
    with ObaDisposeSafeNotifier, ObaPollingController {
  StopArrivalsController({
    required this.stopId,
    required this._client,
    this.minutesBefore = 5,
    this._minutesAfter = defaultMinutesAfter,
    this.refreshInterval = const Duration(seconds: 30),
    this.autoExtend = true,
  });

  static const defaultMinutesAfter = 35;
  static const maxMinutesAfter = 720;
  static const loadMoreStep = 30;

  final String stopId;
  final OneBusAwayClient? Function() _client;
  final int minutesBefore;
  @override
  final Duration refreshInterval;

  /// Whether an empty response widens the window by itself.
  final bool autoExtend;

  int _minutesAfter;
  int get minutesAfter => _minutesAfter;

  bool get isLoadMoreExhausted => _minutesAfter >= maxMinutesAfter;

  StopArrivalsState _state = const StopArrivalsState();
  StopArrivalsState get state => _state;

  /// Widens the window by [loadMoreStep] minutes and refetches.
  Future<void> loadMore() async {
    if (isLoadMoreExhausted) return;
    _minutesAfter = (_minutesAfter + loadMoreStep).clamp(0, maxMinutesAfter);
    await refresh();
  }

  @override
  Future<void> refresh() async {
    final generation = beginFetch();
    _emit(_state.copyWith(isRefreshing: true));
    final client = _client();
    StopArrivalsState next;
    var extend = false;
    try {
      if (client == null) throw const ObaNoRegionException();
      final r = await client.arrivalsAndDepartures.forStop(
        stopId,
        minutesBefore: minutesBefore,
        minutesAfter: _minutesAfter,
      );
      if (!isCurrent(generation)) return;
      updateServerTime(r.currentTime);
      next = StopArrivalsState(
        status: StopArrivalsStatus.loaded,
        stop: r.references.stop(r.entry.stopId),
        entry: r.entry,
        references: r.references,
        updatedAt: r.currentTime,
      );
      extend =
          autoExtend &&
          r.entry.arrivalsAndDepartures.isEmpty &&
          !isLoadMoreExhausted;
    } on ObaApiException catch (e) {
      if (!isCurrent(generation)) return;
      next = e.isNullBody || e.code == 404
          ? const StopArrivalsState(
              status: StopArrivalsStatus.error,
              stopIsMissing: true,
            )
          : _failed(e);
    } catch (e) {
      if (!isCurrent(generation)) return;
      next = _failed(e);
    }
    _emit(next);
    if (extend) {
      _minutesAfter = (_minutesAfter + (_minutesAfter < 240 ? 60 : 120)).clamp(
        0,
        maxMinutesAfter,
      );
      return refresh();
    }
    scheduleNextPoll();
  }

  StopArrivalsState _failed(Object e) => _state.hasData
      ? _state.copyWith(error: e, isRefreshing: false)
      : StopArrivalsState(status: StopArrivalsStatus.error, error: e);

  void _emit(StopArrivalsState s) {
    if (isDisposed) return;
    _state = s;
    notifyListeners();
  }
}
