import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/text_scale.dart';
import '../../widgets/heading.dart';
import '../../l10n/l10n.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/rows.dart';
import '../../widgets/departure_format.dart';

/// An action offered for a departure (overflow menu, long press, and a
/// screen-reader custom action).
@immutable
class ObaDepartureAction {
  const ObaDepartureAction({
    required this.label,
    required this.icon,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final VoidCallback onSelected;
}

/// How a departure row is drawn.
enum ObaDepartureRowStyle {
  normal,

  /// Upcoming, but sooner than the walk to the stop.
  missed,

  /// Already gone.
  past,
}

/// Shows [actions] in a bottom sheet titled [title]. Returns when closed.
Future<void> showObaActionSheet(
  BuildContext context, {
  required String title,
  required List<ObaDepartureAction> actions,
}) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  useSafeArea: true,
  isScrollControlled: true,
  builder: (sheetContext) => SafeArea(
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 8),
            child: ObaHeading(title),
          ),
          for (final a in actions)
            ListTile(
              leading: ExcludeSemantics(child: Icon(a.icon)),
              title: Text(a.label),
              minTileHeight: 48,
              onTap: () {
                Navigator.of(sheetContext).pop();
                a.onSelected();
              },
            ),
        ],
      ),
    ),
  ),
);

/// One departure: route badge, headsign, clock time, schedule status (icon
/// and text), real-time indicator, occupancy, and the countdown. Reads as
/// one sentence; tapping runs [onTap]; [actions] appear in an overflow
/// button, on long press, and as screen-reader custom actions.
///
/// A long list can pass [actionsBuilder] instead of [actions]: the actions
/// are then built only when needed (the overflow sheet opens, or a screen
/// reader is on and needs their labels as custom actions).
///
/// Embeddable: needs only a `Theme` and the SDK localizations.
class ObaDepartureRow extends StatelessWidget {
  const ObaDepartureRow({
    super.key,
    required this.arrival,
    required this.now,
    this.references = References.empty,
    this.onTap,
    this.actions = const [],
    this.actionsBuilder,
    this.style = ObaDepartureRowStyle.normal,
    this.isTransfer = false,
    this.hasAlarm = false,
  });

  final ArrivalAndDeparture arrival;

  /// Server-corrected current time.
  final DateTime now;

  /// Resolves the route (colour, short name).
  final References references;
  final VoidCallback? onTap;
  final List<ObaDepartureAction> actions;

  /// Builds the row's actions on demand; when set it replaces [actions] and
  /// must return a non-empty list.
  final List<ObaDepartureAction> Function()? actionsBuilder;
  final ObaDepartureRowStyle style;

  /// Highlights the rider's transfer trip.
  final bool isTransfer;
  final bool hasAlarm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final oba = ObaTheme.of(context);
    final route = references.route(arrival.routeId);
    final routeName = routeLabel(arrival, route);
    final headsign = arrival.tripHeadsign ?? route?.longName ?? routeName;
    final status = DepartureStatusInfo.of(context, arrival);
    final minutes = arrival.minutesUntil(now) ?? 0;
    final time = arrival.bestDate;
    final clock = time == null ? '' : obaClockTime(context, time);
    final occupancy = status.isRealTime
        ? occupancyLabel(l10n, arrival.occupancyStatus)
        : null;
    final past = style == ObaDepartureRowStyle.past;
    final muted = scheme.onSurfaceVariant;
    final large = obaIsLargeText(context);

