import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

void main() {
  late ObaTestEnv env;
  setUp(() async {
    env = await ObaTestEnv.create(
      responses: {
        'arrivals-and-departures-for-stop': fixture(
          'arrivals_and_departures_for_stop_1_10020.json',
        ),
      },
    );
  });
  tearDown(() => env.dispose());

  Widget feed({String? title}) => ListView(
    children: [
      ObaStopDeparturesCard(stopId: '1_10020', maxArrivals: 1, title: title),
    ],
  );

  testWidgets('shows up to maxArrivals upcoming; see all opens the stop', (
    tester,
  ) async {
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      Scaffold(body: feed()),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    expect(find.text('NE 55TH ST & 37TH AVE NE'), findsOneWidget);
    expect(find.byType(ObaDepartureRow), findsOneWidget);
    await tester.tap(find.text('See all'));
    expect(pushed.single, const StopRoute('1_10020'));
    await tester.tap(find.byType(ObaDepartureRow));
    expect(pushed.last, isA<TripRoute>());
  });

  testWidgets('stops polling in a hidden IndexedStack child (a host tab)', (
    tester,
  ) async {
    int arrivals() => env.requests
        .where((r) => r.url.path.contains('arrivals-and-departures'))
        .length;
    // IndexedStack keeps hidden children's tickers running and reports
    // them through Visibility.of.
    Widget tabs(int index) => Scaffold(
      body: IndexedStack(index: index, children: [feed(), const SizedBox()]),
    );
    await env.pumpPage(tester, tabs(0));
    final shown = arrivals();
    expect(shown, greaterThan(0));
    await env.pumpPage(tester, tabs(1));
    await tester.pump(const Duration(seconds: 95));
    await ObaTestEnv.settle(tester);
    expect(arrivals(), shown);
    await env.pumpPage(tester, tabs(0));
    await tester.pump(const Duration(seconds: 31));
    await ObaTestEnv.settle(tester);
    expect(arrivals(), greaterThan(shown));
  });

  testWidgets('a host title keeps the stop name as a subtitle', (tester) async {
    final handle = tester.ensureSemantics();
    await env.pumpPage(tester, Scaffold(body: feed(title: 'Home stop')));
    expect(
      tester.getSemantics(find.text('Home stop')),
      isSemantics(label: 'Home stop', isHeader: true),
    );
    final name = find.textContaining('NE 55TH ST & 37TH AVE NE');
    expect(name, findsOneWidget);
    expect(tester.getSemantics(name), isNot(isSemantics(isHeader: true)));
    expect(
      tester.getTopLeft(name).dy,
      greaterThan(tester.getTopLeft(find.text('Home stop')).dy),
    );
    handle.dispose();
  });

  testWidgets('no subtitle when the host title is the stop name', (
    tester,
  ) async {
    await env.pumpPage(
      tester,
      Scaffold(body: feed(title: 'NE 55TH ST & 37TH AVE NE')),
    );
    expect(find.textContaining('NE 55TH ST & 37TH AVE NE'), findsOneWidget);
  });

  for (final title in [null, 'Home stop']) {
    final suffix = title == null ? '' : ', host title';
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('accessibility (${mode.name}$suffix)', (tester) async {
        await env.pumpPage(
          tester,
          Scaffold(body: feed(title: title)),
          themeMode: mode,
        );
        await expectObaAccessibility(tester);
      });
    }

    testWidgets('no overflow at 200% text$suffix', (tester) async {
      await env.expectNoOverflowAtTextScale(
        tester,
        Scaffold(body: feed(title: title)),
      );
    });
  }
}
