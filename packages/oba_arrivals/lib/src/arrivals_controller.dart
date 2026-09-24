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

  ArrivalsState copyWith({
    ArrivalsStatus? status,
    Object? error,
    bool? isRefreshing,
  }) =>
      ArrivalsState(
        status: status ?? this.status,
        stop: stop,
        rawArrivals: rawArrivals,
        references: references,
        updatedAt: updatedAt,
        error: error ?? this.error,
        isRefreshing: isRefreshing ?? this.isRefreshing,
      );
}

/// Fetches arrivals for one stop and polls while running.
///
/// Polling runs while at least one holder has called [acquire] without a
/// matching [release], or after a manual [resume] until [pause].
/// `ObaArrivalsPanel` uses [acquire]/[release], so several panels can share
/// one controller: it keeps polling while any of them is visible. Outside a
/// panel, call [resume]/[pause] from your own lifecycle code.
class ArrivalsController extends ChangeNotifier {
  ArrivalsController({
    required this.stopId,
    required this._client,
    this.minutesAfter = 35,
    this.refreshInterval = const Duration(seconds: 30),
    this.onError,
    DateTime Function()? clock,
    // package:clock, not DateTime.now, so fake_async / testWidgets can
    // control time.
  }) : _clock = clock ?? (() => clock_pkg.clock.now());

  final OneBusAwayClient _client;
  final DateTime Function() _clock;
  final String stopId;
  final int minutesAfter;
  final Duration refreshInterval;

  /// Called for each failed fetch, after [state] records the error, so hosts
  /// can log or report it (e.g. to Crashlytics or Sentry). The error is
  /// normally an [ObaException]. Not called for a request superseded by a
  /// newer one, or after [dispose]. If it throws, the exception goes to
  /// [FlutterError.reportError] and polling continues.
  final void Function(Object error, StackTrace stackTrace)? onError;

  ArrivalsState _state = const ArrivalsState();
  ArrivalsState get state => _state;

  Duration _serverOffset = Duration.zero;
  Timer? _timer;
  int _latestRequest = 0;
  bool _resumed = false;
  int _holders = 0;
  bool _disposed = false;

  /// Whether polling is on: held by [acquire], or manually [resume]d.
  bool get isRunning => _resumed || _holders > 0;

  /// The current time on the server's clock.
  DateTime now() => _clock().add(_serverOffset);

  /// Starts polling manually, fetching immediately if polling was off.
  void resume() {
    if (_resumed) return;
    _resumed = true;
    _startIfIdle(wasRunning: _holders > 0);
  }

  /// Ends a manual [resume]. Polling stops unless a holder from [acquire]
  /// remains. An in-flight request still updates [state].
  void pause() {
    _resumed = false;
    _stopIfIdle();
  }

  /// Registers a holder that needs live data, e.g. a visible panel. The
  /// first holder (when not already running) fetches now and starts
  /// polling. Balance each call with [release].
  void acquire() {
    final wasRunning = isRunning;
    _holders++;
    _startIfIdle(wasRunning: wasRunning);
  }

  /// Removes a holder added by [acquire]. When the last one goes (and no
  /// manual [resume] is active), polling stops. A no-op after [dispose], so
  /// a panel may release a controller its host already disposed.
  void release() {
    if (_disposed) return;
    assert(_holders > 0, 'release() without a matching acquire()');
    if (_holders == 0) return;
    _holders--;
    _stopIfIdle();
  }

  void _startIfIdle({required bool wasRunning}) {
    if (!wasRunning && !_disposed) unawaited(refresh());
  }

  void _stopIfIdle() {
    if (isRunning) return;
    _cancelTimer();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Fetches now. When running, the next poll is scheduled
  /// [refreshInterval] after this request completes.
  Future<void> refresh() async {
    _timer?.cancel();
    _timer = null;
    final request = ++_latestRequest;
    _emit(_state.copyWith(isRefreshing: true));

    ArrivalsState next;
    Duration? serverOffset;
    (Object, StackTrace)? failure;
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
    } catch (error, stackTrace) {
      failure = (error, stackTrace);
      next = _state.hasData
          ? _state.copyWith(error: error, isRefreshing: false)
          : ArrivalsState(status: ArrivalsStatus.error, error: error);
    }

    if (_disposed || request != _latestRequest) return;
    if (serverOffset != null) _serverOffset = serverOffset;
    _emit(next);
    if (failure != null) _reportError(failure.$1, failure.$2);
    if (isRunning) _timer = Timer(refreshInterval, () => unawaited(refresh()));
  }

  void _reportError(Object error, StackTrace stackTrace) {
    final onError = this.onError;
    if (onError == null) return;
    try {
      onError(error, stackTrace);
    } catch (exception, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: exception,
        stack: stack,
        library: 'oba_arrivals',
        context: ErrorDescription('while calling ArrivalsController.onError'),
      ));
    }
  }

  void _emit(ArrivalsState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _resumed = false;
    _holders = 0;
    _cancelTimer();
    super.dispose();
  }
}
