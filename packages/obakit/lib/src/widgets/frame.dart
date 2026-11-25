import 'package:flutter/scheduler.dart';

/// Whether the framework is building, laying out or painting a frame (or
/// running the microtasks in the middle of one). Listeners notified now
/// could call `setState` on widgets that are mid-build.
bool get obaIsMidFrame {
  final phase = SchedulerBinding.instance.schedulerPhase;
  return phase == SchedulerPhase.persistentCallbacks ||
      phase == SchedulerPhase.midFrameMicrotasks;
}

/// Runs [fn] now, or after the current frame when called mid-frame
/// ([obaIsMidFrame]).
void obaRunWhenSafe(VoidCallback fn) {
  if (obaIsMidFrame) {
    SchedulerBinding.instance.addPostFrameCallback((_) => fn());
  } else {
    fn();
  }
}
