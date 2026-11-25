import 'package:flutter/material.dart';

import '../app/scope.dart';
import 'oba_route.dart';
import 'route_builder.dart';

/// Navigation for SDK screens. Screens never call `Navigator` directly for
/// SDK destinations; they call `ObaNavigator.of(context).push(route)`.
///
/// [of] resolves, in order:
/// 1. the host's `ObaScope.onNavigate` callback (if it returns true, the
///    request is done);
/// 2. the nearest [ObaNavigatorScope] (the shell installs one that pushes
///    inside the sheet; a host can install its own);
/// 3. otherwise [PageObaNavigator] on the nearest `Navigator`, which pushes
///    the SDK page as a normal full-screen route.
///
/// So a screen works the same inside the shell, inside a host's tab, or
/// pushed from host code.
abstract class ObaNavigator {
  const ObaNavigator();

  /// Shows [route]. Completes with the result the page pops with.
  Future<T?> push<T extends Object?>(ObaRoute route);

  /// Replaces the top page with [route].
  Future<T?> replace<T extends Object?>(ObaRoute route);

  /// Pops the top page.
  void pop<T extends Object?>([T? result]);

  /// Pops every SDK page above the root (the home sheet in the shell; the
  /// host's own page otherwise).
  void popToRoot();

  /// Whether [pop] would pop an SDK page.
  bool get canPop;

  static ObaNavigator of(BuildContext context) {
    final inner =
        ObaNavigatorScope.maybeOf(context) ??
        PageObaNavigator(Navigator.of(context), scopeContext: context);
    final onNavigate = ObaScope.onNavigateOf(context);
    if (onNavigate == null) return inner;
    return _HostInterceptingNavigator(inner, onNavigate, context);
  }
}

/// Installs an [ObaNavigator] for the subtree.
class ObaNavigatorScope extends InheritedWidget {
  const ObaNavigatorScope({
    super.key,
    required this.navigator,
    required super.child,
  });

  final ObaNavigator navigator;

  static ObaNavigator? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ObaNavigatorScope>()?.navigator;

  @override
  bool updateShouldNotify(ObaNavigatorScope oldWidget) =>
      !identical(oldWidget.navigator, navigator);
}

/// Builds a full-screen [PageRoute] for an SDK route. Its settings carry
/// the [ObaRoute] (`settings.arguments`) and its id (`settings.name`).
///
/// The `ObaScope` at [scopeContext] is read now, not in the route's builder:
/// the builder runs again long after the push, when the pushing widget (a
/// departure row, say) may already be gone.
Route<T> obaPageRoute<T>(ObaRoute route, {BuildContext? scopeContext}) {
  final wrap = scopeContext == null ? null : ObaScope.capture(scopeContext);
  return MaterialPageRoute<T>(
    settings: RouteSettings(name: route.id, arguments: route),
    builder: (context) {
      final page = ObaRouteBuilder.build(context, route);
      return wrap == null ? page : wrap(page);
    },
  );
}

/// Pushes SDK pages as ordinary routes on a Flutter [NavigatorState] (the
/// host's). Pages render as full-screen scaffolds.
class PageObaNavigator extends ObaNavigator {
  const PageObaNavigator(this.navigator, {this.scopeContext});

  final NavigatorState navigator;

  /// Where to copy the `ObaScope` from, for navigators above it.
  final BuildContext? scopeContext;

  @override
  Future<T?> push<T extends Object?>(ObaRoute route) =>
      navigator.push<T>(obaPageRoute<T>(route, scopeContext: scopeContext));

  @override
  Future<T?> replace<T extends Object?>(ObaRoute route) =>
      navigator.pushReplacement<T, Object?>(
        obaPageRoute<T>(route, scopeContext: scopeContext),
      );

  @override
  void pop<T extends Object?>([T? result]) => navigator.maybePop<T>(result);

  @override
  void popToRoot() =>
      navigator.popUntil((r) => r.settings.arguments is! ObaRoute);

  @override
  bool get canPop => navigator.canPop();
}

class _HostInterceptingNavigator extends ObaNavigator {
  const _HostInterceptingNavigator(this.inner, this.onNavigate, this.context);

  final ObaNavigator inner;
  final ObaNavigateCallback onNavigate;
  final BuildContext context;

  /// The scope's current callback: a navigator kept across rebuilds still
  /// calls the host's newest closure.
  ObaNavigateCallback get _latest =>
      (context.mounted ? ObaScope.onNavigateOf(context) : null) ?? onNavigate;

  @override
  Future<T?> push<T extends Object?>(ObaRoute route) {
    if (_latest(context, route)) return Future.value();
    return inner.push<T>(route);
  }

  @override
  Future<T?> replace<T extends Object?>(ObaRoute route) {
    if (_latest(context, route)) return Future.value();
    return inner.replace<T>(route);
  }

  @override
  void pop<T extends Object?>([T? result]) => inner.pop<T>(result);

  @override
  void popToRoot() => inner.popToRoot();

  @override
  bool get canPop => inner.canPop;
}
