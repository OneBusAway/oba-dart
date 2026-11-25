import 'package:flutter/material.dart';

import '../features/map/map_coordinator.dart';
import '../navigation/oba_navigator.dart';
import '../navigation/oba_route.dart';
import '../navigation/presentation.dart';
import '../navigation/route_builder.dart';
import '../navigation/sheet_controller.dart';
import '../navigation/sheet_detents.dart';
import '../widgets/frame.dart';

/// The page route used inside the sheet / side panel.
class ObaSheetPageRoute<T> extends PageRoute<T> {
  ObaSheetPageRoute({
    required this.route,
    required this.frameBuilder,
    required bool reduceMotion,
  }) : _duration = reduceMotion
           ? Duration.zero
           : const Duration(milliseconds: 250),
       super(
         settings: RouteSettings(name: route.id, arguments: route),
       );

  final ObaRoute route;
  final Widget Function(BuildContext context, ObaSheetPageRoute<T> self)
  frameBuilder;
  final Duration _duration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  /// Absorbs taps on the page below during the transition, but doesn't
  /// block its semantics. The default barrier wraps the page below in a
  /// blocked semantics branch while the sheet animates its height, and
  /// Flutter 3.47 can drop geometry updates made inside a blocked branch,
  /// later failing with "Null check operator" in
  /// `_updateSemanticsNodeGeometry` (flutter/flutter#186178, fixed after
  /// 3.47). The pages are opaque, so once the transition ends the page
  /// below is offstage and out of the semantics tree anyway.
  // TODO(flutter-upgrade): drop this override once the pinned Flutter
  // includes the fix for flutter/flutter#186178.
  @override
  Widget buildModalBarrier() => const AbsorbPointer(child: SizedBox.expand());

  @override
  Duration get transitionDuration => _duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => frameBuilder(context, this);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (_duration == Duration.zero) return child;
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(curved),
        textDirection: Directionality.of(context),
        child: child,
      ),
    );
  }
}

/// The nested navigator inside the sheet (or side panel). Pages push here,
/// so the map stays visible and interactive behind them.
class ObaSheetNavigatorHost extends StatefulWidget {
  const ObaSheetNavigatorHost({
    super.key,
    required this.presentation,
    required this.coordinator,
    this.sheet,
    this.handleHeight = 0,
  });

  final ObaPresentation presentation;
  final ObaSheetController? sheet;
  final ObaMapCoordinator coordinator;

  /// Height of the sheet's drag handle row (added to the collapsed detent).
  final double handleHeight;

  @override
  State<ObaSheetNavigatorHost> createState() => ObaSheetNavigatorHostState();
}

class ObaSheetNavigatorHostState extends State<ObaSheetNavigatorHost> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  late final _Observer _observer = _Observer(this);
  final List<Route<dynamic>> _stack = [];
  final Map<Route<dynamic>, double> _headerHeights = {};
  final Map<Route<dynamic>, ObaSheetDetent?> _restingDetents = {};

  NavigatorState? get navigatorState => _navigatorKey.currentState;

  /// The SDK routes on the stack, bottom first.
  List<ObaRoute> get routeStack => [
    for (final r in _stack)
      if (r.settings.arguments case final ObaRoute o) o,
  ];

  Route<T> _pageRoute<T>(ObaRoute route) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return ObaSheetPageRoute<T>(
      route: route,
      reduceMotion: reduceMotion,
      frameBuilder: (context, self) => _SheetPageFrame(
        key: ValueKey(self),
        host: this,
        pageRoute: self,
        child: ObaRouteBuilder.build(context, route),
      ),
    );
  }

  Future<T?> push<T>(ObaRoute route) {
    final nav = navigatorState;
    if (nav == null) return Future.value();
    final existing = _stack.lastWhereOrNull(
      (r) => (r.settings.arguments as ObaRoute?)?.id == route.id,
    );
    if (existing != null) {
      nav.popUntil((r) => identical(r, existing));
      widget.sheet?.setDetents(route.detents);
      return Future.value();
    }
    return nav.push<T>(_pageRoute<T>(route));
  }

  Future<T?> replace<T>(ObaRoute route) {
    final nav = navigatorState;
    if (nav == null) return Future.value();
    return nav.pushReplacement<T, Object?>(_pageRoute<T>(route));
  }

  void reportHeaderHeight(Route<dynamic> route, double height) {
    if (_headerHeights[route] == height) return;
    _headerHeights[route] = height;
    if (identical(route, _stack.lastOrNull)) widget.sheet?.remeasure();
  }

  /// The tallest measured header on the stack (pages below the top are
  /// still laid out during transitions), or null while the top page's
  /// header is unmeasured.
  double? get measuredTopHeader {
    final top = _stack.lastOrNull;
    if (top == null || _headerHeights[top] == null) return null;
    var max = 0.0;
    for (final r in _stack) {
      final h = _headerHeights[r];
      if (h != null && h > max) max = h;
    }
    return max;
  }

  double get topHeaderHeight {
    final top = _stack.lastOrNull;
    final h = top == null ? null : _headerHeights[top];
    return (h ?? 64) + widget.handleHeight;
  }

  void _onTopChanged({Route<dynamic>? popped}) {
    final top = _stack.lastOrNull;
    final obaRoute = top?.settings.arguments as ObaRoute?;
    final coordinator = widget.coordinator;
    obaRunWhenSafe(() {
      if (!mounted) return;
      if (popped != null) coordinator.removeOverlay(popped);
      coordinator.setActiveOwner(top);
      coordinator.selectStop(obaRoute is StopRoute ? obaRoute.stopId : null);
      final sheet = widget.sheet;
      if (sheet != null && obaRoute != null) {
        sheet.setDetents(
          obaRoute.detents,
          restore: popped == null ? null : _restingDetents[top],
        );
      }
      setState(() {});
    });
  }

  void _didPush(Route<dynamic> route, Route<dynamic>? previous) {
    final sheet = widget.sheet;
    if (previous != null && sheet != null) {
      _restingDetents[previous] = sheet.restingDetent;
    }
    _stack.add(route);
    _onTopChanged();
  }

  void _didPop(Route<dynamic> route) {
    _stack.remove(route);
    _headerHeights.remove(route);
    _restingDetents.remove(route);
    _onTopChanged(popped: route);
  }

  void _didReplace(Route<dynamic>? oldRoute, Route<dynamic>? newRoute) {
    final i = oldRoute == null ? -1 : _stack.indexOf(oldRoute);
    if (i >= 0 && newRoute != null) {
      _stack[i] = newRoute;
    } else if (newRoute != null) {
      _stack.add(newRoute);
    }
    _headerHeights.remove(oldRoute);
    _restingDetents.remove(oldRoute);
    _onTopChanged(popped: oldRoute);
  }

  /// A menu, dropdown or bottom sheet opened over the top page (they push
  /// a [PopupRoute] onto the nearest navigator, which is this one). It is
  /// not a page: the page under it stays the top page, with its map
  /// overlay and selected stop. A sheet collapsed to its header leaves the
  /// popup almost no room, so it grows one detent.
  void _didPushPopup() {
    final sheet = widget.sheet;
    if (sheet == null) return;
    obaRunWhenSafe(() {
      if (mounted && sheet.isCollapsed) sheet.expand();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (_) => navigatorState?.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        observers: [_observer],
        onGenerateInitialRoutes: (_, _) => [
          _pageRoute<void>(const HomeRoute()),
        ],
        onGenerateRoute: (settings) => switch (settings.arguments) {
          final ObaRoute r => _pageRoute<Object?>(r),
          _ => null,
        },
      ),
    );
  }
}

