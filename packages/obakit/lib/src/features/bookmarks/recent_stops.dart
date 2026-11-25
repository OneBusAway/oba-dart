import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../navigation/presentation.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';

/// The stops viewed recently in the current region, newest first.
List<StoredStop> _recentStops(BuildContext context) {
  final core = ObaScope.of(context).core;
  return core.userData.recentStopsInRegion(core.currentRegion?.id);
}

Listenable _recentSources(BuildContext context) {
  final core = ObaScope.of(context).core;
  return Listenable.merge([
    core.userData.listenable,
    core.regions.currentRegionListenable.listenable,
  ]);
}

/// A recent stop as a row (for lists here and in the section).
class _RecentStopRow extends StatelessWidget {
  const _RecentStopRow({required this.stop, this.onRemove});

  final StoredStop stop;

  /// When set, the row shows a remove button and offers it to screen readers
  /// as a custom action.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final remove = onRemove;
    final row = ObaStopRow(
      stop: stop.toStop(),
      routes: [for (final r in stop.routes) r.toRoute()],
      trailing: remove == null
          ? null
          : IconButton(
              icon: const Icon(Icons.close),
              tooltip: l10n.recentsRemove(stop.name),
              onPressed: remove,
            ),
    );
    if (remove == null) return row;
    return MergeSemantics(
      child: Semantics(
        customSemanticsActions: {
          CustomSemanticsAction(label: l10n.recentsRemove(stop.name)): remove,
        },
        child: Dismissible(
          key: ValueKey('recent-${stop.id}'),
          direction: DismissDirection.endToStart,
          background: ColoredBox(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
          onDismissed: (_) => remove(),
          child: row,
        ),
      ),
    );
  }
}

/// Recently viewed stops of the current region, newest first. Tap opens the
/// stop; each row has a remove button (also a screen-reader action) and can
/// be swiped away; "Clear all" asks first.
class RecentStopsPage extends StatelessWidget {
  const RecentStopsPage({super.key});

  Future<void> _clearAll(BuildContext context, int count) async {
    final l10n = context.obaL10n;
    final store = ObaScope.of(context).core.userData;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recentsClearTitle),
        content: Text(l10n.recentsClearBody(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.recentsClearAll),
          ),
        ],
      ),
    );
    if (confirmed == true) store.deleteAllRecentStops();
  }

  void _remove(BuildContext context, StoredStop stop) {
    final store = ObaScope.of(context).core.userData;
    final l10n = context.obaL10n;
    store.deleteRecentStop(stop.id);
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.recentsRemoved(stop.name))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final embedded = ObaPresentation.of(context) == ObaPresentation.embedded;
    return ListenableBuilder(
      listenable: _recentSources(context),
      builder: (context, _) {
        final stops = _recentStops(context);
        final clear = stops.isEmpty
            ? null
            : () => _clearAll(context, stops.length);
        return ObaSheetPage(
          title: l10n.titleRecentStops,
          actions: [
            if (clear != null)
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: l10n.recentsClearAll,
                onPressed: clear,
              ),
          ],
          slivers: [
            if (embedded && clear != null)
              SliverToBoxAdapter(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: clear,
                    child: Text(l10n.recentsClearAll),
                  ),
                ),
              ),
            if (stops.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ObaEmptyState(
                  icon: Icons.schedule,
                  title: l10n.recentsEmptyTitle,
                  message: l10n.recentsEmptyBody,
                  action: FilledButton.tonal(
                    onPressed: ObaNavigator.of(context).popToRoot,
                    child: Text(l10n.recentsFindStops),
                  ),
                ),
              )
            else
              SliverList.builder(
                itemCount: stops.length,
                itemBuilder: (context, i) => _RecentStopRow(
                  stop: stops[i],
                  onRemove: () => _remove(context, stops[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// The Home tab's recent stops: the newest few, with "See all". A plain
/// non-scrolling column.
class RecentStopsSection extends StatelessWidget {
  const RecentStopsSection({super.key, this.limit = 3});

  final int limit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: _recentSources(context),
      builder: (context, _) {
        final stops = _recentStops(context).take(limit).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ObaSectionHeader(
              title: l10n.homeSectionRecent,
              actionLabel: stops.isEmpty ? null : l10n.commonSeeAll,
              onAction: stops.isEmpty
                  ? null
                  : () =>
                        ObaNavigator.of(context)
                            .push<void>(const RecentStopsRoute()),
            ),
            if (stops.isEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                child: Text(
                  l10n.recentsSectionEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              for (final s in stops) _RecentStopRow(stop: s),
          ],
        );
      },
    );
  }
}
