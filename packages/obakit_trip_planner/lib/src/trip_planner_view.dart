import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import 'api/api.dart';
import 'display/formatting.dart';
import 'itinerary_detail_view.dart';
import 'map_config.dart';
import 'place_search.dart';
import 'strings.dart';
import 'theme.dart';
import 'trip_planner_controller.dart';
import 'widgets/a11y.dart';
import 'widgets/focus_ring.dart';
import 'widgets/icons.dart';
import 'widgets/itinerary_card.dart';
import 'widgets/place_search_page.dart';

/// The trip planner: origin and destination fields, time and mode options,
/// a plan button, and the resulting itineraries. Tapping an itinerary
/// pushes an [ItineraryDetailPage] (override with [onItineraryTap]).
///
/// Lays out as a scrolling list that fills its parent; put it in a
/// [Scaffold] body.
///
/// Accessibility (WCAG 2.1 AA): the origin/destination fields read as
/// "From: Geisel Library" buttons, every chip and button is a labelled 48dp
/// target, the results have a heading, the number of trips found is
/// announced, and errors / "no trips" are live regions. Text follows the
/// host's `TextTheme` and text size and wraps at 200%. See the README.
class TripPlannerView extends StatefulWidget {
  const TripPlannerView({
    super.key,
    this.controller,
    this.service,
    required this.placeSearch,
    required this.mapConfig,
    this.currentLocation,
    this.initialOrigin,
    this.initialDestination,
    this.enabledModes = TripPlannerController.defaultModes,
    this.distanceUnits,
    this.onItineraryTap,
    this.onError,
    this.strings = const TripPlannerStrings(),
  }) : assert(
         controller != null || service != null,
         'Pass a controller or a service.',
       );

  /// Optional host-owned controller. When given, [service],
  /// [initialOrigin], [initialDestination], [enabledModes] and [onError]
  /// are ignored, and the view never disposes it.
  final TripPlannerController? controller;

  /// The planner backend, typically an [OtpClient]. Must be long-lived:
  /// a new instance resets the view.
  final TripPlanService? service;
  final TripPlaceSearch placeSearch;
  final TripMapConfig mapConfig;

  /// Offered in place search, and used to fill an empty origin on start
  /// (as OTPKit does).
  final CurrentLocationProvider? currentLocation;
  final TripPlace? initialOrigin;
  final TripPlace? initialDestination;
  final List<TransportMode> enabledModes;

  /// Null picks units from the app locale.
  final DistanceUnits? distanceUnits;

  /// Replaces the default push of [ItineraryDetailPage].
  final void Function(BuildContext context, Itinerary itinerary)?
  onItineraryTap;

  /// See [TripPlannerController.onError].
  final void Function(Object error, StackTrace stackTrace)? onError;
  final TripPlannerStrings strings;

  @override
  State<TripPlannerView> createState() => _TripPlannerViewState();
}

class _TripPlannerViewState extends State<TripPlannerView> {
  TripPlannerController? _owned;
  TripPlannerController? _listening;
  TripPlannerStatus? _lastStatus;

  TripPlannerController get _controller => widget.controller ?? _owned!;
  TripPlannerStrings get strings => widget.strings;

  @override
  void initState() {
    super.initState();
    _ensureController();
    _listen();
    _fillCurrentLocation();
  }

  /// Follows the controller to announce finished plans.
  void _listen() {
    _listening?.removeListener(_onStateChanged);
    _listening = _controller..addListener(_onStateChanged);
    _lastStatus = _controller.state.status;
  }

  void _onStateChanged() {
    final state = _controller.state;
    final previous = _lastStatus;
    _lastStatus = state.status;
    if (!mounted || previous != TripPlannerStatus.loading) return;
    // "No trips" and errors are live regions; only successes need an
    // explicit announcement.
    if (state.status == TripPlannerStatus.loaded &&
        state.itineraries.isNotEmpty) {
      announce(context, strings.tripsFound(state.itineraries.length));
    }
  }

