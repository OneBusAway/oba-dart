import 'dart:async';

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/loader.dart';
import '../../app/application.dart';
import '../../app/scope.dart';
import '../../features/map/map_coordinator.dart';
import '../../l10n/l10n.dart';
import '../../l10n/strings_bridge.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'search_common.dart';

/// Which kinds of result the search page offers (iOS `SearchScope`).
enum SearchScope {
  all,
  stops,
  routes,
  places;

  /// Quick-search types under this scope, in display order.
  Set<SearchType> get types => switch (this) {
    all => SearchType.values.toSet(),
    stops => {SearchType.stopNumber},
    routes => {SearchType.route},
    places => {SearchType.address},
  };

  /// The search that Enter runs directly; null under [all], where the
  /// rider picks a quick-search row (Enter then runs the first one).
  SearchType? get submitType => switch (this) {
    all => null,
    stops => SearchType.stopNumber,
    routes => SearchType.route,
    places => SearchType.address,
  };

  bool get includesStops => this == all || this == stops;
  bool get includesPlaces => this == all || this == places;
}

enum _PlaceState { idle, loading, loaded, error }

/// The search session: query, scope, the live place results and the
/// running search. Owned by [SearchPage]'s State.
class SearchSessionController extends ChangeNotifier
    with ObaDisposeSafeNotifier {
  SearchSessionController(
    this.app, {
    this.debounce = const Duration(milliseconds: 350),
    this.mapCenter,
    this.visibleBounds,
  });

  final ObaApplication app;
  final Duration debounce;

  /// The map camera, read when a search runs (null without a map).
  final Coordinate? Function()? mapCenter;
  final RegionRect? Function()? visibleBounds;

  String _query = '';
  SearchScope _scope = SearchScope.all;
  Timer? _debounceTimer;
  int _placeGeneration = 0;
  _PlaceState _placeState = _PlaceState.idle;
  List<Place> _places = const [];
  int _searchGeneration = 0;
  bool _searching = false;

  SearchService get _service => app.core.search;

  String get query => _query;
  String get trimmedQuery => _query.trim();
  SearchScope get scope => _scope;
  bool get isSearching => _searching;
  List<Place> get places => _places;
  bool get placesLoading => _placeState == _PlaceState.loading;
  bool get placesFailed => _placeState == _PlaceState.error;
  bool get placesLoaded => _placeState == _PlaceState.loaded;

  /// Whether live place results apply (a provider exists, the scope
  /// includes places, and the query has at least two characters).
  bool get _wantsPlaces =>
      _scope.includesPlaces &&
      trimmedQuery.length >= 2 &&
      _service.availableTypes.contains(SearchType.address);

  /// The quick-search rows for the query, limited to the scope and to what
  /// the region supports.
  List<SearchRequest> get quickRequests => [
    for (final r in _service.quickSearchRequests(_query))
      if (_scope.types.contains(r.type)) r,
  ];

  LocalSearchMatches get localMatches => _scope.includesStops
      ? _service.localMatches(_query, regionId: app.core.currentRegion?.id)
      : const LocalSearchMatches(bookmarks: [], recentStops: []);

  void setQuery(String value) {
    if (value == _query) return;
    _query = value;
    _schedulePlaces();
    notifyListeners();
  }

  void setScope(SearchScope value) {
    if (value == _scope) return;
    _scope = value;
    _schedulePlaces();
    notifyListeners();
  }

  void _schedulePlaces() {
    _debounceTimer?.cancel();
    _placeGeneration++;
    if (!_wantsPlaces) {
      _placeState = _PlaceState.idle;
      _places = const [];
      return;
    }
    final generation = _placeGeneration;
    final q = trimmedQuery;
    _debounceTimer = Timer(debounce, () => _loadPlaces(q, generation));
  }

  Future<void> _loadPlaces(String q, int generation) async {
    final provider = app.config.placeSearchProvider;
    if (provider == null) return;
    _placeState = _PlaceState.loading;
    notifyListeners();
    final region = app.core.currentRegion;
    try {
      final result = await provider.search(
        q,
        near: mapCenter?.call() ?? region?.centerCoordinate,
        within: region?.serviceRect ?? visibleBounds?.call(),
      );
      if (isDisposed || generation != _placeGeneration) return;
      _places = result;
      _placeState = _PlaceState.loaded;
    } catch (_) {
      if (isDisposed || generation != _placeGeneration) return;
      _places = const [];
      _placeState = _PlaceState.error;
    }
    notifyListeners();
  }

  /// Runs [request] (the service records it as a recent search and reports
  /// it to analytics). Returns null when a newer search superseded it.
  /// Throws what the service throws.
  Future<SearchResult?> run(SearchRequest request) async {
    final generation = ++_searchGeneration;
    _searching = true;
    notifyListeners();
    try {
      final result = await _service.search(
        request,
        mapCenter: mapCenter?.call(),
        visibleRect: visibleBounds?.call(),
      );
      return generation == _searchGeneration ? result : null;
    } finally {
      if (!isDisposed && generation == _searchGeneration) {
        _searching = false;
        notifyListeners();
      }
    }
  }

  /// Forgets a running search (the rider left or typed on).
  void cancelSearch() {
    _searchGeneration++;
    if (_searching) {
      _searching = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Search (iOS `SearchSheetView`): a field with scope chips; while typing,
/// quick-search rows ("Route: 10"), matching bookmarks and recent stops,
/// and live place results; with an empty field, recent searches and
/// places. Running a search opens the result directly when it is
/// unambiguous, or the results list.
///
/// Embeddable: needs only an `ObaScope`; the map is optional.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.initialQuery, this.autofocus = true});

  final String? initialQuery;

  /// Focus the field when the page opens.
  final bool autofocus;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchSessionController _session;
  late final TextEditingController _text;
  ObaMapCoordinator? _map;
  String? _message;
  bool _messageIsError = false;

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _map = ObaMapCoordinator.maybeOf(context);
    if (_started) return;
    _started = true;
    final app = ObaScope.of(context);
    _session = SearchSessionController(
      app,
      mapCenter: () => _map?.center,
      visibleBounds: () => _map?.visibleBounds,
    );
    _text = TextEditingController(text: widget.initialQuery ?? '');
    _session.setQuery(_text.text);
    _session.addListener(_onChanged);
    app.core.userData.addListener(_onChanged);
  }

  @override
  void dispose() {
    _session.app.core.userData.removeListener(_onChanged);
    _session.dispose();
    _text.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _onQueryChanged(String value) {
    _session.cancelSearch();
    setState(() => _message = null);
    _session.setQuery(value);
  }

  void _setQueryText(String value) {
    _text.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _onQueryChanged(value);
  }

  void _submit() {
    final q = _session.trimmedQuery;
    if (q.isEmpty) return;
    final type = _session.scope.submitType;
    if (type != null) {
      _run(SearchRequest(q, type));
      return;
    }
    final quick = _session.quickRequests;
    if (quick.isNotEmpty) _runFirstMatch(quick);
  }

  /// Under "All", Enter tries the quick searches in order of how
  /// specific they are (route, stop number, address, vehicle) and opens
  /// the first that finds something, so "75403" finds the stop rather than
  /// reporting that no route has that name.
  Future<void> _runFirstMatch(List<SearchRequest> requests) async {
    const order = [
      SearchType.route,
      SearchType.stopNumber,
      SearchType.address,
      SearchType.vehicleId,
    ];
    final sorted = [...requests]
      ..sort((a, b) => order.indexOf(a.type).compareTo(order.indexOf(b.type)));
    setState(() => _message = null);
    Object? error;
    for (final request in sorted) {
      try {
        final result = await _session.run(request);
        if (!mounted || result == null) return;
        if (result.isEmpty && result is! VehicleResult) continue;
        _handle(request, result);
        return;
      } catch (e) {
        error = e;
      }
    }
    if (!mounted) return;
    if (error != null && sorted.length == 1) {
      _show(searchErrorText(context, error), error: true);
    } else {
      _show(
        context.obaL10n.searchNoResultsBody(_session.trimmedQuery),
        error: false,
      );
    }
  }

  Future<void> _run(SearchRequest request) async {
    setState(() => _message = null);
    try {
      final result = await _session.run(request);
      if (!mounted || result == null) return;
      _handle(request, result);
    } catch (e) {
      if (!mounted) return;
      _show(searchErrorText(context, e), error: true);
    }
  }

  void _handle(SearchRequest request, SearchResult result) {
    final l10n = context.obaL10n;
    {
      final destination = searchResultDestination(result);
      if (destination != null) {
        if (destination is PlaceRoute) {
          rememberPlace(_session.app, destination.place);
        }
        openFromSearch(context, destination);
      } else if (result is VehicleResult) {
        _show(l10n.searchVehicleNoTrip(result.vehicle.vehicleId), error: true);
      } else if (result.isEmpty) {
        _show(l10n.searchNoResultsBody(request.query), error: false);
      } else {
        ObaNavigator.of(context)
            .push(SearchResultsRoute(request, result: result));
      }
    }
  }

  void _show(String message, {required bool error}) {
    setState(() {
      _message = message;
      _messageIsError = error;
    });
    obaAnnounce(context, message);
  }

  void _openStop(String stopId) => openFromSearch(context, StopRoute(stopId));

  void _openPlace(Place place) {
    rememberPlace(_session.app, place);
    openFromSearch(context, PlaceRoute(place));
  }

  Future<void> _confirmClearRecents() async {
    final l10n = context.obaL10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.searchClearRecentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.searchClearAction),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final store = _session.app.core.userData;
    store.deleteAllRecentSearches();
    store.deleteAllRecentPlaces();
    obaAnnounce(context, l10n.searchRecentCleared);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final header = _SearchHeader(
      controller: _text,
      autofocus: widget.autofocus,
      scope: _session.scope,
      onChanged: _onQueryChanged,
      onSubmitted: _submit,
      onClear: () => _setQueryText(''),
      onScope: _session.setScope,
    );
    return ObaSheetPage(
      title: l10n.titleSearch,
      headerBottom: header,
      slivers: [
        if (_session.isSearching)
          SliverToBoxAdapter(
            child: Semantics(
              liveRegion: true,
              label: l10n.searchSearching,
              child: const ExcludeSemantics(child: LinearProgressIndicator()),
            ),
          ),
        if (_message != null)
          SliverToBoxAdapter(
            child: _MessageBanner(
              message: _message!,
              isError: _messageIsError,
              onDismiss: () => setState(() => _message = null),
            ),
          ),
        ..._session.trimmedQuery.isEmpty ? _emptyQuery(l10n) : _typing(l10n),
      ],
    );
  }

  List<Widget> _emptyQuery(ObaLocalizations l10n) {
    final store = _session.app.core.userData;
    final scope = _session.scope;
    final searches = store.recentSearches;
    final places = scope.includesPlaces ? store.recentPlaces : const [];
    final local = scope == SearchScope.stops
        ? store.recentStopsInRegion(_session.app.core.currentRegion?.id)
        : const <StoredStop>[];
    if (searches.isEmpty && places.isEmpty && local.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: ObaEmptyState(
            icon: Icons.search,
            title: l10n.searchEmptyTitle,
            message: l10n.searchEmptyBody,
          ),
        ),
      ];
    }
    return [
      if (local.isNotEmpty) ...[
        _header(l10n.searchRecentStopsHeader),
        _list([
          for (final s in local)
            ObaListRow(
              leading: const Icon(Icons.history),
              title: s.name,
              onTap: () => _openStop(s.id),
            ),
        ]),
      ],
      if (searches.isNotEmpty) ...[
        _header(l10n.searchRecentSearchesHeader),
        _list([
          for (final q in searches)
            ObaListRow(
              leading: const Icon(Icons.history),
              title: q,
              onTap: () => _setQueryText(q),
            ),
        ]),
      ],
      if (places.isNotEmpty) ...[
        _header(l10n.searchRecentPlacesHeader),
        _list([
          for (final p in places)
            ObaListRow(
              leading: const Icon(Icons.place_outlined),
              title: p.name,
              subtitle: p.subtitle,
              onTap: () => _openPlace(
                Place(
                  name: p.name,
                  subtitle: p.subtitle,
                  coordinate: p.coordinate,
                ),
              ),
            ),
        ]),
      ],
      if (searches.isNotEmpty || places.isNotEmpty)
        _list([
          ObaListRow(
            leading: const Icon(Icons.delete_outline),
            title: l10n.searchClearRecent,
            onTap: _confirmClearRecents,
          ),
        ]),
    ];
  }

  List<Widget> _typing(ObaLocalizations l10n) {
    final quick = _session.quickRequests;
    final local = _session.localMatches;
    final s = _session;
    return [
      if (quick.isNotEmpty) ...[
        _header(l10n.searchQuickHeader),
        _list([
          for (final r in quick)
            ObaListRow(
              leading: Icon(searchTypeIcon(r.type)),
              title: quickSearchTitle(l10n, r),
              onTap: s.isSearching ? null : () => _run(r),
            ),
        ]),
      ],
      if (local.recentStops.isNotEmpty) ...[
        _header(l10n.searchRecentStopsHeader),
        _list([
          for (final stop in local.recentStops)
            ObaListRow(
              leading: const Icon(Icons.history),
              title: stop.name,
              subtitle: context.obaFormatters.storedStopSubtitle(stop),
              onTap: () => _openStop(stop.id),
            ),
        ]),
      ],
      if (local.bookmarks.isNotEmpty) ...[
        _header(l10n.searchBookmarksHeader),
        _list([
          for (final b in local.bookmarks)
            ObaListRow(
              leading: const Icon(Icons.bookmark_outline),
              title: b.name,
              subtitle: b.stop.name == b.name ? null : b.stop.name,
              onTap: () => _openStop(b.stop.id),
            ),
        ]),
      ],
      if (s.placesLoading || s.placesLoaded || s.placesFailed) ...[
        _header(l10n.searchPlacesHeader),
        if (s.placesLoading)
          SliverToBoxAdapter(
            child: ObaLoadingState(label: l10n.searchPlacesLoading),
          )
        else if (s.placesFailed)
          SliverToBoxAdapter(child: _InlineNote(l10n.searchPlacesError))
        else if (s.places.isEmpty)
          SliverToBoxAdapter(child: _InlineNote(l10n.searchPlacesNone))
        else
          _list([
            for (final p in s.places)
              ObaListRow(
                leading: const Icon(Icons.place_outlined),
                title: p.name,
                subtitle: p.subtitle,
                onTap: () => _openPlace(p),
              ),
          ]),
      ],
    ];
  }

  Widget _header(String title) =>
      SliverToBoxAdapter(child: ObaSectionHeader(title: title));

  Widget _list(List<Widget> rows) => SliverList.list(children: rows);
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.autofocus,
    required this.scope,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onScope,
  });

  final TextEditingController controller;
  final bool autofocus;
  final SearchScope scope;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;
  final VoidCallback onClear;
  final ValueChanged<SearchScope> onScope;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    String label(SearchScope s) => switch (s) {
      SearchScope.all => l10n.searchScopeAll,
      SearchScope.stops => l10n.searchScopeStops,
      SearchScope.routes => l10n.searchScopeRoutes,
      SearchScope.places => l10n.searchScopePlaces,
    };
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => TextField(
              controller: controller,
              autofocus: autofocus,
              autocorrect: false,
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
              onSubmitted: (_) => onSubmitted(),
              decoration: InputDecoration(
                labelText: l10n.searchFieldLabel,
                hintText: l10n.searchFieldHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: value.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: l10n.searchClear,
                        onPressed: onClear,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            container: true,
            label: l10n.searchScopeLabel,
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final s in SearchScope.values)
                  ChoiceChip(
                    label: Text(label(s)),
                    selected: s == scope,
                    onSelected: (_) => onScope(s),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.obaL10n;
    final bg = isError ? scheme.errorContainer : scheme.secondaryContainer;
    final fg = isError ? scheme.onErrorContainer : scheme.onSecondaryContainer;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 4, 8),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  isError ? Icons.error_outline : Icons.info_outline,
                  color: fg,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(color: fg),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: fg),
                tooltip: l10n.searchDismissMessage,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineNote extends StatelessWidget {
  const _InlineNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
