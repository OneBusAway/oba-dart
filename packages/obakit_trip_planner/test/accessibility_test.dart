import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

import 'support/fixtures.dart';

/// Light and dark host themes, including a host-built scheme whose
/// secondary text and error colours fail 4.5:1 on its own surface.
final themes = <String, ThemeData>{
  'light': ThemeData(colorSchemeSeed: const Color(0xFF182B49)),
  'dark': ThemeData(
    colorSchemeSeed: const Color(0xFF182B49),
    brightness: Brightness.dark,
  ),
  'host light': ThemeData(
    colorScheme: const ColorScheme.light(
      surface: Color(0xFFE9ECF2),
      onSurfaceVariant: Color(0xFF8A8A8A),
      error: Color(0xFFFF5252),
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

Widget app(
  Widget home, {
  required ThemeData theme,
  double textScale = 1,
  bool disableAnimations = false,
}) => MaterialApp(
  theme: theme,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(textScale),
      disableAnimations: disableAnimations,
    ),
    child: child!,
  ),
  home: home,
);

void setPhone(WidgetTester tester, {double width = 390, double height = 844}) {
  tester.view.physicalSize = Size(width * 3, height * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// The SDMTS plan with real-time data on its transit legs (3 min late).
TripPlan realTimePlan() {
  final json = fixtureJson(sdRestFixture);
  final plan = json['plan'] as Map<String, dynamic>;
  for (final itinerary in plan['itineraries'] as List) {
    for (final leg in (itinerary as Map<String, dynamic>)['legs'] as List) {
      final map = leg as Map<String, dynamic>;
      if (map['transitLeg'] == true) {
        map['realTime'] = true;
        map['departureDelay'] = 180;
        map['arrivalDelay'] = 180;
      }
    }
  }
  return parseRestPlanResponse(json);
}

enum PlannerState { idle, loading, loaded, empty, error }

Future<FakeTripPlanService> pumpPlanner(
  WidgetTester tester,
  PlannerState state, {
  required ThemeData theme,
  double textScale = 1,
  bool disableAnimations = false,
}) async {
  final service = FakeTripPlanService();
  switch (state) {
    case PlannerState.loaded:
      service.result = realTimePlan();
    case PlannerState.empty:
      service.result = parseRestPlanResponse(
        fixtureJson('rest/otp_response_empty.json'),
      );
    case PlannerState.error:
      service.error = const OtpNetworkException('offline');
    case PlannerState.idle || PlannerState.loading:
      break;
  }
  await tester.pumpWidget(
    app(
      Scaffold(
        body: TripPlannerView(
          service: service,
          placeSearch: FakeTripPlaceSearch(),
          mapConfig: testMapConfig(),
          initialOrigin: ucsd,
          initialDestination: downtown,
          distanceUnits: DistanceUnits.imperial,
        ),
      ),
      theme: theme,
      textScale: textScale,
      disableAnimations: disableAnimations,
    ),
  );
  await tester.pump();
  if (state != PlannerState.idle) {
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
  }
  return service;
}

Widget detailPage({VoidCallback? onAttributionTap}) => ItineraryDetailPage(
  itinerary: realTimePlan().itineraries.first,
  mapConfig: TripMapConfig(
    userAgentPackageName: 'org.onebusaway.test',
    tileProvider: TransparentTileProvider(),
    onAttributionTap: onAttributionTap,
  ),
  originName: 'Geisel Library',
  distanceUnits: DistanceUnits.imperial,
);

Leg transitLeg({String? color, String? textColor}) => Leg(
  startTime: DateTime.utc(2026, 11, 25, 17),
  endTime: DateTime.utc(2026, 11, 25, 17, 30),
  mode: 'BUS',
  from: const Place(name: 'A', lat: 0, lon: 0),
  to: const Place(name: 'B', lat: 0, lon: 0),
  routeShortName: '7',
  routeColor: color,
  routeTextColor: textColor,
  transitLeg: true,
);

void main() {
  group('contrast', () {
    for (final brightness in Brightness.values) {
      for (final highContrast in [false, true]) {
        test('status colours are at least 4.5:1 on every surface '
            '($brightness, highContrast: $highContrast)', () {
          for (final seed in [
            const Color(0xFF182B49),
            const Color(0xFF6750A4),
            Colors.teal,
            Colors.yellow,
          ]) {
            final scheme = ColorScheme.fromSeed(
              seedColor: seed,
              brightness: brightness,
            );
            final theme = TripPlannerTheme.fromColorScheme(
              scheme,
              highContrast: highContrast,
            );
            for (final bg in [
              scheme.surface,
              scheme.surfaceContainerLow,
              scheme.surfaceContainerHighest,
              scheme.secondaryContainer, // selected card
            ]) {
              for (final c in [theme.onTime, theme.late, theme.early]) {
                expect(
                  TripPlannerContrast.ratio(c, bg),
                  greaterThanOrEqualTo(highContrast ? 6.4 : 4.5),
                  reason: '$c on $bg ($seed)',
                );
              }
            }
          }
        });
      }
    }

    test('a too-faint host override is adjusted against its surface', () {
      final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      final theme = TripPlannerTheme.fromColorScheme(scheme)
          .copyWith(late: const Color(0xFFDDD6FE));
      final fixed = theme.readableStatusColor(
        const LateStatus(3),
        scheme,
        scheme.surface,
      );
      expect(
        TripPlannerContrast.ratio(fixed, scheme.surface),
        greaterThanOrEqualTo(4.5),
      );
      // Scheduled uses the host's onSurfaceVariant, adjusted if needed.
      final host = const ColorScheme.light(
        surface: Color(0xFFE9ECF2),
        onSurfaceVariant: Color(0xFF8A8A8A),
      );
      expect(
        TripPlannerContrast.ratio(
          theme.readableStatusColor(
            const ScheduledStatus(),
            host,
            host.surface,
          ),
          host.surface,
        ),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('contrastingTextColor follows WCAG, not estimated brightness', () {
      // estimateBrightnessForColor picked white here (3.2:1).
      expect(contrastingTextColor(const Color(0xFF00A651)), Colors.black);
      expect(contrastingTextColor(const Color(0xFF1E90FF)), Colors.black);
      expect(contrastingTextColor(const Color(0xFF20183D)), Colors.white);
    });

    test('route text colours always reach 4.5:1', () {
      final theme = TripPlannerTheme.fromColorScheme(
        ColorScheme.fromSeed(seedColor: Colors.blue),
      );
      // An agency pair that fails: white on yellow.
      final bad = transitLeg(color: 'FFFF00', textColor: 'FFFFFF');
      expect(theme.onColorForLeg(bad), Colors.black);
      // A readable agency pair is kept.
      final good = transitLeg(color: '20183D', textColor: 'FFCD00');
      expect(theme.onColorForLeg(good), const Color(0xFFFFCD00));
      for (var hue = 0; hue < 360; hue += 20) {
        for (final l in [0.2, 0.4, 0.5, 0.6, 0.8]) {
          final bg = HSLColor.fromAHSL(1, hue.toDouble(), 0.8, l).toColor();
          final hex = bg.toARGB32().toRadixString(16).substring(2);
          final leg = transitLeg(color: hex, textColor: hex);
          expect(
            TripPlannerContrast.ratio(
              theme.onColorForLeg(leg),
              theme.colorForLeg(leg),
            ),
            greaterThanOrEqualTo(4.5),
            reason: hex,
          );
        }
      }
    });
  });

  group('guidelines in each state', () {
    for (final themeName in themes.keys) {
      for (final state in PlannerState.values) {
        testWidgets('planner $state, $themeName', (tester) async {
          setPhone(tester, height: 2400);
          final service = await pumpPlanner(
            tester,
            state,
            theme: themes[themeName]!,
          );
          await expectGuidelines(tester);
          if (state == PlannerState.loading) {
            service.complete(sdPlan());
            await tester.pump();
          }
        });
      }

      testWidgets('itinerary detail, $themeName', (tester) async {
        setPhone(tester);
        await tester.pumpWidget(
          app(detailPage(onAttributionTap: () {}), theme: themes[themeName]!),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('Show ').first);
        await tester.pumpAndSettle();
        await expectGuidelines(tester);
      });

      testWidgets('place search results, $themeName', (tester) async {
        setPhone(tester);
        await tester.pumpWidget(
          app(
            TripPlaceSearchPage(
              search: FakeTripPlaceSearch(),
              title: 'To',
              currentLocation: () async => here,
            ),
            theme: themes[themeName]!,
          ),
        );
        await tester.enterText(find.byType(TextField), 'o');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();
        expect(find.text('Horton Plaza'), findsOneWidget);
        await expectGuidelines(tester);
      });
    }
  });

  group('200% text', () {
    for (final themeName in ['light', 'dark']) {
      for (final state in PlannerState.values) {
        testWidgets('planner $state reflows, $themeName', (tester) async {
          setPhone(tester, width: 360, height: 4000);
          final service = await pumpPlanner(
            tester,
            state,
            theme: themes[themeName]!,
            textScale: 2,
          );
          expect(tester.takeException(), isNull);
          for (final text in tester.widgetList<Text>(find.byType(Text))) {
            expect(text.overflow, isNot(TextOverflow.ellipsis));
          }
          await expectGuidelines(tester);
          if (state == PlannerState.loading) {
            service.complete(sdPlan());
            await tester.pump();
          }
        });
      }

      testWidgets('itinerary detail reflows, $themeName', (tester) async {
        setPhone(tester, width: 360, height: 3000);
        await tester.pumpWidget(
          app(
            detailPage(onAttributionTap: () {}),
            theme: themes[themeName]!,
            textScale: 2,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        // The time column is folded into the content at large sizes.
        expect(find.text('9:09 AM'), findsWidgets);
        await expectGuidelines(tester);
      });

      testWidgets('place search reflows, $themeName', (tester) async {
        setPhone(tester, width: 360);
        await tester.pumpWidget(
          app(
            TripPlaceSearchPage(
              search: FakeTripPlaceSearch(),
              title: 'To',
              currentLocation: () async => here,
            ),
            theme: themes[themeName]!,
            textScale: 2,
          ),
        );
        await tester.enterText(find.byType(TextField), 'o');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();
        expect(tester.takeException(), isNull);
        await expectGuidelines(tester);
      });
    }
  });

  group('screen readers', () {
    testWidgets('an itinerary card reads as one spoken sentence', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      setPhone(tester, height: 2400);
      await pumpPlanner(tester, PlannerState.loaded, theme: themes['light']!);
      expect(
        find.bySemanticsLabel(
          RegExp(
            r'^\d+:\d\d [AP]M to \d+:\d\d [AP]M, \d+ minutes\. '
            r'Walk \d+ minutes?, then Tram Blue, \d+ minutes.*'
            r'Walk [\d.]+ (feet|miles?).*'
            r'Departs \d+:\d\d [AP]M from .*, real-time, 3 minutes late$',
          ),
        ),
        findsWidgets,
      );
      handle.dispose();
    });

    testWidgets('scheduled trips say so', (tester) async {
      final handle = tester.ensureSemantics();
      setPhone(tester, height: 2400);
      final service = FakeTripPlanService(result: sdPlan());
      await tester.pumpWidget(
        app(
          Scaffold(
            body: TripPlannerView(
              service: service,
              placeSearch: FakeTripPlaceSearch(),
              mapConfig: testMapConfig(),
              initialOrigin: ucsd,
              initialDestination: downtown,
            ),
          ),
          theme: themes['light']!,
        ),
      );
      await tester.tap(find.text('Plan trip'));
      await tester.pump();
      expect(find.bySemanticsLabel(RegExp(r', scheduled time$')), findsWidgets);
      handle.dispose();
    });

    testWidgets('results have a heading and the count is announced', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      setPhone(tester, height: 2400);
      await pumpPlanner(tester, PlannerState.idle, theme: themes['light']!);
      tester.takeAnnouncements();
      // Plan for real (idle state has no result configured yet).
      final service = FakeTripPlanService();
      await tester.pumpWidget(
        app(
          Scaffold(
            body: TripPlannerView(
              service: service,
              placeSearch: FakeTripPlaceSearch(),
              mapConfig: testMapConfig(),
              initialOrigin: ucsd,
              initialDestination: downtown,
            ),
          ),
          theme: themes['light']!,
        ),
      );
      await tester.tap(find.text('Plan trip'));
      await tester.pump();
      expect(
        tester.getSemantics(find.bySemanticsLabel('Planning your trip')),
        matchesSemantics(label: 'Planning your trip', isLiveRegion: true),
      );
      service.complete(sdPlan());
      await tester.pump();
      final count = sdPlan().itineraries.length;
      expect(tester.takeAnnouncements().map((a) => a.message), [
        '$count trips found',
      ]);
      expect(
        tester.getSemantics(find.text('Suggested trips')),
        matchesSemantics(label: 'Suggested trips', isHeader: true),
      );
      handle.dispose();
    });

    testWidgets('errors and "no trips" are live regions', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpPlanner(tester, PlannerState.error, theme: themes['light']!);
      const message = "Couldn't reach the trip planner. Check your connection.";
      expect(
        tester.getSemantics(find.text(message)),
        matchesSemantics(label: message, isLiveRegion: true),
      );
      await pumpPlanner(tester, PlannerState.empty, theme: themes['light']!);
      expect(
        tester.getSemantics(find.text('No trips found')),
        matchesSemantics(label: 'No trips found', isLiveRegion: true),
      );
      handle.dispose();
    });

    testWidgets('the map is one labelled node; markers are excluded', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      setPhone(tester);
      var attributionTaps = 0;
      await tester.pumpWidget(
        app(
          detailPage(onAttributionTap: () => attributionTaps++),
          theme: themes['light']!,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.bySemanticsLabel(
          'Map of the trip. The directions below describe the same trip.',
        ),
        findsOneWidget,
      );
      final attribution = find.text('© OpenStreetMap contributors');
      expect(
        tester.getSemantics(attribution),
        matchesSemantics(
          label: '© OpenStreetMap contributors',
          isLink: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );
      final inkSize = tester.getSize(
        find.ancestor(of: attribution, matching: find.byType(InkWell)),
      );
      expect(inkSize.width, greaterThanOrEqualTo(48));
      expect(inkSize.height, greaterThanOrEqualTo(48));
      await tester.tap(attribution);
      expect(attributionTaps, 1);
      handle.dispose();
    });

    testWidgets('the summary is a heading and durations are spoken', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      setPhone(tester);
      await tester.pumpWidget(app(detailPage(), theme: themes['light']!));
      await tester.pumpAndSettle();
      final summary = find.bySemanticsLabel(
        RegExp(r'^\d+:\d\d [AP]M to \d+:\d\d [AP]M, \d+ minutes$'),
      );
      expect(summary, findsOneWidget);
      expect(
        tester
            .getSemantics(summary)
            .getSemanticsData()
            .flagsCollection
            .isHeader,
        isTrue,
      );
      expect(
        find.bySemanticsLabel(
          RegExp(r'[\d.]+ (feet|miles?), about \d+ minutes?'),
        ),
        findsWidgets,
      );
      expect(
        find.bySemanticsLabel(RegExp('real-time, 3 minutes late')),
        findsWidgets,
      );
      handle.dispose();
    });

    testWidgets('show/hide stops exposes its expanded state', (tester) async {
      final handle = tester.ensureSemantics();
      setPhone(tester);
      await tester.pumpWidget(app(detailPage(), theme: themes['light']!));
      await tester.pumpAndSettle();
      final button = find.textContaining('Show ').first;
      expect(
        tester
            .getSemantics(button)
            .getSemanticsData()
            .flagsCollection
            .isExpanded,
        Tristate.isFalse,
      );
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(
        tester
            .getSemantics(find.textContaining('Hide '))
            .getSemanticsData()
            .flagsCollection
            .isExpanded,
        Tristate.isTrue,
      );
      handle.dispose();
    });

    testWidgets('the place search field has a label and results are '
        'announced', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        app(
          TripPlaceSearchPage(search: FakeTripPlaceSearch(), title: 'To'),
          theme: themes['light']!,
        ),
      );
      final field = find.bySemanticsLabel('Search for a place');
      expect(field, findsOneWidget);
      expect(
        tester
            .getSemantics(field)
            .getSemanticsData()
            .flagsCollection
            .isTextField,
        isTrue,
      );
      tester.takeAnnouncements();
      await tester.enterText(find.byType(TextField), 'horton');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(tester.takeAnnouncements().map((a) => a.message), [
        '1 place found',
      ]);
      handle.dispose();
    });
  });

  group('input and display settings', () {
    testWidgets('cards and place fields work by keyboard with a focus ring', (
      tester,
    ) async {
      setPhone(tester, height: 2400);
      final opened = <Itinerary>[];
      await tester.pumpWidget(
        app(
          Scaffold(
            body: TripPlannerView(
              service: FakeTripPlanService(result: sdPlan()),
              placeSearch: FakeTripPlaceSearch(),
              mapConfig: testMapConfig(),
              initialOrigin: ucsd,
              initialDestination: downtown,
              onItineraryTap: (_, it) => opened.add(it),
            ),
          ),
          theme: themes['light']!,
        ),
      );
      await tester.tap(find.text('Plan trip'));
      await tester.pump();
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );

      // Tab until the first itinerary card has focus.
      final card = find.byType(ItineraryCard).first;
      for (var i = 0; i < 30; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final focus = FocusManager.instance.primaryFocus?.context;
        if (focus != null &&
            find
                .ancestor(of: find.byWidget(focus.widget), matching: card)
                .evaluate()
                .isNotEmpty) {
          break;
        }
      }
      final ring = find.descendant(
        of: card,
        matching: find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              w.position == DecorationPosition.foreground &&
              (w.decoration as BoxDecoration).border != null,
        ),
      );
      expect(ring, findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(opened, hasLength(1));
    });

    testWidgets('reduced motion replaces the planning spinner', (tester) async {
      final service = await pumpPlanner(
        tester,
        PlannerState.loading,
        theme: themes['light']!,
        disableAnimations: true,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
      service.complete(sdPlan());
      await tester.pump();
    });

    testWidgets('high contrast picks the stronger status palette', (
      tester,
    ) async {
      late TripPlannerTheme resolved;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(highContrast: true),
            child: child!,
          ),
          home: Builder(
            builder: (context) {
              resolved = TripPlannerTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved.onTime, const Color(0xFF14532D));
    });
  });
}