  @override
  void didUpdateWidget(TripPlannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        (widget.controller == null && widget.service != oldWidget.service)) {
      _listening?.removeListener(_onStateChanged);
      _listening = null;
      _owned?.dispose();
      _owned = null;
      _ensureController();
      _listen();
      _fillCurrentLocation();
    }
  }

  void _ensureController() {
    if (widget.controller != null) return;
    _owned = TripPlannerController(
      service: widget.service!,
      origin: widget.initialOrigin,
      destination: widget.initialDestination,
      enabledModes: widget.enabledModes,
      onError: (e, s) => widget.onError?.call(e, s),
    );
  }

  Future<void> _fillCurrentLocation() async {
    final provider = widget.currentLocation;
    if (provider == null || _controller.state.origin != null) return;
    final controller = _controller;
    TripPlace? place;
    try {
      place = await provider();
    } catch (_) {
      return;
    }
    if (!mounted || place == null || controller != _controller) return;
    controller.setOriginIfEmpty(place);
  }

  @override
  void dispose() {
    _listening?.removeListener(_onStateChanged);
    _owned?.dispose();
    super.dispose();
  }

  DistanceUnits get _units =>
      widget.distanceUnits ??
      DistanceUnits.forLocale(Localizations.maybeLocaleOf(context));

  Future<void> _pickPlace({required bool origin}) async {
    final state = _controller.state;
    // Captured now, for the same reason as in _openItinerary.
    final search = widget.placeSearch;
    final pageStrings = strings;
    final title = origin
        ? pageStrings.originLabel
        : pageStrings.destinationLabel;
    final near = origin ? state.destination : state.origin;
    final currentLocation = widget.currentLocation;
    final place = await Navigator.of(context).push<TripPlace>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => TripPlaceSearchPage(
          search: search,
          title: title,
          near: near,
          currentLocation: currentLocation,
          strings: pageStrings,
        ),
      ),
    );
    if (place == null || !mounted) return;
    if (origin) {
      _controller.setOrigin(place);
    } else {
      _controller.setDestination(place);
    }
  }

  Future<void> _pickDateTime() async {
    final initial = _controller.state.dateTime ?? clock.now();
    final now = clock.now();
    final first = DateTime(now.year, now.month, now.day);
    final last = DateTime(now.year + 1, now.month, now.day);
    final date = await showDatePicker(
      context: context,
      // A time chosen earlier may be before today by now (the planner was
      // left open over midnight): the picker requires a date in its range.
      initialDate: initial.isBefore(first)
          ? first
          : (initial.isAfter(last) ? last : initial),
      firstDate: first,
      lastDate: last,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;
    _controller.setDateTime(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  Future<void> _openItinerary(int index) async {
    final state = _controller.state;
    final itinerary = state.itineraries[index];
    _controller.selectItinerary(index);
    final custom = widget.onItineraryTap;
    if (custom != null) {
      custom(context, itinerary);
      return;
    }
    // Read everything from this State now: the route can rebuild after the
    // planner itself is gone (a host popping both), when its context is
    // no longer usable.
    final mapConfig = widget.mapConfig;
    final originName = _endpointName(state.origin);
    final destinationName = _endpointName(state.destination);
    final units = _units;
    final pageStrings = strings;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ItineraryDetailPage(
          itinerary: itinerary,
          mapConfig: mapConfig,
          originName: originName,
          destinationName: destinationName,
          distanceUnits: units,
          strings: pageStrings,
        ),
      ),
    );
    if (mounted) _controller.selectItinerary(null);
  }

  String? _endpointName(TripPlace? place) {
    if (place == null) return null;
    return place.isCurrentLocation ? strings.currentLocation : place.name;
  }

  @override
  Widget build(BuildContext context) =>
      TripPlannerContrast.applyAccessibleScheme(
        context,
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final state = _controller.state;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _EndpointsCard(
                  state: state,
                  strings: strings,
                  onOrigin: () => _pickPlace(origin: true),
                  onDestination: () => _pickPlace(origin: false),
                  onSwap: _controller.swapEndpoints,
                ),
                const SizedBox(height: 12),
                _TimeOptions(
                  state: state,
                  strings: strings,
                  onOption: _controller.setTimeOption,
                  onPickTime: _pickDateTime,
                ),
                const SizedBox(height: 8),
                _ModeChips(
                  modes: _controller.availableModes,
                  selected: state.mode,
                  strings: strings,
                  onSelected: _controller.setMode,
                ),
                const SizedBox(height: 8),
                _Options(
                  state: state,
                  strings: strings,
                  onWheelchair: _controller.setWheelchairAccessible,
                  onMaxWalk: _controller.setMaxWalkDistance,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: state.isLoading ? null : _controller.plan,
                  icon: const Icon(Icons.directions),
                  label: Text(strings.planTrip),
                ),
                const SizedBox(height: 16),
                ..._results(context, state),
              ],
            );
          },
        ),
      );

  List<Widget> _results(BuildContext context, TripPlannerState state) {
    final theme = Theme.of(context);
    switch (state.status) {
      case TripPlannerStatus.idle:
        return const [];
      case TripPlannerStatus.loading:
        return [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Semantics(
                liveRegion: true,
                child: TripProgressIndicator(
                  semanticsLabel: strings.planningTrip,
                ),
              ),
            ),
          ),
        ];
      case TripPlannerStatus.error:
        final error = state.error!;
        final retryable =
            error is! MissingTripEndpointsError &&
            (error is! OtpException || error.isRetryable);
        return [
          Semantics(
            liveRegion: true,
            child: Text(
              strings.errorMessage(error),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: TripPlannerContrast.ensure(
                  theme.colorScheme.error,
                  TripPlannerContrast.surfaceOf(context),
                ),
              ),
            ),
          ),
          if (retryable)
            Center(
              child: TextButton(
                onPressed: _controller.plan,
                child: Text(strings.retry),
              ),
            ),
        ];
      case TripPlannerStatus.loaded:
        final itineraries = state.itineraries;
        if (itineraries.isEmpty) {
          return [
            Semantics(
              liveRegion: true,
              child: Text(
                strings.noTripsFound,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: TripPlannerContrast.ensure(
                    theme.colorScheme.onSurfaceVariant,
                    TripPlannerContrast.surfaceOf(context),
                  ),
                ),
              ),
            ),
          ];
        }
        return [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Semantics(
              container: true,
              header: true,
              child: Text(
                strings.resultsHeading,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          for (var i = 0; i < itineraries.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ItineraryCard(
                itinerary: itineraries[i],
                distanceUnits: _units,
                selected: state.selectedIndex == i,
                strings: strings,
                onTap: () => _openItinerary(i),
              ),
            ),
        ];
    }
  }
}

