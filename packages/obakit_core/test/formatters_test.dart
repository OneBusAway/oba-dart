import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

class _Shouty extends ObaCoreStrings {
  const _Shouty();
  @override
  String stopCodeNumeric(String code) => 'STOP NO. $code';
}

void main() {
  const f = ObaFormatters();
  final t0 = DateTime.utc(2024, 1, 1, 12);
  DateTime at(int m) => t0.add(Duration(minutes: m));
  Route r(String? short, {int type = 3, String id = 'x'}) =>
      Route(id: id, agencyId: 'a', shortName: short, type: type);

  test('stop title and subtitle', () {
    expect(f.stopTitle(name: 'Pine St', direction: 'SW'), 'Pine St (SW)');
    expect(f.stopTitle(name: 'Pine St'), 'Pine St');
    expect(
      f.stopSubtitle(code: '1234', direction: 's'),
      'Stop #1234 — Southbound',
    );
    expect(f.stopSubtitle(code: 'Old Library'), "Stop: 'Old Library'");
    expect(
      f.stopSubtitleFor(
        const Stop(id: '1_75403', name: 'x', lat: 0, lon: 0, direction: 'NE'),
      ),
      'Stop #75403 — NE bound',
    );
    expect(f.directionName('nw'), 'Northwest');
    expect(f.directionName('up'), isNull);
    expect(const ObaFormatters(_Shouty()).stopCode('5'), 'STOP NO. 5');
  });

  test('accessibility label', () {
    expect(
      f.stopAccessibilityLabel(
        name: 'Pine St',
        code: '1234',
        direction: 'N',
        routes: [r('10'), r('2')],
        bookmarkName: 'Home',
      ),
      'Home; Pine St; North; Routes: 2, 10; Stop ID: 1234',
    );
  });

  test('route lists', () {
    final routes = [r('49'), r('10'), r('12'), r('8'), r('')];
    expect(f.sortedRouteNames(routes), ['8', '10', '12', '49']);
    expect(f.formattedMapRoutes(routes), '8, 10, 12…');
    expect(f.formattedMapRoutes(routes.take(2)), '10, 49');
    expect(
      f.routeListLabel(routes),
      const RouteListLabel(routeNames: ['8', '10', '12'], overflowCount: 1),
    );
    expect(f.formattedRoutes(routes), 'Routes: 8, 10, 12, 49');
    expect(f.formattedRoutes(routes, limit: 2), 'Routes: 8, 10, + 2 more');
    expect(f.formattedRoutes([]), isNull);
    // Ferries without short names fall back to route types.
    expect(
      f.formattedRoutes([r(null, type: 4), r(null, type: 4), r(null, type: 3)]),
      'Routes: Bus, Ferry',
    );
    expect(f.routeTypeName(RouteType.lightRail), 'Light Rail');
    expect(f.routeTypeName(RouteType.unknown), isNull);
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

  test('departure text', () {
    final soon = arrival(scheduled: at(7));
    expect(f.shortTimeUntil(soon, t0), '7m');
    expect(f.shortTimeUntil(soon, at(7)), 'NOW');
    expect(f.shortTimeUntil(soon, at(10)), '-3m');
    expect(f.timeUntil(soon, at(6)), 'One minute');
    expect(f.timeUntil(soon, at(8)), 'One minute ago');
    expect(f.timeUntil(soon, t0), '7 minutes');
    expect(f.explanation(soon, t0), 'Arrives in 7 min');
    expect(f.explanation(soon, at(9)), 'Arrived 2 min ago');
    final dep = arrival(stopSequence: 0, scheduled: at(3));
    expect(f.explanation(dep, at(3)), 'Departing now');
  });

  test('schedule deviation', () {
    final late = arrival(
      scheduled: at(10),
      predicted: at(13),
      isPredicted: true,
    );
    expect(f.scheduleDeviationLabel(late, t0), 'arrives 3 min late');
    expect(f.scheduleDeviationLabel(late, at(20)), 'arrived 3 min late');
    final early = arrival(
      stopSequence: 0,
      scheduled: at(10),
      predicted: at(8),
      isPredicted: true,
    );
    expect(f.scheduleDeviationLabel(early, t0), 'departs 2 min early');
    final onTime = arrival(
      scheduled: at(10),
      predicted: at(10),
      isPredicted: true,
    );
    expect(f.scheduleDeviationLabel(onTime, at(11)), 'arrived on time');
    expect(
      f.scheduleDeviationLabel(arrival(scheduled: at(10)), t0),
      'Scheduled/not real-time',
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
    expect(f.updatedText(t0, now: at(1)), 'Updated: 1 min. ago');
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
    expect(f.alarmLeadTimeLabel(1), '1 minute');
    expect(f.alarmLeadTimeLabel(5), '5 minutes');
  });

  test('search placeholder', () {
    expect(f.searchPlaceholder(regionNamed('Spokane')), 'Search in Spokane');
  });
}
