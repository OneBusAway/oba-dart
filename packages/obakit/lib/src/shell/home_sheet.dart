import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../widgets/text_scale.dart';
import '../app/scope.dart';
import '../features/bookmarks/bookmarks_routes.dart';
import '../features/settings/settings_routes.dart';
import '../features/search/search_routes.dart';
import '../l10n/l10n.dart';
import '../navigation/home_sections.dart';
import '../navigation/oba_navigator.dart';
import '../navigation/oba_route.dart';
import '../navigation/presentation.dart';
import '../navigation/sheet_controller.dart';
import '../widgets/sheet_page.dart';

/// Every Home tab section, sorted.
List<ObaHomeSection> obaHomeSections() =>
    [...bookmarksHomeSections, ...searchHomeSections, ...settingsHomeSections]
      ..sort((a, b) => a.order.compareTo(b.order));

/// The home sheet: a search field over Home / Recent / Bookmarks tabs (iOS
/// `HomeSheetView` + `HomeTabs`). Home composes the feature sections;
/// Recent and Bookmarks show those features' full lists inline.
class ObaHomeSheet extends StatelessWidget {
  const ObaHomeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final scope = ObaPresentationScope.maybeOf(context);
    final sheet = scope?.sheet;
    Widget header = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ObaSearchFieldButton(),
          const SizedBox(height: 4),
          TabBar(
            // At large text the labels no longer fit a third of the width
            // each and would break mid-word: let the tabs size to their
            // labels and scroll instead.
            isScrollable: obaIsLargeText(context),
            tabAlignment: obaIsLargeText(context) ? TabAlignment.start : null,
            tabs: [
              _tab(Icons.home_outlined, l10n.homeTabHome),
              _tab(Icons.schedule, l10n.homeTabRecent),
              _tab(Icons.bookmark_outline, l10n.homeTabBookmarks),
            ],
          ),
        ],
      ),
    );
    if (sheet != null) {
      // At the largest text sizes on a small phone the search field and
      // tabs can be taller than the sheet: cap them at half of it and let
      // them scroll rather than overflow.
      header = ListenableBuilder(
        listenable: sheet,
        builder: (context, child) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: sheet.maxHeight > 0
                ? math.max(120.0, sheet.maxHeight * 0.5)
                : double.infinity,
          ),
          child: child,
        ),
        child: SingleChildScrollView(primary: false, child: header),
      );
    }
    if (sheet != null) {
      header = GestureDetector(
        behavior: HitTestBehavior.translucent,
        // Screen readers resize through the handle's actions instead.
        excludeFromSemantics: true,
        onVerticalDragUpdate: (d) => sheet.dragBy(-d.delta.dy),
        onVerticalDragEnd: (d) => sheet.settle(-(d.primaryVelocity ?? 0)),
        child: header,
      );
    }
    final report = scope?.onHeaderHeight;
    if (report != null) {
      header = ObaMeasureSize(onSize: (s) => report(s.height), child: header);
    }
    return DefaultTabController(
      length: 3,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            Expanded(
              child: _PauseWhenCollapsed(
                sheet: sheet,
                child: TabBarView(
                  children: [
                    const _HomeTab(),
                    ObaPresentationScope.embedded(
                      child: buildRecentStopsRoute(
                        context,
                        const RecentStopsRoute(),
                      ),
                    ),
                    ObaPresentationScope.embedded(
                      child: buildBookmarksRoute(
                        context,
                        const BookmarksRoute(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Not `Tab`, which has a fixed height: these grow with the text size.
  static Widget _tab(IconData icon, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(child: Icon(icon)),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, softWrap: true),
      ],
    ),
  );
}

/// Disables tickers below while the sheet is collapsed to its header, as
/// iOS does: the nearby and bookmark sections fetch and poll only while
/// visible (they follow `TickerMode`), so a collapsed sheet makes no
/// requests.
class _PauseWhenCollapsed extends StatelessWidget {
  const _PauseWhenCollapsed({required this.sheet, required this.child});

  final ObaSheetController? sheet;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sheet = this.sheet;
    if (sheet == null) return child;
    return ListenableBuilder(
      listenable: sheet,
      builder: (context, child) =>
          TickerMode(enabled: !sheet.isCollapsed, child: child!),
      child: child,
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final sections = obaHomeSections();
    final bottom = MediaQuery.paddingOf(context).bottom;
    return ListView.builder(
      primary: true,
      padding: EdgeInsets.only(bottom: bottom + 16),
      itemCount: sections.length,
      // Each section is its own node whose parts stay separate, so a
      // screen reader hears the heading before the section's text (an
      // empty-state sentence would otherwise merge into the section node
      // and be read first).
      itemBuilder: (context, i) => KeyedSubtree(
        key: ValueKey(sections[i].id),
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          child: sections[i].builder(context),
        ),
      ),
    );
  }
}

/// The search field on the home sheet. It is a button that opens the
/// search page (as on iOS), styled like a field.
class ObaSearchFieldButton extends StatelessWidget {
  const ObaSearchFieldButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      container: true,
      button: true,
      label: l10n.homeSearchLabel,
      hint: l10n.homeSearchPlaceholder,
      excludeSemantics: true,
      onTap: () => _open(context),
      child: Material(
        color: scheme.surfaceContainerHighest,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _open(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.search, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.homeSearchPlaceholder,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    ObaScope.maybeOf(context)?.core.analytics.reportEvent(
      pageUrl: 'app://localhost/home',
      label: AnalyticsLabels.searchSelected,
    );
    ObaNavigator.of(context).push(const SearchRoute());
  }
}
