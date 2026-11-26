import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart' show parseHexColor;
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import 'heading.dart';
import '../app/scope.dart';
import '../platform/listenable_adapter.dart';
import '../l10n/l10n.dart';
import '../navigation/oba_navigator.dart';
import '../navigation/oba_route.dart';
import '../theme/oba_theme.dart';

/// A section title, marked as a header for screen readers, with an
/// optional trailing action ("See all").
class ObaSectionHeader extends StatelessWidget {
  const ObaSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 8, 4),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          ObaHeading(title),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!, semanticsLabel: '$actionLabel, $title'),
            ),
        ],
      ),
    );
  }
}

/// A tappable list row whose parts read as one sentence. Text wraps at any
/// size (no fixed heights); the row is at least 48dp tall.
class ObaListRow extends StatelessWidget {
  const ObaListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.semanticLabel,
    this.selected = false,
  });

  final String title;
  final String? subtitle;

  /// Decorative unless it carries meaning; wrap meaningful icons in
  /// `Semantics(label: ...)`. Plain icons are excluded from semantics.
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Replaces the default "title, subtitle" sentence.
  final String? semanticLabel;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      // Titles are often server names (stops, regions, alerts): isolate
      // them so their punctuation stays put in right-to-left locales.
      title: Text(obaBidiIsolate(context, title)),
      subtitle: subtitle == null
          ? null
          : Text(obaBidiIsolate(context, subtitle!)),
      leading: leading == null ? null : ExcludeSemantics(child: leading!),
      trailing: trailing,
      onTap: onTap,
      selected: selected,
      minTileHeight: 48,
      contentPadding: const EdgeInsetsDirectional.only(start: 16, end: 12),
    );
    if (semanticLabel == null) return MergeSemantics(child: tile);
    return MergeSemantics(
      child: Semantics(
        label: semanticLabel,
        excludeSemantics: true,
        button: onTap != null,
        selected: selected,
        onTap: onTap,
        child: tile,
      ),
    );
  }
}

/// The Material icon for a GTFS route type.
IconData routeTypeIconData(RouteType type) => switch (type) {
  RouteType.lightRail => Icons.tram,
  RouteType.subway => Icons.subway,
  RouteType.rail => Icons.train,
  RouteType.ferry => Icons.directions_boat,
  RouteType.cableCar => Icons.tram,
  RouteType.gondola => Icons.airline_seat_recline_normal,
  RouteType.funicular => Icons.tram,
  RouteType.bus || RouteType.unknown => Icons.directions_bus,
};

/// The localized name of a route type ("Bus", "Light rail").
String routeTypeLabel(ObaLocalizations l10n, RouteType type) => switch (type) {
  RouteType.bus => l10n.routeTypeBus,
  RouteType.lightRail => l10n.routeTypeLightRail,
  RouteType.subway => l10n.routeTypeSubway,
  RouteType.rail => l10n.routeTypeRail,
  RouteType.ferry => l10n.routeTypeFerry,
  RouteType.cableCar => l10n.routeTypeCableCar,
  RouteType.gondola => l10n.routeTypeGondola,
  RouteType.funicular => l10n.routeTypeFunicular,
  RouteType.unknown => l10n.routeTypeUnknown,
};

/// The localized direction ("Northbound") or null when unknown.
String? stopDirectionLabel(ObaLocalizations l10n, StopDirection d) =>
    switch (d) {
      StopDirection.n => l10n.directionN,
      StopDirection.ne => l10n.directionNE,
      StopDirection.e => l10n.directionE,
      StopDirection.se => l10n.directionSE,
      StopDirection.s => l10n.directionS,
      StopDirection.sw => l10n.directionSW,
      StopDirection.w => l10n.directionW,
      StopDirection.nw => l10n.directionNW,
      StopDirection.unknown => null,
    };

/// The route type a stop pin shows: ferry, then light rail, subway, rail,
/// bus (iOS `prioritizedRouteTypeForDisplay`).
RouteType prioritizedRouteType(Iterable<RouteType> types) {
  const priorities = [
    RouteType.ferry,
    RouteType.lightRail,
    RouteType.subway,
    RouteType.rail,
    RouteType.bus,
  ];
  final set = types.toSet();
  for (final t in priorities) {
    if (set.contains(t)) return t;
  }
  return RouteType.unknown;
}

