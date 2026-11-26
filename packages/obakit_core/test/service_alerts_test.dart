import 'package:obakit_core/obakit_core.dart';
import 'package:obakit_core/src/alerts/service_alerts.dart';
import 'package:test/test.dart';

import 'support/support.dart';

Situation alert(
  String id, {
  String? severity,
  DateTime? created,
  List<AffectedEntity> affects = const [],
  List<TimeWindow> windows = const [],
}) => Situation(
  id: id,
  severity: severity,
  creationTime: created,
  allAffects: affects,
  activeWindows: windows,
  summary: TranslatedString(value: 'Summary $id'),
  description: const TranslatedString(value: 'Details'),
  url: const TranslatedString(value: 'https://example.com/a'),
);

void main() {
  test('severity parsing covers OBA and GTFS-rt names', () {
    expect(AlertSeverity.parse('verySevere'), AlertSeverity.severe);
    expect(AlertSeverity.parse('SEVERE'), AlertSeverity.severe);
    expect(AlertSeverity.parse('WARNING'), AlertSeverity.warning);
    expect(AlertSeverity.parse('normal'), AlertSeverity.warning);
    expect(AlertSeverity.parse('noImpact'), AlertSeverity.info);
    expect(AlertSeverity.parse('no_impact'), AlertSeverity.info);
    expect(AlertSeverity.parse('unknown'), AlertSeverity.unknown);
    expect(AlertSeverity.parse(null), AlertSeverity.unknown);
    expect(AlertSeverity.warning.isHighPriority, isTrue);
    expect(AlertSeverity.info.isHighPriority, isFalse);
  });

  test('sort by severity then newest', () {
    final sorted = sortAlertsBySeverity([
      alert('info', severity: 'info', created: DateTime.utc(2024, 3)),
      alert('old', severity: 'severe', created: DateTime.utc(2024, 1)),
      alert('new', severity: 'severe', created: DateTime.utc(2024, 2)),
      alert('none'),
    ]);
    expect(sorted.map((a) => a.id), ['new', 'old', 'info', 'none']);
  });

  test('affects and body', () {
    final a = alert(
      'a',
      affects: const [
        AffectedEntity(agencyId: '1'),
        AffectedEntity(routeId: '1_10', stopId: '1_100'),
      ],
    );
    expect(a.affectsRoute('1_10'), isTrue);
    expect(a.affectsStop('1_100'), isTrue);
    expect(a.affectsTrip('x'), isFalse);
    expect(a.isAgencyWide, isTrue);
    expect(a.title, 'Summary a');
    expect(a.link.toString(), 'https://example.com/a');
    final refs = References(
      agencies: {'1': const Agency(id: '1', name: 'Metro')},
    );
    expect(a.body(references: refs), 'Details\n\nMetro');
    expect(a.body(), 'Details');
  });

  test(
    'alerts for a stop from a real fixture, deduplicated and active',
    () async {
      final r = await loadArrivals(
        'arrivals_and_departures_for_stop_mts_13353_route_and_stop_alerts.json',
        'MTS_13353',
      );
      final now = r.currentTime;
      final alerts = alertsForStop(
        stop: r.entry,
        references: r.references,
        now: now,
      );
      final ids = alerts.map((a) => a.id).toSet();
      // MTS_34 starts after the response's currentTime; MTS_32 is active.
      expect(
        ids,
        containsAll([
          'MTS_9c943ee8-d566-4cd8-8a89-a2a535ebe4fe',
          'MTS_32',
          'MTS_14',
          'MTS_13',
        ]),
      );
      expect(ids, isNot(contains('MTS_34')));
      expect(alerts.length, ids.length);
    },
  );

  test('tracker: unread, mark read, interrupting alerts', () {
    final tracker = ServiceAlertTracker(UserDataStore(InMemoryKeyValueStore()));
    final now = DateTime.utc(2024, 6);
    final severe = alert('s', severity: 'severe');
    final info = alert('i', severity: 'info');
    final expired = alert(
      'e',
      severity: 'severe',
      windows: [TimeWindow(from: DateTime.utc(2020), to: DateTime.utc(2021))],
    );
    expect(tracker.unreadCount([severe, info, expired]), 3);
    expect(
      tracker
          .alertsToInterruptWith([severe, info, expired], now: now)
          .single
          .id,
      's',
    );
    tracker.markRead(severe);
    expect(tracker.alertsToInterruptWith([severe, info], now: now), isEmpty);
    tracker.markAllRead([info]);
    expect(tracker.unread([severe, info]), isEmpty);
    expect(uniqueAlerts([severe, severe, info]), hasLength(2));
  });
}
