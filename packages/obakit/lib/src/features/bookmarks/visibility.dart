import 'package:flutter/widgets.dart';

/// Tells a `State` when its widget is on screen and the app is in the
/// foreground, so it can poll politely. The widget counts as hidden when
/// it sits under a pushed route (its tickers are disabled, see
/// [TickerMode]), in a hidden `IndexedStack` child such as a host's
/// off-screen tab ([Visibility.of]), or when the app is backgrounded.
///
/// Override [onVisibilityChanged]; it is called after every change and
/// once on the first dependency pass.
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
  _LifecycleWatcher(this._onChange);

  final VoidCallback _onChange;
  bool foreground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    foreground =
        state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive;
    _onChange();
  }
}
