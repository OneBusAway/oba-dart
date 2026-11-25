import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../l10n/l10n.dart';
import '../navigation/oba_navigator.dart';
import '../navigation/presentation.dart';
import 'states.dart';

/// The scaffold every SDK page uses. It adapts to how the page is shown
/// (`ObaPresentation`):
///
/// - in the shell's sheet: a compact header (back button, title, actions)
///   that drags the sheet, and a body whose scrolling is coupled to the
///   sheet (drag the list up to expand the sheet, down at the top to
///   collapse it);
/// - in the side panel: the same header, no drag;
/// - as a normal route (host navigator, no shell): a `Scaffold` with an
///   `AppBar`;
/// - embedded inline: the body alone, or with the compact header (title
///   and actions, no back button) when the scope's `showsHeader` is set.
///
/// Give it [slivers] (preferred) or a [body]. A [body] that scrolls must
/// use the primary scroll controller (`primary: true`, or no controller) so
/// the sheet coupling works.
class ObaSheetPage extends StatelessWidget {
  const ObaSheetPage({
    super.key,
    required this.title,
    this.actions = const [],
    this.slivers,
    this.body,
    this.headerBottom,
    this.automaticallyImplyLeading = true,
  }) : assert(
         (slivers == null) != (body == null),
         'Pass exactly one of slivers or body',
       );

  /// Shown in the header and read as a heading by screen readers. Wraps at
  /// large text sizes rather than truncating.
  final String title;

  /// Header buttons. Use `IconButton` with a `tooltip` (it becomes the
  /// semantics label and gets a 48dp target).
  final List<Widget> actions;
  final List<Widget>? slivers;
  final Widget? body;

  /// Pinned under the title (segmented controls, a search field, tabs).
  final Widget? headerBottom;

  /// Show a back button when the navigator can pop.
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final scope = ObaPresentationScope.maybeOf(context);
    final presentation = scope?.presentation ?? ObaPresentation.page;
    final content =
        body ?? _SliverBody(slivers: slivers!, presentation: presentation);
    switch (presentation) {
      case ObaPresentation.embedded:
        if (scope?.showsHeader != true) return content;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ObaSheetHeader(
              title: title,
              actions: actions,
              bottom: headerBottom,
              automaticallyImplyLeading: false,
            ),
            Expanded(child: content),
          ],
        );
      case ObaPresentation.page:
        return Scaffold(
          appBar: AppBar(
            title: Text(title, maxLines: 3, softWrap: true),
            actions: actions,
            automaticallyImplyLeading: automaticallyImplyLeading,
          ),
          body: Column(
            children: [
              ?headerBottom,
              Expanded(child: content),
            ],
          ),
        );
      case ObaPresentation.sheet:
      case ObaPresentation.panel:
        return Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ObaSheetHeader(
                title: title,
                actions: actions,
                bottom: headerBottom,
                automaticallyImplyLeading: automaticallyImplyLeading,
              ),
              Expanded(child: content),
            ],
          ),
        );
    }
  }
}

class _SliverBody extends StatelessWidget {
  const _SliverBody({required this.slivers, required this.presentation});

  final List<Widget> slivers;
  final ObaPresentation presentation;

  @override
  Widget build(BuildContext context) {
    final bottomInset = presentation == ObaPresentation.page
        ? 0.0
        : MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      primary: true,
      slivers: [
        ...slivers,
        SliverPadding(padding: EdgeInsets.only(bottom: bottomInset + 16)),
      ],
    );
  }
}

/// The compact header used in the sheet and side panel. Exposed for pages
/// that need custom layouts; `ObaSheetPage` uses it for you.
///
/// It reports its height (the collapsed detent fits it exactly) and, in the
/// sheet, turns vertical drags into sheet drags.
class ObaSheetHeader extends StatelessWidget {
  const ObaSheetHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.titleWidget,
  });

  final String title;
  final Widget? titleWidget;
  final List<Widget> actions;
  final Widget? bottom;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final scope = ObaPresentationScope.maybeOf(context);
    final sheet = scope?.sheet;
    final theme = Theme.of(context);
    final navigator = ObaNavigator.of(context);
    final showBack = automaticallyImplyLeading && navigator.canPop;
    final l10n = context.obaL10n;

    Widget header = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBack)
                IconButton(
                  icon: const BackButtonIcon(),
                  tooltip: l10n.commonBack,
                  onPressed: navigator.pop,
                )
              else
                const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child:
                      titleWidget ??
                      Semantics(
                        container: true,
                        header: true,
                        child: Text(
                          title,
                          style: theme.textTheme.titleLarge,
                          softWrap: true,
                        ),
                      ),
                ),
              ),
              ...actions,
            ],
          ),
          ?bottom,
        ],
      ),
    );

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
    return header;
  }
}

/// Reports its child's size after every layout that changes it.
class ObaMeasureSize extends SingleChildRenderObjectWidget {
  const ObaMeasureSize({super.key, required this.onSize, super.child});

  final ValueChanged<Size> onSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderObaMeasureSize(onSize);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderObaMeasureSize renderObject,
  ) {
    renderObject.onSize = onSize;
  }
}

/// Render object of [ObaMeasureSize].
class RenderObaMeasureSize extends RenderProxyBox {
  RenderObaMeasureSize(this.onSize);

  ValueChanged<Size> onSize;
  Size? _last;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _last) {
      _last = size;
      final s = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onSize(s));
    }
  }
}

/// A placeholder page for a screen that is not built yet. Feature agents
/// replace every use of it.
class ObaComingSoonPage extends StatelessWidget {
  const ObaComingSoonPage({super.key, required this.title, this.details});

  final String title;

  /// Optional developer-facing note (e.g. the route's parameters).
  final String? details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return ObaSheetPage(
      title: title,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ObaEmptyState(
            icon: Icons.construction_outlined,
            title: l10n.commonComingSoon,
            message: details == null
                ? l10n.commonComingSoonBody
                : '${l10n.commonComingSoonBody}\n$details',
          ),
        ),
      ],
    );
  }
}
