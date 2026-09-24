import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';
import 'package:onebusaway/src/core/transport.dart';
import 'package:test/test.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Transport transportWith(MockClient client,
        {String base = 'https://realtime.sdmts.com/api/',
        Duration timeout = const Duration(seconds: 15)}) =>
    Transport(
      baseUrl: Uri.parse(base),
      apiKey: 'org.onebusaway.iphone',
      httpClient: client,
      timeout: timeout,
    );

void main() {
  final unused = MockClient((_) async => http.Response('', 500));

  group('buildUri', () {
    test('uses the SDMTS server root + api/where', () {
      final uri = transportWith(unused).buildUri(
        'arrivals-and-departures-for-stop',
        id: 'MTS_24151',
      );
      expect(
        uri.toString(),
        'https://realtime.sdmts.com/api/api/where/arrivals-and-departures-for-stop/MTS_24151.json?key=org.onebusaway.iphone',
      );
    });

    test('adds a missing trailing slash to baseUrl', () {
      final uri = transportWith(unused, base: 'https://realtime.sdmts.com/api')
          .buildUri('current-time');
      expect(uri.toString(),
          'https://realtime.sdmts.com/api/api/where/current-time.json?key=org.onebusaway.iphone');
    });

    test('encodes the id and appends params', () {
      final uri = transportWith(unused)
          .buildUri('stop', id: 'A B/1', params: {'minutesAfter': '60'});
      expect(uri.path, '/api/api/where/stop/A%20B%2F1.json');
      expect(uri.queryParameters,
          {'key': 'org.onebusaway.iphone', 'minutesAfter': '60'});
    });
  });

  group('decoding order', () {
    Future<Object?> errorFor(http.Response response) async {
      try {
        await transportWith(MockClient((_) async => response)).get('stop', id: 'X');
        return null;
      } catch (e) {
        return e;
      }
    }

    test('1. non-2xx is httpStatus and the HTML body is not parsed', () async {
      final e = await errorFor(
          http.Response('<!DOCTYPE html><html>404</html>', 404));
      expect(e, isA<ObaApiException>()
          .having((e) => e.kind, 'kind', ObaApiErrorKind.httpStatus)
          .having((e) => e.code, 'code', 404));
    });

    test('2. empty 200 body is emptyResponse', () async {
      final e = await errorFor(http.Response('', 200));
      expect(e, isA<ObaApiException>()
          .having((e) => e.kind, 'kind', ObaApiErrorKind.emptyResponse));
    });

    test('3. non-JSON 200 body is ObaFormatException', () async {
      expect(await errorFor(http.Response('not json', 200)),
          isA<ObaFormatException>());
    });

    test('4. envelope code != 200 is envelope error with text', () async {
      final e = await errorFor(http.Response(fixture('error_envelope.json'), 200));
      expect(e, isA<ObaApiException>()
          .having((e) => e.kind, 'kind', ObaApiErrorKind.envelope)
          .having((e) => e.code, 'code', 401)
          .having((e) => e.text, 'text', 'permission denied'));
    });

    test('network failure is ObaNetworkException', () async {
      final client = MockClient((_) async => throw http.ClientException('boom'));
      await expectLater(transportWith(client).get('stop', id: 'X'),
          throwsA(isA<ObaNetworkException>()));
    });

    test('any other Exception (e.g. TLS during body read) is '
        'ObaNetworkException', () async {
      final client = MockClient((_) async => throw _TlsLike());
      await expectLater(
        transportWith(client).get('stop', id: 'X'),
        throwsA(isA<ObaNetworkException>()
            .having((e) => e.cause, 'cause', isA<_TlsLike>())),
      );
    });

    test('network failure message does not leak the API key', () async {
      final client = MockClient(
          (request) async => throw http.ClientException('boom', request.url));
      final error = await transportWith(client)
          .get('stop', id: 'X', params: {'minutesAfter': '35'})
          .then<Object?>((_) => null, onError: (Object e) => e);
      expect(error, isA<ObaNetworkException>());
      final e = error! as ObaNetworkException;
      expect(e.message, isNot(contains('org.onebusaway.iphone')));
      expect(e.toString(), isNot(contains('org.onebusaway.iphone')));
      expect(e.message, contains('key=REDACTED'));
      expect(e.message, contains('minutesAfter=35'));
      expect(e.message, startsWith('ClientException: '));
    });

    test('timeout is ObaNetworkException', () async {
      final never = Completer<http.Response>();
      final client = MockClient((_) => never.future);
      await expectLater(
        transportWith(client, timeout: const Duration(milliseconds: 20))
            .get('stop', id: 'X'),
        throwsA(isA<ObaNetworkException>()),
      );
    });

    test('success exposes currentTime, version and data', () async {
      final client = MockClient(
          (_) async => http.Response(fixture('arrivals_mts_24151.json'), 200));
      final envelope = await transportWith(client).get('x');
      expect(envelope.currentTime.millisecondsSinceEpoch, 1790228579290);
      expect(envelope.currentTime.isUtc, isTrue);
      expect(envelope.version, 2);
      expect(envelope.data.containsKey('entry'), isTrue);
    });

    test('toList parses list responses and flags', () {
      final envelope = Transport.decode(http.Response(
          '{"code":200,"currentTime":1,"text":"OK","version":2,'
          '"data":{"list":[{"id":"MTS","name":"MTS"}],"limitExceeded":true,'
          '"outOfRange":false,"references":{}}}',
          200));
      final list = envelope.toList(Agency.fromJson);
      expect(list.list.single.id, 'MTS');
      expect(list.limitExceeded, isTrue);
      expect(list.outOfRange, isFalse);
    });
  });
}

class _TlsLike implements Exception {}
