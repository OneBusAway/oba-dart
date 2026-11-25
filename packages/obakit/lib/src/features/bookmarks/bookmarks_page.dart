import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/location_holder.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../navigation/presentation.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/feed_card.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'bookmark_card.dart';
import 'bookmarks_model.dart';
import 'visibility.dart';

/// The key under which the list's sort mode is stored (`true`: by group).
const String bookmarksSortByGroupKey = 'oba.bookmarks.sortByGroup';

/// All bookmarks of the current region: grouped (ungrouped first) or sorted
/// by distance from the user, pinned first, each with live departures.
///
/// Departures refresh every 30 seconds while the list is visible. In the
/// sheet and as a page the sort, refresh and edit buttons sit in the
/// header; embedded (the Home sheet's Bookmarks tab) they sit in a row at
/// the top.
class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage>
    with ObaVisibilityAware<BookmarksPage> {
  BookmarksModel? _model;
  bool _sortByGroup = true;
  final Set<String> _collapsed = {};

  @override
  void didChangeDependencies() {
    if (_model == null) {
      final app = ObaScope.of(context);
      _sortByGroup = app.core.store.readBool(bookmarksSortByGroupKey) ?? true;
      _model = BookmarksModel(app);
    }
    super.didChangeDependencies();
  }

  @override
  void onVisibilityChanged(bool visible) => _model?.setActive(visible);

  @override
  void dispose() {
    _model?.dispose();
    super.dispose();
  }

  void _setSortByGroup(bool value) {
    if (value == _sortByGroup) return;
    ObaScope.of(context).core.store.writeJson(bookmarksSortByGroupKey, value);
    setState(() => _sortByGroup = value);
  }

  Future<void> _refresh() async {
    final model = _model!;
    await model.refresh();
    if (mounted) obaAnnounce(context, context.obaL10n.bookmarksUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final model = _model!;
    final l10n = context.obaL10n;
    final navigator = ObaNavigator.of(context);
    final embedded = ObaPresentation.of(context) == ObaPresentation.embedded;
    final sortButton = PopupMenuButton<bool>(
      tooltip: l10n.bookmarksSortTooltip,
      icon: const Icon(Icons.sort),
      onSelected: _setSortByGroup,
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          value: true,
          checked: _sortByGroup,
          child: Text(l10n.bookmarksSortByGroup),
        ),
        CheckedPopupMenuItem(
          value: false,
          checked: !_sortByGroup,
          child: Text(l10n.bookmarksSortByDistance),
        ),
      ],
    );
    final refreshButton = IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: l10n.bookmarksRefreshTooltip,
      onPressed: _refresh,
    );
    final manageButton = IconButton(
      icon: const Icon(Icons.edit_outlined),
      tooltip: l10n.bookmarksManageTooltip,
      onPressed: () => navigator.push<void>(const ManageBookmarksRoute()),
    );
    // Sorting by distance follows the rider while the page is visible.
    return ObaLocationHolder(
      enabled: !_sortByGroup,
      child: ListenableBuilder(
        listenable: Listenable.merge([
          model,
          ObaScope.of(context).core.locationListenable.valueListenable,
        ]),
        builder: (context, _) {
          final app = ObaScope.of(context);
          final sections = _sortByGroup
              ? sectionBookmarksByGroup(model.bookmarks, model.groups)
              : sectionBookmarksByDistance(
                  model.bookmarks,
                  app.core.currentLocation?.coordinate,
                );
          return ObaSheetPage(
            title: l10n.titleBookmarks,
            actions: [sortButton, refreshButton, manageButton],
            slivers: [
              if (embedded)
                SliverToBoxAdapter(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: [sortButton, refreshButton, manageButton],
                  ),
                ),
              if (sections.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ObaEmptyState(
                    icon: Icons.bookmark_outline,
                    title: l10n.bookmarksEmptyTitle,
                    message: l10n.bookmarksEmptyBody,
                    action: FilledButton.tonal(
                      onPressed: navigator.popToRoot,
                      child: Text(l10n.bookmarksFindStops),
                    ),
                  ),
                )
              else
                SliverList.list(
                  children: [
                    for (final section in sections)
                      ..._section(context, section, sections.length),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _section(
    BuildContext context,
    BookmarkListSection section,
    int sectionCount,
  ) {
    final l10n = context.obaL10n;
    final model = _model!;
    final title =
        section.group?.name ??
        (section.isUngrouped && sectionCount > 1
            ? l10n.bookmarksUngrouped
            : null);
    final collapsed = _collapsed.contains(section.id);
    return [
      if (title != null)
        _GroupHeader(
          title: title,
          collapsed: collapsed,
          onToggle: () => setState(() {
            if (!_collapsed.remove(section.id)) _collapsed.add(section.id);
          }),
        ),
      if (!collapsed)
        for (final b in section.bookmarks)
          BookmarkCard(
            key: ValueKey('bookmark-${b.id}'),
            bookmark: b,
            departures: model.loader.stateFor(b.stopId),
            now: model.loader.now(),
            onRetry: model.refresh,
          ),
    ];
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.title,
    required this.collapsed,
    required this.onToggle,
  });

  final String title;
  final bool collapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return MergeSemantics(
      child: Semantics(
        container: true,
        header: true,
        value: collapsed
            ? l10n.bookmarksGroupCollapsed
            : l10n.bookmarksGroupExpanded,
        onTapHint: l10n.bookmarksGroupToggleHint,
        child: ListTile(
          title: Text(title),
          titleTextStyle: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          trailing: ExcludeSemantics(
            child: Icon(collapsed ? Icons.expand_more : Icons.expand_less),
          ),
          minTileHeight: 48,
          onTap: onToggle,
        ),
      ),
    );
  }
}

/// The pinned bookmarks and the newest few ([limit]), each with live
/// departures, and a "See all" link, in a `Card` for a host's home feed.
/// Same container as `ObaNearbyStopsCard`: the host's `CardTheme` styles
/// it, its title is a heading, and the bookmarks inside are separated by
/// dividers rather than drawn as cards of their own. Needs only an
/// `ObaScope`; fetches only while visible.
///
/// The full app's Home tab uses the same list unboxed
/// ([BookmarksSection]).
class ObaBookmarksCard extends StatelessWidget {
  const ObaBookmarksCard({
    super.key,
    this.limit = 3,
    this.title,
    this.showSeeAll = true,
    this.margin,
  });

  /// How many bookmarks to show (pinned ones always show).
  final int limit;

  /// Overrides the header text.
  final String? title;
  final bool showSeeAll;

  /// Overrides `CardTheme.margin`.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => ObaFeedCard(
    margin: margin,
    child: _BookmarksList(
      limit: limit,
      title: title,
      showSeeAll: showSeeAll,
      inCard: true,
    ),
  );
}

/// The Home tab's Bookmarks section: the same list as [ObaBookmarksCard],
/// without the outer card (each bookmark is its own card).
class BookmarksSection extends StatelessWidget {
  const BookmarksSection({super.key});

  @override
  Widget build(BuildContext context) =>
      const _BookmarksList(limit: 3, showSeeAll: true, inCard: false);
}

class _BookmarksList extends StatefulWidget {
  const _BookmarksList({
    required this.limit,
    this.title,
    required this.showSeeAll,
    required this.inCard,
  });

  final int limit;
  final String? title;
  final bool showSeeAll;
  final bool inCard;

  @override
  State<_BookmarksList> createState() => _BookmarksListState();
}

class _BookmarksListState extends State<_BookmarksList>
    with ObaVisibilityAware<_BookmarksList> {
  BookmarksModel? _model;

  @override
  void didChangeDependencies() {
    _model ??= BookmarksModel(ObaScope.of(context), limit: widget.limit);
    super.didChangeDependencies();
  }

  @override
  void onVisibilityChanged(bool visible) => _model?.setActive(visible);

  @override
  void dispose() {
    _model?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final model = _model!;
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: model,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ObaSectionHeader(
            title: widget.title ?? l10n.homeSectionBookmarks,
            actionLabel: widget.showSeeAll && model.bookmarks.isNotEmpty
                ? l10n.commonSeeAll
                : null,
            onAction: widget.showSeeAll && model.bookmarks.isNotEmpty
                ? () =>
                      ObaNavigator.of(context)
                          .push<void>(const BookmarksRoute())
                : null,
          ),
          if (model.bookmarks.isEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Text(
                l10n.bookmarksSectionEmpty,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            for (final (i, b) in model.bookmarks.indexed) ...[
              if (widget.inCard && i > 0)
                const Divider(height: 1, indent: 16, endIndent: 16),
              BookmarkCard(
                key: ValueKey('home-bookmark-${b.id}'),
                bookmark: b,
                departures: model.loader.stateFor(b.stopId),
                now: model.loader.now(),
                onRetry: model.refresh,
                allowDelete: false,
                boxed: !widget.inCard,
              ),
            ],
        ],
      ),
    );
  }
}
