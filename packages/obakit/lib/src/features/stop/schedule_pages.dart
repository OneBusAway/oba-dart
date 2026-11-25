import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/application.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'route_stops_page.dart' show ObaLoader;
import 'stop_format.dart';

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Previous / next day buttons around a date that opens a date picker.
class ScheduleDateBar extends StatelessWidget {
  const ScheduleDateBar({
    super.key,
    required this.date,
    required this.onChanged,
  });

  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final label = MaterialLocalizations.of(context).formatFullDate(date);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: l10n.stopSchedPrevDay,
            onPressed: () => onChanged(date.subtract(const Duration(days: 1))),
          ),
          Expanded(
            child: TextButton.icon(
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(
                label,
                textAlign: TextAlign.center,
                semanticsLabel: l10n.stopSchedPickDate(label),
              ),
              onPressed: () async {
                final today = _day(clock.now());
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: today.subtract(const Duration(days: 30)),
                  lastDate: today.add(const Duration(days: 365)),
                );
                if (picked != null) onChanged(_day(picked));
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: l10n.stopSchedNextDay,
            onPressed: () => onChanged(date.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }
}

/// One hour of departures: the hour, then the times (wrapping). Read as
/// one sentence: "6 AM: 6:05 AM, 6:35 AM".
class ScheduleHourRow extends StatelessWidget {
  const ScheduleHourRow({
    super.key,
    required this.hour,
    required this.times,
    this.highlight,
  });

  final int hour;
  final List<DateTime> times;

  /// A time to emphasise (the next departure).
  final DateTime? highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hourLabel = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: hour, minute: 0),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    final labels = [for (final t in times) obaClockTime(context, t)];
    return Semantics(
      label: context.obaL10n.stopSchedHour(hourLabel, labels.join(', ')),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 6),
        child: Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 72),
              child: Text(
                hourLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (var i = 0; i < times.length; i++)
              Text(
                labels[i],
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: times[i] == highlight ? FontWeight.w700 : null,
                  decoration: times[i] == highlight
                      ? TextDecoration.underline
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _hourRows(List<DateTime> times, DateTime now) {
  final next = times.where((t) => t.isAfter(now)).firstOrNull;
  return [
    for (final (hour, items) in groupByHour(times, (t) => t))
      ScheduleHourRow(hour: hour, times: items, highlight: next),
  ];
}

Widget _heading(BuildContext context, String text) => Padding(
  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
  child: Semantics(
    container: true,
    header: true,
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  ),
);

/// A stop's full-day schedule (iOS `ScheduleForStopView`): a date picker,
/// a route picker, then each direction's departures grouped by hour, with
/// frequency-based service as headways.
class StopSchedulePage extends StatefulWidget {
  const StopSchedulePage({super.key, required this.stopId, this.date});

  final String stopId;
  final DateTime? date;

  @override
  State<StopSchedulePage> createState() => _StopSchedulePageState();
}

class _StopSchedulePageState extends State<StopSchedulePage> {
  late DateTime _date = _day(widget.date ?? clock.now());
  late ObaLoader<ObaEntryResponse<ScheduleForStop>> _loader;
  ObaApplication? _app;
  bool _started = false;
  String? _routeId;

  @override
  void initState() {
    super.initState();
    _loader = _make();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _app = ObaScope.of(context);
    if (!_started) {
      _started = true;
      _loader.load();
    }
  }

  ObaLoader<ObaEntryResponse<ScheduleForStop>> _make() {
    final date = _date;
    return ObaLoader(() {
      final client = _app?.core.restClient;
      if (client == null) throw StateError('no region');
      return client.schedules.forStop(widget.stopId, date: date);
    });
  }

  void _setDate(DateTime d) {
    setState(() => _date = d);
    _loader.dispose();
    _loader = _make()..load();
  }

  @override
  void dispose() {
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: _loader, builder: _build);

  Widget _build(BuildContext context, Widget? _) {
    final l10n = context.obaL10n;
    final r = _loader.value;
    final routes = r == null
        ? const <RouteScheduleAtStop>[]
        : stopScheduleRoutes(r.entry, r.references);
    final selected =
        routes.where((x) => x.routeId == _routeId).firstOrNull ??
        routes.firstOrNull;
    final stop = r?.references.stop(widget.stopId);
    final now = clock.now();
    final slivers = <Widget>[
      SliverToBoxAdapter(
        child: ScheduleDateBar(date: _date, onChanged: _setDate),
      ),
    ];
    if (r == null || _loader.loading) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: _loader.error != null
              ? ObaErrorState(error: _loader.error, onRetry: _loader.load)
              : const ObaLoadingState(),
        ),
      );
    } else if (routes.isEmpty || selected == null) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: ObaEmptyState(
            icon: Icons.event_busy_outlined,
            title: l10n.stopSchedEmpty,
          ),
        ),
      );
    } else {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  container: true,
                  header: true,
                  child: Text(
                    l10n.stopSchedRoute,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final route in routes)
                      ChoiceChip(
                        label: Text(route.displayName),
                        selected: route == selected,
                        onSelected: (_) =>
                            setState(() => _routeId = route.routeId),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      final rows = <Widget>[];
      for (final d in selected.directions) {
        rows.add(
          _heading(
            context,
            [
              if (d.headsign != null) l10n.stopSchedTo(d.headsign!),
              l10n.stopSchedDepartures(d.departures.length),
            ].join(' · '),
          ),
        );
        for (final f in d.frequencies) {
          rows.add(
            ObaListRow(
              leading: const Icon(Icons.repeat),
              title: l10n.stopSchedEvery(
                (f.headway / 60).round(),
                obaClockTime(context, f.startTime),
                obaClockTime(context, f.endTime),
              ),
            ),
          );
        }
        rows.addAll(_hourRows([for (final x in d.departures) x.time], now));
      }
      slivers.add(SliverList.list(children: rows));
    }
    return ObaSheetPage(
      title: stop == null
          ? l10n.titleStopSchedule
          : '${l10n.titleStopSchedule} · ${stop.name}',
      slivers: slivers,
    );
  }
}

