import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../widgets/states.dart';
import 'departure_row.dart';
import 'stop_format.dart';

/// Shows [message] in a snack bar (when there is a messenger) and
/// announces it to screen readers.
void stopNotify(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
  obaAnnounce(context, message);
}

/// Opens [uri] outside the app; tells the rider when that fails.
Future<void> stopLaunch(BuildContext context, Uri uri) async {
  var ok = false;
  try {
    ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    ok = false;
  }
  if (!ok && context.mounted) {
    stopNotify(context, context.obaL10n.stopPageCannotOpen);
  }
}

/// Opens walking (or, in bike mode, cycling) directions to [destination]
/// with the maps app chosen in Settings, asking first when set to "ask
/// every time".
Future<void> openStopDirections(
  BuildContext context,
  Coordinate destination,
) async {
  final app = ObaScope.of(context).core;
  final l10n = context.obaL10n;
  var choice = directionsAppFor(app.settings.walkingDirectionsProvider);
  choice ??= await showDialog<DirectionsApp>(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      title: Text(l10n.stopPageDirectionsChooser),
      children: [
        for (final (app, label) in [
          (DirectionsApp.appleMaps, l10n.stopPageAppleMaps),
          (DirectionsApp.googleMaps, l10n.stopPageGoogleMaps),
        ])
          SimpleDialogOption(
            onPressed: () => Navigator.of(dialogContext).pop(app),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(label),
              ),
            ),
          ),
      ],
    ),
  );
  if (choice == null || !context.mounted) return;
  await stopLaunch(
    context,
    walkingDirectionsUrl(
      choice,
      destination,
      bike: app.settings.bikeModeEnabled,
    ),
  );
}

/// Opens the platform share sheet for [uri].
Future<void> stopShare(BuildContext context, Uri uri, {String? subject}) async {
  final box = context.findRenderObject() as RenderBox?;
  try {
    await SharePlus.instance.share(
      ShareParams(
        uri: uri,
        subject: subject,
        sharePositionOrigin: box == null || !box.hasSize
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  } catch (_) {
    if (context.mounted) {
      stopNotify(context, context.obaL10n.stopPageCannotOpen);
    }
  }
}

/// Adds an alarm for [arrival] (after asking for the lead time) or removes
/// its existing one.
Future<void> toggleStopAlarm(
  BuildContext context,
  ArrivalAndDeparture arrival, {
  required DateTime now,
}) async {
  final core = ObaScope.of(context).core;
  final l10n = context.obaL10n;
  final existing = core.alarms.alarmFor(arrival);
  try {
    if (existing != null) {
      await core.alarms.removeAlarm(existing);
      if (context.mounted) stopNotify(context, l10n.stopAlarmRemoved);
      return;
    }
    final choices = alarmLeadTimeChoices(arrival.minutesUntil(now) ?? 0);
    if (choices.isEmpty) return;
    final initial =
        closestAlarmLeadTime(
          choices,
          core.settings.defaultAlarmLeadTimeMinutes,
        ) ??
        choices.last;
    final minutes = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) =>
          _AlarmPicker(choices: choices, initial: initial),
    );
    if (minutes == null) return;
    await core.alarms.createAlarm(
      arrival,
      minutesBefore: minutes,
      title: arrival.routeAndHeadsign(),
    );
    if (context.mounted) stopNotify(context, l10n.stopAlarmSet(minutes));
  } on AlarmUnavailableException catch (e) {
    if (!context.mounted) return;
    stopNotify(
      context,
      e.reason == AlarmUnavailableReason.permissionDenied
          ? l10n.stopAlarmPermissionDenied
          : l10n.stopAlarmFailed,
    );
  } catch (_) {
    if (context.mounted) stopNotify(context, l10n.stopAlarmFailed);
  }
}

class _AlarmPicker extends StatelessWidget {
  const _AlarmPicker({required this.choices, required this.initial});

  final List<int> choices;
  final int initial;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 8),
            child: Semantics(
              container: true,
              header: true,
              child: Text(
                l10n.stopAlarmPickerTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: RadioGroup<int>(
              groupValue: initial,
              onChanged: (v) => Navigator.of(context).pop(v),
              child: ListView(
                controller: controller,
                children: [
                  for (final m in choices)
                    RadioListTile<int>(
                      value: m,
                      title: Text(l10n.stopAlarmLeadTime(m)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The actions a departure row offers (iOS `DepartureRowActions`).
List<ObaDepartureAction> departureActions(
  BuildContext context,
  ArrivalAndDeparture arrival, {
  required DateTime now,
  Stop? stop,
  bool includeShowTrip = true,
}) {
  final app = ObaScope.of(context);
  final core = app.core;
  final l10n = context.obaL10n;
  final nav = ObaNavigator.of(context);
  final region = core.currentRegion;
  final hasAlarm = core.alarms.alarmFor(arrival) != null;
  final shareUrl = region == null
      ? null
      : DeepLinkRouter.tripShareUrl(region: region, arrival: arrival);
  return [
    if (includeShowTrip)
      ObaDepartureAction(
        label: l10n.stopRowShowTrip,
        icon: Icons.directions_bus_outlined,
        onSelected: () => nav.push(TripRoute(TripRef.fromArrival(arrival))),
      ),
    if (hasAlarm || core.alarms.canCreateAlarm(arrival, now))
      ObaDepartureAction(
        label: hasAlarm ? l10n.stopRowRemoveAlarm : l10n.stopRowAddAlarm,
        icon: hasAlarm
            ? Icons.notifications_off_outlined
            : Icons.notifications_outlined,
        onSelected: () => toggleStopAlarm(context, arrival, now: now),
      ),
    if (stop != null)
      ObaDepartureAction(
        label: l10n.stopRowBookmarkTrip,
        icon: Icons.bookmark_add_outlined,
        onSelected: () =>
            nav.push(BookmarkEditorRoute(stop: stop, arrival: arrival)),
      ),
    if (shareUrl != null)
      ObaDepartureAction(
        label: l10n.stopRowShareTrip,
        icon: Icons.share_outlined,
        onSelected: () =>
            stopShare(context, shareUrl, subject: arrival.routeAndHeadsign()),
      ),
    if (region?.supportsScheduleForRoute ?? false)
      ObaDepartureAction(
        label: l10n.stopRowRouteSchedule,
        icon: Icons.calendar_month_outlined,
        onSelected: () => nav.push(
          RouteScheduleRoute(arrival.routeId, stopId: arrival.stopId),
        ),
      ),
    ObaDepartureAction(
      label: l10n.stopRowRouteStops,
      icon: Icons.route_outlined,
      onSelected: () => nav.push(RouteStopsRoute(arrival.routeId)),
    ),
  ];
}

/// "10 - Downtown, arriving 10:42 AM" style text for a transfer banner.
String transferBannerText(BuildContext context, ObaTransferContext t) =>
    context.obaL10n.stopPageTransfer(
      t.fromRouteShortName,
      t.fromTripHeadsign,
      obaClockTime(context, t.arrivalTime),
    );
