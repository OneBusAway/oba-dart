import 'package:flutter/widgets.dart';

import 'strings.dart';

/// Supplies [ObaArrivalsStrings] to every [ObaArrivalsPanel] below it that
/// was not given strings of its own, so a host with its own localization
/// system can translate every panel in one place.
///
/// [resolve] runs at each panel's own context (so it may read
/// `Localizations` there, and the panel rebuilds when the locale changes).
/// Pass a long-lived function such as a top-level one: a new function
/// rebuilds every panel below.
///
/// ```dart
/// ObaArrivalsStringsScope(
///   resolve: (context) => MyArrivalsStrings(AppLocalizations.of(context)),
///   child: app,
/// )
/// ```
class ObaArrivalsStringsScope extends InheritedWidget {
  const ObaArrivalsStringsScope({
    super.key,
    required this.resolve,
    required super.child,
  });

  final ObaArrivalsStrings Function(BuildContext context) resolve;

  /// The strings from the nearest scope, resolved at [context]; null when
  /// there is no scope.
  static ObaArrivalsStrings? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ObaArrivalsStringsScope>()
      ?.resolve(context);

  @override
  bool updateShouldNotify(ObaArrivalsStringsScope oldWidget) =>
      resolve != oldWidget.resolve;
}
