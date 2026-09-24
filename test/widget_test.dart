import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:oba_dart/app.dart';

void main() {
  final fixture = File('packages/onebusaway/test/fixtures/arrivals_mts_24151.json')
      .readAsStringSync();

  OneBusAwayClient client(List<String> requested) => OneBusAwayClient(
        baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
        apiKey: 'test',
        httpClient: MockClient((r) async {
          requested.add(r.url.pathSegments.last);
          return http.Response(fixture, 200);
        }),
      );

  testWidgets('home feed embeds the shuttle panel capped at 3 rows',
      (tester) async {
    final requested = <String>[];
    await tester.pumpWidget(StudentLifeDemoApp(client: client(requested)));
    await tester.pump();
    await tester.pump();

    expect(find.text('UC San Diego'), findsOneWidget);
    expect(find.text('SHUTTLE'), findsOneWidget);
    expect(find.text('Old Town'), findsOneWidget);
    expect(requested, ['MTS_24151.json']);
  });

  testWidgets('See all reuses the card controller: no refetch, one poll',
      (tester) async {
    final requested = <String>[];
    await tester.pumpWidget(StudentLifeDemoApp(client: client(requested)));
    await tester.pump();
    await tester.pump();
    expect(requested, hasLength(1));

    await tester.tap(find.text('SEE ALL ARRIVALS'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Old Town'), findsOneWidget); // shown from shared data
    expect(requested, hasLength(1)); // opening the page doesn't refetch

    await tester.pump(const Duration(seconds: 30));
    await tester.pump();
    // The shared controller keeps polling once per interval, not per panel.
    expect(requested, hasLength(2));
  });

  testWidgets('choosing another stop swaps the controller cleanly',
      (tester) async {
    final requested = <String>[];
    await tester.pumpWidget(StudentLifeDemoApp(client: client(requested)));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.byTooltip('Choose stop'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('UCSD Central Campus Trolley').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(requested, ['MTS_24151.json', 'MTS_88986.json']);
    // The old controller is disposed: no further polls for the first stop.
    await tester.pump(const Duration(seconds: 30));
    await tester.pump();
    expect(requested.where((r) => r == 'MTS_24151.json'), hasLength(1));
  });

  testWidgets('tapping a row shows a snackbar', (tester) async {
    await tester.pumpWidget(StudentLifeDemoApp(client: client([])));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Old Town'));
    await tester.pump();
    expect(find.text('30 → Old Town'), findsOneWidget);
  });
}
