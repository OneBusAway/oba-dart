import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as oba show Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../l10n/strings_bridge.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/rows.dart';
import '../../widgets/states.dart';
import 'stop_actions.dart';
import 'stop_format.dart';

/// Metric or imperial, from the locale.

/// The stop page header: code and direction, route badges, the walk (or
/// bike) time pill, agency attribution and the transfer banner. Public so a
/// host can show it above its own departures list.
class StopHeader extends StatelessWidget {
  const StopHeader({
    super.key,
    required this.stop,
    this.routes = const [],
    this.references = References.empty,
    this.walkTime,
    this.bikeMode = false,
    this.transfer,
  });

  final Stop stop;
  final List<oba.Route> routes;
  final References references;
  final WalkTime? walkTime;
  final bool bikeMode;
  final ObaTransferContext? transfer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final details = [
      if (stop.code != null && stop.code!.isNotEmpty) l10n.stopCode(stop.code!),
      ?stopDirectionLabel(l10n, stop.compassDirection),
    ].join(' · ');
    final sorted = [...routes]
      ..sort(
        (a, b) => naturalCompare(
          a.shortName ?? a.longName ?? a.id,
          b.shortName ?? b.longName ?? b.id,
        ),
      );
    final agencies = context.obaFormatters.formattedAgencies(
      sorted,
      references,
    );
    final walk = walkTime;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.isNotEmpty) Text(details, style: muted),
          if (sorted.isNotEmpty) ...[
            const SizedBox(height: 8),
            Semantics(
              label: l10n.stopRoutes(
                sorted.map((r) => r.shortName ?? r.longName ?? r.id).join(', '),
              ),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final r in sorted) ObaRouteBadge.forRoute(r)],
              ),
            ),
          ],
          if (walk != null) ...[
            const SizedBox(height: 8),
            _WalkPill(stop: stop, walk: walk, bike: bikeMode),
          ],
          if (agencies.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(l10n.stopPageAgencies(agencies), style: muted),
          ],
          if (transfer != null) ...[
            const SizedBox(height: 8),
            _TransferBanner(text: transferBannerText(context, transfer!)),
          ],
        ],
      ),
    );
  }
}

class _WalkPill extends StatelessWidget {
  const _WalkPill({required this.stop, required this.walk, required this.bike});

  final Stop stop;
  final WalkTime walk;
  final bool bike;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final distance = context.obaFormatters.distance(
      walk.distanceMeters,
      units: obaDistanceUnits(context),
    );
    return Semantics(
      label: bike
          ? l10n.stopPageBikeTimeLabel(walk.minutes, distance)
          : l10n.stopPageWalkTimeLabel(walk.minutes, distance),
      button: true,
      onTap: () => openStopDirections(context, stop.coordinate),
      excludeSemantics: true,
      // A button rather than a chip: chip labels stay on one line and
      // clipped the distance at large text sizes.
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: OutlinedButton.icon(
          icon: Icon(bike ? Icons.directions_bike : Icons.directions_walk),
          label: Text(
            '${bike ? l10n.stopPageBikeTime(walk.minutes) : l10n.stopPageWalkTime(walk.minutes)} · $distance',
          ),
          onPressed: () => openStopDirections(context, stop.coordinate),
        ),
      ),
    );
  }
}

class _TransferBanner extends StatelessWidget {
  const _TransferBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.transfer_within_a_station,
              color: scheme.onSecondaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The stop's service alerts, most severe first, collapsible, with unread
/// markers. Tapping one marks it read and opens it.
class StopAlertsSection extends StatelessWidget {
  const StopAlertsSection({
    super.key,
    required this.alerts,
    this.references = References.empty,
    this.expanded = true,
    this.onExpansionChanged,
  });

