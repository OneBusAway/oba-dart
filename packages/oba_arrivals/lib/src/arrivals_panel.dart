import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:onebusaway/onebusaway.dart';

import 'arrivals_controller.dart';
import 'color_utils.dart';
import 'display/arrival_filtering.dart';
import 'strings.dart';
import 'strings_scope.dart';
import 'widgets/arrival_row.dart';
import 'widgets/panel_states.dart';
import 'widgets/stop_header.dart';

/// Wayfinder-style arrivals and departures for one stop.
///
/// Lays out as a non-scrolling [Column]; wrap it in a scroll view for
/// full-screen use. Polls while visible and the app is in the foreground.
///
/// Accessibility (WCAG 2.1 AA): rows read as one sentence, the stop name is
/// a heading, loading/empty/error/stale messages are live regions, and the
/// result of a refresh the rider asked for (refresh button or Retry) is
/// announced. Background polls are not announced. Text follows the host's
/// `TextTheme` and the user's text size; status colours are checked for
/// contrast against the surface the panel sits on. See the package README.
class ObaArrivalsPanel extends StatefulWidget {
  const ObaArrivalsPanel({
    super.key,
    this.client,
    this.stopId,
    this.controller,
    this.onArrivalTap,
    this.onError,
    this.minutesAfter = 35,
    this.maxArrivals,
    this.refreshInterval = const Duration(seconds: 30),
    this.strings = const ObaArrivalsStrings(),
  }) : assert(
         controller != null || (client != null && stopId != null),
         'Pass a controller, or both client and stopId.',
       );

  /// The API client. It must be long-lived: create it once (e.g. in `main`
  /// or a `State`), reuse it, and close it when done. A new client instance
  /// reloads the panel.
  final OneBusAwayClient? client;
  final String? stopId;

  /// Optional host-owned controller. When given, [client], [stopId],
  /// [minutesAfter], [refreshInterval] and [onError] are ignored.
  ///
  /// The panel calls `ArrivalsController.acquire` while it is visible and
  /// the app is in the foreground, and `release` otherwise, so the
  /// controller keeps polling while any panel sharing it is on screen. The
  /// panel never disposes it; the host does.
  final ArrivalsController? controller;
  final void Function(ArrivalAndDeparture arrival)? onArrivalTap;

  /// Called for each failed fetch; see `ArrivalsController.onError`. The
  /// latest callback is always used, so an inline closure is fine and
  /// doesn't reload the panel. Ignored when [controller] is given: pass
  /// `onError` to that controller instead.
  final void Function(Object error, StackTrace stackTrace)? onError;
  final int minutesAfter;

  /// Maximum rows to show; null shows all.
  final int? maxArrivals;
  final Duration refreshInterval;

  /// The panel's text. Left at the default, the panel uses the strings of
  /// the nearest [ObaArrivalsStringsScope] when there is one (hosts such as
  /// obakit use it to localize every panel), and English otherwise.
  final ObaArrivalsStrings strings;

  @override
  State<ObaArrivalsPanel> createState() => _ObaArrivalsPanelState();
}

