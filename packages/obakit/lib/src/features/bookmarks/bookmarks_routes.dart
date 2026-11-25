// Bookmarks, bookmark editor and management, recent stops, service alerts,
// agencies, and their home sections. The pages live in the files exported
// below; this file maps routes to them and lists the home sections.

import 'package:flutter/material.dart';

import '../../navigation/home_sections.dart';
import '../../navigation/oba_route.dart';
import 'agencies_page.dart';
import 'alarms_section.dart';
import 'alerts_pages.dart';
import 'bookmark_editor.dart';
import 'bookmarks_page.dart';
import 'manage_bookmarks.dart';
import 'recent_stops.dart';

export 'agencies_page.dart' show AgenciesPage;
export 'alarms_section.dart' show AlarmsSection;
export 'alerts_pages.dart'
    show AlertDetailPage, AlertsListPage, ServiceAlertsSection;
export 'alerts_loader.dart' show AlertsLoader;
export 'bookmark_editor.dart' show BookmarkEditorPage;
export 'bookmarks_page.dart'
    show BookmarksPage, BookmarksSection, ObaBookmarksCard;
export 'manage_bookmarks.dart' show ManageBookmarksPage;
export 'recent_stops.dart' show RecentStopsPage, RecentStopsSection;
export '../../widgets/link_opener.dart' show ObaUrlOpener;

Widget buildRecentStopsRoute(BuildContext context, RecentStopsRoute route) =>
    const RecentStopsPage();

Widget buildBookmarksRoute(BuildContext context, BookmarksRoute route) =>
    const BookmarksPage();

Widget buildBookmarkEditorRoute(
  BuildContext context,
  BookmarkEditorRoute route,
) => BookmarkEditorPage(route: route);

Widget buildManageBookmarksRoute(
  BuildContext context,
  ManageBookmarksRoute route,
) => const ManageBookmarksPage();

Widget buildAlertsListRoute(BuildContext context, AlertsListRoute route) =>
    AlertsListPage(stopId: route.stopId, routeId: route.routeId);

Widget buildAlertDetailRoute(BuildContext context, AlertDetailRoute route) =>
    AlertDetailPage(route: route);

Widget buildAgenciesRoute(BuildContext context, AgenciesRoute route) =>
    const AgenciesPage();

/// Home tab sections owned by this feature: alarms, alerts, bookmarks and
/// recent stops.
List<ObaHomeSection> get bookmarksHomeSections => [
  ObaHomeSection(id: 'alarms', order: 4, builder: (_) => const AlarmsSection()),
  ObaHomeSection(
    id: 'alerts',
    order: 5,
    builder: (_) => const ServiceAlertsSection(),
  ),
  ObaHomeSection(
    id: 'bookmarks',
    order: 10,
    builder: (_) => const BookmarksSection(),
  ),
  ObaHomeSection(
    id: 'recent',
    order: 30,
    builder: (_) => const RecentStopsSection(),
  ),
];
