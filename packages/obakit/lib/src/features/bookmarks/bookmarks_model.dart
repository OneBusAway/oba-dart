import 'package:flutter/foundation.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/loader.dart';
import '../../app/application.dart';
import '../../platform/listenable_adapter.dart';
import 'departures_loader.dart';

/// The bookmarks of the current region plus their live departures. Owned by
/// a `State` of the bookmarks list or card; disposed there.
///
/// Bookmarks from other regions are not listed (iOS lists only the current
/// region's). With [limit] set, only the bookmarks a compact list shows are
/// kept (every pinned one, then the newest; see [selectHomeBookmarks]) and
/// only their stops are fetched.
class BookmarksModel extends ChangeNotifier with ObaDisposeSafeNotifier {
  BookmarksModel(this.app, {this.limit, StopDeparturesLoader? loader})
    : loader = loader ?? StopDeparturesLoader(app) {
    _sources = Listenable.merge([
      app.core.userData.listenable,
      app.core.regions.currentRegionListenable.listenable,
    ])..addListener(_onSourceChanged);
    this.loader.addListener(notifyListeners);
    _recompute();
  }

  final ObaApplication app;
  final int? limit;
  final StopDeparturesLoader loader;
  late final Listenable _sources;
  bool _active = false;
  List<Bookmark> _bookmarks = const [];

  /// The bookmarks to show, in storage order of the current region (or the
  /// compact selection when [limit] is set).
  List<Bookmark> get bookmarks => _bookmarks;

  List<BookmarkGroup> get groups => app.core.userData.bookmarkGroups;

  void _onSourceChanged() {
    _recompute();
    notifyListeners();
  }

  void _recompute() {
    final inRegion = app.core.userData.bookmarksInRegion(
      app.core.currentRegion?.id,
    );
    final l = limit;
    _bookmarks = l == null ? inRegion : selectHomeBookmarks(inRegion, limit: l);
    loader.setStops({for (final b in _bookmarks) b.stopId}, fetchNew: _active);
  }

  /// Visible and in the foreground: polls and refreshes stale data.
  void setActive(bool active) {
    if (_active == active) return;
    _active = active;
    loader.setActive(active);
  }

  Future<void> refresh() => loader.refresh();

  @override
  void dispose() {
    _sources.removeListener(_onSourceChanged);
    loader.removeListener(notifyListeners);
    loader.dispose();
    super.dispose();
  }
}
