// End-to-end smoke test: boots the real app (lib/main.dart's
// buildOneBusAwayApp: real network, real plugins, live Puget Sound data) and
// walks onboarding, the map shell and the home sheet.
//
// Run on a device or simulator with location permission available:
//
//   mise exec -- flutter test integration_test/walkthrough_test.dart -d <device>
//
// The test prints `SHOT:<name>` before pausing a few seconds at each step,
// so a wrapper script tailing the output can take a real device screenshot
// (`xcrun simctl io <udid> screenshot`, or `adb exec-out screencap -p`).
// Semantics outlines are printed as `SEM:<name>:<line>` lines. It asserts
// structure only, never specific arrival values. Start from a fresh install
// (onboarding not yet seen) with the device location in downtown Seattle.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'walkthrough_helpers.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('walkthrough', (tester) async {
    final w = Walkthrough(tester);
    await w.boot();
    await w.onboarding();
    await w.mapShell();
    await w.homeSheet();
    await w.step('stop', w.stopPage);
    await w.step('bookmarks', w.bookmarks);
    await w.step('trip', w.tripPage);
    await w.step('stop_schedule', w.stopSchedule);
    await w.step('search', w.search);
    await w.step('planner', w.tripPlanner);
    await w.step('explore', w.explore);
    await w.step('reports', w.reports);
    await w.system('dark');
    await w.step('dark', () => w.mainScreens('dark'));
    await w.system('bigtext');
    await w.step('dark_bigtext', () => w.mainScreens('darkbig'));
    await w.system('light');
    await w.step('bigtext', () => w.mainScreens('big'));
    await w.system('normaltext');
    expect(w.failures, isEmpty);
  }, timeout: const Timeout(Duration(minutes: 30)));
}
