import 'package:flutter/widgets.dart';
import 'package:obakit_core/obakit_core.dart';

import '../features/stop/stop_arrivals_controller.dart';
import 'scope.dart';

/// Holds a live-location lease ([LocationService.acquire]) while this
/// widget is visible and the app is in the foreground, the same way
/// [ObaPollingHolder] holds polling: the lease is released when a pushed
/// route covers the widget, when it sits in a hidden `IndexedStack` child
/// (a host's off-screen tab), when the app is backgrounded, and on dispose.
///
/// The device's position stream runs only while at least one holder holds,
/// so put one around anything that shows live location. [enabled] false
/// holds nothing (for example when a widget was given a fixed point)
/// without changing the tree below.
///
/// ```dart
/// ObaLocationHolder(child: MyWalkingDistanceRow(...))
/// ```
class ObaLocationHolder extends StatefulWidget {
  const ObaLocationHolder({
    super.key,
    this.enabled = true,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  State<ObaLocationHolder> createState() => _ObaLocationHolderState();
}

class _ObaLocationHolderState extends State<ObaLocationHolder> {
  _LocationDemand? _demand;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = ObaScope.of(context).core.locationService;
    if (!identical(service, _demand?.service)) {
      // ObaPollingHolder releases the old demand when it sees a new one.
      _demand = _LocationDemand(service)..enabled = widget.enabled;
    }
  }

  @override
  void didUpdateWidget(ObaLocationHolder old) {
    super.didUpdateWidget(old);
    _demand?.enabled = widget.enabled;
  }

  @override
  void dispose() {
    _demand?.enabled = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ObaPollingHolder(controller: _demand!, child: widget.child);
}

/// Adapts a [LocationService] lease to [ObaPollable], gated by [enabled].
class _LocationDemand implements ObaPollable {
  _LocationDemand(this.service);

  final LocationService service;
  LocationLease? _lease;
  bool _held = false;
  bool _enabled = true;

  set enabled(bool value) {
    _enabled = value;
    _sync();
  }

  @override
  void acquire() {
    _held = true;
    _sync();
  }

  @override
  void release() {
    _held = false;
    _sync();
  }

  void _sync() {
    final want = _held && _enabled && !service.isDisposed;
    if (want && _lease == null) {
      _lease = service.acquire();
    } else if (!want && _lease != null) {
      _lease!.release();
      _lease = null;
    }
  }
}
