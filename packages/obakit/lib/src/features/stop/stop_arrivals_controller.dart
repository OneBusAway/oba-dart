import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:obakit_core/obakit_core.dart';

/// Something that polls while at least one holder needs live data.
abstract interface class ObaPollable {
  void acquire();
  void release();
}

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
class StopArrivalsController extends ChangeNotifier implements ObaPollable {
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
  final Duration refreshInterval;

  /// Whether an empty response widens the window by itself.
  final bool autoExtend;

  int _minutesAfter;
  int get minutesAfter => _minutesAfter;

  bool get isLoadMoreExhausted => _minutesAfter >= maxMinutesAfter;

  StopArrivalsState _state = const StopArrivalsState();
  StopArrivalsState get state => _state;

  Duration _offset = Duration.zero;
  Timer? _timer;
  int _holders = 0;
  int _generation = 0;
  bool _disposed = false;

  /// The server's current time.
  DateTime now() => clock.now().add(_offset);

  bool get isRunning => _holders > 0;

  @override
  void acquire() {
    _holders++;
    if (_holders == 1 && !_disposed) unawaited(refresh());
  }

  @override
  void release() {
    if (_disposed || _holders == 0) return;
    _holders--;
    if (_holders == 0) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Widens the window by [loadMoreStep] minutes and refetches.
  Future<void> loadMore() async {
    if (isLoadMoreExhausted) return;
    _minutesAfter = (_minutesAfter + loadMoreStep).clamp(0, maxMinutesAfter);
    await refresh();
  }

  /// Fetches now; the next poll follows [refreshInterval] later.
  Future<void> refresh() async {
    _timer?.cancel();
    _timer = null;
    final generation = ++_generation;
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
      if (_disposed || generation != _generation) return;
      _offset = r.currentTime.difference(clock.now());
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
      if (_disposed || generation != _generation) return;
      next = e.isNullBody || e.code == 404
          ? const StopArrivalsState(
              status: StopArrivalsStatus.error,
              stopIsMissing: true,
            )
          : _failed(e);
    } catch (e) {
      if (_disposed || generation != _generation) return;
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
    if (isRunning && !_disposed) {
      _timer = Timer(refreshInterval, () => unawaited(refresh()));
    }
  }

  StopArrivalsState _failed(Object e) => _state.hasData
      ? _state.copyWith(error: e, isRefreshing: false)
      : StopArrivalsState(status: StopArrivalsStatus.error, error: e);

  void _emit(StopArrivalsState s) {
    if (_disposed) return;
    _state = s;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}

/// Thrown when no region (and so no API client) is selected.
class ObaNoRegionException implements Exception {
  const ObaNoRegionException();
}

/// Holds [controller] (via [ObaPollable.acquire]) while this widget is
/// visible (not covered by a pushed route, which turns `TickerMode` off,
/// and not in a hidden `IndexedStack` child, which `Visibility.of` reports)
/// and the app is in the foreground.
class ObaPollingHolder extends StatefulWidget {
  const ObaPollingHolder({
    super.key,
    required this.controller,
    required this.child,
  });

  final ObaPollable controller;
  final Widget child;

  @override
  State<ObaPollingHolder> createState() => _ObaPollingHolderState();
}

class _ObaPollingHolderState extends State<ObaPollingHolder>
    with WidgetsBindingObserver {
  bool _holding = false;
  bool _visible = true;
  bool _foreground = true;
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final s = WidgetsBinding.instance.lifecycleState;
    _foreground =
        s == null ||
        s == AppLifecycleState.resumed ||
        s == AppLifecycleState.inactive;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = TickerMode.valuesOf(context).enabled && Visibility.of(context);
    _schedule();
  }

  @override
  void didUpdateWidget(ObaPollingHolder old) {
    super.didUpdateWidget(old);
    if (!identical(old.controller, widget.controller)) {
      if (_holding) old.controller.release();
      _holding = false;
      _schedule();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground =
        state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive;
    _sync();
  }

  void _schedule() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (mounted) _sync();
    });
  }

  void _sync() {
    final want = _visible && _foreground;
    if (want && !_holding) {
      _holding = true;
      widget.controller.acquire();
    } else if (!want && _holding) {
      _holding = false;
      widget.controller.release();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_holding) widget.controller.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
