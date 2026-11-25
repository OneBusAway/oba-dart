// The panel in a right-to-left host: the header and rows mirror (the stop
// name starts at the right edge, the route badge sits on the right, and the
// row chevron points left), and the left-to-right layout is unchanged.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

import 'support/fixtures.dart';

const stopName = 'Eighth College / Theatre District (North)';

Future<void> pumpPanel(WidgetTester tester, TextDirection direction) async {
  await tester.binding.setSurfaceSize(const Size(390, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: Directionality(
        textDirection: direction,
        child: Scaffold(
          body: SingleChildScrollView(
            child: ObaArrivalsPanel(
              client: fakeClient((_) async => okResponse()),
              stopId: 'MTS_24151',
              onArrivalTap: (_) {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  for (final direction in TextDirection.values) {
    final rtl = direction == TextDirection.rtl;
    testWidgets('mirrors in ${direction.name}', (tester) async {
      await pumpPanel(tester, direction);
      final name = tester.getRect(find.text(stopName));
      // The header's start padding is 16 on the reading side.
      if (rtl) {
        expect(name.right, moreOrLessEquals(390 - 16));
      } else {
        expect(name.left, moreOrLessEquals(16));
      }

      final badge = tester.getRect(find.byType(RouteBadge).first);
      final chevron = find.byIcon(Icons.chevron_right).first;
      final chevronRect = tester.getRect(chevron);
      if (rtl) {
        expect(badge.center.dx, greaterThan(chevronRect.center.dx));
      } else {
        expect(badge.center.dx, lessThan(chevronRect.center.dx));
      }
      expect(Directionality.of(tester.element(chevron)), direction);
      expect(Icons.chevron_right.matchTextDirection, isTrue);
    });
  }
}
