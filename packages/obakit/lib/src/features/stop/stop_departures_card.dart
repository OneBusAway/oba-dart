import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/polling.dart';
import '../../app/application.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/rows.dart';
import '../../widgets/states.dart';
import 'departure_row.dart';
import 'stop_actions.dart';
import 'stop_arrivals_controller.dart';

/// The next few departures at one stop, for a host's feed: a non-scrolling
/// card (no fixed height) with the stop name, up to [maxArrivals] upcoming
/// departures, and a link to the full stop page. It honours the rider's
/// departure-type filter and the stop's hidden routes, polls every 30 s
/// while visible, and navigates through `ObaNavigator` (so a host's
/// `ObaScope.onNavigate` can take over).
///
/// Unlike `oba_arrivals`' `ObaArrivalsPanel` (which needs its own client
/// and knows nothing of the SDK), this card needs only an `ObaScope`.
class ObaStopDeparturesCard extends StatefulWidget {
  const ObaStopDeparturesCard({
    super.key,
    required this.stopId,
    this.maxArrivals = 3,
    this.title,
    this.controller,
  });

  final String stopId;
  final int maxArrivals;

  /// Replaces the stop name in the header. The stop name then shows under
  /// it, unless it is the same text.
  final String? title;

  /// Share a controller with a `StopPage` pushed from the card.
  final StopArrivalsController? controller;

  @override
  State<ObaStopDeparturesCard> createState() => _ObaStopDeparturesCardState();
}

class _ObaStopDeparturesCardState extends State<ObaStopDeparturesCard> {
  StopArrivalsController? _owned;
  late StopArrivalsController _controller;
  ObaApplication? _app;

  /// What the card rebuilds for; created once per controller/application.
  Listenable? _listenable;
  ObaCoreApplication? _listenableCore;

  @override
  void initState() {
    super.initState();
    _controller = _resolve();
  }

  StopArrivalsController _resolve() =>
      widget.controller ??
      (_owned = StopArrivalsController(
        stopId: widget.stopId,
        client: () => _app?.core.restClient,
        autoExtend: false,
      ));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _app = ObaScope.of(context);
  }

  @override
  void didUpdateWidget(ObaStopDeparturesCard old) {
    super.didUpdateWidget(old);
    if (old.stopId != widget.stopId || old.controller != widget.controller) {
      _owned?.dispose();
      _owned = null;
      _controller = _resolve();
      _listenable = null;
    }
  }

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final core = ObaScope.of(context).core;
    if (!identical(core, _listenableCore)) {
      _listenableCore = core;
      _listenable = null;
    }
    return ObaPollingHolder(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _listenable ??= Listenable.merge([
          _controller,
          ObaListenableAdapter(core.settings),
          ObaListenableAdapter(core.userData),
        ]),
        builder: (context, _) => _build(context, core),
      ),
    );
  }

  Widget _build(BuildContext context, ObaCoreApplication core) {
    final l10n = context.obaL10n;
    final s = _controller.state;
    final now = _controller.now();
    final region = core.currentRegion;
    final prefs = region == null
        ? const StopPreferences()
        : core.userData.stopPreferences(region.id, widget.stopId);
    final d = StopDepartures.build(
      s.rawArrivals,
      references: s.references,
      now: now,
      preferences: prefs,
      filter: core.settings.arrivalDepartureFilter,
    );
    final stopName = s.stop?.name;
    final title = widget.title ?? stopName ?? l10n.titleStop;
    final subtitle =
        widget.title != null && stopName != null && stopName != widget.title
        ? stopName
        : null;
    final nav = ObaNavigator.of(context);
    final Widget body;
    if (!s.hasData) {
      body = s.status == StopArrivalsStatus.error
          ? ObaErrorState(error: s.error, onRetry: _controller.refresh)
          : const ObaLoadingState();
    } else if (d.upcoming.isEmpty) {
      body = Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
        child: Text(l10n.stopCardEmpty),
      );
    } else {
      final alarms = core.alarms.lookup();
      body = Column(
        children: [
          for (final a in d.upcoming.take(widget.maxArrivals))
            if (alarms.alarmFor(a) != null case final hasAlarm)
              ObaDepartureRow(
                arrival: a,
                now: now,
                references: s.references,
                hasAlarm: hasAlarm,
                onTap: () => nav.push(TripRoute(TripRef.fromArrival(a))),
                actions: departureActions(
                  context,
                  a,
                  now: now,
                  stop: s.stop,
                  hasAlarm: hasAlarm,
                ),
              ),
        ],
      );
    }
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ObaSectionHeader(
            title: title,
            actionLabel: l10n.commonSeeAll,
            onAction: () => nav.push(StopRoute(widget.stopId, name: stopName)),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 4),
              child: Text(
                obaBidiIsolate(context, subtitle),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          if (s.isStale)
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  l10n.stopPageStaleBody,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          body,
        ],
      ),
    );
  }
}
