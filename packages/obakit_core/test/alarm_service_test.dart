import 'package:clock/clock.dart';
import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  final region = regionNamed('Puget Sound');
  final now = DateTime.utc(2024, 1, 1, 12);
  late FakeHttp http;
  late UserDataStore userData;
  late FakePushServiceProvider push;
  late AlarmService service;
  bool withObaco = true;

  setUp(() {
    withObaco = true;
    http = FakeHttp({
      'alarms/gone': (404, 'gone'),
      'alarms/broken': (500, 'oops'),
      '/alarms': (200, fixture('create_alarm.json')),
    });
    userData = UserDataStore(InMemoryKeyValueStore());
    push = FakePushServiceProvider(token: 'tok');
    service = AlarmService(
      obaco: () => withObaco
          ? ObacoClient(
              baseUrl: region.sidecarBaseUrl!,
              regionId: 1,
              httpClient: http.client,
            )
          : null,
      region: () => region,
      userData: userData,
      pushServiceProvider: push,
    );
  });

  final departure = arrival(
    tripId: 't9',
    scheduled: now.add(const Duration(minutes: 20)),
    vehicleId: 'v1',
  );

  test('creates, records, and finds an alarm', () async {
    final alarm = await withClock(
      Clock.fixed(now),
      () => service.createAlarm(departure, minutesBefore: 5),
    );
    expect(
      alarm.url.toString(),
      'https://alerts.example.com/regions/1/alarms/1234567890',
    );
    expect(alarm.tripDate, now.add(const Duration(minutes: 20)));
    expect(alarm.alarmDate, now.add(const Duration(minutes: 15)));
    expect(alarm.deepLink!.regionId, 1);
    expect(userData.alarms.single, alarm);
    expect(service.alarmFor(departure), alarm);
    expect(service.alarmFor(arrival(tripId: 'other')), isNull);
    final lookup = service.lookup();
    expect(lookup.alarmFor(departure), alarm);
    expect(lookup.alarmFor(arrival(tripId: 'other')), isNull);
    expect(identical(userData.alarms, userData.alarms), isTrue);
    final form = Uri.splitQueryString(http.requests.single.body);
    expect(form['seconds_before'], '300');
    expect(form['user_push_id'], 'tok');
    expect(form['vehicle_id'], 'v1');
  });

  test('availability and errors', () async {
    expect(service.isAvailable, isTrue);
    expect(service.canCreateAlarm(departure, now), isTrue);
    expect(
      service.canCreateAlarm(departure, now.add(const Duration(minutes: 19))),
      isFalse,
    );
    await expectLater(
      withClock(
        Clock.fixed(now),
        () => service.createAlarm(departure, minutesBefore: 20),
      ),
      throwsA(
        isA<AlarmUnavailableException>().having(
          (e) => e.reason,
          'reason',
          AlarmUnavailableReason.tooSoon,
        ),
      ),
    );
    withObaco = false;
    expect(service.isAvailable, isFalse);
    await expectLater(
      withClock(
        Clock.fixed(now),
        () => service.createAlarm(departure, minutesBefore: 5),
      ),
      throwsA(
        isA<AlarmUnavailableException>().having(
          (e) => e.reason,
          'reason',
          AlarmUnavailableReason.noObaco,
        ),
      ),
    );
  });

  test('asks for permission when there is no token', () async {
    push = FakePushServiceProvider(grantPermission: false);
    service = AlarmService(
      obaco: () => ObacoClient(
        baseUrl: region.sidecarBaseUrl!,
        regionId: 1,
        httpClient: http.client,
      ),
      region: () => region,
      userData: userData,
      pushServiceProvider: push,
    );
    await expectLater(
      withClock(
        Clock.fixed(now),
        () => service.createAlarm(departure, minutesBefore: 5),
      ),
      throwsA(
        isA<AlarmUnavailableException>().having(
          (e) => e.reason,
          'reason',
          AlarmUnavailableReason.permissionDenied,
        ),
      ),
    );
    expect(push.permissionRequests, 1);
  });

  test('no push provider means no alarms', () {
    final s = AlarmService(
      obaco: () => null,
      region: () => region,
      userData: userData,
    );
    expect(s.isAvailable, isFalse);
  });

  test(
    'remove: success, already fired (404), failure keeps local copy',
    () async {
      StoredAlarm stored(String path) => StoredAlarm(
        url: Uri.parse('https://alerts.example.com/regions/1/$path'),
        tripDate: now.add(const Duration(hours: 1)),
      );
      final ok = stored('alarms/1');
      final gone = stored('alarms/gone');
      final broken = stored('alarms/broken');
      userData
        ..addAlarm(ok)
        ..addAlarm(gone)
        ..addAlarm(broken);
      await service.removeAlarm(ok);
      await service.removeAlarm(gone);
      await expectLater(
        service.removeAlarm(broken),
        throwsA(isA<ObaApiException>()),
      );
      expect(userData.alarms.single.url, broken.url);
      expect(http.requests.map((r) => r.method).toSet(), {'DELETE'});
    },
  );

  test('prune removes past alarms', () {
    userData.addAlarm(
      StoredAlarm(
        url: Uri.parse('https://a/1'),
        tripDate: now.subtract(const Duration(minutes: 1)),
      ),
    );
    withClock(Clock.fixed(now), service.pruneExpiredAlarms);
    expect(userData.alarms, isEmpty);
  });
}
