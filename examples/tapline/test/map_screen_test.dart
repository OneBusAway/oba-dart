import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:tapline_example/map_vector.dart';
import 'package:tapline_example/screens/map_screen.dart';

import 'support/test_env.dart';

Color _hex(String hex) => Color(int.parse('FF${hex.substring(1)}', radix: 16));

/// The fill of each reload-store pin the map draws.
List<Color> _pinFills(WidgetTester tester) => [
  for (final pin
      in find.bySemanticsLabel(RegExp('^Reload location: ')).evaluate())
    (tester
                .widgetList<DecoratedBox>(
                  find.descendant(
                    of: find.byElementPredicate((e) => e == pin),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .first
                .decoration
            as BoxDecoration)
        .color!,
];

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());

  for (final (brightness, palette) in [
    (Brightness.light, taplineLightPalette),
    (Brightness.dark, taplineDarkPalette),
  ]) {
    testWidgets('reload-store pins have 3:1 contrast on the '
        '${brightness.name} map', (tester) async {
      mockMapTileCache();
      await env.pumpApp(
        tester,
        home: const MapScreen(),
        brightness: brightness,
        surfaceSize: const Size(390, 844),
      );
      final fills = _pinFills(tester);
      expect(fills, isNotEmpty);
      // The host's own glyph in the SDK pin.
      expect(
        find.descendant(
          of: find.bySemanticsLabel(RegExp('^Reload location: ')),
          matching: find.byIcon(Icons.storefront),
        ),
        findsNWidgets(fills.length),
      );
      final ground = _hex(palette.background);
      for (final fill in fills) {
        expect(
          ObaContrast.ratio(fill, ground),
          greaterThanOrEqualTo(3),
          reason: 'pin $fill on ${palette.background}',
        );
      }
      await env.tearDown(tester);
    });
  }
}
