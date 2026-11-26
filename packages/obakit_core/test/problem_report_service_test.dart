import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

class _Events extends NoopAnalytics {
  final values = <Object?>[];
  @override
  void reportEvent({
    required String pageUrl,
    required String label,
    Object? value,
  }) {
    expect(label, AnalyticsLabels.reportProblem);
    values.add(value);
  }
}

void main() {
  final region = regionNamed('Puget Sound');
  late FakeHttp http;
  late ProblemReportService service;
  late _Events events;

  setUp(() {
    http = FakeHttp({
      'report-problem': (200, fixture('report_stop_problem.json')),
      'ghost_bus_reports': (200, fixture('create_ghost_bus_report.json')),
    });
    events = _Events();
    service = ProblemReportService(
      client: () => OneBusAwayClient(
        baseUrl: region.obaBaseUrl,
        apiKey: 'k',
        httpClient: http.client,
      ),
      obaco: () => ObacoClient(
        baseUrl: region.sidecarBaseUrl!,
        regionId: 1,
        httpClient: http.client,
      ),
      currentLocation: () => seattle,
      userId: () => 'uid',
      analytics: events,
    );
  });

  test('stop report sends code, trimmed comment and location', () async {
    await service.reportStopProblem(
      '1_1',
      code: StopProblemCode.nameWrong,
      comment: '  wrong  ',
    );
    final q = http.requests.single.url.queryParameters;
    expect(q['code'], 'stop_name_wrong');
    expect(q['userComment'], 'wrong');
    expect(q['userLat'], '47.6');
    expect(q['userLocationAccuracy'], '10.0');
    expect(events.values, ['stop:stop_name_wrong']);
  });

  test('trip report', () async {
    await service.reportTripProblem(
      arrival(tripId: 't', vehicleId: 'v'),
      code: TripProblemCode.neverCame,
      userOnVehicle: false,
      comment: ' ',
    );
    final q = http.requests.single.url.queryParameters;
    expect(q['tripId'], 't');
    expect(q['vehicleId'], 'v');
    expect(q.containsKey('userComment'), isFalse);
  });

  test('ghost bus report', () async {
    final t = DateTime.utc(2024, 1, 1, 12);
    await service.reportGhostBus(
      arrival(
        scheduled: t,
        predicted: t.add(const Duration(minutes: 4)),
        isPredicted: true,
      ),
    );
    final form = Uri.splitQueryString(http.requests.single.body);
    expect(form['user_identifier'], 'uid');
    expect(form['schedule_deviation_minutes'], '4');
    expect(form['user_latitude'], '47.6');
    expect(service.canReportGhostBus, isTrue);
  });

  test('stop report without location when sharing is off', () async {
    await service.reportStopProblem(
      '1_1',
      code: StopProblemCode.other,
      includeLocation: false,
    );
    final q = http.requests.single.url.queryParameters;
    expect(q.containsKey('userLat'), isFalse);
    expect(q.containsKey('userLocationAccuracy'), isFalse);
  });

  test('trip report overrides the vehicle id and can omit location', () async {
    await service.reportTripProblem(
      arrival(tripId: 't', vehicleId: 'v'),
      code: TripProblemCode.cameLate,
      userOnVehicle: true,
      vehicleId: ' 1234 ',
      includeLocation: false,
    );
    final q = http.requests.single.url.queryParameters;
    expect(q['vehicleId'], '1234');
    expect(q['userOnVehicle'], 'true');
    expect(q.containsKey('userLat'), isFalse);
  });

  test('trip report by id, without an arrival', () async {
    await service.reportTripProblemFor(
      tripId: 't2',
      serviceDate: DateTime.utc(2024, 1, 1),
      code: TripProblemCode.wrongHeadsign,
      userOnVehicle: false,
      stopId: 's',
    );
    final q = http.requests.single.url.queryParameters;
    expect(q['tripId'], 't2');
    expect(q['stopId'], 's');
    expect(q['code'], 'wrong_headsign');
    expect(q['userLat'], '47.6');
    expect(events.values, ['trip:wrong_headsign']);
  });

  test('ghost bus report can omit location', () async {
    await service.reportGhostBus(arrival(), includeLocation: false);
    final form = Uri.splitQueryString(http.requests.single.body);
    expect(form.containsKey('user_latitude'), isFalse);
  });

  test('without a client', () {
    final s = ProblemReportService(client: () => null);
    expect(
      () => s.reportStopProblem('1', code: StopProblemCode.other),
      throwsA(isA<ProblemReportUnavailableException>()),
    );
    expect(s.canReportGhostBus, isFalse);
  });
}
