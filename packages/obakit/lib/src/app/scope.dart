import 'package:flutter/widgets.dart';
import 'package:oba_arrivals/oba_arrivals.dart'
    show ObaArrivalsStrings, ObaArrivalsStringsScope;

import '../l10n/l10n.dart';
import '../l10n/strings_bridge.dart';
import '../navigation/oba_route.dart';
import 'application.dart';

/// Called for every navigation request from an SDK screen before the SDK
/// handles it. Return true when the host handled it (e.g. it pushed its own
/// page or switched tabs); false lets the SDK push its page.
typedef ObaNavigateCallback = bool Function(
  BuildContext context,
  ObaRoute route,
);

/// Puts an [ObaApplication] in the tree. Every SDK widget needs one as an
/// ancestor, and nothing else: no shell, no map, no `MaterialApp` delegates
/// (it adds the SDK's localizations delegate itself when missing).
///
/// It also localizes any `oba_arrivals` `ObaArrivalsPanel` below it that
/// was not given its own strings, from the SDK's strings for the panel's
/// locale.
///
/// ```dart
/// ObaScope(
///   application: app,
///   onNavigate: (context, route) {
///     if (route is StopRoute) { myRouter.openStop(route.stopId); return true; }
///     return false; // the SDK pushes its own page
///   },
///   child: const NearbyStopsSection(),
/// )
/// ```
///
/// The scope does not own [application]; dispose it yourself.
///
/// Passing a new [onNavigate] closure on every build (an inline lambda) is
/// fine: dependents rebuild only when [application] changes, and
/// navigation always calls the latest callback.
class ObaScope extends StatelessWidget {
  const ObaScope({
    super.key,
    required this.application,
    this.onNavigate,
    required this.child,
  });

  final ObaApplication application;
  final ObaNavigateCallback? onNavigate;
  final Widget child;

  /// The nearest application. Throws when there is no [ObaScope].
  static ObaApplication of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ObaScopeData>();
    if (scope == null) {
      throw FlutterError(
        'ObaScope.of() called with a context that has no ObaScope ancestor.\n'
        'Wrap the SDK widget (or your MaterialApp) in an ObaScope.',
      );
    }
    return scope.application;
  }

  static ObaApplication? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ObaScopeData>()?.application;

  /// The host's navigation callback, if any.
  static ObaNavigateCallback? onNavigateOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_ObaScopeData>()?.onNavigate;

  /// Wraps [child] in a copy of the scope found at [context]. Used when an
  /// SDK page is pushed onto a navigator that sits above the host's
  /// [ObaScope] (e.g. the root navigator).
  static Widget rewrap(BuildContext context, Widget child) {
    final scope = context.getInheritedWidgetOfExactType<_ObaScopeData>();
    if (scope == null) return child;
    return ObaScope(
      application: scope.application,
      onNavigate: scope.onNavigate,
      child: child,
    );
  }

  /// Like [rewrap], but reads the scope at [context] now and returns the
  /// wrapper to apply later. For a pushed route: its builder runs again
  /// whenever the route's state changes (a page pushed above it, or popped),
  /// by which time the widget that pushed it may be gone and its context
  /// can no longer be searched.
  ///
  /// Navigation from the wrapped page calls the scope's newest
  /// `onNavigate` while [context] is still mounted, and the one captured
  /// here after that.
  static Widget Function(Widget child) capture(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<_ObaScopeData>();
    if (scope == null) return (child) => child;
    final application = scope.application;
    final captured = scope.onNavigate;
    bool onNavigate(BuildContext pageContext, ObaRoute route) {
      final latest = context.mounted ? onNavigateOf(context) : captured;
      return latest?.call(pageContext, route) ?? false;
    }

    return (child) => ObaScope(
      application: application,
      onNavigate: onNavigate,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = _ObaScopeData(
      application: application,
      onNavigate: onNavigate,
      child: ObaArrivalsStringsScope(resolve: _arrivalsStrings, child: child),
    );
    final hasLocalizations = Localizations.maybeLocaleOf(context) != null;
    if (hasLocalizations && ObaLocalizations.of(context) == null) {
      result = Localizations.override(
        context: context,
        delegates: const [ObaLocalizations.delegate],
        child: result,
      );
    }
    return result;
  }
}

/// Resolved at each panel's context, so it follows that context's locale.
ObaArrivalsStrings _arrivalsStrings(BuildContext context) =>
    context.obaArrivalsStrings;

class _ObaScopeData extends InheritedWidget {
  const _ObaScopeData({
    required this.application,
    required this.onNavigate,
    required super.child,
  });

  final ObaApplication application;
  final ObaNavigateCallback? onNavigate;

  // onNavigate is read at navigation time (getInheritedWidgetOfExactType,
  // no dependency), so a new closure needs no rebuild.
  @override
  bool updateShouldNotify(_ObaScopeData old) =>
      !identical(old.application, application);
}