/// A route's full-day timetable (iOS `ScheduleForRouteView`): date and
/// direction pickers, then either the times at one stop grouped by hour
/// (the default, readable by screen readers and at large text) or a
/// horizontally scrollable stop × trip grid.
class RouteSchedulePage extends StatefulWidget {
  const RouteSchedulePage({
    super.key,
    required this.routeId,
    this.date,
    this.stopId,
  });

  final String routeId;
  final DateTime? date;

  /// The rider's stop, preselected and marked.
  final String? stopId;

  @override
  State<RouteSchedulePage> createState() => _RouteSchedulePageState();
}

class _RouteSchedulePageState extends State<RouteSchedulePage> {
  late DateTime _date = _day(widget.date ?? clock.now());
  late ObaLoader<ObaEntryResponse<ScheduleForRoute>> _loader;
  ObaApplication? _app;
  bool _started = false;
  int _direction = 0;
  String? _stopId;
  bool _grid = false;

  @override
  void initState() {
    super.initState();
    _stopId = widget.stopId;
    _loader = _make();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _app = ObaScope.of(context);
    if (!_started) {
      _started = true;
      _loader.load();
    }
  }

  ObaLoader<ObaEntryResponse<ScheduleForRoute>> _make() {
    final date = _date;
    return ObaLoader(() {
      final client = _app?.core.restClient;
      if (client == null) throw StateError('no region');
      return client.schedules.forRoute(widget.routeId, date: date);
    });
  }

  void _setDate(DateTime d) {
    setState(() => _date = d);
    _loader.dispose();
    _loader = _make()..load();
  }

  @override
  void dispose() {
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: _loader, builder: _build);

