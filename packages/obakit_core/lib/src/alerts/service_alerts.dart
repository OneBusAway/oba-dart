import 'package:onebusaway/onebusaway.dart';

import '../user_data/user_data_store.dart';

/// A normalised severity. OBA servers send either their own `ESeverity`
/// names (`noImpact`, `slight`, `severe`, `verySevere`...) or GTFS-rt names
/// (`INFO`, `WARNING`, `SEVERE`); both map here.
enum AlertSeverity {
  unknown,
  info,
  warning,
  severe;

  static AlertSeverity parse(String? raw) {
    final v = raw?.toLowerCase().replaceAll(RegExp(r'[_\s-]'), '');
    return switch (v) {
      'info' || 'noimpact' || 'veryslight' || 'slight' => info,
      'warning' || 'normal' => warning,
      'severe' || 'verysevere' => severe,
      _ => unknown,
    };
  }

  /// iOS treats WARNING and SEVERE as high severity (agency alert bulletins).
  bool get isHighPriority => this == warning || this == severe;
}

extension ServiceAlertLogic on Situation {
  AlertSeverity get alertSeverity => AlertSeverity.parse(severity);

  bool get isHighPriority => alertSeverity.isHighPriority;

  String? get title => summary?.value;

  /// The description, then the sorted names of affected agencies found in
  /// [references], separated by a blank line (iOS `body(forLocale:)`).
  String body({References? references}) {
    final agencies = references == null
        ? <String>[]
        : ({
            for (final a in allAffects)
              if (a.agencyId case final id?) ?references.agency(id)?.name,
          }.toList()..sort());
    return [
      if (description?.value case final d? when d.isNotEmpty) d,
      if (agencies.isNotEmpty) agencies.join(', '),
    ].join('\n\n');
  }

  Uri? get link {
    final raw = url?.value;
    return raw == null || raw.isEmpty ? null : Uri.tryParse(raw);
  }

  bool affectsStop(String stopId) => allAffects.any((a) => a.stopId == stopId);

  bool affectsRoute(String routeId) =>
      allAffects.any((a) => a.routeId == routeId);

  bool affectsTrip(String tripId) => allAffects.any((a) => a.tripId == tripId);

  /// Applies to a whole agency (no route, stop or trip named).
  bool get isAgencyWide => allAffects.any(
    (a) =>
        a.agencyId != null &&
        a.routeId == null &&
        a.stopId == null &&
        a.tripId == null,
  );
}

/// Most severe first, then newest first, then by id for stability.
List<Situation> sortAlertsBySeverity(Iterable<Situation> alerts) {
  final list = alerts.toList();
  list.sort((a, b) {
    final s = b.alertSeverity.index.compareTo(a.alertSeverity.index);
    if (s != 0) return s;
    final at = a.creationTime;
    final bt = b.creationTime;
    if (at != null && bt != null && at != bt) return bt.compareTo(at);
    if (at != null && bt == null) return -1;
    if (at == null && bt != null) return 1;
    return a.id.compareTo(b.id);
  });
  return list;
}

/// Drops duplicate ids, keeping the first.
List<Situation> uniqueAlerts(Iterable<Situation> alerts) {
  final seen = <String>{};
  return [
    for (final a in alerts)
      if (seen.add(a.id)) a,
  ];
}

/// The alerts shown on a stop page: those referenced by the stop's
/// `situationIds` and by any arrival, de-duplicated, active at [now], most
/// severe first.
List<Situation> alertsForStop({
  required StopWithArrivalsAndDepartures stop,
  required References references,
  required DateTime now,
}) {
  final ids = [
    ...stop.situationIds,
    for (final a in stop.arrivalsAndDepartures) ...a.situationIds,
  ];
  return sortAlertsBySeverity(
    uniqueAlerts(references.situationsWithIds(ids))
        .where((s) => s.isActiveAt(now)),
  );
}

/// Read/unread state for service alerts, backed by [UserDataStore].
class ServiceAlertTracker {
  const ServiceAlertTracker(this.userData);

  final UserDataStore userData;

  bool isUnread(Situation alert) => userData.isAlertUnread(alert.id);

  void markRead(Situation alert) => userData.markAlertRead(alert.id);

  void markAllRead(Iterable<Situation> alerts) =>
      userData.markAlertsRead(alerts.map((a) => a.id));

  List<Situation> unread(Iterable<Situation> alerts) =>
      alerts.where(isUnread).toList();

  int unreadCount(Iterable<Situation> alerts) => unread(alerts).length;

  /// Unread, high-priority alerts that warrant interrupting the user (the
  /// iOS agency alert bulletin), most severe first.
  List<Situation> alertsToInterruptWith(
    Iterable<Situation> alerts, {
    required DateTime now,
  }) => sortAlertsBySeverity(
    alerts.where((a) => a.isHighPriority && isUnread(a) && a.isActiveAt(now)),
  );
}
