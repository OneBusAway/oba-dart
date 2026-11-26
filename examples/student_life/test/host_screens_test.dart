// Host-only screens and cards: no OBA widgets, no application needed.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_life_example/data/dining.dart';
import 'package:student_life_example/data/events.dart';
import 'package:student_life_example/data/schedule.dart';
import 'package:student_life_example/data/student.dart';
import 'package:student_life_example/screens/me_tab.dart';
import 'package:student_life_example/screens/today_tab.dart';
import 'package:student_life_example/settings.dart';
import 'package:student_life_example/widgets/student_id_card.dart';

import 'support/test_env.dart';

Widget todayHostCards() => Scaffold(
  body: ListView(
    children: [
      const NextClassCard(meeting: nextClass),
      const DiningCard(halls: diningHalls),
      FeaturedEventCard(event: featuredEvent),
    ],
  ),
);

void main() {
  group('Today host cards', () {
    testWidgets('show the next class, leave-by time and dining hours', (
      tester,
    ) async {
      await pumpHost(tester, todayHostCards());
      expect(find.text('CSE 110 · Center Hall 105 · 9:30 AM'), findsOneWidget);
      // 9:30 minus a 13 minute walk minus 5 minutes' margin.
      expect(find.text('Leave by 9:12 AM · 13 min walk'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Directions to Center Hall'),
        findsOneWidget,
      );
      // Open or closed is in the text, not just a colour.
      expect(find.text('Open · 7 AM – 9 PM'), findsOneWidget);
      expect(find.text('Closed · 11 AM – 2 PM'), findsOneWidget);
      expect(find.text('Winter Career Fair'), findsOneWidget);
      await expectAccessible(tester);
    });

    testWidgets('are accessible in dark mode', (tester) async {
      await pumpHost(tester, todayHostCards(), brightness: Brightness.dark);
      await expectAccessible(tester);
    });

    testWidgets('reflow at 200% text without overflow', (tester) async {
      await pumpHost(tester, todayHostCards(), textScale: 2);
      expect(tester.takeException(), isNull);
    });
  });

  group('Me', () {
    testWidgets('the ID card reads its barcode as a labelled image', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpHost(
        tester,
        const Scaffold(body: StudentIdCard(student: currentStudent)),
      );
      expect(
        find.bySemanticsLabel('Barcode for student ID A00000000'),
        findsOneWidget,
      );
      final barcode = tester.getSemantics(
        find.bySemanticsLabel('Barcode for student ID A00000000'),
      );
      expect(barcode.flagsCollection.isImage, isTrue);
      expect(find.text('Alex Rivera'), findsOneWidget);
      expect(find.text('PID A00000000'), findsOneWidget);
      expect(
        tester.getSemantics(find.text('Student ID')).flagsCollection.isHeader,
        isTrue,
      );
      handle.dispose();
    });

    testWidgets('switches drive the embed overlay and theme settings', (
      tester,
    ) async {
      final settings = StudentLifeSettings(themeMode: ThemeMode.light);
      addTearDown(settings.dispose);
      await pumpHost(tester, const MeTab(), settings: settings);
      expect(find.text('Saved stops'), findsOneWidget);
      expect(find.text('Service alerts'), findsOneWidget);

      await tester.tap(find.text('Show OBA embeds'));
      await tester.pump();
      expect(settings.showObaEmbeds.value, isTrue);

      await tester.tap(find.text('Dark mode'));
      await tester.pump();
      expect(settings.themeMode.value, ThemeMode.dark);
      await expectAccessible(tester);
    });

    testWidgets('reflows at 200% text without overflow', (tester) async {
      await pumpHost(tester, const MeTab(), textScale: 2);
      expect(tester.takeException(), isNull);
    });
  });
}
