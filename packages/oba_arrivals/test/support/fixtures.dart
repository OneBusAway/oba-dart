import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';

/// Tests run with the package directory as the working directory.
String arrivalsFixture() =>
    File('../onebusaway/test/fixtures/arrivals_mts_24151.json').readAsStringSync();

/// `currentTime` in the fixture: 2026-09-24T04:22:59.290Z.
final fixtureServerTime =
    DateTime.fromMillisecondsSinceEpoch(1790228579290, isUtc: true);

http.Response okResponse([String? body]) =>
    http.Response(body ?? arrivalsFixture(), 200,
        headers: {'content-type': 'application/json; charset=utf-8'});

OneBusAwayClient fakeClient(
        Future<http.Response> Function(http.Request request) handler) =>
    OneBusAwayClient(
      baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
      apiKey: 'test',
      httpClient: MockClient(handler),
    );
