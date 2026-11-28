import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_life_example/widgets/host_page.dart';

const _long = 'Eighth College / Theatre District (North), Southwest bound';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('a long host title wraps in full at ${scale}x text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 3;
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      addTearDown(tester.view.reset);
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const HostObaPage(
                    title: _long,
                    sdkWidget: 'StopPage',
                    child: SizedBox.expand(),
                  ),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final title = find.text(_long);
      final paragraph = tester.renderObject<RenderParagraph>(title);
      expect(paragraph.didExceedMaxLines, isFalse, reason: 'truncated');
      // Wrapped onto more than one line, and inside the app bar.
      expect(
        paragraph.size.height,
        greaterThan(paragraph.preferredLineHeight * 1.5),
      );
      final bar = tester.getRect(find.byType(AppBar));
      final rect = tester.getRect(title);
      expect(
        bar.top <= rect.top && rect.bottom <= bar.bottom,
        isTrue,
        reason: 'title $rect outside app bar $bar',
      );
      expect(tester.takeException(), isNull);
    });
  }
}