  final List<Situation> alerts;
  final References references;
  final bool expanded;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final tracker = ObaScope.of(context).core.alerts;
    final unread = tracker.unreadCount(alerts);
    final oba = ObaTheme.of(context);
    final title = [
      l10n.stopPageAlertsCount(alerts.length),
      if (unread > 0) l10n.stopPageAlertsUnread(unread),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
      child: Card.outlined(
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          initiallyExpanded: expanded,
          onExpansionChanged: onExpansionChanged,
          leading: Icon(Icons.warning_amber_rounded, color: oba.early),
          // Not a separate container: the title must label the tile's
          // expand/collapse button, which is the heading itself.
          title: Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.titleSmall),
          ),
          children: [
            for (final a in alerts)
              ObaListRow(
                leading: Icon(
                  a.isHighPriority ? Icons.error_outline : Icons.info_outline,
                  color: a.isHighPriority ? oba.early : null,
                ),
                title: a.title ?? l10n.stopPageServiceAlerts,
                subtitle: [
                  if (a.isHighPriority) l10n.stopPageAlertImportant,
                  if (tracker.isUnread(a)) l10n.stopPageAlertUnread,
                ].join(' · ').ifEmptyNull,
                trailing: tracker.isUnread(a)
                    ? ExcludeSemantics(
                        child: Icon(Icons.circle, size: 10, color: oba.brand),
                      )
                    : null,
                onTap: () {
                  tracker.markRead(a);
                  ObaNavigator.of(context).push(AlertDetailRoute(a));
                },
              ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  String? get ifEmptyNull => isEmpty ? null : this;
}

/// Shown above stale departures after a failed refresh.
class StopStaleBanner extends StatelessWidget {
  const StopStaleBanner({
    super.key,
    this.error,
    this.updatedAt,
    required this.now,
    this.isRetrying = false,
    this.onRetry,
  });

  final Object? error;
  final DateTime? updatedAt;
  final DateTime now;
  final bool isRetrying;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final updated = updatedAt == null
        ? null
        : l10n.stopPageUpdated(
            context.obaFormatters.timeAgo(updatedAt!, now: now),
          );
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
            child: Row(
              children: [
                Icon(Icons.cloud_off, color: scheme.onErrorContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.stopPageStaleTitle,
                        style: textTheme.titleSmall?.copyWith(
                          color: scheme.onErrorContainer,
                        ),
                      ),
                      Text(
                        [
                          ObaErrorState.messageFor(context, error),
                          l10n.stopPageStaleBody,
                          ?updated,
                        ].join(' '),
                        style: textTheme.bodyMedium?.copyWith(
                          color: scheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onRetry != null)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: scheme.onErrorContainer,
                    ),
                    onPressed: isRetrying ? null : onRetry,
                    child: Text(l10n.commonRetry),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Load more", the time window and the freshness line.
class StopFooter extends StatelessWidget {
  const StopFooter({
    super.key,
    required this.minutesAfter,
    required this.exhausted,
    required this.isLoading,
    required this.updatedAt,
    required this.now,
    required this.onLoadMore,
  });

  final int minutesAfter;
  final bool exhausted;
  final bool isLoading;
  final DateTime? updatedAt;
  final DateTime now;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      child: Column(
        children: [
          if (!exhausted)
            OutlinedButton.icon(
              icon: const Icon(Icons.more_time),
              label: Text(l10n.stopPageLoadMore),
              onPressed: isLoading ? null : onLoadMore,
            ),
          const SizedBox(height: 8),
          Text(
            l10n.stopPageWindow(minutesAfter),
            style: muted,
            textAlign: TextAlign.center,
          ),
          if (updatedAt != null)
            Text(
              l10n.stopPageUpdated(
                context.obaFormatters.timeAgo(updatedAt!, now: now),
              ),
              style: muted,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

/// The line between departures the rider would miss and those reachable
/// on foot (or by bike). Tapping opens directions.
class WalkTimeDivider extends StatelessWidget {
  const WalkTimeDivider({
    super.key,
    required this.minutes,
    this.bike = false,
    this.onTap,
  });

  final int minutes;
  final bool bike;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final color = ObaTheme.of(context).brand;
    final text = bike
        ? l10n.stopPageBikeDivider(minutes)
        : l10n.stopPageWalkDivider(minutes);
    return Semantics(
      button: onTap != null,
      label: text,
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Icon(
                  bike ? Icons.directions_bike : Icons.directions_walk,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A route group in route mode: badge, headsigns, and the next times;
/// tapping expands its departures.
class RouteGroupHeader extends StatelessWidget {
  const RouteGroupHeader({
    super.key,
    required this.group,
    required this.now,
    required this.expanded,
    required this.onToggle,
  });

  final GroupedArrivalDeparture group;
  final DateTime now;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final upcoming = [
      for (final a in group.arrivals)
        if ((a.minutesUntil(now) ?? -1) >= 0) a,
    ];
    final headsigns = {for (final a in group.arrivals) ?a.tripHeadsign}
        .join(', ');
    final next = upcoming
        .take(3)
        .map((a) => countdownText(l10n, a.minutesUntil(now) ?? 0))
        .join(', ');
    final first = upcoming.firstOrNull;
    final route = group.route;
    return Semantics(
      label: l10n.stopRouteGroupLabel(
        group.displayName,
        headsigns,
        group.arrivals.length,
        first == null
            ? '-'
            : etaA11y(l10n, first, first.minutesUntil(now) ?? 0),
      ),
      button: true,
      expanded: expanded,
      onTap: onToggle,
      excludeSemantics: true,
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 8, 10),
          child: Row(
            children: [
              ObaRouteBadge(
                label: group.displayName,
                color: route?.color,
                textColor: route?.textColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(headsigns, style: theme.textTheme.titleMedium),
                    if (next.isNotEmpty)
                      Text(
                        l10n.stopRouteGroupNext(next),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(expanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}

/// Per-stop sort and hidden routes (iOS `StopPreferencesView`). Changes
/// apply immediately through [onChanged].
class StopFilterSheet extends StatefulWidget {
  const StopFilterSheet({
    super.key,
    required this.routes,
    required this.preferences,
    required this.onChanged,
  });

  final List<oba.Route> routes;
  final StopPreferences Function() preferences;
  final ValueChanged<StopPreferences> onChanged;

  @override
  State<StopFilterSheet> createState() => _StopFilterSheetState();
}

class _StopFilterSheetState extends State<StopFilterSheet> {
  late StopPreferences _prefs = widget.preferences();

  void _set(StopPreferences p) {
    setState(() => _prefs = p);
    widget.onChanged(p);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    Widget heading(String t) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 4),
      child: Semantics(
        container: true,
        header: true,
        child: Text(t, style: theme.textTheme.titleSmall),
      ),
    );
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      container: true,
                      header: true,
                      child: Text(
                        l10n.stopFilterTitle,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.commonDone),
                  ),
                ],
              ),
            ),
            heading(l10n.stopFilterSort),
            RadioGroup<StopSort>(
              groupValue: _prefs.sortType,
              onChanged: (v) => _set(_prefs.copyWith(sortType: v)),
              child: Column(
                children: [
                  RadioListTile<StopSort>(
                    value: StopSort.time,
                    title: Text(l10n.stopPageModeTime),
                  ),
                  RadioListTile<StopSort>(
                    value: StopSort.route,
                    title: Text(l10n.stopPageModeRoute),
                  ),
                ],
              ),
            ),
            heading(l10n.stopFilterRoutesHeader),
            for (final r in widget.routes)
              CheckboxListTile(
                value: !_prefs.isRouteHidden(r.id),
                onChanged: (_) => _set(_prefs.toggleRouteHidden(r.id)),
                secondary: ObaRouteBadge.forRoute(r),
                title: Text(r.longName ?? r.description ?? r.shortName ?? r.id),
              ),
            if (_prefs.hasHiddenRoutes)
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () =>
                      _set(_prefs.copyWith(hiddenRoutes: const [])),
                  child: Text(l10n.stopFilterShowAll),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
