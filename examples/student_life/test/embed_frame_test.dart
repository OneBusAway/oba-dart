import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_life_example/settings.dart';
import 'package:student_life_example/widgets/embed_frame.dart';

import 'support/test_env.dart';

void main() {
  const chip = ValueKey('embed-frame-chip');
  const body = _Probe();

  testWidgets('off: the child is rendered untouched', (tester) async {
    final settings = StudentLifeSettings();
    addTearDown(settings.dispose);
    await pumpHost(
      tester,
      const Scaffold(
        body: EmbedFrame(sdkWidget: 'ObaStopDeparturesCard', child: body),
      ),
      settings: settings,
    );
    expect(find.text('SDK content'), findsOneWidget);
    expect(find.byKey(chip), findsNothing);
    expect(
      find.descendant(
        of: find.byType(EmbedFrame),
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
  });

  testWidgets('on: an outline and a label chip hidden from screen readers', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final settings = StudentLifeSettings();
    addTearDown(settings.dispose);
    await pumpHost(
      tester,
      const Scaffold(
        body: EmbedFrame(sdkWidget: 'ObaStopDeparturesCard', child: body),
      ),
      settings: settings,
    );
    final state = tester.state(find.byType(_Probe));

    settings.showObaEmbeds.value = true;
    await tester.pump();
    expect(find.text('OBA · ObaStopDeparturesCard'), findsOneWidget);
    expect(find.byKey(chip), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('OBA ·')), findsNothing);
    expect(find.text('SDK content'), findsOneWidget);
    // The child keeps its state: toggling never reloads an SDK widget.
    expect(tester.state(find.byType(_Probe)), same(state));

    settings.showObaEmbeds.value = false;
    await tester.pump();
    expect(find.byKey(chip), findsNothing);
    handle.dispose();
  });

  testWidgets('fills: a page-sized child gets the remaining space', (
    tester,
  ) async {
    final settings = StudentLifeSettings(showObaEmbeds: true);
    addTearDown(settings.dispose);
    await pumpHost(
      tester,
      Scaffold(
        body: EmbedFrame(
          sdkWidget: 'StopPage',
          fills: true,
          child: ListView(children: const [body]),
        ),
      ),
      settings: settings,
    );
    expect(tester.takeException(), isNull);
    expect(find.text('OBA · StopPage'), findsOneWidget);
  });

  testWidgets('without a SettingsScope it is a pass-through', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EmbedFrame(sdkWidget: 'X', child: body),
      ),
    );
    expect(find.text('SDK content'), findsOneWidget);
  });
}

/// Stands in for an SDK widget; stateful, so a test can tell whether it
/// was rebuilt from scratch.
class _Probe extends StatefulWidget {
  const _Probe();

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  @override
  Widget build(BuildContext context) => const Text('SDK content');
}