    final badge = ObaRouteBadge(
      label: routeName,
      color: route?.color,
      textColor: route?.textColor,
    );
    final headsignText = Text(
      obaBidiIsolate(context, headsign),
      style: theme.textTheme.titleMedium?.copyWith(color: past ? muted : null),
    );
    final details = Wrap(
      spacing: 8,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (clock.isNotEmpty)
          Text(
            clock,
            style: theme.textTheme.bodyMedium?.copyWith(color: muted),
          ),
        _IconText(
          icon: status.icon,
          text: status.label,
          color: past ? muted : status.color,
          bold: true,
        ),
        if (occupancy != null)
          _IconText(icon: Icons.people_outline, text: occupancy, color: muted),
      ],
    );
    final countdown = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // One Text.rich, not a Row: in the stacked (200%) layout a long
        // countdown ("21 мин.") wraps instead of overflowing, and in the
        // one-line layout it needs no bounded width.
        Text.rich(
          TextSpan(
            children: [
              if (status.isRealTime && !past)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 4),
                    child: Icon(obaRealTimeIcon, size: 16, color: status.color),
                  ),
                ),
              TextSpan(text: countdownText(l10n, minutes)),
            ],
          ),
          textAlign: TextAlign.end,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: past
                ? muted
                : (status.isRealTime ? status.color : scheme.onSurface),
          ),
        ),
        if (hasAlarm)
          Icon(Icons.notifications_active, size: 18, color: oba.brand),
      ],
    );

    final content = large
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [badge, countdown],
              ),
              const SizedBox(height: 4),
              headsignText,
              details,
            ],
          )
        : Row(
            children: [
              badge,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [headsignText, const SizedBox(height: 2), details],
                ),
              ),
              const SizedBox(width: 8),
              countdown,
            ],
          );

    final sentence = [
      l10n.stopRowA11yLabel(
        routeName,
        headsign,
        etaA11y(l10n, arrival, minutes),
        clock,
        status.a11y,
      ),
      ?occupancy,
      if (isTransfer) l10n.stopRowA11yTransfer,
      if (style == ObaDepartureRowStyle.missed) l10n.stopRowA11yMissed,
      if (hasAlarm) l10n.stopRowA11yAlarm,
    ].join(', ');

    final actionsTitle = l10n.stopRowActions(routeName);
    final builder = actionsBuilder;
    final hasActions = builder != null || actions.isNotEmpty;
    void openActions() => showObaActionSheet(
      context,
      title: actionsTitle,
      actions: builder?.call() ?? actions,
    );

    final inkWell = InkWell(
      onTap: onTap,
      onLongPress: hasActions ? openActions : null,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 8, 10),
        child: content,
      ),
    );
    Widget semantics(List<ObaDepartureAction> semanticActions) => Semantics(
      label: sentence,
      button: onTap != null,
      // excludeSemantics drops the InkWell's actions: carry them here.
      onTap: onTap,
      onLongPress: hasActions ? openActions : null,
      excludeSemantics: true,
      customSemanticsActions: {
        for (final a in semanticActions)
          CustomSemanticsAction(label: a.label): a.onSelected,
      },
      child: inkWell,
    );

    final Widget main = builder == null
        ? semantics(actions)
        // Built lazily: only a screen reader needs the labels up front.
        : _WhenSemanticsEnabled(
            builder: (enabled) =>
                semantics(enabled ? builder() : const <ObaDepartureAction>[]),
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isTransfer ? oba.brand.withValues(alpha: 0.08) : null,
        border: isTransfer
            ? BorderDirectional(start: BorderSide(color: oba.brand, width: 4))
            : null,
      ),
      child: Row(
        children: [
          Expanded(child: main),
          if (hasActions)
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: actionsTitle,
              onPressed: openActions,
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({
    required this.icon,
    required this.text,
    required this.color,
    this.bold = false,
  });

  final IconData icon;
  final String text;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: color, fontWeight: bold ? FontWeight.w600 : null);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Flexible(child: Text(text, style: style)),
      ],
    );
  }
}

/// Rebuilds when the platform turns semantics (a screen reader, switch
/// access) on or off, passing whether it is on now.
class _WhenSemanticsEnabled extends StatefulWidget {
  const _WhenSemanticsEnabled({required this.builder});

  final Widget Function(bool enabled) builder;

  @override
  State<_WhenSemanticsEnabled> createState() => _WhenSemanticsEnabledState();
}

class _WhenSemanticsEnabledState extends State<_WhenSemanticsEnabled> {
  @override
  void initState() {
    super.initState();
    SemanticsBinding.instance.addSemanticsEnabledListener(_changed);
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    SemanticsBinding.instance.removeSemanticsEnabledListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(SemanticsBinding.instance.semanticsEnabled);
}
