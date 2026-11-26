import 'dart:async';

import 'package:flutter/material.dart';

import '../place_search.dart';
import '../strings.dart';
import '../theme.dart';
import 'a11y.dart';

/// Full-screen place picker. Pops with the chosen [TripPlace], or null when
/// dismissed.
///
/// The search field has a visible label and sits in the body (not a
/// fixed-height app bar slot), so it grows with the text size. The number
/// of results is announced; "no places" and errors are live regions.
class TripPlaceSearchPage extends StatefulWidget {
  const TripPlaceSearchPage({
    super.key,
    required this.search,
    required this.title,
    this.near,
    this.currentLocation,
    this.debounce = const Duration(milliseconds: 300),
    this.strings = const TripPlannerStrings(),
  });

  final TripPlaceSearch search;

  /// The field being filled ("From" / "To"), shown in the app bar.
  final String title;

  /// Passed to [TripPlaceSearch.search] to bias results.
  final TripPlace? near;
  final CurrentLocationProvider? currentLocation;
  final Duration debounce;
  final TripPlannerStrings strings;

  @override
  State<TripPlaceSearchPage> createState() => _TripPlaceSearchPageState();
}

class _TripPlaceSearchPageState extends State<TripPlaceSearchPage> {
  final _query = TextEditingController();
  Timer? _debounce;
  int _generation = 0;
  bool _searching = false;
  bool _failed = false;
  bool _locating = false;
  String? _locationError;
  List<TripPlace>? _results;

  TripPlannerStrings get strings => widget.strings;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final generation = ++_generation;
    if (value.trim().isEmpty) {
      setState(() {
        _results = null;
        _searching = false;
        _failed = false;
      });
      return;
    }
    setState(() => _searching = true);
    _debounce = Timer(widget.debounce, () => _run(value.trim(), generation));
  }

  Future<void> _run(String query, int generation) async {
    try {
      final results = await widget.search.search(query, near: widget.near);
      if (!mounted || generation != _generation) return;
      setState(() {
        _results = results;
        _searching = false;
        _failed = false;
      });
      if (results.isNotEmpty) {
        announce(context, strings.placesFound(results.length));
      }
    } catch (_) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _results = null;
        _searching = false;
        _failed = true;
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _locating = true;
      _locationError = null;
    });
    TripPlace? place;
    try {
      place = await widget.currentLocation!();
    } catch (_) {
      place = null;
    }
    if (!mounted) return;
    if (place == null) {
      setState(() {
        _locating = false;
        _locationError = strings.locationUnavailable;
      });
      return;
    }
    Navigator.of(context).pop(place);
  }

  @override
  Widget build(BuildContext context) {
    return TripPlannerContrast.applyAccessibleScheme(
      context,
      Builder(builder: _buildPage),
    );
  }

  Widget _buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final results = _results;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _query,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              decoration: InputDecoration(
                labelText: strings.searchLabel,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: ListenableBuilder(
                  listenable: _query,
                  builder: (context, _) => _query.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          tooltip: strings.clearSearch,
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _query.clear();
                            _onChanged('');
                          },
                        ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (widget.currentLocation != null)
                  ListTile(
                    leading: _locating
                        ? SizedBox.square(
                            dimension: 24,
                            child: TripProgressIndicator(
                              semanticsLabel: strings.useCurrentLocation,
                            ),
                          )
                        : Icon(
                            Icons.my_location,
                            color: theme.colorScheme.primary,
                          ),
                    title: Text(strings.useCurrentLocation),
                    subtitle: _locationError == null
                        ? null
                        : Semantics(
                            liveRegion: true,
                            child: Text(
                              _locationError!,
                              style: TextStyle(
                                color: TripPlannerContrast.ensure(
                                  theme.colorScheme.error,
                                  TripPlannerContrast.surfaceOf(context),
                                ),
                              ),
                            ),
                          ),
                    enabled: !_locating,
                    onTap: _useCurrentLocation,
                  ),
                if (_searching) const TripProgressIndicator(linear: true),
                if (_failed)
                  _Message(
                    text: strings.searchError,
                    color: theme.colorScheme.error,
                  )
                else if (results != null && results.isEmpty && !_searching)
                  _Message(text: strings.searchNoResults),
                if (results != null)
                  for (final place in results)
                    ListTile(
                      leading: const Icon(Icons.place_outlined),
                      title: Text(place.name),
                      subtitle: place.subtitle == null
                          ? null
                          : Text(place.subtitle!),
                      onTap: () => Navigator.of(context).pop(place),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Semantics(
      liveRegion: true,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: TripPlannerContrast.ensure(
            color ?? Theme.of(context).colorScheme.onSurfaceVariant,
            TripPlannerContrast.surfaceOf(context),
          ),
        ),
      ),
    ),
  );
}
