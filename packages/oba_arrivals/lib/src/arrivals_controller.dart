import 'dart:async';

import 'package:clock/clock.dart' as clock_pkg;
import 'package:flutter/foundation.dart';
import 'package:onebusaway/onebusaway.dart';

enum ArrivalsStatus {
  /// No data yet; the first request is in flight.
  loading,

  /// Data is available. `ArrivalsState.error` is set if the latest refresh
  /// failed and the data is stale.
  loaded,

  /// No data and the last request failed. Stays `error` (with
  /// `ArrivalsState.isRefreshing` set) while a retry or poll is in flight;
  /// it never goes back to [loading].
  error,
}

@immutable
class ArrivalsState {
  const ArrivalsState({
    this.status = ArrivalsStatus.loading,
    this.stop,
    this.rawArrivals = const [],
    this.references = References.empty,
    this.updatedAt,
    this.error,
    this.isRefreshing = false,
  });

  final ArrivalsStatus status;
  final Stop? stop;

  /// Unfiltered, in server order. Filter with `visibleArrivals(raw, now)`.
  final List<ArrivalAndDeparture> rawArrivals;
  final References references;

  /// Server time of the last successful fetch.
  final DateTime? updatedAt;
  final Object? error;
  final bool isRefreshing;

  bool get hasData => updatedAt != null;
}

/// Fetches arrivals for one stop and polls while running.
///
/// Framework-agnostic: call [pause]/[resume] from lifecycle code (the panel
/// does this for you).
class ArrivalsController extends ChangeNotifier {
  ArrivalsController({
    required this.stopId,
    required this._client,
    this.minutesAfter = 35,
    this.refreshInterval = const Duration(seconds: 30),
    DateTime Function()? clock,
    // package:clock, not DateTime.now, so fake_async / testWidgets can
    // control time.
  }) : _clock = clock ?? (() => clock_pkg.clock.now());

  final OneBusAwayClient _client;
  final DateTime Function() _clock;
  final String stopId;
  final int minutesAfter;
  final Duration refreshInterval;

  ArrivalsState _state = const ArrivalsState();
  ArrivalsState get state => _state;

  Duration _serverOffset = Duration.zero;
  Timer? _timer;
  int _latestRequest = 0;
  bool _running = false;
  bool _disposed = false;

  bool get isRunning => _running;

  /// The current time on the server's clock.
  DateTime now() => _clock().add(_serverOffset);

  /// Starts polling, fetching immediately. No-op if already running.
  void resume() {
    if (_running) return;
    _running = true;
    unawaited(refresh());
  }

  /// Stops polling. An in-flight request still updates [state].
  void pause() {
    _running = false;
    _timer?.cancel();
    _timer = null;
  }

  /// Fetches now. When running, the next poll is scheduled
  /// [refreshInterval] after this request completes.
  Future<void> refresh() async {
    _timer?.cancel();
    _timer = null;
    final request = ++_latestRequest;
    _emit(
      ArrivalsState(
        status: _state.status,
        stop: _state.stop,
        rawArrivals: _state.rawArrivals,
        references: _state.references,
        updatedAt: _state.updatedAt,
        error: _state.error,
        isRefreshing: true,
      ),
    );

    ArrivalsState next;
    Duration? serverOffset;
    try {
      final response = await _client.arrivalsAndDepartures.forStop(
        stopId,
        minutesAfter: minutesAfter,
      );
      serverOffset = response.currentTime.difference(_clock());
      next = ArrivalsState(
        status: ArrivalsStatus.loaded,
        stop: response.references.stop(response.entry.stopId),
        rawArrivals: response.entry.arrivalsAndDepartures,
        references: response.references,
        updatedAt: response.currentTime,
      );
    } catch (error) {
      next = _state.hasData
          ? ArrivalsState(
              status: ArrivalsStatus.loaded,
              stop: _state.stop,
              rawArrivals: _state.rawArrivals,
              references: _state.references,
              updatedAt: _state.updatedAt,
              error: error,
            )
          : ArrivalsState(status: ArrivalsStatus.error, error: error);
    }

    if (_disposed || request != _latestRequest) return;
    if (serverOffset != null) _serverOffset = serverOffset;
    _emit(next);
    if (_running) _timer = Timer(refreshInterval, () => unawaited(refresh()));
  }

  void _emit(ArrivalsState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    pause();
    super.dispose();
  }
}
