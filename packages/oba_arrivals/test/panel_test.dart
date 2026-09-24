import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:oba_arrivals/oba_arrivals.dart';

import 'support/fixtures.dart';

Widget host(Widget panel, {ThemeData? theme}) => MaterialApp(
  theme: theme,
  home: Scaffold(body: SingleChildScrollView(child: panel)),
);

/// Lets MockClient futures resolve, then rebuilds.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

String fixtureWith(void Function(Map<String, dynamic> entry) edit) {
  final json = jsonDecode(arrivalsFixture()) as Map<String, dynamic>;
  edit((json['data'] as Map<String, dynamic>)['entry'] as Map<String, dynamic>);
  return jsonEncode(json);
}

void main() {
  testWidgets('shows skeleton rows while loading', (tester) async {
    final pending = Completer<http.Response>();
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) => pending.future),
          stopId: 'MTS_24151',
        ),
      ),
    );
    expect(find.byKey(const ValueKey('oba-skeleton-row')), findsNWidgets(3));
    pending.complete(okResponse());
    await settle(tester);
  });

  testWidgets('loaded: header, subtitle and visible rows in server order', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse()),
          stopId: 'MTS_24151',
        ),
      ),
    );
    await settle(tester);

    expect(
      find.text('Eighth College / Theatre District (North)'),
      findsOneWidget,
    );
    expect(
      find.text('Stop #24151 · Southwest bound · 101, 30, IL, S'),
      findsOneWidget,
    );
    expect(find.text('UTC'), findsNothing); // departed
    expect(find.text('Old Town'), findsOneWidget);
    expect(find.text('Inside Loop'), findsOneWidget);
    expect(find.text('SIO'), findsOneWidget);
    expect(find.text('4m'), findsOneWidget);
    expect(find.text('5m'), findsOneWidget);
    expect(find.text('8m'), findsOneWidget);
    expect(find.textContaining('2 min late'), findsOneWidget);
    expect(find.textContaining('on time'), findsOneWidget);
    expect(find.textContaining('scheduled'), findsOneWidget);
    expect(find.byIcon(Icons.rss_feed), findsNWidgets(2));
    expect(find.byIcon(Icons.schedule), findsOneWidget);
    final order = [
      'Old Town',
      'Inside Loop',
      'SIO',
    ].map((t) => tester.getTopLeft(find.text(t)).dy).toList();
    expect(order, orderedEquals([...order]..sort()));
  });

  testWidgets('maxArrivals caps rows', (tester) async {
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse()),
          stopId: 'MTS_24151',
          maxArrivals: 2,
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Inside Loop'), findsOneWidget);
    expect(find.text('SIO'), findsNothing);
  });

  testWidgets('empty list shows the no-arrivals message', (tester) async {
    final body = fixtureWith((e) => e['arrivalsAndDepartures'] = []);
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse(body)),
          stopId: 'MTS_24151',
          minutesAfter: 60,
        ),
      ),
    );
    await settle(tester);
    expect(find.text('No arrivals in the next 60 minutes'), findsOneWidget);
  });

  testWidgets('empty body shows not-found message and retry refetches', (
    tester,
  ) async {
    var requests = 0;
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async {
            requests++;
            return requests == 1 ? http.Response('', 200) : okResponse();
          }),
          stopId: 'MTS_99999999',
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Stop not found or service unavailable'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Retry'));
    await settle(tester);
    expect(requests, 2);
    expect(find.text('Old Town'), findsOneWidget);
  });

  testWidgets('error state keeps message and Retry across a background poll', (
    tester,
  ) async {
    var requests = 0;
    final second = Completer<http.Response>();
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) {
            requests++;
            return requests == 1
                ? Future.value(http.Response('', 200))
                : second.future;
          }),
          stopId: 'MTS_99999999',
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Stop not found or service unavailable'), findsOneWidget);

    await tester.pump(const Duration(seconds: 30)); // poll starts, in flight
    expect(requests, 2);
    expect(find.byKey(const ValueKey('oba-skeleton-row')), findsNothing);
    expect(find.text('Stop not found or service unavailable'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Retry'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('oba-refresh')),
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );

    second.complete(http.Response('', 200));
    await settle(tester);
    expect(find.byKey(const ValueKey('oba-skeleton-row')), findsNothing);
    expect(find.text('Stop not found or service unavailable'), findsOneWidget);
  });

  testWidgets(
    'header shimmers only while loading; otherwise names the stop id',
    (tester) async {
      final pending = Completer<http.Response>();
      await tester.pumpWidget(
        host(
          ObaArrivalsPanel(
            client: fakeClient((_) => pending.future),
            stopId: 'MTS_99999999',
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey('oba-header-placeholder')),
        findsOneWidget,
      );
      expect(find.text('Stop #99999999'), findsNothing);

      pending.complete(http.Response('', 200)); // error with no data
      await settle(tester);
      expect(
        find.text('Stop not found or service unavailable'),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('oba-header-placeholder')),
        findsNothing,
      );
      expect(find.text('Stop #99999999'), findsOneWidget);
    },
  );

  testWidgets('loaded without the stop in references shows the stop id title', (
    tester,
  ) async {
    final json = jsonDecode(arrivalsFixture()) as Map<String, dynamic>;
    ((json['data'] as Map<String, dynamic>)['references']
            as Map<String, dynamic>)['stops'] =
        [];
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse(jsonEncode(json))),
          stopId: 'MTS_24151',
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Old Town'), findsOneWidget);
    expect(find.byKey(const ValueKey('oba-header-placeholder')), findsNothing);
    expect(find.text('Stop #24151'), findsOneWidget);
  });

  testWidgets('IL badge from the real fixture has black text', (tester) async {
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse()),
          stopId: 'MTS_24151',
        ),
      ),
    );
    await settle(tester);
    final label = tester.widget<Text>(
      find.descendant(of: find.byType(RouteBadge), matching: find.text('IL')),
    );
    expect(label.style!.color, Colors.black);
  });

  testWidgets('failed refresh keeps rows and shows stale notice', (
    tester,
  ) async {
    var requests = 0;
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async {
            requests++;
            return requests == 1 ? okResponse() : http.Response('', 503);
          }),
          stopId: 'MTS_24151',
        ),
      ),
    );
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('oba-refresh')));
    await settle(tester);
    expect(find.text('Old Town'), findsOneWidget);
    expect(find.byKey(const ValueKey('oba-stale-notice')), findsOneWidget);
  });

  testWidgets('departed row disappears on tick without refetching', (
    tester,
  ) async {
    var requests = 0;
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async {
            requests++;
            return okResponse();
          }),
          stopId: 'MTS_24151',
          refreshInterval: const Duration(minutes: 10),
        ),
      ),
    );
    await settle(tester);
    expect(find.text('4m'), findsOneWidget);

    await tester.pump(const Duration(seconds: 60));
    expect(find.text('3m'), findsOneWidget); // Old Town ticked down

    await tester.pump(const Duration(minutes: 4));
    expect(find.text('Old Town'), findsNothing); // ETA now negative
    expect(find.text('Inside Loop'), findsOneWidget);
    expect(requests, 1);
  });

  testWidgets('onArrivalTap receives the arrival; chevron only when tappable', (
    tester,
  ) async {
    ArrivalAndDeparture? tapped;
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse()),
          stopId: 'MTS_24151',
          onArrivalTap: (a) => tapped = a,
        ),
      ),
    );
    await settle(tester);
    expect(find.byIcon(Icons.chevron_right), findsNWidgets(3));
    await tester.tap(find.text('Old Town'));
    expect(tapped!.tripId, 'MTS_19630024');

    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse()),
          stopId: 'MTS_24151',
        ),
      ),
    );
    await settle(tester);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('rows expose a single semantics label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse()),
          stopId: 'MTS_24151',
        ),
      ),
    );
    await settle(tester);
    expect(
      find.bySemanticsLabel(
        'IL, Inside Loop, arriving in 5 minutes, 2 min late, real-time',
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('S, SIO, arriving in 8 minutes, scheduled'),
      findsOneWidget,
    );
    expect(find.byTooltip('Refresh arrivals'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('pauses while TickerMode disabled', (tester) async {
    var requests = 0;
    final client = fakeClient((_) async {
      requests++;
      return okResponse();
    });
    Widget build(bool enabled) => host(
      TickerMode(
        enabled: enabled,
        child: ObaArrivalsPanel(client: client, stopId: 'MTS_24151'),
      ),
    );

    await tester.pumpWidget(build(true));
    await settle(tester);
    expect(requests, 1);
    await tester.pumpWidget(build(false));
    await tester.pump(const Duration(minutes: 2));
    expect(requests, 1);
    await tester.pumpWidget(build(true));
    await settle(tester);
    expect(requests, 2);
  });

  testWidgets('pauses when app is paused, refreshes on resume', (tester) async {
    var requests = 0;
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: fakeClient((_) async {
            requests++;
            return okResponse();
          }),
          stopId: 'MTS_24151',
        ),
      ),
    );
    await settle(tester);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(minutes: 2));
    expect(requests, 1);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settle(tester);
    expect(requests, 2);
  });

  testWidgets('changing stopId reloads', (tester) async {
    final stops = <String>[];
    final client = fakeClient((r) async {
      stops.add(r.url.pathSegments.last);
      return okResponse();
    });
    await tester.pumpWidget(
      host(ObaArrivalsPanel(client: client, stopId: 'MTS_24151')),
    );
    await settle(tester);
    await tester.pumpWidget(
      host(ObaArrivalsPanel(client: client, stopId: 'MTS_88986')),
    );
    await settle(tester);
    expect(stops, ['MTS_24151.json', 'MTS_88986.json']);
  });

  testWidgets('onError reports failures; a new closure does not reload', (
    tester,
  ) async {
    var requests = 0;
    final client = fakeClient((_) async {
      requests++;
      return http.Response('', 500);
    });
    final first = <Object>[];
    final second = <Object>[];
    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: client,
          stopId: 'MTS_24151',
          onError: (e, _) => first.add(e),
        ),
      ),
    );
    await settle(tester);
    expect(first.single, isA<ObaApiException>());

    await tester.pumpWidget(
      host(
        ObaArrivalsPanel(
          client: client,
          stopId: 'MTS_24151',
          onError: (e, _) => second.add(e),
        ),
      ),
    );
    await settle(tester);
    expect(requests, 1); // same configuration, no reload

    await tester.tap(find.widgetWithText(TextButton, 'Retry'));
    await settle(tester);
    expect(first, hasLength(1));
    expect(second, hasLength(1)); // the latest callback is used
  });

  testWidgets('lays out without overflow at 200% text scale', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 800 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: ObaArrivalsPanel(
                client: fakeClient((_) async => okResponse()),
                stopId: 'MTS_24151',
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('host-provided controller is not disposed by the panel', (
    tester,
  ) async {
    final controller = ArrivalsController(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
    );
    await tester.pumpWidget(host(ObaArrivalsPanel(controller: controller)));
    await settle(tester);
    await tester.pumpWidget(const SizedBox());
    expect(() => controller.addListener(() {}), returnsNormally);
    controller.dispose();
  });

  testWidgets(
    'a host controller shared by a card and a pushed full-page panel keeps '
    'polling while the page is on top',
    (tester) async {
      var requests = 0;
      final controller = ArrivalsController(
        client: fakeClient((_) async {
          requests++;
          return okResponse();
        }),
        stopId: 'MTS_24151',
      );
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: Scaffold(body: ObaArrivalsPanel(controller: controller)),
        ),
      );
      await settle(tester);
      expect(requests, 1);

      unawaited(
        navigator.currentState!.push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              body: SingleChildScrollView(
                child: ObaArrivalsPanel(controller: controller),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(); // transition done; the card is covered
      final afterPush = requests;

      await tester.pump(const Duration(seconds: 30));
      await settle(tester);
      expect(requests, greaterThan(afterPush));
      expect(controller.isRunning, isTrue);

      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(controller.isRunning, isTrue); // the card holds it again

      await tester.pumpWidget(const SizedBox());
      await settle(tester);
      expect(controller.isRunning, isFalse); // every panel released it
      controller.dispose();
    },
  );

  testWidgets(
    'resuming a shared host controller on TickerMode re-enable does not '
    'notify a sibling during the panel\'s build',
    (tester) async {
      final controller = ArrivalsController(
        client: fakeClient((_) async => okResponse()),
        stopId: 'MTS_24151',
      );
      late StateSetter setLocalState;
      var enabled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                setLocalState = setState;
                return Column(
                  children: [
                    ListenableBuilder(
                      listenable: controller,
                      builder: (context, _) => Text(
                        controller.state.isRefreshing ? 'refreshing' : 'idle',
                      ),
                    ),
                    TickerMode(
                      enabled: enabled,
                      child: ObaArrivalsPanel(controller: controller),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await settle(tester);

      // Re-enabling TickerMode rebuilds only the StatefulBuilder's subtree
      // (not a fresh pumpWidget), so the panel's didChangeDependencies runs
      // while the framework's current build target is the panel itself. The
      // sibling ListenableBuilder must not be notified synchronously from
      // there.
      setLocalState(() => enabled = true);
      await tester.pump();
      await settle(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('Old Town'), findsOneWidget);
      controller.dispose();
    },
  );
}
