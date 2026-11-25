import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../widgets/rows.dart';
import 'bookmark_actions.dart';
import 'departure_line.dart';
import 'departures_loader.dart';

/// A bookmark with its live next departures: stop name (or the bookmark's
/// own name), what it saves, and up to [maxDepartures] departures with
/// loading, empty and error states of its own.
///
/// A stop bookmark lists the stop's next departures; a trip bookmark lists
/// the next ones matching its route and headsign. Tapping the header opens
/// the stop; tapping a departure of a trip bookmark opens its trip.
class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.bookmark,
    required this.departures,
    required this.now,
    this.maxDepartures = 3,
    this.onRetry,
    this.allowDelete = true,
    this.boxed = true,
  });

  /// Draws its own card. False inside a container that already is one
  /// (`ObaBookmarksCard`), where bookmarks are separated by dividers.
  final bool boxed;

  final Bookmark bookmark;
  final BookmarkStopDepartures departures;
  final DateTime now;
  final int maxDepartures;
  final VoidCallback? onRetry;
  final bool allowDelete;

  List<ArrivalAndDeparture> _matching() {
    final key = bookmark.tripKey;
    final all = key == null
        ? departures.arrivals
        : arrivalsMatchingTripKey(
            departures.arrivals,
            key,
            references: departures.references,
          );
    return upcomingArrivals(all, now).take(maxDepartures).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final stop = bookmark.stop;
    final details = _details(l10n);
    final nameText = bookmark.name;
    final type = prioritizedRouteType(stop.routes.map((r) => r.routeType));
    final navigator = ObaNavigator.of(context);
    final header = MergeSemantics(
      child: Semantics(
        customSemanticsActions: BookmarkActions.semanticActions(
          context,
          bookmark,
          allowDelete: allowDelete,
        ),
        child: ListTile(
          leading: ExcludeSemantics(child: ObaRouteTypeIcon(type)),
          title: Row(
            children: [
              Flexible(child: Text(nameText)),
              if (bookmark.isPinned) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.push_pin,
                  size: 16,
                  semanticLabel: l10n.bookmarksPinned,
                ),
              ],
            ],
          ),
          titleTextStyle: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          subtitle: details == null ? null : Text(details),
          minTileHeight: 48,
          contentPadding: const EdgeInsetsDirectional.only(start: 16, end: 0),
          onTap: () => navigator.push<void>(StopRoute(stop.id)),
        ),
      ),
    );
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: header),
            BookmarkMenuButton(bookmark: bookmark, allowDelete: allowDelete),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
          child: _body(context),
        ),
      ],
    );
    if (!boxed) return content;
    return Card(
      margin: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }

  String? _details(ObaLocalizations l10n) {
    final stop = bookmark.stop;
    if (bookmark.isTripBookmark) {
      final headsign = bookmark.tripHeadsign ?? '';
      final route = headsign.isEmpty
          ? l10n.bookmarksDepartureRouteOnly(bookmark.routeShortName ?? '')
          : l10n.bookmarksDepartureRoute(
              bookmark.routeShortName ?? '',
              headsign,
            );
      return [route, stop.name].join(' · ');
    }
    final parts = [
      if (stop.name != bookmark.name) stop.name,
      if (stop.code != null && stop.code!.isNotEmpty) l10n.stopCode(stop.code!),
      ?stopDirectionLabel(l10n, stop.compassDirection),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  Widget _body(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    if (departures.isLoading) {
      return Semantics(
        liveRegion: true,
        label: l10n.bookmarksLoadingDepartures,
        child: ExcludeSemantics(
          child: Row(
            children: [
              const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.bookmarksLoadingDepartures,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (departures.hasError) {
      return Semantics(
        liveRegion: true,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Icon(
              Icons.error_outline,
              size: 20,
              color: theme.colorScheme.error,
              semanticLabel: l10n.commonErrorTitle,
            ),
            Text(
              l10n.bookmarksDeparturesError,
              style: theme.textTheme.bodyMedium,
            ),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ),
      );
    }
    final matches = _matching();
    final stopId = bookmark.stopId;
    final navigator = ObaNavigator.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (matches.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.bookmarksNoDepartures,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (final a in matches)
            DepartureLine(
              key: ValueKey(
                '${a.tripId}-${a.serviceDate.millisecondsSinceEpoch}',
              ),
              arrival: a,
              now: now,
              route: departures.references?.route(a.routeId),
              onTap: () => bookmark.isTripBookmark
                  ? navigator.push<void>(TripRoute(TripRef.fromArrival(a)))
                  : navigator.push<void>(StopRoute(stopId)),
            ),
        if (departures.isStale)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.bookmarksDeparturesStale,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
