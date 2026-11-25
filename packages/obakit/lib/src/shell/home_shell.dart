import 'dart:math' as math;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../app/scope.dart';
import '../platform/listenable_adapter.dart';
import '../features/map/map_coordinator.dart';
import '../features/map/map_view.dart';
import '../features/search/search_routes.dart';
import '../l10n/l10n.dart';
import '../navigation/oba_navigator.dart';
import '../navigation/oba_route.dart';
import '../navigation/presentation.dart';
import '../navigation/sheet_controller.dart';
import '../theme/oba_theme.dart';
import '../widgets/frame.dart';
import 'sheet_navigator.dart';

/// The map-panel experience (iOS `MapPanelRootView`): a full-screen map
/// with floating controls and a draggable bottom sheet holding a nested
/// navigator, so pages push inside the sheet while the map stays visible
/// and interactive. At widths of `ObaTheme.wideLayoutBreakpoint` (840dp)
/// and up, the sheet becomes a side panel.
///
/// Needs an `ObaScope` ancestor. `ObaApp` builds one for you.
class ObaHomeShell extends StatefulWidget {
  const ObaHomeShell({super.key, this.coordinator});

  /// Shared with the map and every page. Created when null.
  final ObaMapCoordinator? coordinator;

  @override
  State<ObaHomeShell> createState() => ObaHomeShellState();
}

