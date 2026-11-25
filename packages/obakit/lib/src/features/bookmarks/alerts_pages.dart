import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/heading.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'alerts_loader.dart';
import '../../widgets/link_opener.dart';
import '../../widgets/visibility.dart';

String _severityLabel(ObaLocalizations l10n, AlertSeverity s) => switch (s) {
  AlertSeverity.info => l10n.alertsSeverityInfo,
  AlertSeverity.warning => l10n.alertsSeverityWarning,
  AlertSeverity.severe => l10n.alertsSeveritySevere,
  AlertSeverity.unknown => l10n.alertsSeverityUnknown,
};

IconData _severityIcon(AlertSeverity s) => switch (s) {
  AlertSeverity.info => Icons.info_outline,
  AlertSeverity.warning => Icons.warning_amber_outlined,
  AlertSeverity.severe => Icons.error_outline,
  AlertSeverity.unknown => Icons.notifications_outlined,
};

/// The severity icon's colour: 3:1 on the surface at least, because a host
/// theme's `tertiary` may be a light accent (gold on white is 1.5:1).
Color _severityColor(BuildContext context, AlertSeverity s) {
  final scheme = Theme.of(context).colorScheme;
  final colour = switch (s) {
    AlertSeverity.severe => scheme.error,
    AlertSeverity.warning => scheme.tertiary,
    _ => scheme.onSurfaceVariant,
  };
  return ObaContrast.ensureReadable(colour, scheme.surface, minRatio: 3);
}

/// The summary, or "Service alert" when it has none.
String _title(ObaLocalizations l10n, Situation a) {
  final t = a.title?.trim();
  return t == null || t.isEmpty ? l10n.alertsNoTitle : t;
}

