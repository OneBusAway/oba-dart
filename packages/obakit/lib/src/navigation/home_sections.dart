import 'package:flutter/widgets.dart';

/// One block of the Home tab (bookmarks, nearby departures, ...).
///
/// Feature files contribute sections through their `...HomeSections`
/// lists; the home sheet shows them sorted by [order]. Each section's
/// widget must be a plain, non-scrolling widget (a `Column`), so the same
/// widget works in a host's feed.
@immutable
class ObaHomeSection {
  const ObaHomeSection({
    required this.id,
    required this.order,
    required this.builder,
  });

  final String id;

  /// Ascending. Current slots: alerts 5, bookmarks 10, nearby 20, recent
  /// 30, explore 40, settings and more 50.
  final int order;
  final WidgetBuilder builder;
}
