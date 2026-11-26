import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:oba_arrivals/src/widgets/focus_ring.dart';

import 'support/fixtures.dart';

/// Light and dark themes the panel must work under: Material defaults, the
/// UCSD navy brand, and a host-built scheme whose surfaces are not the
/// Material 3 tones (the panel must not assume any brand theme).
final themes = <String, ThemeData>{
  'default light': ThemeData(),
  'default dark': ThemeData(brightness: Brightness.dark),
  'navy light': ThemeData(colorSchemeSeed: const Color(0xFF182B49)),
  'navy dark': ThemeData(
    colorSchemeSeed: const Color(0xFF182B49),
    brightness: Brightness.dark,
  ),
  'host light': ThemeData(
    colorScheme: const ColorScheme.light(
      surface: Color(0xFFE9ECF2),
      onSurface: Color(0xFF111111),
      onSurfaceVariant: Color(0xFF8A8A8A), // fails 4.5:1 on its surface
      error: Color(0xFFFF5252), // fails 4.5:1 on its surface
    ),
  ),
  'host dark': ThemeData(
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF303030),
      onSurface: Color(0xFFEEEEEE),
      onSurfaceVariant: Color(0xFF777777), // fails 4.5:1 on its surface
    ),
  ),
};

Future<void> expectGuidelines(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  handle.dispose();
}

Widget host(
  Widget panel, {
  required ThemeData theme,
  double textScale = 1,
  bool highContrast = false,
  bool disableAnimations = false,
}) => MaterialApp(
  theme: theme,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(textScale),
      highContrast: highContrast,
      disableAnimations: disableAnimations,
    ),
    child: child!,
  ),
  home: Scaffold(body: SingleChildScrollView(child: panel)),
);

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

String emptyFixture() {
  final json = jsonDecode(arrivalsFixture()) as Map<String, dynamic>;
  ((json['data'] as Map<String, dynamic>)['entry']
          as Map<String, dynamic>)['arrivalsAndDepartures'] =
      <Object>[];
  return jsonEncode(json);
}

enum PanelState { loading, loaded, empty, error, stale }

/// Pumps the panel into [state]. Returns a completer to finish when the
/// state leaves a request pending (loading).
Future<Completer<http.Response>?> pumpState(
  WidgetTester tester,
  PanelState state, {
  required ThemeData theme,
  double textScale = 1,
}) async {
  final pending = Completer<http.Response>();
  var requests = 0;
  final client = fakeClient((_) {
    requests++;
    return switch (state) {
      PanelState.loading => pending.future,
      PanelState.loaded => Future.value(okResponse()),
      PanelState.empty => Future.value(okResponse(emptyFixture())),
      PanelState.error => Future.value(http.Response('', 200)),
      PanelState.stale =>
        requests == 1
            ? Future.value(okResponse())
            : Future.value(http.Response('', 500)),
    };
  });
  await tester.pumpWidget(
    host(
      ObaArrivalsPanel(
        client: client,
        stopId: 'MTS_24151',
        onArrivalTap: (_) {},
      ),
      theme: theme,
      textScale: textScale,
    ),
  );
  await settle(tester);
  if (state == PanelState.stale) {
    await tester.tap(find.byKey(const ValueKey('oba-refresh')));
    await settle(tester);
    expect(find.byKey(const ValueKey('oba-stale-notice')), findsOneWidget);
  }
  return state == PanelState.loading ? pending : null;
}

