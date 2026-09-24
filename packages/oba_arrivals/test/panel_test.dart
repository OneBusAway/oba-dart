import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

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
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) => pending.future),
      stopId: 'MTS_24151',
    )));
    expect(find.byKey(const ValueKey('oba-skeleton-row')), findsNWidgets(3));
    pending.complete(okResponse());
    await settle(tester);
  });

  testWidgets('loaded: header, subtitle and visible rows in server order',
      (tester) async {
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
    )));
    await settle(tester);

    expect(find.text('Eighth College / Theatre District (North)'), findsOneWidget);
    expect(find.text('Stop #24151 · Southwest bound · 101, 30, IL, S'), findsOneWidget);
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
    final order = ['Old Town', 'Inside Loop', 'SIO']
        .map((t) => tester.getTopLeft(find.text(t)).dy)
        .toList();
    expect(order, orderedEquals([...order]..sort()));
  });

  testWidgets('maxArrivals caps rows', (tester) async {
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
      maxArrivals: 2,
    )));
    await settle(tester);
    expect(find.text('Inside Loop'), findsOneWidget);
    expect(find.text('SIO'), findsNothing);
  });

  testWidgets('empty list shows the no-arrivals message', (tester) async {
    final body = fixtureWith((e) => e['arrivalsAndDepartures'] = []);
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse(body)),
      stopId: 'MTS_24151',
      minutesAfter: 60,
    )));
    await settle(tester);
    expect(find.text('No arrivals in the next 60 minutes'), findsOneWidget);
  });

  testWidgets('empty body shows not-found message and retry refetches',
      (tester) async {
    var requests = 0;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async {
        requests++;
        return requests == 1 ? http.Response('', 200) : okResponse();
      }),
      stopId: 'MTS_99999999',
    )));
    await settle(tester);
    expect(find.text('Stop not found or service unavailable'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Retry'));
    await settle(tester);
    expect(requests, 2);
    expect(find.text('Old Town'), findsOneWidget);
  });

  testWidgets('failed refresh keeps rows and shows stale notice', (tester) async {
    var requests = 0;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async {
        requests++;
        return requests == 1 ? okResponse() : http.Response('', 503);
      }),
      stopId: 'MTS_24151',
    )));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('oba-refresh')));
    await settle(tester);
    expect(find.text('Old Town'), findsOneWidget);
    expect(find.byKey(const ValueKey('oba-stale-notice')), findsOneWidget);
  });

  testWidgets('departed row disappears on tick without refetching',
      (tester) async {
    var requests = 0;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async {
        requests++;
        return okResponse();
      }),
      stopId: 'MTS_24151',
      refreshInterval: const Duration(minutes: 10),
    )));
    await settle(tester);
    expect(find.text('4m'), findsOneWidget);

    await tester.pump(const Duration(seconds: 60));
    expect(find.text('3m'), findsOneWidget); // Old Town ticked down

    await tester.pump(const Duration(minutes: 4));
    expect(find.text('Old Town'), findsNothing); // ETA now negative
    expect(find.text('Inside Loop'), findsOneWidget);
    expect(requests, 1);
  });

  testWidgets('onArrivalTap receives the arrival; chevron only when tappable',
      (tester) async {
    ArrivalAndDeparture? tapped;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
      onArrivalTap: (a) => tapped = a,
    )));
    await settle(tester);
    expect(find.byIcon(Icons.chevron_right), findsNWidgets(3));
    await tester.tap(find.text('Old Town'));
    expect(tapped!.tripId, 'MTS_19630024');

    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
    )));
    await settle(tester);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('rows expose a single semantics label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
    )));
    await settle(tester);
    expect(
      find.bySemanticsLabel(
          'IL, Inside Loop, arriving in 5 minutes, 2 min late, real-time'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('S, SIO, arriving in 8 minutes, scheduled'),
        findsOneWidget);
    expect(find.byTooltip('Refresh arrivals'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('pauses while TickerMode disabled', (tester) async {
    var requests = 0;
    final client = fakeClient((_) async {
      requests++;
      return okResponse();
    });
    Widget build(bool enabled) => host(TickerMode(
          enabled: enabled,
          child: ObaArrivalsPanel(client: client, stopId: 'MTS_24151'),
        ));

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
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async {
        requests++;
        return okResponse();
      }),
      stopId: 'MTS_24151',
    )));
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
    await tester.pumpWidget(host(ObaArrivalsPanel(client: client, stopId: 'MTS_24151')));
    await settle(tester);
    await tester.pumpWidget(host(ObaArrivalsPanel(client: client, stopId: 'MTS_88986')));
    await settle(tester);
    expect(stops, ['MTS_24151.json', 'MTS_88986.json']);
  });

  testWidgets('lays out without overflow at 200% text scale', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 800 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
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
    ));
    await settle(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('host-provided controller is not disposed by the panel',
      (tester) async {
    final controller = ArrivalsController(
        client: fakeClient((_) async => okResponse()), stopId: 'MTS_24151');
    await tester.pumpWidget(host(ObaArrivalsPanel(controller: controller)));
    await settle(tester);
    await tester.pumpWidget(const SizedBox());
    expect(() => controller.addListener(() {}), returnsNormally);
    controller.dispose();
  });
}
