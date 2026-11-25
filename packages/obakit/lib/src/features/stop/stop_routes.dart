// OWNER: stop agent (stop page, schedules, trip page, route stops, problem
// reports). The pages live in the other files of this folder; this file
// keeps the `build...Route` functions the registry calls and re-exports
// the public widgets.

import 'package:flutter/widgets.dart';

import '../../navigation/oba_route.dart';
import 'report_pages.dart';
import 'route_stops_page.dart';
import 'schedule_pages.dart';
import 'stop_page.dart';
import 'trip_page.dart';

export 'departure_row.dart'
    show ObaDepartureRow, ObaDepartureAction, ObaDepartureRowStyle;
export 'report_pages.dart'
    show
        ReportStopProblemPage,
        ReportTripProblemPage,
        GhostBusReportRoute,
        GhostBusReportPage;
export 'route_stops_page.dart' show RouteStopsPage;
export 'schedule_pages.dart'
    show StopSchedulePage, RouteSchedulePage, ScheduleHourRow, ScheduleDateBar;
export 'stop_arrivals_controller.dart';
export 'stop_departures_card.dart';
export 'stop_page.dart';
export 'stop_sections.dart'
    show
        StopHeader,
        StopAlertsSection,
        StopStaleBanner,
        StopFooter,
        WalkTimeDivider,
        RouteGroupHeader,
        StopFilterSheet;
export 'trip_controller.dart';
export 'trip_page.dart';

Widget buildStopRoute(BuildContext context, StopRoute route) =>
    StopPage(stopId: route.stopId, transfer: route.transfer);

Widget buildTripRoute(BuildContext context, TripRoute route) =>
    TripPage(trip: route.trip);

Widget buildRouteStopsRoute(BuildContext context, RouteStopsRoute route) =>
    RouteStopsPage(routeId: route.routeId);

Widget buildStopScheduleRoute(BuildContext context, StopScheduleRoute route) =>
    StopSchedulePage(stopId: route.stopId, date: route.date);

Widget buildRouteScheduleRoute(
  BuildContext context,
  RouteScheduleRoute route,
) => RouteSchedulePage(
  routeId: route.routeId,
  date: route.date,
  stopId: route.stopId,
);

Widget buildReportStopProblemRoute(
  BuildContext context,
  ReportStopProblemRoute route,
) => ReportStopProblemPage(stopId: route.stopId);

Widget buildReportTripProblemRoute(
  BuildContext context,
  ReportTripProblemRoute route,
) => ReportTripProblemPage(trip: route.trip, arrival: route.arrival);
