import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/src/widgets/visibility.dart';

class _Probe extends StatefulWidget {
  const _Probe(this.log);

  final List<bool> log;

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> with ObaVisibilityAware<_Probe> {
  @override
  void onVisibilityChanged(bool visible) => widget.log.add(visible);

  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  testWidgets('follows the app lifecycle', (tester) async {
    final log = <bool>[];
    await tester.pumpWidget(_Probe(log));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(log, [true, false, true]);
  });

  testWidgets('hidden under TickerMode off', (tester) async {
    final log = <bool>[];
    await tester.pumpWidget(TickerMode(enabled: false, child: _Probe(log)));
    await tester.pumpWidget(TickerMode(enabled: true, child: _Probe(log)));
    expect(log, [false, true]);
  });
}
