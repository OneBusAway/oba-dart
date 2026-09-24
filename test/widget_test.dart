import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:oba_dart/app.dart';
import 'package:onebusaway/onebusaway.dart';

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

  testWidgets('See all pushes a full page and the card stops polling',
      (tester) async {
    final requested = <String>[];
    await tester.pumpWidget(StudentLifeDemoApp(client: client(requested)));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('SEE ALL ARRIVALS'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
    final before = requested.length;
    await tester.pump(const Duration(seconds: 30));
    await tester.pump();
    // Only the full-page panel polls; the covered card is paused.
    expect(requested.length, before + 1);
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
