import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapline_example/widgets/embed_frame.dart';

void main() {
  Widget host(ValueNotifier<bool> show) => MaterialApp(
    home: Scaffold(
      body: EmbedFrame(
        sdkWidget: 'ObaNearbyStopsCard',
        visible: show,
        child: const _Counter(),
      ),
    ),
  );

  testWidgets('off: renders the child untouched', (tester) async {
    final show = ValueNotifier(false);
    addTearDown(show.dispose);
    await tester.pumpWidget(host(show));
    expect(find.text('OBA · ObaNearbyStopsCard'), findsNothing);
    expect(find.text('count 0'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(EmbedFrame),
        matching: find.byWidgetPredicate(
          (w) => w is CustomPaint && w.foregroundPainter != null,
        ),
      ),
      findsNothing,
    );
  });

  testWidgets('on: outline and chip, chip hidden from screen readers, '
      'child state kept', (tester) async {
    final semantics = tester.ensureSemantics();
    final show = ValueNotifier(false);
    addTearDown(show.dispose);
    await tester.pumpWidget(host(show));
    await tester.tap(find.text('count 0'));
    await tester.pump();
    expect(find.text('count 1'), findsOneWidget);

    show.value = true;
    await tester.pump();
    expect(find.text('OBA · ObaNearbyStopsCard'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('OBA ·')), findsNothing);
    expect(find.text('count 1'), findsOneWidget, reason: 'state survives');

    show.value = false;
    await tester.pump();
    expect(find.text('OBA · ObaNearbyStopsCard'), findsNothing);
    expect(find.text('count 1'), findsOneWidget);
    semantics.dispose();
  });
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _n = 0;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => setState(() => _n++),
    child: Text('count $_n'),
  );
}