/// A route-type glyph. Decorative by default; pass [semanticLabel] when it
/// is the only indication of the mode.
class ObaRouteTypeIcon extends StatelessWidget {
  const ObaRouteTypeIcon(
    this.type, {
    super.key,
    this.color,
    this.semanticLabel,
  });

  final RouteType type;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      routeTypeIconData(type),
      color: color,
      semanticLabel: semanticLabel,
    );
    return semanticLabel == null ? ExcludeSemantics(child: icon) : icon;
  }
}

/// A route short-name badge that grows with the text size. The text colour
/// is the feed's `route_text_color` when it is readable on the route colour,
/// otherwise black or white, whichever reads better.
///
/// It never clamps text scaling. With the rider's "Reduce colors" setting
/// on (`ObaSettings.reducedColors`), every badge uses one neutral style.
class ObaRouteBadge extends StatelessWidget {
  const ObaRouteBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.semanticLabel,
  });

  /// From a [Route] model.
  factory ObaRouteBadge.forRoute(core.Route route, {Key? key}) => ObaRouteBadge(
    key: key,
    label: route.shortName ?? route.longName ?? route.id,
    color: route.color,
    textColor: route.textColor,
  );

  final String label;

  /// GTFS hex colours (no `#`), as on `Route`.
  final String? color;
  final String? textColor;

  /// When null the badge is excluded from semantics (the row reads the
  /// route name in its own sentence).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final settings = ObaScope.maybeOf(context)?.core.settings;
    if (settings != null) {
      return ListenableBuilder(
        listenable: settings.listenable,
        builder: (context, _) =>
            _build(context, scheme, settings.reducedColors),
      );
    }
    return _build(context, scheme, false);
  }

  Widget _build(BuildContext context, ColorScheme scheme, bool reduced) {
    final background = reduced
        ? scheme.inverseSurface
        : parseHexColor(color) ?? scheme.inverseSurface;
    final foreground = reduced
        ? scheme.onInverseSurface
        : ObaContrast.ensureReadable(parseHexColor(textColor), background);
    final badge = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 40, minHeight: 32),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: ObaContrast.ratio(background, scheme.surface) < 3
              ? Border.all(color: scheme.outline)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: foreground, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
    return semanticLabel == null
        ? ExcludeSemantics(child: badge)
        : Semantics(
            label: semanticLabel,
            child: ExcludeSemantics(child: badge),
          );
  }
}

/// A stop in a list: route-type icon, name, and "Stop 1234 · Northbound ·
/// Routes 10, 44" (wrapping). Read as one sentence. Tapping pushes the stop
/// page unless [onTap] is given.
class ObaStopRow extends StatelessWidget {
  const ObaStopRow({
    super.key,
    required this.stop,
    this.routes = const [],
    this.trailing,
    this.onTap,
    this.extraDetails,
  });

  final Stop stop;

  /// The stop's routes (from the response references), for the icon and
  /// the routes line.
  final List<core.Route> routes;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Appended to the details line, e.g. a distance ("250 m").
  final String? extraDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final type = prioritizedRouteType(routes.map((r) => r.routeType));
    final names = [
      for (final r in routes)
        if ((r.shortName ?? r.longName) != null) r.shortName ?? r.longName!,
    ];
    final details = [
      if (stop.code != null && stop.code!.isNotEmpty) l10n.stopCode(stop.code!),
      ?stopDirectionLabel(l10n, stop.compassDirection),
      if (names.isNotEmpty) l10n.stopRoutes(names.join(', ')),
      ?extraDetails,
    ].join(' · ');
    return ObaListRow(
      leading: ObaRouteTypeIcon(type),
      title: stop.name,
      subtitle: details.isEmpty ? null : details,
      trailing: trailing,
      semanticLabel: l10n.stopRowLabel(
        stop.name,
        '${routeTypeLabel(l10n, type)}, $details',
      ),
      onTap: onTap ?? () => ObaNavigator.of(context).push(StopRoute(stop.id)),
    );
  }
}
