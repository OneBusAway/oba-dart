import 'package:flutter/widgets.dart';

/// Tells a `State` when its widget is on screen and the app is in the
/// foreground, so it can poll politely. The widget counts as hidden when
/// it sits under a pushed route (its tickers are disabled, see
/// [TickerMode]), in a hidden `IndexedStack` child such as a host's
/// off-screen tab ([Visibility.of]), or when the app is not in the
/// foreground (seeded from [WidgetsBinding.lifecycleState]).
///
/// Override [onVisibilityChanged]; it is called once on the first
/// dependency pass and then after every change. It may run during
/// `didChangeDependencies`, where `setState` is allowed (the element is
/// about to build anyway).
mixin ObaVisibilityAware<T extends StatefulWidget> on State<T> {
  late final _LifecycleWatcher _watcher = _LifecycleWatcher(_update);
  bool _tickerEnabled = true;
  bool? _lastVisible;

  /// Whether the widget is visible right now.
  bool get isVisible => _tickerEnabled && _watcher.foreground;

  /// Called when [isVisible] changes.
  void onVisibilityChanged(bool visible);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_watcher);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tickerEnabled =
        TickerMode.valuesOf(context).enabled && Visibility.of(context);
    _update();
  }

  void _update() {
    if (!mounted) return;
    final visible = isVisible;
    if (visible == _lastVisible) return;
    _lastVisible = visible;
    onVisibilityChanged(visible);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_watcher);
    super.dispose();
  }
}

class _LifecycleWatcher with WidgetsBindingObserver {
  _LifecycleWatcher(this._onChange)
    : foreground = _isForeground(WidgetsBinding.instance.lifecycleState);

  final VoidCallback _onChange;
  bool foreground;

  static bool _isForeground(AppLifecycleState? state) =>
      state == null ||
      state == AppLifecycleState.resumed ||
      state == AppLifecycleState.inactive;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    foreground = _isForeground(state);
    _onChange();
  }
}
