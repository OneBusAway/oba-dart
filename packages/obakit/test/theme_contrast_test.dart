import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

void main() {
  const surfaceLight = Color(0xFFFFFFFF);
  const surfaceDark = Color(0xFF121212);

  void check(String name, ObaTheme t, Color surface) {
    group(name, () {
      void text(String label, Color fg, Color bg) => test(
        '$label >= 4.5:1',
        () => expect(ObaContrast.ratio(fg, bg), greaterThanOrEqualTo(4.5)),
      );
      void nonText(String label, Color a, Color b) => test(
        '$label >= 3:1',
        () => expect(ObaContrast.ratio(a, b), greaterThanOrEqualTo(3)),
      );
      text('onBrand on brand', t.onBrand, t.brand);
      text('onTime on surface', t.onTime, surface);
      text('late on surface', t.late, surface);
      text('early on surface', t.early, surface);
      text('scheduled on surface', t.scheduled, surface);
      text('canceled on surface', t.canceled, surface);
      text('onVehicle on vehicle', t.onVehicle, t.vehicle);
      nonText('pin glyph on fill', t.stopPinGlyph, t.stopPinFill);
      nonText('pin stroke vs fill', t.stopPinStroke, t.stopPinFill);
      nonText(
        'bookmarked glyph on fill',
        t.bookmarkedPinGlyph,
        t.bookmarkedPinFill,
      );
      nonText('selected ring on map', t.selectedPinRing, t.mapBackground);
      nonText('user location on map', t.userLocation, t.mapBackground);
      nonText('route line on map', t.routeLine, t.mapBackground);
      nonText('brand on map', t.brand, t.mapBackground);
      test('pin visible on light or dark tiles', () {
        // Fill and stroke contrast each other, so one of them always
        // stands out from the tiles.
        for (final tile in const [Color(0xFFF2EFE9), Color(0xFF1B1B1D)]) {
          final best = [
            ObaContrast.ratio(t.stopPinFill, tile),
            ObaContrast.ratio(t.stopPinStroke, tile),
          ].reduce((a, b) => a > b ? a : b);
          expect(best, greaterThanOrEqualTo(3));
        }
      });
    });
  }

  check('light', ObaTheme.light(), surfaceLight);
  check('dark', ObaTheme.dark(), surfaceDark);
  check('high contrast light', ObaTheme.highContrastLight(), surfaceLight);
  check('high contrast dark', ObaTheme.highContrastDark(), surfaceDark);

  // Status text sits on cards, rows, chips and selected rows, not only on
  // the plain surface: check every Material 3 surface role it is drawn on.
  group('status colours on every surface role', () {
    for (final (name, b, hc, t) in [
      ('light', Brightness.light, false, ObaTheme.light()),
      ('dark', Brightness.dark, false, ObaTheme.dark()),
      ('hc light', Brightness.light, true, ObaTheme.highContrastLight()),
      ('hc dark', Brightness.dark, true, ObaTheme.highContrastDark()),
    ]) {
      final s = ObaTheme.buildThemeData(
        brightness: b,
        highContrast: hc,
      ).colorScheme;
      final surfaces = {
        'surface': s.surface,
        'surfaceDim': s.surfaceDim,
        'surfaceBright': s.surfaceBright,
        'surfaceContainerLowest': s.surfaceContainerLowest,
        'surfaceContainerLow': s.surfaceContainerLow,
        'surfaceContainer': s.surfaceContainer,
        'surfaceContainerHigh': s.surfaceContainerHigh,
        'surfaceContainerHighest': s.surfaceContainerHighest,
        'secondaryContainer': s.secondaryContainer,
      };
      final statuses = {
        'onTime': t.onTime,
        'late': t.late,
        'early': t.early,
        'scheduled': t.scheduled,
        'canceled': t.canceled,
      };
      for (final st in statuses.entries) {
        for (final sf in surfaces.entries) {
          test('$name ${st.key} on ${sf.key} >= 4.5:1', () {
            expect(
              ObaContrast.ratio(st.value, sf.value),
              greaterThanOrEqualTo(4.5),
            );
          });
        }
      }
    }
  });

  testWidgets('default status colours stay readable on a host surface', (
    tester,
  ) async {
    late ObaTheme resolved;
    // A host whose cards are a mid grey the defaults weren't made for.
    final host = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
          .copyWith(surfaceContainerHighest: const Color(0xFFC8C8C8)),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: host,
        home: Builder(
          builder: (context) {
            resolved = ObaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    for (final c in [resolved.onTime, resolved.late, resolved.early]) {
      expect(
        ObaContrast.ratio(c, const Color(0xFFC8C8C8)),
        greaterThanOrEqualTo(4.5),
      );
    }
  });

  group('generated ThemeData', () {
    for (final (b, hc) in [
      (Brightness.light, false),
      (Brightness.dark, false),
      (Brightness.light, true),
      (Brightness.dark, true),
    ]) {
      test('$b high contrast: $hc', () {
        final s = ObaTheme.buildThemeData(
          brightness: b,
          highContrast: hc,
        ).colorScheme;
        final min = hc ? 7.0 : 4.5;
        expect(
          ObaContrast.ratio(s.onSurface, s.surface),
          greaterThanOrEqualTo(min),
        );
        expect(
          ObaContrast.ratio(s.onPrimary, s.primary),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          ObaContrast.ratio(s.onSurfaceVariant, s.surfaceContainerLow),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          ObaContrast.ratio(s.onInverseSurface, s.inverseSurface),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          ObaContrast.ratio(s.primary, s.surface),
          greaterThanOrEqualTo(3),
        );
      });
    }
  });

  group('readable foreground on route colours', () {
    test('picks black or white', () {
      expect(
        ObaContrast.readableOn(const Color(0xFFFFCD00)),
        const Color(0xFF000000),
      );
      expect(
        ObaContrast.readableOn(const Color(0xFF00205B)),
        const Color(0xFFFFFFFF),
      );
    });

    test('keeps a readable feed colour, replaces an unreadable one', () {
      const bg = Color(0xFF0B5394);
      expect(
        ObaContrast.ensureReadable(const Color(0xFFFFFFFF), bg),
        const Color(0xFFFFFFFF),
      );
      expect(
        ObaContrast.ensureReadable(const Color(0xFF0A4A80), bg),
        const Color(0xFFFFFFFF),
      );
    });

    test('every badge text in a sample of feed colours meets 4.5:1', () {
      for (var v = 0; v <= 0xFFFFFF; v += 0x0F0F0F) {
        final bg = Color(0xFF000000 | v);
        expect(
          ObaContrast.ratio(ObaContrast.readableOn(bg), bg),
          greaterThanOrEqualTo(4.5),
        );
      }
    });
  });

  testWidgets('ObaTheme.of falls back by brightness and contrast', (
    tester,
  ) async {
    late ObaTheme got;
    Widget probe() => Builder(
      builder: (c) {
        got = ObaTheme.of(c);
        return const SizedBox();
      },
    );
    await tester.pumpWidget(
      MaterialApp(theme: ThemeData.dark(), home: probe()),
    );
    expect(got.brand, ObaTheme.dark().brand);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(highContrast: true),
        child: MaterialApp(theme: ThemeData.light(), home: probe()),
      ),
    );
    expect(got.brand, ObaTheme.highContrastLight().brand);
  });
}
