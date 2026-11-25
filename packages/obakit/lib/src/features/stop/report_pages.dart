import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/heading.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../navigation/sheet_detents.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';

enum _SendState { idle, sending, sent, failed }

/// Shared state for the report forms: submission, validation and the
/// screen-reader announcements for each transition.
mixin _ReportForm<W extends StatefulWidget> on State<W> {
  final comment = TextEditingController();
  bool shareLocation = true;
  _SendState sendState = _SendState.idle;
  String? validation;

  /// The region the form was opened in. The stop or trip belongs to it,
  /// so a report must not go to another region's server.
  int? _regionId;
  bool _regionCaptured = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_regionCaptured) return;
    _regionCaptured = true;
    _regionId = ObaScope.of(context).core.currentRegion?.id;
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  bool get canSubmit;

  Future<void> send(Future<void> Function() action) async {
    final l10n = context.obaL10n;
    if (!canSubmit) {
      setState(() => validation = l10n.stopReportChooseProblem);
      obaAnnounce(context, l10n.stopReportChooseProblem);
      return;
    }
    setState(() {
      validation = null;
      sendState = _SendState.sending;
    });
    obaAnnounce(context, l10n.stopReportSending);
    try {
      if (ObaScope.of(context).core.currentRegion?.id != _regionId) {
        throw const ProblemReportUnavailableException('Region changed');
      }
      await action();
      if (!mounted) return;
      setState(() => sendState = _SendState.sent);
      obaAnnounce(context, l10n.stopReportSent);
    } catch (_) {
      if (!mounted) return;
      setState(() => sendState = _SendState.failed);
      obaAnnounce(context, l10n.stopReportFailed);
    }
  }

  Widget heading(String text) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
    child: ObaHeading(text, style: Theme.of(context).textTheme.titleSmall),
  );

  Widget commentField() => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
    child: TextField(
      controller: comment,
      minLines: 2,
      maxLines: 6,
      enabled: sendState != _SendState.sending,
      decoration: InputDecoration(
        labelText: context.obaL10n.stopReportComment,
        border: const OutlineInputBorder(),
      ),
    ),
  );

  Widget locationSwitch() => SwitchListTile(
    value: shareLocation,
    onChanged: sendState == _SendState.sending
        ? null
        : (v) => setState(() => shareLocation = v),
    title: Text(context.obaL10n.stopReportShareLocation),
    subtitle: Text(context.obaL10n.stopReportShareLocationHelp),
  );

  /// The submit button and the status line (sending, sent, failed).
  Widget submitArea({required VoidCallback onSubmit}) {
    final l10n = context.obaL10n;
    final scheme = Theme.of(context).colorScheme;
    final (String? text, Color? color, IconData? icon) = switch (sendState) {
      _SendState.idle => (validation, scheme.error, Icons.error_outline),
      _SendState.sending => (l10n.stopReportSending, null, null),
      _SendState.sent => (
        l10n.stopReportSent,
        scheme.primary,
        Icons.check_circle_outline,
      ),
      _SendState.failed => (l10n.stopReportFailed, scheme.error, Icons.error),
    };
    final showText = text == null && validation != null ? validation : text;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showText != null)
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    if (sendState == _SendState.sending)
                      const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else if (icon != null)
                      Icon(icon, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        showText,
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(color: color),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (sendState == _SendState.sent)
            FilledButton(
              onPressed: () => ObaNavigator.of(context).pop(),
              child: Text(l10n.commonDone),
            )
          else
            FilledButton.icon(
              icon: const Icon(Icons.send),
              label: Text(l10n.stopReportSend),
              onPressed: sendState == _SendState.sending ? null : onSubmit,
            ),
        ],
      ),
    );
  }
}

/// Reports a problem with a stop (iOS `StopProblemView`): what is wrong,
/// an optional comment, and whether to attach the location.
class ReportStopProblemPage extends StatefulWidget {
  const ReportStopProblemPage({super.key, required this.stopId});

  final String stopId;

  @override
  State<ReportStopProblemPage> createState() => _ReportStopProblemPageState();
}