  Widget _build(BuildContext context, Widget? _) {
    final l10n = context.obaL10n;
    final core = ObaScope.of(context).core;
    final supported = core.currentRegion?.supportsScheduleForRoute ?? true;
    final r = _loader.value;
    final route = r?.references.route(widget.routeId);
    final directions = r == null
        ? const <RouteTimetableDirection>[]
        : routeTimetable(r.entry, r.references);
    final dir = directions.isEmpty
        ? null
        : directions[_direction.clamp(0, directions.length - 1)];
    final slivers = <Widget>[];
    if (!supported) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: ObaEmptyState(
            icon: Icons.table_chart_outlined,
            title: l10n.stopSchedNotSupported,
          ),
        ),
      );
    } else {
      slivers.add(
        SliverToBoxAdapter(
          child: ScheduleDateBar(date: _date, onChanged: _setDate),
        ),
      );
      if (r == null || _loader.loading) {
        slivers.add(
          SliverFillRemaining(
            hasScrollBody: false,
            child: _loader.error != null
                ? ObaErrorState(error: _loader.error, onRetry: _loader.load)
                : const ObaLoadingState(),
          ),
        );
      } else if (dir == null || dir.tripIds.isEmpty) {
        slivers.add(
          SliverFillRemaining(
            hasScrollBody: false,
            child: ObaEmptyState(
              icon: Icons.event_busy_outlined,
              title: l10n.stopSchedEmpty,
            ),
          ),
        );
      } else {
        slivers.add(SliverToBoxAdapter(child: _controls(context, directions)));
        slivers.addAll(
          _grid ? [_gridSliver(context, dir)] : _listSlivers(context, dir),
        );
      }
    }
    final name = route?.shortName ?? route?.longName;
    return ObaSheetPage(
      title: name == null
          ? l10n.titleRouteSchedule
          : '${l10n.titleRouteSchedule} · $name',
      slivers: slivers,
    );
  }

  Widget _controls(BuildContext context, List<RouteTimetableDirection> dirs) {
    final l10n = context.obaL10n;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (dirs.length > 1) ...[
            Semantics(
              container: true,
              header: true,
              child: Text(
                l10n.stopSchedDirection,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < dirs.length; i++)
                  ChoiceChip(
                    label: Text(
                      l10n.stopSchedTo(dirs[i].headsign ?? '${i + 1}'),
                    ),
                    selected: i == _direction.clamp(0, dirs.length - 1),
                    onSelected: (_) => setState(() => _direction = i),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                icon: const Icon(Icons.view_list_outlined),
                label: Text(l10n.stopSchedViewList),
              ),
              ButtonSegment(
                value: true,
                icon: const Icon(Icons.grid_on),
                label: Text(l10n.stopSchedViewGrid),
              ),
            ],
            selected: {_grid},
            showSelectedIcon: false,
            onSelectionChanged: (v) => setState(() => _grid = v.first),
          ),
        ],
      ),
    );
  }

  String _stopName(BuildContext context, (String, Stop?) s) {
    final name = s.$2?.name ?? s.$1;
    return s.$1 == widget.stopId
        ? context.obaL10n.stopSchedYourStop(name)
        : name;
  }

  List<Widget> _listSlivers(BuildContext context, RouteTimetableDirection d) {
    final l10n = context.obaL10n;
    final index = (_stopId == null ? null : d.indexOfStop(_stopId!)) ?? 0;
    final stop = d.stops[index];
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
          child: ListTile(
            leading: const ExcludeSemantics(child: Icon(Icons.place_outlined)),
            title: Text(l10n.stopSchedStop),
            subtitle: Text(_stopName(context, stop)),
            trailing: const ExcludeSemantics(
              child: Icon(Icons.arrow_drop_down),
            ),
            minTileHeight: 48,
            onTap: () => _pickStop(context, d),
          ),
        ),
      ),
      SliverList.list(children: _hourRows(d.timesAtStop(index), clock.now())),
    ];
  }

  Future<void> _pickStop(
    BuildContext context,
    RouteTimetableDirection d,
  ) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (_, controller) => ListView(
          controller: controller,
          children: [
            for (final s in d.stops)
              ListTile(
                title: Text(_stopName(context, s)),
                selected: s.$1 == _stopId,
                minTileHeight: 48,
                onTap: () => Navigator.of(sheetContext).pop(s.$1),
              ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _stopId = picked);
  }

  Widget _gridSliver(BuildContext context, RouteTimetableDirection d) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final border = BorderSide(color: theme.colorScheme.outlineVariant);
    Widget cell(String text, {bool header = false, String? semantics}) =>
        Semantics(
          label: semantics,
          excludeSemantics: semantics != null,
          header: header,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              text,
              style: header
                  ? theme.textTheme.labelLarge
                  : theme.textTheme.bodyMedium,
            ),
          ),
        );
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder(horizontalInside: border),
          children: [
            for (var s = 0; s < d.stops.length; s++)
              TableRow(
                decoration: d.stops[s].$1 == widget.stopId
                    ? BoxDecoration(color: theme.colorScheme.secondaryContainer)
                    : null,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: cell(_stopName(context, d.stops[s]), header: true),
                  ),
                  for (var t = 0; t < d.times.length; t++)
                    cell(
                      d.times[t][s] == null
                          ? '–'
                          : obaClockTime(context, d.times[t][s]!),
                      semantics: l10n.stopSchedCell(
                        d.stops[s].$2?.name ?? d.stops[s].$1,
                        t + 1,
                        d.times[t][s] == null
                            ? l10n.stopSchedNoDeparture
                            : obaClockTime(context, d.times[t][s]!),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