class _EndpointsCard extends StatelessWidget {
  const _EndpointsCard({
    required this.state,
    required this.strings,
    required this.onOrigin,
    required this.onDestination,
    required this.onSwap,
  });

  final TripPlannerState state;
  final TripPlannerStrings strings;
  final VoidCallback onOrigin;
  final VoidCallback onDestination;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _PlaceField(
                  label: strings.originLabel,
                  placeholder: strings.chooseOrigin,
                  place: state.origin,
                  icon: Icons.trip_origin,
                  iconColor: scheme.primary,
                  strings: strings,
                  onTap: onOrigin,
                ),
                const Divider(height: 1, indent: 56),
                _PlaceField(
                  label: strings.destinationLabel,
                  placeholder: strings.chooseDestination,
                  place: state.destination,
                  icon: Icons.location_on,
                  iconColor: scheme.error,
                  strings: strings,
                  onTap: onDestination,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: strings.swapEndpoints,
            icon: const Icon(Icons.swap_vert),
            onPressed: onSwap,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _PlaceField extends StatelessWidget {
  const _PlaceField({
    required this.label,
    required this.placeholder,
    required this.place,
    required this.icon,
    required this.iconColor,
    required this.strings,
    required this.onTap,
  });

  final String label;
  final String placeholder;
  final TripPlace? place;
  final IconData icon;
  final Color iconColor;
  final TripPlannerStrings strings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final place = this.place;
    final value = place == null
        ? placeholder
        : (place.isCurrentLocation ? strings.currentLocation : place.name);
    return Semantics(
      button: true,
      label: '$label: $value',
      excludeSemantics: true,
      onTap: onTap,
      child: FocusRingInkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  place?.isCurrentLocation == true ? Icons.my_location : icon,
                  color: iconColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: TripPlannerContrast.ensure(
                            theme.colorScheme.onSurfaceVariant,
                            TripPlannerContrast.surfaceOf(context),
                          ),
                        ),
                      ),
                      Text(
                        value,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: TripPlannerContrast.ensure(
                            place == null
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurface,
                            TripPlannerContrast.surfaceOf(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeOptions extends StatelessWidget {
  const _TimeOptions({
    required this.state,
    required this.strings,
    required this.onOption,
    required this.onPickTime,
  });

  final TripPlannerState state;
  final TripPlannerStrings strings;
  final ValueChanged<TripTimeOption> onOption;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final dateTime = state.dateTime;
    final label = dateTime == null
        ? null
        : '${localizations.formatMediumDate(dateTime)}, '
              '${formatClockTime(dateTime, localizations, alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context))}';
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final option in TripTimeOption.values)
          ChoiceChip(
            label: Text(strings.timeOption(option)),
            selected: state.timeOption == option,
            onSelected: (_) => onOption(option),
          ),
        if (state.timeOption != TripTimeOption.leaveNow && label != null)
          ActionChip(
            avatar: const Icon(Icons.schedule),
            label: Text(label),
            tooltip: strings.changeTime(label),
            onPressed: onPickTime,
          ),
      ],
    );
  }
}

class _ModeChips extends StatelessWidget {
  const _ModeChips({
    required this.modes,
    required this.selected,
    required this.strings,
    required this.onSelected,
  });