class _Observer extends NavigatorObserver {
  _Observer(this.host);

  final ObaSheetNavigatorHostState host;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PopupRoute) return host._didPushPopup();
    host._didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! PopupRoute) host._didPop(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! PopupRoute) host._didPop(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      host._didReplace(oldRoute, newRoute);
}

/// Wraps each page: its own sheet-coupled scroll controller, the
/// presentation scope, and header-height reporting.
class _SheetPageFrame extends StatefulWidget {
  const _SheetPageFrame({
    super.key,
    required this.host,
    required this.pageRoute,
    required this.child,
  });

  final ObaSheetNavigatorHostState host;
  final Route<dynamic> pageRoute;
  final Widget child;

  @override
  State<_SheetPageFrame> createState() => _SheetPageFrameState();
}

class _SheetPageFrameState extends State<_SheetPageFrame> {
  late ScrollController _scroll = _create();
  ObaSheetController? _boundSheet;

  ScrollController _create() {
    final sheet = widget.host.widget.sheet;
    _boundSheet = sheet;
    return sheet == null ? ScrollController() : ObaSheetScrollController(sheet);
  }

  @override
  void didUpdateWidget(_SheetPageFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.host.widget.sheet, _boundSheet)) {
      final old = _scroll;
      _scroll = _create();
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final host = widget.host;
    final theme = Theme.of(context);
    return ObaPresentationScope(
      presentation: host.widget.presentation,
      sheet: host.widget.sheet,
      onHeaderHeight: (h) => host.reportHeaderHeight(widget.pageRoute, h),
      child: PrimaryScrollController(
        controller: _scroll,
        automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
        child: ColoredBox(
          color: theme.colorScheme.surfaceContainerLow,
          child: widget.child,
        ),
      ),
    );
  }
}

/// An [ObaNavigator] that pushes into the shell's sheet.
class ObaSheetNavigator extends ObaNavigator {
  ObaSheetNavigator(this._host);

  final ObaSheetNavigatorHostState? Function() _host;

  @override
  Future<T?> push<T extends Object?>(ObaRoute route) =>
      _host()?.push<T>(route) ?? Future.value();

  @override
  Future<T?> replace<T extends Object?>(ObaRoute route) =>
      _host()?.replace<T>(route) ?? Future.value();

  @override
  void pop<T extends Object?>([T? result]) =>
      _host()?.navigatorState?.maybePop<T>(result);

  @override
  void popToRoot() => _host()?.navigatorState?.popUntil((r) => r.isFirst);

  @override
  bool get canPop => _host()?.navigatorState?.canPop() ?? false;
}

extension<T> on List<T> {
  T? lastWhereOrNull(bool Function(T) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    return null;
  }
}
