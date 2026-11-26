import 'package:flutter/widgets.dart';

import 'sheet_controller.dart';

/// How an SDK page is being shown. `ObaSheetPage` adapts its chrome to it.
enum ObaPresentation {
  /// In the shell's draggable bottom sheet: compact header with a drag
  /// handle above it; dragging the content drags the sheet.
  sheet,

  /// In the shell's side panel (wide layouts): compact header, no drag.
  panel,

  /// A normal full-screen route (host navigator, or no shell at all):
  /// `Scaffold` with an `AppBar`. The default.
  page,

  /// Inline in another screen (a home tab, a host card): body only, no
  /// header.
  embedded;

  /// The presentation for [context]; [page] when nothing says otherwise.
  static ObaPresentation of(BuildContext context) =>
      ObaPresentationScope.maybeOf(context)?.presentation ??
      ObaPresentation.page;
}

/// Tells pages below how they are shown, and (in the sheet) gives them the
/// sheet controller and the scroll controller wired to it.
class ObaPresentationScope extends InheritedWidget {
  const ObaPresentationScope({
    super.key,
    required this.presentation,
    this.sheet,
    this.onHeaderHeight,
    this.showsHeader = false,
    required super.child,
  });

  /// Shows [child] inline, without page chrome.
  ///
  /// A page embedded this way shows only its body, so its title (a stop's
  /// name, say) and its header actions (refresh, bookmark, the overflow
  /// menu) are gone. Set [showsHeader] when the host has no title of its
  /// own for the page, for example a stop page that fills a host tab.
  const ObaPresentationScope.embedded({
    super.key,
    this.showsHeader = false,
    required super.child,
  }) : presentation = ObaPresentation.embedded,
       sheet = null,
       onHeaderHeight = null;

  final ObaPresentation presentation;

  /// Embedded pages only: show the page's title (as a heading) and its
  /// actions above the body, without a back button (the host's own chrome
  /// handles back).
  final bool showsHeader;

  /// The sheet, when [presentation] is [ObaPresentation.sheet].
  final ObaSheetController? sheet;

  /// Pages report their measured header height here (it sizes the
  /// collapsed detent).
  final ValueChanged<double>? onHeaderHeight;

  static ObaPresentationScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ObaPresentationScope>();

  @override
  bool updateShouldNotify(ObaPresentationScope old) =>
      old.presentation != presentation ||
      !identical(old.sheet, sheet) ||
      old.onHeaderHeight != onHeaderHeight ||
      old.showsHeader != showsHeader;
}
