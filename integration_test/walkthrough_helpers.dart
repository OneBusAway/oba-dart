import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_dart/main.dart';
import 'package:obakit/obakit.dart';

/// Shared driving helpers for the walkthrough test. Everything waits in
/// real time (the integration binding runs live), pumping frames as it goes.
class Walkthrough {
  Walkthrough(this.tester);

  final WidgetTester tester;
  final StreamController<Uri> links = StreamController<Uri>.broadcast();
  final List<String> problems = [];

  ObaHomeShellState get shell =>
      tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));

  ObaApplication get app =>
      ObaScope.of(tester.element(find.byType(ObaHomeShell)));

  // -- Timing -------------------------------------------------------------

  /// Pumps frames for [d] of real time.
  Future<void> wait(Duration d) async {
    final end = DateTime.now().add(d);
    while (DateTime.now().isBefore(end)) {
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    await tester.pump();
  }

  Future<void> seconds(num s) =>
      wait(Duration(milliseconds: (s * 1000).round()));

  /// Pumps until [finder] matches something, or fails after [timeout].
  Future<void> until(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
    bool required = true,
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump();
      if (finder.evaluate().isNotEmpty) return;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (required) {
      fail('Timed out waiting for $finder');
    } else {
      note('timed out waiting for $finder');
    }
  }

  Future<bool> appears(
    Finder finder, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    await until(finder, timeout: timeout, required: false);
    return finder.evaluate().isNotEmpty;
  }

  void note(String message) {
    problems.add(message);
    // ignore: avoid_print
    print('NOTE:$message');
  }

  /// Asks the wrapper script for a device screenshot, then holds still.
  Future<void> shot(String name, {num settle = 1.5}) async {
    await seconds(settle);
    lastShot = name;
    // ignore: avoid_print
    print('SHOT:$name');
    await seconds(2.5);
  }

  // -- Interaction --------------------------------------------------------

  Future<void> tap(Finder finder, {num settle = 1}) async {
    await until(finder);
    await tester.ensureVisible(finder.first);
    await tester.pump();
    await tester.tap(finder.first, warnIfMissed: false);
    await seconds(settle);
  }

  Future<void> tapText(String text, {num settle = 1}) =>
      tap(find.text(text), settle: settle);

  Future<void> tapTooltip(String tooltip, {num settle = 1}) =>
      tap(find.byTooltip(tooltip), settle: settle);

  Future<void> back({num settle = 1}) async {
    final nav = shell.navigator;
    if (nav.canPop) {
      nav.pop();
    } else {
      await tester.pageBack();
    }
    await seconds(settle);
  }

  Future<void> popToRoot() async {
    shell.navigator.popToRoot();
    await seconds(1);
  }

  Future<void> push(ObaRoute route, {num settle = 2}) async {
    shell.navigator.push(route);
    await seconds(settle);
  }

  // -- Semantics ----------------------------------------------------------

  /// Prints a compact outline of the semantics tree (traversal order) as
  /// `SEM:<name>:` lines.
  void dumpSemantics(String name) {
    final root = tester.binding.rootPipelineOwner;
    SemanticsNode? rootNode;
    void findRoot(PipelineOwner owner) {
      rootNode ??= owner.semanticsOwner?.rootSemanticsNode;
      owner.visitChildren(findRoot);
    }

    findRoot(root);
    if (rootNode == null) {
      note('no semantics tree for $name');
      return;
    }
    final out = StringBuffer();
    void visit(SemanticsNode node, int depth) {
      // Merged into an ancestor: the platform never sees it on its own.
      if (node.isMergedIntoParent) return;
      final d = node.getSemanticsData();
      final parts = <String>[];
      final label = d.label.replaceAll('\n', ' / ');
      if (label.isNotEmpty) parts.add('"$label"');
      if (d.value.isNotEmpty) parts.add('value="${d.value}"');
      if (d.hint.isNotEmpty) parts.add('hint="${d.hint}"');
      if (d.tooltip.isNotEmpty) parts.add('tooltip="${d.tooltip}"');
      final flags = <String>[
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.isHeader)) 'header',
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.isButton)) 'button',
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.isLink)) 'link',
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.isTextField)) 'textfield',
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.isSelected)) 'selected',
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.isImage)) 'image',
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.isLiveRegion)) 'live',
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.hasToggledState))
          // ignore: deprecated_member_use
          d.hasFlag(SemanticsFlag.isToggled) ? 'on' : 'off',
        // ignore: deprecated_member_use
        if (d.hasFlag(SemanticsFlag.hasCheckedState))
          // ignore: deprecated_member_use
          d.hasFlag(SemanticsFlag.isChecked) ? 'checked' : 'unchecked',
      ];
      final actions = <String>[
        for (final a in SemanticsAction.values)
          if (d.hasAction(a) &&
              a != SemanticsAction.didGainAccessibilityFocus &&
              a != SemanticsAction.didLoseAccessibilityFocus &&
              a != SemanticsAction.showOnScreen)
            a.name,
      ];
      final custom = d.customSemanticsActionIds ?? const [];
      final interesting =
          parts.isNotEmpty || flags.isNotEmpty || actions.isNotEmpty;
      if (interesting) {
        final customLabels = [
          for (final id in custom)
            CustomSemanticsAction.getAction(id)?.label ?? '?',
        ];
        out.writeln(
          '${'  ' * depth}${parts.join(' ')}'
          '${flags.isEmpty ? '' : ' [${flags.join(',')}]'}'
          '${actions.isEmpty ? '' : ' {${actions.join(',')}}'}'
          '${customLabels.isEmpty ? '' : ' custom(${customLabels.join('; ')})'}',
        );
      }
      for (final child in node.debugListChildrenInOrder(
        DebugSemanticsDumpOrder.traversalOrder,
      )) {
        visit(child, interesting ? depth + 1 : depth);
      }
    }

    visit(rootNode!, 0);
    for (final line in out.toString().split('\n')) {
      if (line.trim().isEmpty) continue;
      // ignore: avoid_print
      print('SEM:$name:$line');
    }
  }

  /// Runs Flutter's accessibility guidelines against the current screen
  /// and records failures as notes (live data varies, so they don't fail
  /// the run; the report lists them).
  Future<void> guidelines(String name) async {
    for (final entry in {
      'tap-android': androidTapTargetGuideline,
      'tap-ios': iOSTapTargetGuideline,
      'labeled': labeledTapTargetGuideline,
      'contrast': textContrastGuideline,
    }.entries) {
      final result = await entry.value.evaluate(tester);
      if (!result.passed) {
        note('GUIDELINE $name ${entry.key}: ${result.reason}');
      }
    }
  }

  // -- Flows --------------------------------------------------------------

  String lastShot = 'boot';

  Future<void> boot() async {
    // Tag framework errors with where the walk was, for the log.
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      // ignore: avoid_print
      print(
        'FLUTTERERROR:$lastShot:${details.exceptionAsString().split('\n').first}',
      );
      original?.call(details);
    };
    final widget = await buildOneBusAwayApp(links: links.stream);
    await tester.pumpWidget(widget);
    await seconds(2);
  }

  Future<void> onboarding() async {
    final l10n = lookupObaLocalizations(const Locale('en'));
    if (await appears(
      find.text(l10n.commonContinue),
      timeout: const Duration(seconds: 5),
    )) {
      await shot('01_onboarding_welcome');
      await tapText(l10n.commonContinue);
    }
    if (find.text(l10n.onboardingAllowLocation).evaluate().isNotEmpty) {
      await shot('02_onboarding_location');
      // The wrapper grants the permission from outside (no system dialog).
      // ignore: avoid_print
      print('GRANT_LOCATION');
      await seconds(4);
      await tapText(l10n.onboardingAllowLocation, settle: 3);
    }
    if (find.text(l10n.onboardingRegionTitle).evaluate().isNotEmpty) {
      await shot('03_onboarding_region');
      final use = find.text(l10n.onboardingRegionUse('Puget Sound'));
      if (use.evaluate().isEmpty) {
        note('region step did not suggest Puget Sound');
        await tapText('Puget Sound');
      } else {
        await tap(use);
      }
    }
    await until(
      find.byType(ObaHomeShell),
      timeout: const Duration(seconds: 20),
    );
    expect(app.core.currentRegion?.regionName, 'Puget Sound');
  }

  Future<void> mapShell() async {
    final l10n = lookupObaLocalizations(const Locale('en'));
    await seconds(4);
    await shot('04_map_shell');
    expect(find.textContaining('OpenStreetMap'), findsWidgets);
    // Zoomed out: the pill.
    shell.coordinator.moveTo(const Coordinate(47.6097, -122.3331), zoom: 12);
    await until(
      find.text(l10n.mapZoomInForStops),
      timeout: const Duration(seconds: 10),
      required: false,
    );
    await shot('05_map_zoomed_out');
    // Zoomed in near downtown: pins.
    shell.coordinator.moveTo(const Coordinate(47.6097, -122.3331), zoom: 17);
    await seconds(5);
    await shot('06_map_stops');
    if (find.byTooltip(l10n.mapRecenter).evaluate().isNotEmpty) {
      await tapTooltip(l10n.mapRecenter, settle: 3);
      await shot('07_map_recentred');
    } else {
      note('no recentre button');
    }
    await tapTooltip(l10n.mapSettingsButton, settle: 2);
    await shot('08_map_settings');
    await back();
    if (find.byTooltip(l10n.mapStopsListButton).evaluate().isNotEmpty) {
      await tapTooltip(l10n.mapStopsListButton, settle: 2);
      await shot('09_stops_on_map');
      await back();
    } else {
      note('no stops-list button');
    }
  }

  Future<void> homeSheet() async {
    final l10n = lookupObaLocalizations(const Locale('en'));
    final sheet = shell.sheet;
    await shot('10_home_collapsed');
    sheet.expand();
    await seconds(4);
    await shot('11_home_half');
    sheet.expandFully();
    await seconds(6);
    await shot('12_home_full');
    dumpSemantics('home_sheet');
    await guidelines('home_sheet');
    await tapText(l10n.homeTabRecent);
    await shot('13_recent_tab');
    await tapText(l10n.homeTabBookmarks);
    await shot('14_bookmarks_tab');
    await tapText(l10n.homeTabHome);
    sheet.collapse();
    sheet.collapse();
    await seconds(2);
  }

  ObaLocalizations get l10n => lookupObaLocalizations(const Locale('en'));

  final List<String> failures = [];

  /// Runs one flow; a failure is recorded (with a screenshot) and the walk
  /// continues from the home sheet.
  Future<void> step(String name, Future<void> Function() body) async {
    // ignore: avoid_print
    print('STEP:$name');
    try {
      await body();
    } catch (e, st) {
      failures.add('$name: $e');
      // ignore: avoid_print
      print('FAIL:$name: $e\n$st');
      await shot('FAIL_$name', settle: 0.5);
    }
    try {
      await popToRoot();
    } catch (_) {}
  }

  Future<void> openStopByLink() async {
    links.add(Uri.parse('onebusaway://view-stop?stopID=1_75403&regionID=1'));
    await until(find.byType(StopPage));
    await until(
      find.byType(ObaDepartureRow),
      timeout: const Duration(seconds: 20),
      required: false,
    );
    // Late at night the default window can be empty: widen it.
    for (
      var i = 0;
      i < 4 && find.byType(ObaDepartureRow).evaluate().isEmpty;
      i++
    ) {
      final more = find.text(l10n.stopPageLoadMore);
      if (more.evaluate().isEmpty) break;
      await tap(more, settle: 4);
    }
    await seconds(2);
  }

  /// Scrolls the departures into view (lazily built at large text) and
  /// opens the first one's trip.
  Future<void> tapFirstDeparture() async {
    final row = find.byType(ObaDepartureRow);
    if (row.evaluate().isEmpty &&
        find.text(l10n.stopPageLoadMore).evaluate().isNotEmpty) {
      // Late at night the stop may have nothing soon: use a nearby
      // departure from the home sheet instead.
      note('no departures at the stop; opening a nearby departure');
      await popToRoot();
      shell.sheet.expandFully();
      await until(
        find.byType(NearbyDepartureTile),
        timeout: const Duration(seconds: 30),
      );
      // The tile opens its stop, which has departures soon.
      await tap(find.byType(NearbyDepartureTile).first, settle: 5);
      shell.sheet.expandFully();
      await until(row, timeout: const Duration(seconds: 20), required: false);
    }
    if (row.evaluate().isEmpty) {
      // Rows below the fold are not built yet (large text). Scroll until
      // one exists; `scrollUntilVisible` needs exactly one match, and
      // several rows can appear at once.
      final list = find.byType(Scrollable).last;
      for (var i = 0; i < 30 && row.evaluate().isEmpty; i++) {
        await tester.drag(list, const Offset(0, -300));
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.ensureVisible(row.first);
      await tester.pump(const Duration(milliseconds: 300));
    }
    await tap(row.first, settle: 5);
  }

  Future<void> stopPage() async {
    await openStopByLink();
    await shot('20_stop_medium');
    shell.sheet.expandFully();
    await seconds(2);
    await shot('21_stop_full');
    dumpSemantics('stop_page');
    await guidelines('stop_page');
    if (find.byType(ObaDepartureRow).evaluate().isEmpty) {
      note('stop 1_75403 has no departures in the window right now');
    }
    // Route mode and back.
    await tapText(l10n.stopPageModeRoute, settle: 2);
    await shot('22_stop_by_route');
    await tapText(l10n.stopPageModeTime, settle: 2);
    // Earlier departures.
    final earlier = find.textContaining('earlier departure');
    if (await appears(earlier, timeout: const Duration(seconds: 2))) {
      await tap(earlier, settle: 2);
      await shot('23_stop_earlier');
      if (find.text(l10n.stopPageHideEarlier).evaluate().isNotEmpty) {
        await tapText(l10n.stopPageHideEarlier);
      }
    } else {
      note('no earlier-departures toggle at 1_75403');
    }
    // Departure types.
    await tap(find.byTooltip(l10n.stopPageDepartureTypes), settle: 1);
    await shot('24_stop_departure_types');
    await tapText(l10n.stopPageFilterRealtime, settle: 2);
    await shot('25_stop_realtime_only');
    await tap(find.byTooltip(l10n.stopPageDepartureTypes), settle: 1);
    await tap(find.text(l10n.stopPageFilterAll).last, settle: 2);
    // Filter routes.
    await tap(find.textContaining(l10n.stopPageFilterRoutes), settle: 2);
    await shot('26_stop_filter_routes');
    await tester.pageBack().catchError((_) {});
    await seconds(1);
    if (find.byType(BottomSheet).evaluate().isNotEmpty) {
      await tester.tapAt(const Offset(20, 80));
      await seconds(1);
    }
    // Refresh.
    if (find.byTooltip(l10n.stopPageRefresh).evaluate().isNotEmpty) {
      await tapTooltip(l10n.stopPageRefresh, settle: 3);
    }
    // Overflow menu.
    await tapTooltip(l10n.stopPageMoreActions);
    await shot('27_stop_overflow');
    await tapText(l10n.stopPageServiceAlerts, settle: 3);
    await shot('28_stop_alerts');
    await back();
    shell.sheet.collapse();
    await seconds(2);
    await shot('29_stop_map_routes');
  }

  Future<void> bookmarks() async {
    await openStopByLink();
    await tapTooltip(l10n.stopPageBookmark, settle: 2);
    await shot('30_bookmark_editor');
    await tapText(l10n.bookmarksEditorSave, settle: 2);
    expect(find.byTooltip(l10n.stopPageBookmarked), findsOneWidget);
    await popToRoot();
    shell.sheet.expandFully();
    await seconds(2);
    await tapText(l10n.homeTabBookmarks, settle: 4);
    await shot('31_bookmarks_tab');
    dumpSemantics('bookmarks');
    await guidelines('bookmarks');
    final actions = find.byWidgetPredicate(
      (w) =>
          w is PopupMenuButton && (w.tooltip ?? '').startsWith('Actions for'),
    );
    await tap(actions);
    await shot('32_bookmark_actions');
    await tapText(l10n.bookmarksActionPin, settle: 2);
    await shot('33_bookmark_pinned');
    await tap(actions);
    await tapText(l10n.bookmarksActionEdit, settle: 2);
    await shot('34_bookmark_edit');
    await back();
    await tapText(l10n.homeTabBookmarks, settle: 1);
    await tapTooltip(l10n.bookmarksManageTooltip, settle: 2);
    await shot('35_manage_bookmarks');
    await tapTooltip(l10n.bookmarksManageAddGroup, settle: 1);
    await tester.enterText(find.byType(TextField).last, 'Work');
    await seconds(1);
    await shot('36_new_group');
    await tap(find.text(l10n.bookmarksEditorSave).last, settle: 2);
    await shot('37_manage_with_group');
    await back();
    await tapText(l10n.homeTabRecent, settle: 2);
    await shot('38_recent_tab');
    expect(find.textContaining('Stop 75403'), findsWidgets);
    await tapText(l10n.homeTabHome, settle: 3);
    await shot('39_home_with_bookmark');
  }

  Future<void> tripPage() async {
    await openStopByLink();
    shell.sheet.expandFully();
    await seconds(1);
    await tapFirstDeparture();
    expect(find.byType(TripPage), findsOneWidget);
    await shot('40_trip_medium');
    shell.sheet.expandFully();
    await seconds(2);
    await shot('41_trip_full');
    dumpSemantics('trip_page');
    await guidelines('trip_page');
    shell.sheet.collapse();
    await seconds(2);
    await shot('42_trip_map');
    shell.sheet.expandFully();
    await seconds(1);
    final allStops = find.text(l10n.stopTripRouteStops);
    await tester.scrollUntilVisible(
      allStops,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tap(allStops, settle: 4);
    await shot('43_route_stops');
    final direction = find.textContaining('To ');
    if (direction.evaluate().length > 1) {
      await tap(direction.at(1), settle: 3);
      await shot('44_route_stops_direction');
    } else {
      note('route stops: no direction switcher found');
    }
    await back();
    await back();
    // Route schedule from the departure row's actions.
    final rowActions = find.byWidgetPredicate(
      (w) =>
          w is Tooltip &&
          w.message != null &&
          w.message!.startsWith('More actions for route'),
    );
    if (await appears(rowActions, timeout: const Duration(seconds: 3))) {
      await tap(rowActions);
      await shot('45_row_actions');
      await tapText(l10n.stopRowRouteSchedule, settle: 4);
      await shot('46_route_schedule');
      await tapTooltip(l10n.stopSchedNextDay, settle: 3);
      await shot('47_route_schedule_next_day');
    } else {
      note('no departure-row actions button');
    }
  }

  Future<void> stopSchedule() async {
    await openStopByLink();
    await tapTooltip(l10n.stopPageMoreActions);
    await tapText(l10n.stopPageSchedules, settle: 4);
    shell.sheet.expandFully();
    await seconds(1);
    await shot('50_stop_schedule');
    await tapTooltip(l10n.stopSchedNextDay, settle: 3);
    await shot('51_stop_schedule_next_day');
  }

  Future<void> search() async {
    await tap(find.bySemanticsLabel(l10n.homeSearchLabel).first, settle: 2);
    await shot('60_search_empty');
    dumpSemantics('search');
    final field = find.byType(TextField).first;
    await tester.enterText(field, '40');
    await seconds(3);
    await shot('61_search_typed_40');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await seconds(5);
    await shot('62_search_route_40');
    await popToRoot();
    await tap(find.bySemanticsLabel(l10n.homeSearchLabel).first, settle: 2);
    await tester.enterText(find.byType(TextField).first, '75403');
    await seconds(1);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await seconds(5);
    await shot('63_search_stop_75403');
    await popToRoot();
    await tap(find.bySemanticsLabel(l10n.homeSearchLabel).first, settle: 2);
    await tester.enterText(find.byType(TextField).first, 'Space Needle');
    await seconds(4);
    await shot('64_search_space_needle_typed');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await seconds(6);
    await shot('65_search_space_needle');
    if (find.byType(PlacePage).evaluate().isEmpty) {
      final hit = find.textContaining('Space Needle');
      if (await appears(hit, timeout: const Duration(seconds: 5))) {
        await tap(hit.last, settle: 4);
      }
    }
    await until(find.byType(PlacePage), timeout: const Duration(seconds: 10));
    await shot('66_place_page');
    final from = find.text(l10n.searchPlaceDirectionsFrom);
    await tester.scrollUntilVisible(
      from,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tap(from, settle: 3);
    expect(find.byType(TripPlannerPage), findsOneWidget);
    await shot('67_plan_from_place');
  }

  Future<void> tripPlanner() async {
    await push(
      const TripPlannerRoute(
        origin: Place(
          name: 'Pike Place Market',
          coordinate: Coordinate(47.6097, -122.3422),
        ),
        destination: Place(
          name: 'University of Washington',
          coordinate: Coordinate(47.6553, -122.3035),
        ),
      ),
      settle: 3,
    );
    shell.sheet.expandFully();
    await seconds(2);
    await tapText('Plan trip', settle: 12);
    await shot('70_planner_results');
    dumpSemantics('trip_planner');
    final itinerary = find.byWidgetPredicate(
      (w) => w is InkWell && w.onTap != null,
    );
    final minutes = find.textContaining(' min');
    if (await appears(minutes, timeout: const Duration(seconds: 15))) {
      await tap(minutes.first, settle: 4);
      await shot('71_itinerary_detail');
      shell.sheet.collapse();
      await seconds(2);
      await shot('72_itinerary_map');
    } else {
      note('trip planner: no itineraries ($itinerary)');
    }
  }

  Future<void> explore() async {
    // Weather.
    shell.sheet.collapse();
    shell.sheet.collapse();
    await seconds(2);
    final weather = find.bySemanticsLabel(RegExp('^Weather: '));
    if (await appears(weather, timeout: const Duration(seconds: 5))) {
      await tap(weather, settle: 3);
      shell.sheet.expandFully();
      await seconds(1);
      await shot('80_weather');
      await popToRoot();
    } else {
      note('no weather button');
    }
    await push(const AlertsListRoute(), settle: 4);
    await shot('81_alerts');
    await popToRoot();
    await push(const AgenciesRoute(), settle: 4);
    shell.sheet.expandFully();
    await seconds(1);
    await shot('82_agencies');
    await popToRoot();
    // Region picker: Tampa and back.
    await push(const RegionPickerRoute(), settle: 3);
    shell.sheet.expandFully();
    await seconds(1);
    await shot('83_region_picker');
    final tampa = find.textContaining('Tampa');
    await tester.scrollUntilVisible(
      tampa,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tap(tampa.first, settle: 6);
    expect(app.core.currentRegion?.regionName, contains('Tampa'));
    await popToRoot();
    shell.sheet.collapse();
    await seconds(4);
    await shot('84_tampa_map');
    await push(const RegionPickerRoute(), settle: 3);
    final puget = find.text('Puget Sound');
    await tester.scrollUntilVisible(
      puget,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tap(puget.first, settle: 6);
    expect(app.core.currentRegion?.regionName, 'Puget Sound');
    await popToRoot();
    await seconds(3);
    await shot('85_back_to_puget');
    // Settings, More, Credits.
    await push(const SettingsRoute(), settle: 2);
    shell.sheet.expandFully();
    await seconds(1);
    await shot('86_settings');
    dumpSemantics('settings');
    final compact = find.text(l10n.settingsReducedColors);
    await tester.scrollUntilVisible(
      compact,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tap(compact, settle: 1);
    expect(app.core.settings.reducedColors, isTrue);
    await shot('87_settings_toggled');
    // Persisted: a second application over the same storage (what a
    // relaunch reads) sees the change.
    final relaunched = await buildOneBusAwayApp();
    expect(relaunched.application.core.settings.reducedColors, isTrue);
    relaunched.application.dispose();
    app.core.settings.reducedColors = false;
    await popToRoot();
    await push(const MoreRoute(), settle: 2);
    shell.sheet.expandFully();
    await seconds(1);
    await shot('88_more');
    await push(const CreditsRoute(), settle: 3);
    await shot('89_credits');
  }

  Future<void> reports() async {
    await push(const ReportStopProblemRoute('1_75403'), settle: 3);
    shell.sheet.expandFully();
    await seconds(1);
    await shot('90_report_stop');
    final send = find.text(l10n.stopReportSend);
    await tester.scrollUntilVisible(
      send,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    // Sending with no problem chosen must be refused locally.
    await tap(send, settle: 2);
    await shot('91_report_stop_validation');
    expect(
      find.text(l10n.stopReportChooseProblem),
      findsWidgets,
      reason: 'the form validates before sending',
    );
  }

  /// Asks the wrapper to change a system setting (dark mode, text size).
  Future<void> system(String setting) async {
    // ignore: avoid_print
    print('SET:$setting');
    await seconds(4);
  }

  /// The main screens again, in the current appearance.
  Future<void> mainScreens(String tag) async {
    await popToRoot();
    shell.sheet.collapse();
    shell.sheet.collapse();
    await seconds(2);
    await shot('${tag}_a_home_collapsed');
    dumpSemantics('${tag}_home_collapsed');
    await guidelines('${tag}_home_collapsed');
    shell.sheet.expandFully();
    await seconds(3);
    await shot('${tag}_b_home_full');
    await tapText(l10n.homeTabBookmarks, settle: 3);
    await shot('${tag}_c_bookmarks');
    await guidelines('${tag}_bookmarks');
    await tapText(l10n.homeTabHome, settle: 1);
    await openStopByLink();
    shell.sheet.expandFully();
    await seconds(2);
    await shot('${tag}_d_stop');
    await guidelines('${tag}_stop');
    await tapFirstDeparture();
    shell.sheet.expandFully();
    await seconds(2);
    await shot('${tag}_e_trip');
    await guidelines('${tag}_trip');
    await popToRoot();
    await push(const SearchRoute(), settle: 2);
    await tester.enterText(find.byType(TextField).first, '40');
    await seconds(3);
    await shot('${tag}_f_search');
    await guidelines('${tag}_search');
    await popToRoot();
  }
}
