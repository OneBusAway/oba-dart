import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

const stopId = '1_10020';
const stopName = 'NE 55TH ST & 37TH AVE NE';

Future<ObaTestEnv> makeEnv({
  Map<String, String>? responses,
  String arrivals = 'arrivals_and_departures_for_stop_1_10020.json',
  Map<String, String> storeValues = const {},
  ObaLocation? location,
}) => ObaTestEnv.create(
  responses:
      responses ?? {'arrivals-and-departures-for-stop': fixture(arrivals)},
  storeValues: storeValues,
  location: location,
  permission: location == null
      ? LocationPermissionStatus.notDetermined
      : LocationPermissionStatus.whileInUse,
);

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  testWidgets('loaded: header, rows, earlier toggle, recents, analytics', (
    tester,
  ) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    expect(find.text(stopName), findsWidgets);
    expect(find.text('Stop 10020 · Westbound'), findsOneWidget);
    // Two upcoming rows; two past rows behind the toggle.
    expect(find.byType(ObaDepartureRow), findsNWidgets(2));
    await tester.tap(find.text('Show 2 earlier departures'));
    await tester.pumpAndSettle();
    expect(find.byType(ObaDepartureRow), findsNWidgets(4));
    expect(find.text('Hide earlier departures'), findsOneWidget);
    final region = env.app.core.currentRegion!.id;
    expect(env.app.core.userData.recentStopsInRegion(region).first.id, stopId);
    final request = env.requests.first.url;
    expect(request.queryParameters['minutesBefore'], '5');
    expect(request.queryParameters['minutesAfter'], '35');
  });

  testWidgets('a row reads as one sentence with status text', (tester) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    final handle = tester.ensureSemantics();
    expect(
      find.bySemanticsLabel(
        RegExp(
          r'^Route 65 to LAKE CITY WEDGWOOD, arrives in \d+ minutes, at .+, live tracking, ',
        ),
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('route mode groups by route and expands', (tester) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    await tester.tap(find.text('By route'));
    await tester.pumpAndSettle();
    expect(find.byType(RouteGroupHeader), findsNWidgets(2));
    expect(find.byType(ObaDepartureRow), findsNothing);
    // Expand through the screen-reader tap action (the header excludes its
    // children's semantics, so it must carry the action itself).
    final handle = tester.ensureSemantics();
    final node = tester.getSemantics(find.byType(RouteGroupHeader).first);
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    node.owner!.performAction(node.id, SemanticsAction.tap);
    await tester.pumpAndSettle();
    handle.dispose();
    expect(find.byType(ObaDepartureRow), findsNWidgets(2));
    final region = env.app.core.currentRegion!.id;
    expect(
      env.app.core.userData.stopPreferences(region, stopId).sortType,
      StopSort.route,
    );
  });

  testWidgets('tapping a row pushes its trip; row actions push routes', (
    tester,
  ) async {
    env = await makeEnv();
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const StopPage(stopId: stopId),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    await tester.tap(find.byType(ObaDepartureRow).first);
    expect(pushed.single, isA<TripRoute>());
    // A screen reader's double-tap (the semantics tap action) opens it too.
    final handle = tester.ensureSemantics();
    final row = tester.getSemantics(
      find
          .descendant(
            of: find.byType(ObaDepartureRow).first,
            matching: find.byType(InkWell),
          )
          .first,
    );
    expect(row.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    row.owner!.performAction(row.id, SemanticsAction.tap);
    await tester.pump();
    expect(pushed, hasLength(2));
    pushed.removeLast();
    handle.dispose();
    expect((pushed.single as TripRoute).trip.stopId, stopId);

    await tester.tap(find.byTooltip(RegExp('More actions for route')).first);
    await tester.pumpAndSettle();
    expect(find.text('Show trip details'), findsOneWidget);
    expect(find.text('Share trip'), findsOneWidget);
    // No push provider: no alarm action.
    expect(find.text('Add alarm'), findsNothing);
    await tester.tap(find.text('Bookmark this trip'));
    await tester.pumpAndSettle();
    final bookmark = pushed.last as BookmarkEditorRoute;
    expect(bookmark.arrival, isNotNull);
    expect(bookmark.stop?.id, stopId);
  });

  testWidgets('header actions: bookmark, overflow menu destinations', (
    tester,
  ) async {
    env = await makeEnv();
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      const StopPage(stopId: stopId),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    await tester.tap(find.byTooltip('Bookmark stop'));
    expect((pushed.last as BookmarkEditorRoute).stop?.id, stopId);

    Future<void> menu(String item) async {
      await tester.tap(find.byTooltip('More stop actions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(item));
      await tester.pumpAndSettle();
    }

    await menu('Schedules');
    expect(pushed.last, const StopScheduleRoute(stopId));
    await menu('Service alerts');
    expect(pushed.last, const AlertsListRoute(stopId: stopId));
    await menu('Nearby stops');
    expect(pushed.last, isA<NearbyStopsRoute>());
    await menu('Report a problem');
    expect(pushed.last, const ReportStopProblemRoute(stopId));
  });

  testWidgets('bookmarked state', (tester) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    final core = env.app.core;
    core.userData.addBookmark(
      Bookmark.forStop(
        name: 'Home',
        regionId: core.currentRegion!.id,
        stop: core.userData.recentStopsInRegion(core.currentRegion!.id).first,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Bookmarked. Edit bookmark'), findsOneWidget);
  });

  testWidgets('empty response widens the window, then shows empty state', (
    tester,
  ) async {
    env = await makeEnv(arrivals: 'arrivals_and_departures_empty.json');
    await env.pumpPage(tester, const StopPage(stopId: 'MTS_1'));
    expect(find.text('No upcoming departures'), findsOneWidget);
    final windows = [
      for (final r in env.requests) r.url.queryParameters['minutesAfter'],
    ];
    expect(windows.first, '35');
    expect(windows.last, '720');
    expect(find.text('Load more departures'), findsNothing);
  });

  testWidgets('load more widens by 30 minutes', (tester) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    await tester.scrollUntilVisible(find.text('Load more departures'), 100);
    await tester.tap(find.text('Load more departures'));
    await ObaTestEnv.settle(tester);
    expect(env.requests.last.url.queryParameters['minutesAfter'], '65');
    expect(find.text('Showing the next 65 minutes'), findsOneWidget);
  });

  testWidgets('error then retry; stale banner keeps data', (tester) async {
    final responses = {'arrivals-and-departures-for-stop': '{not json'};
    env = await makeEnv(responses: responses);
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    expect(find.text('Try again'), findsOneWidget);
    responses['arrivals-and-departures-for-stop'] = fixture(
      'arrivals_and_departures_for_stop_1_10020.json',
    );
    await tester.tap(find.text('Try again'));
    await ObaTestEnv.settle(tester);
    expect(find.byType(ObaDepartureRow), findsNWidgets(2));

    responses['arrivals-and-departures-for-stop'] = '{not json';
    await tester.tap(find.byTooltip('Refresh'));
    await ObaTestEnv.settle(tester);
    expect(find.text("Couldn't refresh departures"), findsOneWidget);
    expect(find.byType(ObaDepartureRow), findsNWidgets(2));
  });

  testWidgets('missing stop', (tester) async {
    env = await makeEnv(
      responses: {'arrivals-and-departures-for-stop': 'null', 'stop/': 'null'},
    );
    await env.pumpPage(tester, const StopPage(stopId: 'nope'));
    expect(find.text('Stop not found'), findsOneWidget);
  });

  testWidgets('hidden routes and the departure-type filter', (tester) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    final core = env.app.core;
    final region = core.currentRegion!.id;
    core.userData.setStopPreferences(
      region,
      stopId,
      const StopPreferences(hiddenRoutes: ['1_30', '1_65']),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Every route with departures here is hidden.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Show all routes'));
    await tester.pumpAndSettle();
    expect(find.byType(ObaDepartureRow), findsNWidgets(2));

    core.userData.setStopPreferences(region, stopId, const StopPreferences());
    core.settings.arrivalDepartureFilter = ArrivalDepartureFilter.scheduledOnly;
    await tester.pumpAndSettle();
    expect(
      find.text('No departures match the departure-type filter.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Show all departures'));
    await tester.pumpAndSettle();
    expect(core.settings.arrivalDepartureFilter, ArrivalDepartureFilter.all);
  });

  testWidgets('filter routes sheet persists hidden routes per stop', (
    tester,
  ) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    await tester.tap(find.text('Filter routes'));
    await tester.pumpAndSettle();
    expect(find.byType(CheckboxListTile), findsWidgets);
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();
    final region = env.app.core.currentRegion!.id;
    expect(
      env.app.core.userData.stopPreferences(region, stopId).hiddenRoutes.length,
      1,
    );
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 route hidden'), findsOneWidget);
  });

  testWidgets('walk time pill and divider from the user location', (
    tester,
  ) async {
    // The upcoming rows are 21 and 22 minutes away; a 22-minute walk puts
    // the divider between them.
    final stop = (lat: 47.6685829, lon: -122.2883);
    env = await makeEnv(
      location: ObaLocation(
        lat: stop.lat + 1806 / 111320,
        lon: stop.lon,
        timestamp: DateTime.utc(2024),
      ),
    );
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    expect(find.textContaining('22 min walk'), findsWidgets);
    expect(find.byType(WalkTimeDivider), findsOneWidget);
    final rows = tester
        .widgetList<ObaDepartureRow>(find.byType(ObaDepartureRow))
        .toList();
    expect(rows.first.style, ObaDepartureRowStyle.missed);
    expect(rows.last.style, ObaDepartureRowStyle.normal);
  });

  testWidgets('transfer trip is highlighted', (tester) async {
    env = await makeEnv();
    await env.pumpPage(
      tester,
      StopPage(
        stopId: stopId,
        transfer: ObaTransferContext(
          arrivalTime: DateTime.utc(2012, 7, 29),
          fromRouteShortName: '65',
          fromTripHeadsign: 'WEDGWOOD',
          fromTripId: '1_18198947',
        ),
      ),
    );
    final highlighted = tester
        .widgetList<ObaDepartureRow>(find.byType(ObaDepartureRow))
        .where((r) => r.isTransfer);
    expect(highlighted.single.arrival.tripId, '1_18198947');
    expect(find.textContaining('Transfer from 65 WEDGWOOD'), findsOneWidget);
  });

  testWidgets('declares map overlays when a map is present', (tester) async {
    env = await makeEnv(
      responses: {
        'arrivals-and-departures-for-stop': fixture(
          'arrivals_and_departures_for_stop_1_10020.json',
        ),
        'stops-for-route': fixture('stops_for_route_1_44.json'),
      },
    );
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    await env.pumpPage(
      tester,
      const StopPage(stopId: stopId),
      coordinator: map,
    );
    expect(map.overlay.stops.single.id, stopId);
    expect(map.overlay.polylines, isNotEmpty);
    // The camera centres on the stop.
    final stop = map.overlay.stops.single;
    expect(map.overlay.fitBounds!.contains(stop.lat, stop.lon), isTrue);
    expect(
      env.requests.where((r) => r.url.path.contains('stops-for-route')),
      isNotEmpty,
    );
  });

  testWidgets('shapes: one request per route, cached for other pages', (
    tester,
  ) async {
    env = await makeEnv(
      responses: {
        'arrivals-and-departures-for-stop': fixture(
          'arrivals_and_departures_for_stop_1_10020.json',
        ),
        'stops-for-route': fixture('stops_for_route_1_44.json'),
      },
    );
    int shapeRequests() => env.requests
        .where((r) => r.url.path.contains('stops-for-route'))
        .length;
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    await env.pumpPage(
      tester,
      const StopPage(stopId: stopId),
      coordinator: map,
    );
    // The stop's three routes, fetched once each.
    expect(shapeRequests(), 3);
    expect(env.app.core.stopsForRoute.length, 3);
    // The route's stops page reuses the cached response.
    await env.pumpPage(
      tester,
      const RouteStopsPage(routeId: '1_30'),
      coordinator: map,
    );
    expect(shapeRequests(), 3);
    expect(map.overlay.polylines, isNotEmpty);
  });

  testWidgets('a location fix leaves the page and its map overlay alone', (
    tester,
  ) async {
    final stop = (lat: 47.6685829, lon: -122.2883);
    ObaLocation at(double metersNorth) => ObaLocation(
      lat: stop.lat + metersNorth / 111320,
      lon: stop.lon,
      timestamp: DateTime.utc(2024).add(Duration(seconds: metersNorth.round())),
    );
    env = await makeEnv(location: at(1806));
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    await env.pumpPage(
      tester,
      const StopPage(stopId: stopId),
      coordinator: map,
    );
    expect(find.textContaining('22 min walk'), findsWidgets);
    final overlay = map.overlay;
    var notified = 0;
    map.addListener(() => notified++);
    final row = tester.widget(find.byType(ObaDepartureRow).first);

    // A few metres closer: the same walk minutes.
    env.location.setLocation(at(1800));
    await tester.pump();
    expect(identical(map.overlay, overlay), isTrue);
    expect(notified, 0);
    expect(
      identical(tester.widget(find.byType(ObaDepartureRow).first), row),
      isTrue,
      reason: 'the rows were not rebuilt',
    );

    // Far enough to change the walk minutes: the rows follow.
    env.location.setLocation(at(600));
    await tester.pump();
    expect(find.byType(WalkTimeDivider), findsNothing);
    expect(find.textContaining('8 min walk'), findsWidgets);
  });

  testWidgets('lazily built row actions still reach screen readers', (
    tester,
  ) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    final handle = tester.ensureSemantics();
    await tester.pump();
    final node = tester.getSemantics(
      find
          .descendant(
            of: find.byType(ObaDepartureRow).first,
            matching: find.byType(InkWell),
          )
          .first,
    );
    final labels = [
      for (final id in node.getSemanticsData().customSemanticsActionIds ?? [])
        CustomSemanticsAction.getAction(id)!.label,
    ];
    expect(labels, contains('Show trip details'));
    expect(labels, contains('Bookmark this trip'));
    handle.dispose();
  });

  testWidgets('no map: no shapes requested', (tester) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    expect(
      env.requests.where((r) => r.url.path.contains('stops-for-route')),
      isEmpty,
    );
  });

  for (final presentation in [
    ObaPresentation.embedded,
    ObaPresentation.sheet,
    ObaPresentation.panel,
  ]) {
    testWidgets('renders in ${presentation.name}', (tester) async {
      env = await makeEnv();
      await env.pumpPage(
        tester,
        const StopPage(stopId: stopId),
        presentation: presentation,
      );
      expect(find.byType(ObaDepartureRow), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('embedded in a host page: with or without its header', (
    tester,
  ) async {
    env = await makeEnv();
    Widget host({required bool showsHeader}) => Scaffold(
      appBar: AppBar(title: const Text('Transit')),
      body: ObaPresentationScope.embedded(
        showsHeader: showsHeader,
        child: const StopPage(stopId: stopId),
      ),
    );
    // No header: the host titles the page; the actions lead the list.
    await env.pumpPage(tester, host(showsHeader: false));
    expect(find.text(stopName), findsNothing);
    expect(find.byTooltip('Bookmark stop'), findsOneWidget);

    // A host tab with no title of its own for the stop: the stop's name is a
    // heading and the page's actions are there, under the host's one app
    // bar and without a second back button.
    await env.pumpPage(tester, host(showsHeader: true));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text(stopName), findsOneWidget);
    expect(
      tester.getSemantics(find.text(stopName)),
      matchesSemantics(label: stopName, isHeader: true),
    );
    expect(find.byTooltip('Bookmark stop'), findsOneWidget);
    expect(find.byTooltip('More stop actions'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
    expect(find.byType(ObaDepartureRow), findsNWidgets(2));
    await expectObaAccessibility(tester);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('accessibility (${mode.name})', (tester) async {
      env = await makeEnv();
      await env.pumpPage(
        tester,
        const StopPage(stopId: stopId),
        themeMode: mode,
      );
      await tester.tap(find.text('Show 2 earlier departures'));
      await tester.pumpAndSettle();
      await expectObaAccessibility(tester);
    });
  }

  testWidgets('no overflow at 200% text', (tester) async {
    env = await makeEnv();
    await env.expectNoOverflowAtTextScale(
      tester,
      const StopPage(stopId: stopId),
    );
    await tester.tap(find.text('By route'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('polls every 30 s while visible', (tester) async {
    env = await makeEnv();
    await env.pumpPage(tester, const StopPage(stopId: stopId));
    final before = env.requests.length;
    await tester.pump(const Duration(seconds: 31));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    expect(env.requests.length, before + 1);
  });

  testWidgets('sheet at a medium detent, 200% text, with a walk pill', (
    tester,
  ) async {
    env = await makeEnv(
      location: ObaLocation(
        lat: 47.6685829 + 1806 / 111320,
        lon: -122.2883,
        timestamp: DateTime.utc(2024),
      ),
    );
    await env.pumpPage(
      tester,
      const StopPage(stopId: stopId),
      presentation: ObaPresentation.sheet,
      textScale: 2,
      surfaceSize: const Size(390, 340),
    );
    expect(tester.takeException(), isNull);
    // The walk pill wraps instead of clipping its distance.
    final walk = tester.renderObject<RenderBox>(
      find.textContaining('min walk').first,
    );
    final right = walk.localToGlobal(Offset(walk.size.width, 0)).dx;
    expect(right, lessThanOrEqualTo(390 - 16));
    // Refresh and bookmark move into the overflow menu at large text.
    expect(find.byTooltip('Refresh'), findsNothing);
    await tester.tap(find.byTooltip('More stop actions'));
    await tester.pumpAndSettle();
    expect(find.text('Refresh'), findsOneWidget);
    expect(find.text('Bookmark stop'), findsOneWidget);
  });
}