void main() {
  group('contrast of the default themes', () {
    for (final entry in themes.entries) {
      test('status colours are at least 4.5:1 on ${entry.key} surfaces', () {
        final scheme = entry.value.colorScheme;
        final dark = scheme.brightness == Brightness.dark;
        final oba = dark ? ObaArrivalsTheme.dark() : ObaArrivalsTheme.light();
        final surfaces = {
          'surface': scheme.surface,
          'surfaceContainerLowest': scheme.surfaceContainerLowest,
          'surfaceContainerLow': scheme.surfaceContainerLow,
          'surfaceContainer': scheme.surfaceContainer,
          'surfaceContainerHigh': scheme.surfaceContainerHigh,
          'surfaceContainerHighest': scheme.surfaceContainerHighest,
        };
        for (final s in surfaces.entries) {
          for (final kind in ArrivalStatusKind.values) {
            final color = oba.readableColorFor(kind, scheme, s.value);
            expect(
              contrastRatio(color, s.value),
              greaterThanOrEqualTo(4.5),
              reason: '$kind on ${s.key}',
            );
          }
        }
      });
    }

    test('fixed defaults pass on seeded schemes without adjustment', () {
      for (final seed in [
        const Color(0xFF6750A4),
        const Color(0xFF182B49),
        Colors.teal,
        Colors.yellow,
        Colors.red,
      ]) {
        for (final brightness in Brightness.values) {
          final scheme = ColorScheme.fromSeed(
            seedColor: seed,
            brightness: brightness,
          );
          final oba = brightness == Brightness.dark
              ? ObaArrivalsTheme.dark()
              : ObaArrivalsTheme.light();
          for (final bg in [
            scheme.surface,
            scheme.surfaceContainerHighest,
            scheme.secondaryContainer,
          ]) {
            for (final c in [oba.onTime, oba.late, oba.early]) {
              expect(
                contrastRatio(c, bg),
                greaterThanOrEqualTo(4.5),
                reason: '$c on $bg ($seed, $brightness)',
              );
            }
          }
        }
      }
    });

    test('high-contrast defaults reach 6.4:1 or more', () {
      final light = ObaArrivalsTheme.highContrastLight();
      final dark = ObaArrivalsTheme.highContrastDark();
      final lightScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      final darkScheme = ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      );
      for (final c in [light.onTime, light.late, light.early]) {
        expect(
          contrastRatio(c, lightScheme.surfaceContainerHighest),
          greaterThanOrEqualTo(7),
        );
      }
      for (final c in [dark.onTime, dark.late, dark.early]) {
        expect(
          contrastRatio(c, darkScheme.surfaceContainerHighest),
          greaterThanOrEqualTo(6.4),
        );
      }
    });

    test('a host override that is too light is adjusted, not shown', () {
      const host = ObaArrivalsTheme(
        onTime: Color(0xFF86EFAC), // light green: 1.4:1 on white
        late: Color(0xFFC4B5FD),
        early: Color(0xFFFCA5A5),
      );
      const white = Color(0xFFFFFFFF);
      final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      expect(contrastRatio(host.onTime, white), lessThan(4.5));
      final fixed = host.readableColorFor(
        ArrivalStatusKind.onTime,
        scheme,
        white,
      );
      expect(contrastRatio(fixed, white), greaterThanOrEqualTo(4.5));
      // Still recognisably green (the hue is kept, only darkened).
      expect(fixed.g, greaterThan(fixed.r));
    });
  });

  group('contrast helpers', () {
    test('contrastRatio matches WCAG reference values', () {
      expect(contrastRatio(Colors.black, Colors.white), closeTo(21, 0.01));
      expect(
        contrastRatio(const Color(0xFF767676), Colors.white),
        closeTo(4.54, 0.01),
      );
      expect(contrastRatio(Colors.white, Colors.white), 1);
    });

    test('ensureContrast keeps passing colours and fixes failing ones', () {
      const navy = Color(0xFF182B49);
      expect(ensureContrast(navy, Colors.white), navy);
      for (final bg in [Colors.white, const Color(0xFF121212)]) {
        for (final c in [Colors.yellow, Colors.grey, Colors.lightBlue]) {
          expect(
            contrastRatio(ensureContrast(c, bg), bg),
            greaterThanOrEqualTo(4.5),
          );
          expect(
            contrastRatio(ensureContrast(c, bg, minRatio: 3), bg),
            greaterThanOrEqualTo(3),
          );
        }
      }
    });

    test('accessibleColorScheme fixes only what fails', () {
      final seeded = ColorScheme.fromSeed(seedColor: const Color(0xFF182B49));
      expect(identical(accessibleColorScheme(seeded), seeded), isTrue);
      final host = themes['host light']!.colorScheme;
      final fixed = accessibleColorScheme(host);
      for (final c in [fixed.onSurfaceVariant, fixed.error, fixed.primary]) {
        expect(contrastRatio(c, host.surface), greaterThanOrEqualTo(4.5));
        expect(
          contrastRatio(c, host.surfaceContainerHighest),
          greaterThanOrEqualTo(4.5),
        );
      }
      expect(fixed.surface, host.surface);
    });

    test('readableTextColor rejects feed text colours that fail', () {
      // Yellow text on white: an unreadable route_color/route_text_color.
      expect(
        readableTextColor(const Color(0xFFFFFF00), Colors.white),
        Colors.black,
      );
      expect(
        readableTextColor(const Color(0xFF000099), Colors.white),
        const Color(0xFF000099),
      );
    });
  });

  group('route badge colours', () {
    test('every route colour gets a 4.5:1 label on both gradient stops', () {
      // A sweep of hues and tones, including the mid-tones where neither
      // black nor white passes against a lightened gradient top.
      for (var hue = 0; hue < 360; hue += 15) {
        for (final lightness in [0.1, 0.3, 0.4, 0.45, 0.5, 0.55, 0.7, 0.9]) {
          final bg = HSLColor.fromAHSL(
            1,
            hue.toDouble(),
            0.8,
            lightness,
          ).toColor();
          for (final preferred in [null, Colors.white, Colors.black, bg]) {
            final colors = RouteBadge.colorsFor(bg, preferred);
            final top = Color.alphaBlend(
              Colors.white.withValues(alpha: 0.18),
              bg,
            );
            expect(
              contrastRatio(colors.foreground, bg),
              greaterThanOrEqualTo(4.5),
              reason: 'label on $bg',
            );
            if (colors.gradient) {
              expect(
                contrastRatio(colors.foreground, top),
                greaterThanOrEqualTo(4.5),
                reason: 'label on gradient top of $bg',
              );
            }
          }
        }
      }
    });

    test('a readable feed text colour is kept', () {
      final colors = RouteBadge.colorsFor(
        const Color(0xFF20183D),
        const Color(0xFFFFCD00),
      );
      expect(colors.foreground, const Color(0xFFFFCD00));
      expect(colors.gradient, isTrue);
    });

    testWidgets('an unreadable agency pair is corrected in the widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: RouteBadge(label: '7', color: 'FFFF00', textColor: 'FFFFFF'),
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('7'));
      expect(text.style!.color, Colors.black);
    });
  });

  group('guidelines in each state', () {
    for (final themeName in ['navy light', 'navy dark', 'host light']) {
      for (final state in PanelState.values) {
        testWidgets('$state, $themeName', (tester) async {
          final pending = await pumpState(
            tester,
            state,
            theme: themes[themeName]!,
          );
          await expectGuidelines(tester);
          pending?.complete(okResponse());
          await settle(tester);
        });
      }
    }
  });

  group('200% text', () {
    for (final themeName in ['navy light', 'navy dark']) {
      for (final state in PanelState.values) {
        testWidgets('$state reflows without overflow, $themeName', (
          tester,
        ) async {
          tester.view.physicalSize = const Size(320 * 3, 900 * 3);
          tester.view.devicePixelRatio = 3;
          addTearDown(tester.view.reset);
          final pending = await pumpState(
            tester,
            state,
            theme: themes[themeName]!,
            textScale: 2,
          );
          expect(tester.takeException(), isNull);
          if (state == PanelState.loaded || state == PanelState.stale) {
            // Nothing essential is truncated: every text is unclamped.
            for (final text in tester.widgetList<Text>(find.byType(Text))) {
              expect(text.maxLines, isNull, reason: text.data);
              expect(text.overflow, isNot(TextOverflow.ellipsis));
            }
            expect(
              find.text('Eighth College / Theatre District (North)'),
              findsOneWidget,
            );
            expect(find.text('Inside Loop'), findsOneWidget);
            expect(find.text('5m'), findsOneWidget);
            expect(find.textContaining('2 min late'), findsOneWidget);
          }
          await expectGuidelines(tester);
          pending?.complete(okResponse());
          await settle(tester);
        });
      }
    }

    testWidgets('long headsigns and route names wrap at 200% on a narrow '
        'screen', (tester) async {
      tester.view.physicalSize = const Size(280 * 3, 900 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final json = jsonDecode(arrivalsFixture()) as Map<String, dynamic>;
      final entry =
          (json['data'] as Map<String, dynamic>)['entry']
              as Map<String, dynamic>;
      for (final a in (entry['arrivalsAndDepartures'] as List)) {
        (a as Map<String, dynamic>)['tripHeadsign'] =
            'Very Long Destination Name Via Several Neighbourhoods';
        a['routeShortName'] = 'Rapid 215 Express';
      }
      await tester.pumpWidget(
        host(
          ObaArrivalsPanel(
            client: fakeClient((_) async => okResponse(jsonEncode(json))),
            stopId: 'MTS_24151',
            onArrivalTap: (_) {},
          ),
          theme: themes['navy light']!,
          textScale: 2,
        ),
      );
      await settle(tester);
      expect(tester.takeException(), isNull);
    });
  });

  group('screen readers', () {
    testWidgets('the stop name is a heading', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpState(tester, PanelState.loaded, theme: themes['navy light']!);
      expect(
        tester.getSemantics(
          find.text('Eighth College / Theatre District (North)'),
        ),
        matchesSemantics(
          label: 'Eighth College / Theatre District (North)',
          isHeader: true,
        ),
      );
      expect(
        find.bySemanticsLabel('Stop #24151, Southwest bound, 101, 30, IL, S'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('loading is read once, as a live region', (tester) async {
      final handle = tester.ensureSemantics();
      final pending = await pumpState(
        tester,
        PanelState.loading,
        theme: themes['navy light']!,
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Loading arrivals')),
        matchesSemantics(label: 'Loading arrivals', isLiveRegion: true),
      );
      pending!.complete(okResponse());
      await settle(tester);
      expect(find.bySemanticsLabel('Loading arrivals'), findsNothing);
      handle.dispose();
    });

    testWidgets('empty, error and stale messages are live regions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      for (final (state, message) in [
        (PanelState.empty, 'No arrivals in the next 35 minutes'),
        (PanelState.error, 'Stop not found or service unavailable'),
      ]) {
        await pumpState(tester, state, theme: themes['navy light']!);
        expect(
          tester.getSemantics(find.text(message)),
          matchesSemantics(label: message, isLiveRegion: true),
        );
      }
      await pumpState(tester, PanelState.stale, theme: themes['navy light']!);
      final node = tester.getSemantics(find.textContaining("Couldn't update"));
      expect(node.getSemanticsData().flagsCollection.isLiveRegion, true);
      handle.dispose();
    });

    testWidgets('a rider-initiated refresh is announced; polls are not', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpState(tester, PanelState.loaded, theme: themes['navy light']!);
      tester.takeAnnouncements();

      await tester.pump(const Duration(seconds: 30)); // background poll
      await settle(tester);
      expect(tester.takeAnnouncements(), isEmpty);

      await tester.tap(find.byKey(const ValueKey('oba-refresh')));
      await settle(tester);
      expect(tester.takeAnnouncements().map((a) => a.message), [
        'Arrivals updated',
      ]);
      handle.dispose();
    });

    testWidgets('a failed retry announces the error', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpState(tester, PanelState.error, theme: themes['navy light']!);
      tester.takeAnnouncements();
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await settle(tester);
      expect(tester.takeAnnouncements().map((a) => a.message), [
        'Stop not found or service unavailable',
      ]);
      handle.dispose();
    });

    testWidgets('frequency-based rows speak whole words', (tester) async {
      final strings = const ObaArrivalsStrings();
      expect(strings.minutesLateSemantics(1), '1 minute late');
      expect(strings.minutesEarlySemantics(3), '3 minutes early');
      expect(
        strings.everyMinutesUntilSemantics(12, '9:00 PM'),
        'every 12 minutes until 9:00 PM',
      );
    });
  });

  group('input and display settings', () {
    testWidgets('rows are keyboard operable and show a focus ring', (
      tester,
    ) async {
      final tapped = <String>[];
      await tester.pumpWidget(
        host(
          ObaArrivalsPanel(
            client: fakeClient((_) async => okResponse()),
            stopId: 'MTS_24151',
            onArrivalTap: (a) => tapped.add(a.tripHeadsign ?? ''),
          ),
          theme: themes['navy light']!,
        ),
      );
      await settle(tester);
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );

      // Tab past the refresh button to the first row.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final ring = find.descendant(
        of: find.byType(FocusRingInkWell),
        matching: find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              (w.decoration as BoxDecoration).border != null,
        ),
      );
      expect(ring, findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(tapped, ['Old Town', 'Inside Loop']);
    });

    testWidgets('high contrast switches to the stronger palette', (
      tester,
    ) async {
      late ObaArrivalsTheme resolved;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              resolved = ObaArrivalsTheme.of(context);
              return const SizedBox();
            },
          ),
          theme: themes['navy light']!,
          highContrast: true,
        ),
      );
      expect(resolved.onTime, ObaArrivalsTheme.highContrastLight().onTime);
    });

    testWidgets('reduced motion replaces the refresh spinner', (tester) async {
      final pending = Completer<http.Response>();
      var requests = 0;
      await tester.pumpWidget(
        host(
          ObaArrivalsPanel(
            client: fakeClient((_) {
              requests++;
              return requests == 1
                  ? Future.value(okResponse())
                  : pending.future;
            }),
            stopId: 'MTS_24151',
          ),
          theme: themes['navy light']!,
          disableAnimations: true,
        ),
      );
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('oba-refresh')));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
      pending.complete(okResponse());
      await settle(tester);
    });

    testWidgets('bold text is applied to row text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(boldText: true),
            child: child!,
          ),
          home: Scaffold(
            body: ObaArrivalsPanel(
              client: fakeClient((_) async => okResponse()),
              stopId: 'MTS_24151',
            ),
          ),
        ),
      );
      await settle(tester);
      final rich = tester.widget<RichText>(
        find.descendant(
          of: find.textContaining('Southwest bound'),
          matching: find.byType(RichText),
        ),
      );
      expect(rich.text.style?.fontWeight, FontWeight.bold);
    });
  });
}
