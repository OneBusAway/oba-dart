import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

class _Shouty extends ObaCoreStrings {
  const _Shouty();
  @override
  String stopCodeNumeric(String code) => 'STOP NO. $code';
}

void main() {
  const f = ObaFormatters();
  final t0 = DateTime.utc(2024, 1, 1, 12);
  DateTime at(int m) => t0.add(Duration(minutes: m));

  test('stop subtitle', () {
    expect(
      f.stopSubtitle(code: '1234', direction: 's'),
      'Stop #1234 — Southbound',
    );
    expect(f.stopSubtitle(code: 'Old Library'), "Stop: 'Old Library'");
    expect(
      f.storedStopSubtitle(
        StoredStop.fromStop(
          const Stop(id: '1_75403', name: 'x', lat: 0, lon: 0, direction: 'NE'),
        ),
      ),
      'Stop #75403 — NE bound',
    );
    expect(const ObaFormatters(_Shouty()).stopCode('5'), 'STOP NO. 5');
  });

  test('agencies', () {
    final refs = References(
      agencies: {
        'a': const Agency(id: 'a', name: 'Metro'),
        'b': const Agency(id: 'b', name: 'Community Transit'),
      },
    );
    expect(
      f.formattedAgencies([
        const Route(id: '1', agencyId: 'a'),
        const Route(id: '2', agencyId: 'b'),
        const Route(id: '3', agencyId: 'a'),
      ], refs),
      'Community Transit, Metro',
    );
  });

  test('time ago', () {
    expect(f.timeAgo(t0, now: t0.add(const Duration(seconds: 3))), 'Just Now');
    expect(
      f.timeAgo(t0, now: t0.add(const Duration(seconds: 31))),
      '31 sec. ago',
    );
    expect(f.timeAgo(t0, now: at(4)), '4 min. ago');
    expect(f.timeAgo(t0, now: at(130)), '2 hr. ago');
    expect(f.timeAgo(t0, now: at(60 * 49)), '2 days ago');
  });

  test('distance', () {
    expect(f.distance(347), '350 m');
    expect(f.distance(1234), '1.2 km');
    expect(f.distance(2000), '2 km');
    expect(f.distance(100, units: DistanceUnits.imperial), '330 ft');
    expect(f.distance(1609.344 * 0.5, units: DistanceUnits.imperial), '0.5 mi');
  });

  test('alarm lead times', () {
    expect(alarmLeadTimeChoices(1), isEmpty);
    expect(alarmLeadTimeChoices(2), [1]);
    expect(alarmLeadTimeChoices(12), [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]);
    expect(alarmLeadTimeChoices(50).take(5), [45, 30, 25, 20, 15]);
    expect(alarmLeadTimeChoices(200).first, 180);
    expect(closestAlarmLeadTime([45, 30, 25, 20, 15, 10], 12), 10);
    expect(closestAlarmLeadTime([], 10), isNull);
  });

  test('measurement system by country', () {
    expect(MeasurementSystem.forCountry('us'), MeasurementSystem.us);
    expect(MeasurementSystem.forCountry('PR'), MeasurementSystem.us);
    expect(MeasurementSystem.forCountry('GB'), MeasurementSystem.uk);
    expect(MeasurementSystem.forCountry('DE'), MeasurementSystem.metric);
    expect(MeasurementSystem.forCountry(null), MeasurementSystem.metric);
    expect(DistanceUnits.of(MeasurementSystem.uk), DistanceUnits.imperial);
    expect(
      const ObaFormatters(
        ObaCoreStrings(),
        DistanceUnits.imperial,
      ).distance(100),
      '330 ft',
    );
  });
}
