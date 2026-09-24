import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';
import 'package:test/test.dart';

import 'support/fixtures.dart';

void main() {
  test(
    'arrivalsAndDepartures.forStop builds the request and parses the entry',
    () async {
      late Uri requested;
      final client = OneBusAwayClient(
        baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
        apiKey: 'org.onebusaway.iphone',
        httpClient: MockClient((request) async {
          requested = request.url;
          return http.Response(
            fixture('arrivals_mts_24151.json'),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await client.arrivalsAndDepartures.forStop(
        'MTS_24151',
        minutesBefore: 0,
        minutesAfter: 60,
        time: DateTime.fromMillisecondsSinceEpoch(1790228579290, isUtc: true),
      );

      expect(
        requested.path,
        '/api/api/where/arrivals-and-departures-for-stop/MTS_24151.json',
      );
      expect(requested.queryParameters, {
        'key': 'org.onebusaway.iphone',
        'minutesBefore': '0',
        'minutesAfter': '60',
        'time': '1790228579290',
      });
      expect(response.entry.stopId, 'MTS_24151');
      expect(response.entry.arrivalsAndDepartures, hasLength(4));
      expect(response.references.stop('MTS_24151')!.code, '24151');
      expect(response.currentTime.millisecondsSinceEpoch, 1790228579290);
    },
  );

  test('omits optional params that were not given', () async {
    late Uri requested;
    final client = OneBusAwayClient(
      baseUrl: Uri.parse('https://example.org/'),
      apiKey: 'k',
      httpClient: MockClient((request) async {
        requested = request.url;
        return http.Response(fixture('arrivals_mts_24151.json'), 200);
      }),
    );
    await client.arrivalsAndDepartures.forStop('MTS_24151');
    expect(requested.queryParameters, {'key': 'k'});
  });

  test('parses a live SDMTS response', () async {
    final client = OneBusAwayClient(
      baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
      apiKey: 'k',
      httpClient: MockClient(
        (_) async => http.Response(fixture('arrivals_live.json'), 200),
      ),
    );
    final response = await client.arrivalsAndDepartures.forStop('MTS_24151');
    expect(response.entry.stopId, 'MTS_24151');
    expect(response.references.stop('MTS_24151'), isNotNull);
  });

  test('close() closes only an http client it created', () {
    var closed = false;
    final injected = _TrackingClient(() => closed = true);
    OneBusAwayClient(
      baseUrl: Uri.parse('https://x/'),
      apiKey: 'k',
      httpClient: injected,
    ).close();
    expect(closed, isFalse);
  });
}

class _TrackingClient extends http.BaseClient {
  _TrackingClient(this.onClose);
  final void Function() onClose;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      throw UnimplementedError();

  @override
  void close() => onClose();
}
