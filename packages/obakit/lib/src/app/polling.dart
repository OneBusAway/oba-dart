import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';

import '../widgets/frame.dart';
import '../widgets/loader.dart';
import '../widgets/visibility.dart';

/// Something that polls while at least one holder needs live data.
abstract interface class ObaPollable {
  void acquire();
  void release();
}

/// The polling skeleton of a controller that fetches one thing and
/// refetches every [refreshInterval] while held: reference-counted holders,
/// one timer, a generation counter so a stale response is dropped, and the
/// server's clock. [refresh] calls [beginFetch], checks [isCurrent] after
/// each await, records [updateServerTime], and ends with
/// [scheduleNextPoll].
mixin ObaPollingController on ChangeNotifier, ObaDisposeSafeNotifier
    implements ObaPollable {
  Duration _offset = Duration.zero;
  Timer? _timer;
  int _holders = 0;
  int _generation = 0;

  Duration get refreshInterval;

  /// Fetches now; the next poll follows [refreshInterval] later.
  Future<void> refresh();

  /// The server's current time (offset from the latest response).
  DateTime now() => clock.now().add(_offset);

  /// Whether any holder wants live data.
  bool get isRunning => _holders > 0;

  @override
  void acquire() {
    _holders++;
    if (_holders == 1 && !isDisposed) unawaited(refresh());
  }

  @override
  void release() {
    if (isDisposed || _holders == 0) return;
    _holders--;
    if (_holders == 0) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Cancels the pending poll and starts a fetch; returns its generation.
  @protected
  int beginFetch() {
    _timer?.cancel();
    _timer = null;
    return ++_generation;
  }

  /// Whether the fetch started as [generation] is still the latest.
  @protected
  bool isCurrent(int generation) => !isDisposed && generation == _generation;

  /// Records the server's clock from a response's `currentTime`.
  @protected
  void updateServerTime(DateTime serverNow) =>
      _offset = serverNow.difference(clock.now());

  /// Schedules the next [refresh] while anyone holds this.
  @protected
  void scheduleNextPoll() {
    if (isRunning && !isDisposed) {
      _timer = Timer(refreshInterval, () => unawaited(refresh()));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Thrown when no region (and so no API client) is selected.
class ObaNoRegionException implements Exception {
  const ObaNoRegionException();
}

/// Holds [controller] (via [ObaPollable.acquire]) while this widget is
/// visible and the app is in the foreground ([ObaVisibilityAware]): it is
/// released when a pushed route covers the widget, when it sits in a hidden
/// `IndexedStack` child, when the app is backgrounded, and on dispose.
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
    with ObaVisibilityAware<ObaPollingHolder> {
  bool _holding = false;
  bool _scheduled = false;

  // Acquiring may notify listeners, so never do it mid-build.
  @override
  void onVisibilityChanged(bool visible) => _schedule();

  @override
  void didUpdateWidget(ObaPollingHolder old) {
    super.didUpdateWidget(old);
    if (!identical(old.controller, widget.controller)) {
      if (_holding) old.controller.release();
      _holding = false;
      _schedule();
    }
  }

  void _schedule() {
    if (_scheduled) return;
    _scheduled = true;
    obaRunWhenSafe(() {
      _scheduled = false;
      if (mounted) _sync();
    });
  }

  void _sync() {
    final want = isVisible;
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
    if (_holding) widget.controller.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
