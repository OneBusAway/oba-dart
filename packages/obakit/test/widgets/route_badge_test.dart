import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../support/oba_test_harness.dart';

void main() {
  testWidgets('reduce colors draws every badge in one neutral style', (
    tester,
  ) async {
    final env = await ObaTestEnv.create();
    addTearDown(env.dispose);
    await env.pumpPage(
      tester,
      const Scaffold(
        body: ObaRouteBadge(label: '10', color: 'FF0000'),
      ),
    );
    Color fill() =>
        ((tester.widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(ObaRouteBadge),
                    matching: find.byType(DecoratedBox),
                  ),
                )).decoration
                as BoxDecoration)
            .color!;
    expect(fill(), const Color(0xFFFF0000));
    env.app.core.settings.reducedColors = true;
    await tester.pump();
    final scheme = Theme.of(tester.element(find.byType(ObaRouteBadge)))
        .colorScheme;
    expect(fill(), scheme.inverseSurface);
  });
}