  final List<TransportMode> modes;
  final TransportMode selected;
  final TripPlannerStrings strings;
  final ValueChanged<TransportMode> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 4,
    children: [
      for (final mode in modes)
        ChoiceChip(
          avatar: Icon(transportModeIcon(mode)),
          showCheckmark: false,
          label: Text(strings.transportMode(mode)),
          selected: mode == selected,
          onSelected: (_) => onSelected(mode),
        ),
    ],
  );
}

class _Options extends StatelessWidget {
  const _Options({
    required this.state,
    required this.strings,
    required this.onWheelchair,
    required this.onMaxWalk,
  });

  final TripPlannerState state;
  final TripPlannerStrings strings;
  final ValueChanged<bool> onWheelchair;
  final ValueChanged<WalkingDistance> onMaxWalk;

  @override
  Widget build(BuildContext context) {
    final walkLabel = strings.maxWalk(
      strings.walkingDistance(state.maxWalkDistance),
    );
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        FilterChip(
          avatar: const Icon(Icons.accessible),
          label: Text(strings.wheelchairAccessible),
          selected: state.wheelchairAccessible,
          onSelected: onWheelchair,
        ),
        MenuAnchor(
          menuChildren: [
            for (final distance in WalkingDistance.values)
              MenuItemButton(
                leadingIcon: distance == state.maxWalkDistance
                    ? const Icon(Icons.check)
                    : const SizedBox.square(dimension: 24),
                onPressed: () => onMaxWalk(distance),
                child: Text(strings.walkingDistance(distance)),
              ),
          ],
          builder: (context, menu, _) => ActionChip(
            avatar: const Icon(Icons.directions_walk),
            label: Text(walkLabel),
            onPressed: () => menu.isOpen ? menu.close() : menu.open(),
          ),
        ),
      ],
    );
  }
}