class ObaHomeShellState extends State<ObaHomeShell>
    with TickerProviderStateMixin {
  static const double handleHeight = 24;

  late final ObaSheetController sheet = ObaSheetController(vsync: this);

  /// The map's bottom padding in the narrow layout, derived from [sheet].
  /// Notifies only when the padding changes, and only the map's floating
  /// controls listen: dragging the sheet never rebuilds the map itself.
  late final _SheetMapPadding _mapPadding = _SheetMapPadding(sheet);
  late ObaMapCoordinator _coordinator =
      widget.coordinator ?? (_owned = ObaMapCoordinator());
  ObaMapCoordinator? _owned;
  final GlobalKey<ObaSheetNavigatorHostState> _hostKey = GlobalKey();
  late final ObaSheetNavigator _navigator = ObaSheetNavigator(
    () => _hostKey.currentState,
  );

  /// The navigator for pages in the sheet / panel (deep links use it).
  ObaNavigator get navigator => _navigator;

  ObaMapCoordinator get coordinator => _coordinator;

  /// The SDK routes in the sheet, bottom first (for tests and hosts).
  List<ObaRoute> get routeStack =>
      _hostKey.currentState?.routeStack ?? const [];

  @override
  void didUpdateWidget(ObaHomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.coordinator != null &&
        !identical(widget.coordinator, _coordinator)) {
      _coordinator = widget.coordinator!;
    }
  }

  @override
  void dispose() {
    _mapPadding.dispose();
    sheet.dispose();
    _owned?.dispose();
    super.dispose();
  }

  Widget _map({ValueListenable<EdgeInsets>? padding}) => ObaMapView(
    coordinator: _coordinator,
    paddingListenable: padding,
    onOpenMapSettings: () => _navigator.push(const MapSettingsRoute()),
    onShowStopsList: () => _navigator.push(const StopsOnMapRoute()),
    topStartAccessory: buildWeatherAccessory(context),
  );

  @override
  Widget build(BuildContext context) {
    final theme = ObaTheme.of(context);
    sheet.reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return ObaMapCoordinatorScope(
      coordinator: _coordinator,
      child: ObaNavigatorScope(
        navigator: _navigator,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= theme.wideLayoutBreakpoint;
            return wide
                ? _buildWide(context, theme)
                : _buildNarrow(context, constraints, theme);
          },
        ),
      ),
    );
  }

  Widget _buildWide(BuildContext context, ObaTheme theme) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: theme.sidePanelWidth,
            child: Material(
              color: scheme.surfaceContainerLow,
              // The panel sits at the start edge: pad for the insets on
              // that side only (the right in right-to-left locales).
              child: SafeArea(
                left: Directionality.of(context) == TextDirection.ltr,
                right: Directionality.of(context) == TextDirection.rtl,
                child: ObaSheetNavigatorHost(
                  key: _hostKey,
                  presentation: ObaPresentation.panel,
                  coordinator: _coordinator,
                ),
              ),
            ),
          ),
          VerticalDivider(width: 1, color: scheme.outlineVariant),
          Expanded(child: _map()),
        ],
      ),
    );
  }

  Widget _buildNarrow(
    BuildContext context,
    BoxConstraints constraints,
    ObaTheme theme,
  ) {
    final media = MediaQuery.of(context);
    final maxHeight = math.max(
      0.0,
      constraints.maxHeight - media.padding.top - 12,
    );
    final scheme = Theme.of(context).colorScheme;
    _mapPadding.maxHeight = maxHeight;
    // The status bar always sits over the map (the sheet stops below it).
    return _StatusBarOverMap(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Semantics(
          container: true,
          explicitChildNodes: true,
          child: Stack(
            children: [
              Positioned.fill(
                child: Semantics(
                  // Screen readers read the sheet first, then the map: the
                  // sheet holds the page the rider opened, and the map's
                  // pins (dozens of them, some under the sheet) come last.
                  sortKey: const OrdinalSortKey(1),
                  container: true,
                  explicitChildNodes: true,
                  child: _map(padding: _mapPadding),
                ),
              ),
              Positioned.fill(
                child: ListenableBuilder(
                  listenable: sheet,
                  builder: (context, child) {
                    final header =
                        _hostKey.currentState?.topHeaderHeight ??
                        (handleHeight + 120);
                    sheet.updateMetrics(
                      maxHeight: maxHeight,
                      headerHeight: header + media.padding.bottom,
                    );
                    // updateMetrics may move the sheet without notifying.
                    _mapPadding.refresh();
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: sheet.height,
                        width: double.infinity,
                        child: child,
                      ),
                    );
                  },
                  child: Semantics(
                    sortKey: const OrdinalSortKey(0),
                    container: true,
                    explicitChildNodes: true,
                    child: Material(
                      color: scheme.surfaceContainerLow,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(theme.sheetCornerRadius),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      // The handle paints after the pages: a route's modal
                      // barrier blocks the semantics of everything painted
                      // before it.
                      child: Stack(
                        children: [
                          Positioned.fill(
                            top: handleHeight,
                            // Pages lay out at least as tall as their header,
                            // so a collapsed sheet clips instead of
                            // overflowing.
                            child: ClipRect(
                              child: LayoutBuilder(
                                builder: (context, box) {
                                  // Before the header is measured, lay out
                                  // at full height (clipped) so it never
                                  // overflows.
                                  final floor =
                                      _hostKey
                                          .currentState
                                          ?.measuredTopHeader ??
                                      sheet.maxHeight;
                                  final h = math.max(box.maxHeight, floor);
                                  return OverflowBox(
                                    alignment: Alignment.topCenter,
                                    minHeight: h,
                                    maxHeight: h,
                                    child: ObaSheetNavigatorHost(
                                      key: _hostKey,
                                      presentation: ObaPresentation.sheet,
                                      sheet: sheet,
                                      coordinator: _coordinator,
                                      handleHeight: handleHeight,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: ObaSheetHandle(
                              sheet: sheet,
                              height: handleHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The map padding under the sheet: `min(sheet height, half the available
/// height)` at the bottom.
class _SheetMapPadding extends ChangeNotifier
    implements ValueListenable<EdgeInsets> {
  _SheetMapPadding(this.sheet) {
    sheet.addListener(refresh);
  }

  final ObaSheetController sheet;
  double _maxHeight = 0;
  EdgeInsets _value = EdgeInsets.zero;

  @override
  EdgeInsets get value => _value;

  set maxHeight(double v) {
    if (v == _maxHeight) return;
    _maxHeight = v;
    refresh();
  }

  bool _notifyScheduled = false;
  bool _disposed = false;

  /// Recomputes the padding. [value] is updated at once (camera moves read
  /// it); listeners are told after the frame when this runs while the tree
  /// builds or lays out (the sheet resolves its height there).
  void refresh() {
    final next = EdgeInsets.only(
      bottom: math.min(sheet.height, _maxHeight * 0.5),
    );
    if (next == _value) return;
    _value = next;
    if (obaIsMidFrame) {
      if (_notifyScheduled) return;
      _notifyScheduled = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _notifyScheduled = false;
        if (!_disposed) notifyListeners();
      });
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    sheet.removeListener(refresh);
    super.dispose();
  }
}

/// The sheet's drag handle. Besides dragging, it is adjustable without
/// gestures: screen readers get increase/decrease actions ("Expand panel",
/// "Collapse panel"), and the keyboard can focus it and use the arrow keys
/// or Enter/Space (cycle).
class ObaSheetHandle extends StatefulWidget {
  const ObaSheetHandle({super.key, required this.sheet, required this.height});

  final ObaSheetController sheet;
  final double height;

  @override
  State<ObaSheetHandle> createState() => _ObaSheetHandleState();
}

class _ObaSheetHandleState extends State<ObaSheetHandle> {
  bool _focused = false;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final sheet = widget.sheet;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp) {
      sheet.expand();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      sheet.collapse();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      if (!sheet.expand()) sheet.animateTo(sheet.minHeight);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final scheme = Theme.of(context).colorScheme;
    final sheet = widget.sheet;
    return ListenableBuilder(
      listenable: sheet,
      builder: (context, _) => Focus(
        onKeyEvent: _onKey,
        onFocusChange: (f) => setState(() => _focused = f),
        child: Semantics(
          container: true,
          label: l10n.sheetLabel,
          hint: l10n.sheetHandleHint,
          onIncrease: sheet.canExpand ? sheet.expand : null,
          onDecrease: sheet.canCollapse ? sheet.collapse : null,
          customSemanticsActions: {
            if (sheet.canExpand)
              CustomSemanticsAction(label: l10n.sheetExpand): sheet.expand,
            if (sheet.canCollapse)
              CustomSemanticsAction(label: l10n.sheetCollapse): sheet.collapse,
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onVerticalDragUpdate: (d) => sheet.dragBy(-d.delta.dy),
            onVerticalDragEnd: (d) => sheet.settle(-(d.primaryVelocity ?? 0)),
            child: SizedBox(
              height: widget.height,
              child: Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(3),
                    border: _focused
                        ? Border.all(color: scheme.primary, width: 2)
                        : null,
                    boxShadow: _focused
                        ? [BoxShadow(color: scheme.primary, spreadRadius: 3)]
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Status-bar icons readable over the map tiles: dark over the default
/// street tiles (light even in a dark theme) and over imagery as before,
/// light over a host's dark street tiles (`ObaMapConfig.standardDark`).
class _StatusBarOverMap extends StatelessWidget {
  const _StatusBarOverMap({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context);
    final settings = app.core.settings;
    return ListenableBuilder(
      listenable: settings.listenable,
      builder: (context, child) {
        final darkTiles = app.map.showsDarkStreetTiles(
          settings.mapType,
          Theme.of(context).brightness,
        );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              (darkTiles
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark)
                  .copyWith(statusBarColor: const Color(0x00000000)),
          child: child!,
        );
      },
      child: child,
    );
  }
}
