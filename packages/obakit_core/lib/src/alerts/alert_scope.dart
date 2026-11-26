import 'package:onebusaway/onebusaway.dart';

import 'service_alerts.dart';

/// The alerts in [alerts] to list for a screen: de-duplicated, active at
/// [now], limited to those affecting [stopId] and/or [routeId] when given
/// (an alert matching either qualifies), most severe then newest first.
List<Situation> alertsInScope(
  Iterable<Situation> alerts, {
  String? stopId,
  String? routeId,
  required DateTime now,
}) {
  final scoped = stopId != null || routeId != null;
  return sortAlertsBySeverity(
    uniqueAlerts(alerts).where(
      (a) =>
          a.isActiveAt(now) &&
          (!scoped ||
              (stopId != null && a.affectsStop(stopId)) ||
              (routeId != null && a.affectsRoute(routeId))),
    ),
  );
}

/// The distinct route ids [alert] names, in order.
List<String> affectedRouteIds(Situation alert) =>
    {for (final a in alert.allAffects) ?a.routeId}.toList();

/// The distinct stop ids [alert] names, in order.
List<String> affectedStopIds(Situation alert) =>
    {for (final a in alert.allAffects) ?a.stopId}.toList();