class _ObaArrivalsPanelState extends State<ObaArrivalsPanel>
    with WidgetsBindingObserver {
  static const _tickInterval = Duration(seconds: 30);

  ArrivalsController? _ownedController;
  late ArrivalsController _controller;
  Timer? _tick;
  bool _appActive = true;
  bool _visible = true;

  /// Whether this panel currently holds [_controller] via `acquire`.
  bool _holding = false;

  /// True when a post-frame callback has already been scheduled to apply
  /// [_syncRunning], so multiple requests within one frame are coalesced.
  bool _syncScheduled = false;

  /// Set when the rider asks for a refresh; the outcome is announced once
  /// the request settles.
  bool _announceNextResult = false;

  @override
  void initState() {
    super.initState();
    _controller = _resolveController();
    _controller.addListener(_onControllerChanged);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _appActive = lifecycle == null || _isActive(lifecycle);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appActive = _isActive(state);
    _syncRunning();
  }

  static bool _isActive(AppLifecycleState state) =>
      state == AppLifecycleState.resumed || state == AppLifecycleState.inactive;

  ArrivalsController _resolveController() {
    final external = widget.controller;
    if (external != null) return external;
    return _ownedController = ArrivalsController(
      client: widget.client!,
      stopId: widget.stopId!,
      minutesAfter: widget.minutesAfter,
      refreshInterval: widget.refreshInterval,
      onError: (error, stackTrace) => widget.onError?.call(error, stackTrace),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // False when a pushed route covers this one, among other cases, and
    // in a hidden IndexedStack child (e.g. a host's off-screen tab), which
    // keeps its tickers but reports itself through Visibility.of.
    _visible = TickerMode.valuesOf(context).enabled && Visibility.of(context);
    _scheduleSyncRunning();
  }

  @override
  void didUpdateWidget(ObaArrivalsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed =
        widget.controller != oldWidget.controller ||
        (widget.controller == null &&
            (widget.stopId != oldWidget.stopId ||
                widget.client != oldWidget.client ||
                widget.minutesAfter != oldWidget.minutesAfter ||
                widget.refreshInterval != oldWidget.refreshInterval));
    if (!changed) return;
    _controller.removeListener(_onControllerChanged);
    _releaseController();
    _ownedController?.dispose();
    _ownedController = null;
    _controller = _resolveController();
    _controller.addListener(_onControllerChanged);
    _scheduleSyncRunning();
  }

  /// Applies [_syncRunning] after this frame finishes building, coalescing
  /// requests raised more than once within the same frame.
  ///
  /// [didChangeDependencies] and [didUpdateWidget] run during the build
  /// phase. Calling [_syncRunning] from there can call
  /// `ArrivalsController.acquire`, which synchronously notifies listeners; if
  /// the host shares its controller with another widget outside this
  /// panel's subtree (e.g. a `ListenableBuilder` elsewhere in the tree),
  /// that notification can call `markNeedsBuild` on a widget the framework
  /// isn't currently building, which throws. Deferring to a post-frame
  /// callback runs it once the frame (and any lock on the element tree) is
  /// over.
  void _scheduleSyncRunning() {
    if (_syncScheduled) return;
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (mounted) _syncRunning();
    });
  }

  /// Holds the controller while visible and the app is active, and
  /// releases it otherwise. The countdown tick follows the same rule.
  void _syncRunning() {
    final want = _appActive && _visible;
    _syncTick(want);
    if (want && !_holding) {
      _holding = true;
      _controller.acquire();
    } else if (!want) {
      _releaseController();
    }
  }

  /// Whether the tick was stopped (hidden or backgrounded) since it last ran.
  bool _tickPaused = false;

  /// Runs the 30 s countdown tick only while the panel is shown. Coming
  /// back, the countdown is rebuilt at once instead of at the next tick.
  void _syncTick(bool want) {
    if (want) {
      if (_tick != null) return;
      _tick = Timer.periodic(_tickInterval, (_) {
        if (mounted) setState(() {});
      });
      if (_tickPaused) {
        _tickPaused = false;
        setState(() {});
      }
    } else if (_tick != null) {
      _tick!.cancel();
      _tick = null;
      _tickPaused = true;
    }
  }

  /// Releases [_controller] if this panel holds it. Releasing never
  /// notifies listeners, so it is safe during build.
  void _releaseController() {
    if (!_holding) return;
    _holding = false;
    _controller.release();
  }

  /// [ObaArrivalsPanel.strings] when the host passed its own, otherwise
  /// the nearest [ObaArrivalsStringsScope]'s, otherwise English.
  ObaArrivalsStrings get _strings {
    final own = widget.strings;
    if (!identical(own, const ObaArrivalsStrings())) return own;
    return ObaArrivalsStringsScope.maybeOf(context) ?? own;
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
    final state = _controller.state;
    if (_announceNextResult &&
        !state.isRefreshing &&
        state.status != ArrivalsStatus.loading) {
      _announceNextResult = false;
      final strings = _strings;
      _announce(
        state.error == null
            ? strings.arrivalsUpdated
            : state.status == ArrivalsStatus.error
            ? _errorMessage(state.error, strings)
            : strings.staleNotice(
                formatArrivalTime(context, state.updatedAt ?? DateTime.now()),
              ),
      );
    }
  }

  /// A rider-initiated refresh (refresh button or Retry).
  void _refresh() {
    _announceNextResult = true;
    _controller.refresh();
  }

  void _announce(String message) {
    final view = View.maybeOf(context);
    if (view == null) return;
    SemanticsService.sendAnnouncement(
      view,
      message,
      Directionality.maybeOf(context) ?? TextDirection.ltr,
    );
  }

  @override
  void dispose() {
    _tick?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onControllerChanged);
    _releaseController();
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = accessibleColorScheme(theme.colorScheme);
    if (identical(scheme, theme.colorScheme)) return _buildColumn(context);
    return Theme(
      data: theme.copyWith(colorScheme: scheme),
      child: Builder(builder: _buildColumn),
    );
  }

  Widget _buildColumn(BuildContext context) {
    final state = _controller.state;
    final strings = _strings;
    // Its own semantics node, so the panel's text and its live regions never
    // merge into a host's node (for example a card whose title is a heading).
    return Semantics(
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StopHeader(
            stop: state.stop,
            stopId: _controller.stopId,
            isLoading: state.status == ArrivalsStatus.loading,
            references: state.references,
            isRefreshing: state.isRefreshing,
            onRefresh: _refresh,
            strings: strings,
          ),
          const Divider(height: 1),
          ..._body(context, state, strings),
        ],
      ),
    );
  }

  List<Widget> _body(
    BuildContext context,
    ArrivalsState state,
    ObaArrivalsStrings strings,
  ) {
    switch (state.status) {
      case ArrivalsStatus.loading:
        return [LoadingRows(label: strings.loadingArrivals)];
      case ArrivalsStatus.error:
        return [
          PanelMessage(
            message: _errorMessage(state.error, strings),
            action: TextButton(onPressed: _refresh, child: Text(strings.retry)),
          ),
        ];
      case ArrivalsStatus.loaded:
        final now = _controller.now();
        var rows = visibleArrivals(state.rawArrivals, now);
        final max = widget.maxArrivals;
        if (max != null && rows.length > max) rows = rows.sublist(0, max);
        return [
          if (rows.isEmpty)
            PanelMessage(message: strings.noArrivals(_controller.minutesAfter)),
          for (final (i, arrival) in rows.indexed) ...[
            if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
            ArrivalRow(
              arrival: arrival,
              route: state.references.route(arrival.routeId),
              now: now,
              strings: strings,
              onTap: widget.onArrivalTap,
            ),
          ],
          if (state.error != null && state.updatedAt != null)
            StaleNotice(
              key: const ValueKey('oba-stale-notice'),
              message: strings.staleNotice(
                formatArrivalTime(context, state.updatedAt!),
              ),
            ),
        ];
    }
  }

  static String _errorMessage(Object? error, ObaArrivalsStrings strings) =>
      switch (error) {
        ObaApiException(kind: ObaApiErrorKind.emptyResponse) =>
          strings.stopNotFound,
        ObaNetworkException() => strings.networkError,
        _ => strings.loadError,
      };
}
