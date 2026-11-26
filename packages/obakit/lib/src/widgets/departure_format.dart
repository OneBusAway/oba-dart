// Departure text shared by every list of departures (stop page, trip
// page, bookmarks, nearby): status, countdown, spoken ETA and route label.

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import '../l10n/l10n.dart';
import '../theme/oba_theme.dart';

/// Marks a live (real-time) countdown, next to the minutes.
const IconData obaRealTimeIcon = Icons.sensors;

/// How a departure is doing against its schedule, shown with an icon and
/// text (never colour alone).
class DepartureStatusInfo {
  const DepartureStatusInfo({
    required this.label,
    required this.icon,
    required this.color,
    required this.isRealTime,
    required this.a11y,
  });

  factory DepartureStatusInfo.of(BuildContext context, ArrivalAndDeparture a) {
    final l10n = context.obaL10n;
    final theme = ObaTheme.of(context);
    if (a.tripStatus?.statusModifier == TripStatusModifier.canceled) {
      return DepartureStatusInfo(
        label: l10n.stopRowCanceled,
        icon: Icons.cancel_outlined,
        color: theme.canceled,
        isRealTime: false,
        a11y: l10n.stopRowCanceled,
      );
    }
    final dev = a.deviationFromScheduleInMinutes.abs();
    final (label, icon, color) = switch (a.scheduleStatus) {
      ScheduleStatus.onTime => (
        l10n.stopRowOnTime,
        Icons.check_circle_outline,
        theme.onTime,
      ),
      ScheduleStatus.delayed => (
        l10n.stopRowLate(dev),
        Icons.hourglass_bottom,
        theme.late,
      ),
      ScheduleStatus.early => (
        l10n.stopRowEarly(dev),
        Icons.fast_forward,
        theme.early,
      ),
      ScheduleStatus.unknown => (
        l10n.stopRowScheduled,
        Icons.calendar_today_outlined,
        theme.scheduled,
      ),
    };
    final realTime = a.scheduleStatus != ScheduleStatus.unknown;
    return DepartureStatusInfo(
      label: label,
      icon: icon,
      color: color,
      isRealTime: realTime,
      a11y: realTime
          ? l10n.stopRowA11yLive(label)
          : l10n.stopRowA11yScheduledOnly,
    );
  }

  final String label;
  final IconData icon;
  final Color color;
  final bool isRealTime;

  /// Status clause for the row's screen-reader sentence.
  final String a11y;
}

/// The occupancy label, or null when unknown.
String? occupancyLabel(ObaLocalizations l10n, OccupancyStatus? o) =>
    switch (o) {
      OccupancyStatus.empty => l10n.stopRowOccupancyEmpty,
      OccupancyStatus.manySeatsAvailable => l10n.stopRowOccupancyManySeats,
      OccupancyStatus.fewSeatsAvailable => l10n.stopRowOccupancyFewSeats,
      OccupancyStatus.standingRoomOnly => l10n.stopRowOccupancyStanding,
      OccupancyStatus.crushedStandingRoomOnly => l10n.stopRowOccupancyCrushed,
      OccupancyStatus.full => l10n.stopRowOccupancyFull,
      OccupancyStatus.notAcceptingPassengers ||
      OccupancyStatus.notBoardable => l10n.stopRowOccupancyNotAccepting,
      _ => null,
    };

/// The short countdown ("NOW", "5 min", "3 min ago").
String countdownText(ObaLocalizations l10n, int minutes) {
  if (minutes == 0) return l10n.stopRowNow;
  if (minutes < 0) return l10n.stopRowMinutesAgo(-minutes);
  return l10n.stopRowMinutes(minutes);
}

/// The spoken ETA ("arrives in 5 minutes", "departed 2 minutes ago").
String etaA11y(ObaLocalizations l10n, ArrivalAndDeparture a, int minutes) {
  final departing =
      a.arrivalDepartureStatus == ArrivalDepartureStatus.departing;
  if (minutes < 0) {
    return departing
        ? l10n.stopRowA11yDeparted(-minutes)
        : l10n.stopRowA11yArrived(-minutes);
  }
  return departing
      ? l10n.stopRowA11yDeparts(minutes)
      : l10n.stopRowA11yArrives(minutes);
}

/// The route's short name for display: the route's, then the arrival's,
/// then the route's long name, then its id without the agency prefix.
/// [route] comes from the response's references.
String routeLabel(ArrivalAndDeparture a, core.Route? route) =>
    route?.shortName ??
    a.routeShortName ??
    route?.longName ??
    agencyLocalId(a.routeId);