/// One alert as a row: severity icon and text, summary, unread marker.
class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.alert, required this.unread, this.onTap});

  final Situation alert;
  final bool unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final severity = alert.alertSeverity;
    final severityText = _severityLabel(l10n, severity);
    final title = _title(l10n, alert);
    return ObaListRow(
      leading: Icon(
        _severityIcon(severity),
        color: _severityColor(context, severity),
      ),
      title: title,
      subtitle: [if (unread) l10n.alertsUnread, severityText].join(' · '),
      semanticLabel: l10n.alertsRowLabel(
        unread ? l10n.alertsUnreadPrefix : '',
        severityText,
        title,
      ),
      trailing: unread
          ? ExcludeSemantics(
              child: Icon(
                Icons.circle,
                size: 12,
                color: theme.colorScheme.primary,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}

/// Service alerts for a stop or route, or the region-wide ones when neither
/// is given, most severe then newest first, with unread markers and "Mark
/// all as read". See [AlertsLoader] for where the alerts come from.
class AlertsListPage extends StatefulWidget {
  const AlertsListPage({super.key, this.stopId, this.routeId});

  final String? stopId;
  final String? routeId;

  @override
  State<AlertsListPage> createState() => _AlertsListPageState();
}

class _AlertsListPageState extends State<AlertsListPage> {
  AlertsLoader? _loader;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loader == null) {
      _loader = AlertsLoader(
        ObaScope.of(context),
        stopId: widget.stopId,
        routeId: widget.routeId,
      );
      _loader!.load();
    }
  }

  @override
  void didUpdateWidget(AlertsListPage old) {
    super.didUpdateWidget(old);
    if (old.stopId != widget.stopId || old.routeId != widget.routeId) {
      _loader?.dispose();
      _loader = AlertsLoader(
        ObaScope.of(context),
        stopId: widget.stopId,
        routeId: widget.routeId,
      )..load();
    }
  }

  @override
  void dispose() {
    _loader?.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    await _loader!.load();
    if (mounted) obaAnnounce(context, context.obaL10n.dataUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final app = ObaScope.of(context);
    final loader = _loader!;
    return ListenableBuilder(
      listenable: Listenable.merge([loader, app.core.userData.listenable]),
      builder: (context, _) {
        final tracker = app.core.alerts;
        final alerts = loader.alerts;
        final unread = tracker.unreadCount(alerts);
        final markAll = unread == 0
            ? null
            : () {
                tracker.markAllRead(alerts);
                obaAnnounce(context, l10n.alertsAllRead);
              };
        final refresh = IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.commonRetry,
          onPressed: _reload,
        );
        final markButton = IconButton(
          icon: const Icon(Icons.done_all),
          tooltip: l10n.alertsMarkAllRead,
          onPressed: markAll,
        );
        return ObaSheetPage(
          title: l10n.titleAlerts,
          actions: [markButton, refresh],
          slivers: [
            if (loader.isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: ObaLoadingState(),
              )
            else if (loader.error != null && alerts.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ObaErrorState(error: loader.error, onRetry: _reload),
              )
            else if (alerts.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ObaEmptyState(
                  icon: Icons.notifications_none,
                  title: l10n.alertsEmptyTitle,
                  message: loader.isRegionWide
                      ? '${l10n.alertsEmptyBody} ${l10n.alertsRegionNote}'
                      : l10n.alertsEmptyBody,
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 4),
                    child: Text(
                      l10n.alertsUnreadCount(unread),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: alerts.length,
                itemBuilder: (context, i) => _AlertRow(
                  alert: alerts[i],
                  unread: tracker.isUnread(alerts[i]),
                  onTap: () =>
                      ObaNavigator.of(context)
                          .push<void>(AlertDetailRoute(alerts[i])),
                ),
              ),
              if (loader.isRegionWide)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      12,
                      16,
                      0,
                    ),
                    child: Text(
                      l10n.alertsRegionNote,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

/// One alert: summary, severity (icon and text), description, active period,
/// affected routes and stops (tappable) and a link opened outside the app.
/// Opening it marks the alert read.
class AlertDetailPage extends StatefulWidget {
  const AlertDetailPage({super.key, required this.route, this.urlOpener});

  final AlertDetailRoute route;

  /// Overrides the [ObaLinkOpenerScope] opener for this page.
  final ObaUrlOpener? urlOpener;

  @override
  State<AlertDetailPage> createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ObaScope.of(context).core.alerts.markRead(widget.route.situation);
    });
  }

  Future<void> _open(Uri uri) =>
      obaOpenLink(context, uri, opener: widget.urlOpener);

  String _dateTime(BuildContext context, DateTime t) {
    final date = MaterialLocalizations.of(context)
        .formatMediumDate(t.toLocal());
    return '$date ${obaClockTime(context, t)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final alert = widget.route.situation;
    final severity = alert.alertSeverity;
    final description = alert.description?.value.trim();
    final link = alert.link;
    final routes = affectedRouteIds(alert);
    final stops = affectedStopIds(alert);
    final navigator = ObaNavigator.of(context);
    final created = alert.creationTime;
    final windows = alert.activeWindows;
    return ObaSheetPage(
      title: l10n.titleAlertDetail,
      body: ListView(
        primary: true,
        padding: const EdgeInsets.all(16),
        children: [
          ObaHeading(_title(l10n, alert), style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _severityIcon(severity),
                color: _severityColor(context, severity),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _severityLabel(l10n, severity),
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          if (created != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.alertsDetailUpdated(_dateTime(context, created)),
                style: theme.textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            description == null || description.isEmpty
                ? l10n.alertsDetailNoDetails
                : description,
            style: theme.textTheme.bodyLarge,
          ),
          if (windows.isNotEmpty) ...[
            _heading(context, l10n.alertsDetailActive),
            for (final w in windows)
              Text(
                w.to == null
                    ? l10n.alertsDetailFrom(_dateTime(context, w.from))
                    : l10n.alertsDetailRange(
                        _dateTime(context, w.from),
                        _dateTime(context, w.to!),
                      ),
                style: theme.textTheme.bodyMedium,
              ),
          ],
          if (routes.isNotEmpty || stops.isNotEmpty) ...[
            _heading(context, l10n.alertsDetailAffects),
            if (routes.isNotEmpty) ...[
              Text(l10n.alertsDetailRoutes, style: theme.textTheme.labelLarge),
              Wrap(
                spacing: 8,
                children: [
                  for (final r in routes)
                    ActionChip(
                      label: Text(agencyLocalId(r)),
                      tooltip: l10n.bookmarksDepartureRouteOnly(
                        agencyLocalId(r),
                      ),
                      onPressed: () => navigator.push<void>(RouteStopsRoute(r)),
                    ),
                ],
              ),
            ],
            if (stops.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l10n.alertsDetailStops, style: theme.textTheme.labelLarge),
              Wrap(
                spacing: 8,
                children: [
                  for (final s in stops)
                    ActionChip(
                      label: Text(agencyLocalId(s)),
                      tooltip: l10n.stopCode(agencyLocalId(s)),
                      onPressed: () => navigator.push<void>(StopRoute(s)),
                    ),
                ],
              ),
            ],
          ],
          if (link != null && isWebUri(link)) ...[
            const SizedBox(height: 24),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.alertsDetailLearnMore),
                onPressed: () => _open(link),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _heading(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 4),
    child: ObaHeading(text),
  );
}

/// High-priority unread alerts for the region, on the Home tab and in host
/// feeds: the worst two, a "more" count, and "See all". Renders nothing when
/// there is nothing to say (and while loading).
class ServiceAlertsSection extends StatefulWidget {
  const ServiceAlertsSection({super.key, this.limit = 2});

  final int limit;

  @override
  State<ServiceAlertsSection> createState() => _ServiceAlertsSectionState();
}

class _ServiceAlertsSectionState extends State<ServiceAlertsSection>
    with ObaVisibilityAware<ServiceAlertsSection> {
  static const _staleAfter = Duration(minutes: 5);
  AlertsLoader? _loader;

  @override
  void didChangeDependencies() {
    _loader ??= AlertsLoader(ObaScope.of(context));
    super.didChangeDependencies();
  }

  @override
  void onVisibilityChanged(bool visible) {
    final loader = _loader;
    if (!visible || loader == null) return;
    final at = loader.loadedAt;
    if (at == null || clock.now().difference(at) > _staleAfter) loader.load();
  }

  @override
  void dispose() {
    _loader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context);
    final loader = _loader!;
    final l10n = context.obaL10n;
    return ListenableBuilder(
      listenable: Listenable.merge([loader, app.core.userData.listenable]),
      builder: (context, _) {
        final urgent = app.core.alerts.alertsToInterruptWith(
          loader.alerts,
          now: clock.now(),
        );
        if (urgent.isEmpty) return const SizedBox.shrink();
        final shown = urgent.take(widget.limit).toList();
        final more = urgent.length - shown.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ObaSectionHeader(
              title: l10n.homeSectionAlerts,
              actionLabel: l10n.commonSeeAll,
              onAction: () =>
                  ObaNavigator.of(context).push<void>(const AlertsListRoute()),
            ),
            for (final a in shown)
              _AlertRow(
                alert: a,
                unread: true,
                onTap: () =>
                    ObaNavigator.of(context).push<void>(AlertDetailRoute(a)),
              ),
            if (more > 0)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                child: Text(
                  l10n.alertsSectionMore(more),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        );
      },
    );
  }
}