class _ReportStopProblemPageState extends State<ReportStopProblemPage>
    with _ReportForm {
  StopProblemCode? _code;

  @override
  bool get canSubmit => _code != null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final core = ObaScope.of(context).core;
    String label(StopProblemCode c) => switch (c) {
      StopProblemCode.nameWrong => l10n.stopReportStopNameWrong,
      StopProblemCode.numberWrong => l10n.stopReportStopNumberWrong,
      StopProblemCode.locationWrong => l10n.stopReportStopLocationWrong,
      StopProblemCode.routeOrTripMissing => l10n.stopReportRouteMissing,
      StopProblemCode.other => l10n.stopReportOther,
    };
    return ObaSheetPage(
      title: l10n.titleReportStopProblem,
      slivers: [
        SliverList.list(
          children: [
            heading(l10n.stopReportProblemHeader),
            RadioGroup<StopProblemCode>(
              groupValue: _code,
              onChanged: (c) => setState(() {
                _code = c;
                validation = null;
              }),
              child: Column(
                children: [
                  for (final c in StopProblemCode.values)
                    RadioListTile<StopProblemCode>(
                      value: c,
                      title: Text(label(c)),
                      enabled: sendState != _SendState.sending,
                    ),
                ],
              ),
            ),
            commentField(),
            locationSwitch(),
            submitArea(
              onSubmit: () => send(
                () => core.problemReports.reportStopProblem(
                  widget.stopId,
                  code: _code!,
                  comment: comment.text,
                  includeLocation: shareLocation,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Reports a problem with a trip (iOS `VehicleProblemView`): what went
/// wrong, whether the rider is aboard (and the vehicle number), a comment,
/// and whether to attach the location.
class ReportTripProblemPage extends StatefulWidget {
  const ReportTripProblemPage({super.key, required this.trip, this.arrival});

  final TripRef trip;

  /// The arrival the report is about, when known.
  final ArrivalAndDeparture? arrival;

  @override
  State<ReportTripProblemPage> createState() => _ReportTripProblemPageState();
}

class _ReportTripProblemPageState extends State<ReportTripProblemPage>
    with _ReportForm {
  TripProblemCode? _code;
  bool _onVehicle = false;
  final _vehicle = TextEditingController();

  @override
  void initState() {
    super.initState();
    final id = widget.arrival?.vehicleId ?? widget.trip.vehicleId;
    if (id != null) _vehicle.text = id;
  }

  @override
  void dispose() {
    _vehicle.dispose();
    super.dispose();
  }

  @override
  bool get canSubmit => _code != null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final core = ObaScope.of(context).core;
    String label(TripProblemCode c) => switch (c) {
      TripProblemCode.neverCame => l10n.stopReportNeverCame,
      TripProblemCode.cameEarly => l10n.stopReportCameEarly,
      TripProblemCode.cameLate => l10n.stopReportCameLate,
      TripProblemCode.wrongHeadsign => l10n.stopReportWrongHeadsign,
      TripProblemCode.doesNotStopHere => l10n.stopReportNotStopHere,
      TripProblemCode.other => l10n.stopReportOther,
    };
    final arrival = widget.arrival;
    final about = arrival?.routeAndHeadsign();
    return ObaSheetPage(
      title: l10n.titleReportTripProblem,
      slivers: [
        SliverList.list(
          children: [
            if (about != null && about.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: Text(l10n.stopReportAbout(about)),
              ),
            heading(l10n.stopReportProblemHeader),
            RadioGroup<TripProblemCode>(
              groupValue: _code,
              onChanged: (c) => setState(() {
                _code = c;
                validation = null;
              }),
              child: Column(
                children: [
                  for (final c in TripProblemCode.values)
                    RadioListTile<TripProblemCode>(
                      value: c,
                      title: Text(label(c)),
                      enabled: sendState != _SendState.sending,
                    ),
                ],
              ),
            ),
            SwitchListTile(
              value: _onVehicle,
              onChanged: sendState == _SendState.sending
                  ? null
                  : (v) => setState(() => _onVehicle = v),
              title: Text(l10n.stopReportOnVehicle),
            ),
            if (_onVehicle)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                child: TextField(
                  controller: _vehicle,
                  decoration: InputDecoration(
                    labelText: l10n.stopReportVehicleId,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            commentField(),
            locationSwitch(),
            submitArea(
              onSubmit: () => send(
                () => arrival != null
                    ? core.problemReports.reportTripProblem(
                        arrival,
                        code: _code!,
                        userOnVehicle: _onVehicle,
                        comment: comment.text,
                        vehicleId: _onVehicle ? _vehicle.text : null,
                        includeLocation: shareLocation,
                      )
                    : core.problemReports.reportTripProblemFor(
                        tripId: widget.trip.tripId,
                        serviceDate: widget.trip.serviceDate,
                        code: _code!,
                        userOnVehicle: _onVehicle,
                        vehicleId: _onVehicle
                            ? _vehicle.text
                            : widget.trip.vehicleId,
                        stopId: widget.trip.stopId,
                        comment: comment.text,
                        includeLocation: shareLocation,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Reports a vehicle that never came to the region's Obaco server.
final class GhostBusReportRoute extends ObaCustomRoute {
  const GhostBusReportRoute(this.arrival);

  final ArrivalAndDeparture arrival;

  @override
  String get id => 'ghostBusReport-${arrival.tripId}-${arrival.stopId}';

  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;

  @override
  Widget build(BuildContext context) => GhostBusReportPage(arrival: arrival);
}

/// The ghost-bus form (iOS `GhostBusReportView`): how long the rider
/// waited, a comment, and whether to share the location.
class GhostBusReportPage extends StatefulWidget {
  const GhostBusReportPage({super.key, required this.arrival});

  final ArrivalAndDeparture arrival;

  @override
  State<GhostBusReportPage> createState() => _GhostBusReportPageState();
}

class _GhostBusReportPageState extends State<GhostBusReportPage>
    with _ReportForm {
  static const _waits = [5, 10, 15, 20, 30];
  int _wait = 15;

  @override
  bool get canSubmit => true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final core = ObaScope.of(context).core;
    final a = widget.arrival;
    final scheduled = a.scheduledDate;
    return ObaSheetPage(
      title: l10n.stopGhostTitle,
      slivers: [
        SliverList.list(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: Text(l10n.stopGhostExplain),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: Text(
                l10n.stopReportAbout(
                  [
                    a.routeAndHeadsign(),
                    if (scheduled != null) obaClockTime(context, scheduled),
                  ].join(' · '),
                ),
              ),
            ),
            heading(l10n.stopGhostWait),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final w in _waits)
                    ChoiceChip(
                      label: Text(
                        w == 30
                            ? l10n.stopGhostWaitThirtyPlus
                            : l10n.stopGhostWaitMinutes(w),
                      ),
                      selected: _wait == w,
                      onSelected: (_) => setState(() => _wait = w),
                    ),
                ],
              ),
            ),
            commentField(),
            locationSwitch(),
            submitArea(
              onSubmit: () => send(
                () => core.problemReports.reportGhostBus(
                  a,
                  waitDurationMinutes: _wait,
                  comment: comment.text,
                  includeLocation: shareLocation,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
