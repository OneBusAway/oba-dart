import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

void main() {
  group('parseHexColor', () {
    test('accepts lowercase, uppercase and #-prefixed hex', () {
      expect(parseHexColor('ffcd00'), const Color(0xFFFFCD00));
      expect(parseHexColor('000099'), const Color(0xFF000099));
      expect(parseHexColor('#20183D'), const Color(0xFF20183D));
    });

    test('null, empty and malformed are null', () {
      expect(parseHexColor(null), isNull);
      expect(parseHexColor(''), isNull);
      expect(parseHexColor('zzzzzz'), isNull);
      expect(parseHexColor('fff'), isNull);
    });
  });

  test('contrastingTextColor picks the higher WCAG contrast', () {
    expect(contrastingTextColor(const Color(0xFFFFCD00)), Colors.black); // IL
    expect(contrastingTextColor(const Color(0xFF90A7D3)), Colors.black); // S
    expect(contrastingTextColor(const Color(0xFF20183D)), Colors.white); // OL
    expect(contrastingTextColor(const Color(0xFF374151)), Colors.white);
  });

  test('badgeFontSize follows Wayfinder rule', () {
    expect(badgeFontSize('IL'), 24);
    expect(badgeFontSize('101'), 24);
    expect(
      badgeFontSize('Blue Line'),
      21,
    ); // min(24, round(90/4)=23, round(42/2)=21)
    expect(
      badgeFontSize('Supercalifragilistic'),
      8,
    ); // round(90/20)=5 -> floor 8
  });

  group('ObaArrivalsTheme', () {
    test('light and dark status colors', () {
      expect(ObaArrivalsTheme.light().onTime, const Color(0xFF16A34A));
      expect(ObaArrivalsTheme.dark().late, const Color(0xFFA78BFA));
    });

    testWidgets('of() uses brightness default unless host registers one', (
      tester,
    ) async {
      late ObaArrivalsTheme resolved;
      Widget probe(ThemeData theme) => MaterialApp(
        theme: theme,
        home: Builder(
          builder: (context) {
            resolved = ObaArrivalsTheme.of(context);
            return const SizedBox();
          },
        ),
      );

      await tester.pumpWidget(probe(ThemeData(brightness: Brightness.dark)));
      expect(resolved.onTime, const Color(0xFF4ADE80));

      const custom = ObaArrivalsTheme(
        onTime: Colors.teal,
        late: Colors.orange,
        early: Colors.pink,
      );
      await tester.pumpWidget(probe(ThemeData(extensions: const [custom])));
      await tester.pumpAndSettle();
      expect(resolved.onTime, Colors.teal);
    });

    test('scheduled and canceled resolve from the color scheme', () {
      final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      final theme = ObaArrivalsTheme.light();
      expect(
        theme.colorFor(ArrivalStatusKind.scheduled, scheme),
        scheme.onSurfaceVariant,
      );
      expect(theme.colorFor(ArrivalStatusKind.canceled, scheme), scheme.error);
      expect(
        theme.colorFor(ArrivalStatusKind.late, scheme),
        const Color(0xFF7C3AED),
      );
    });

    test('lerp and copyWith', () {
      final a = ObaArrivalsTheme.light();
      final b = ObaArrivalsTheme.dark();
      expect(a.lerp(b, 1).onTime, b.onTime);
      expect(a.copyWith(badgeRadius: 4).badgeRadius, 4);
    });
  });

  group('RouteBadge', () {
    Finder badgePart(Type type) => find.descendant(
      of: find.byType(RouteBadge),
      matching: find.byType(type),
    );

    Future<Text> pumpBadge(WidgetTester tester, Widget badge) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Center(child: badge),
          ),
        ),
      );
      return tester.widget<Text>(badgePart(Text));
    }

    testWidgets(
      'UCSD IL badge uses black text on ffcd00 when textColor is empty',
      (tester) async {
        final text = await pumpBadge(
          tester,
          const RouteBadge(label: 'IL', color: 'ffcd00', textColor: null),
        );
        expect(text.style!.color, Colors.black);
        final box = tester.widget<DecoratedBox>(badgePart(DecoratedBox));
        expect(
          (box.decoration as BoxDecoration).color,
          const Color(0xFFFFCD00),
        );
      },
    );

    testWidgets('GTFS textColor wins; missing color uses fallback', (
      tester,
    ) async {
      final text = await pumpBadge(
        tester,
        const RouteBadge(label: '30', color: null, textColor: 'FFFFFF'),
      );
      expect(text.style!.color, const Color(0xFFFFFFFF));
      final box = tester.widget<DecoratedBox>(badgePart(DecoratedBox));
      expect((box.decoration as BoxDecoration).color, const Color(0xFF374151));
    });

    testWidgets('is 64x56 and ignores text scaling', (tester) async {
      await pumpBadge(tester, const RouteBadge(label: 'IL', color: 'ffcd00'));
      expect(tester.getSize(find.byType(RouteBadge)), const Size(64, 56));
      final scaler = MediaQuery.textScalerOf(tester.element(badgePart(Text)));
      expect(scaler, TextScaler.noScaling);
    });
  });
}
