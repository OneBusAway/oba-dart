import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/states.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/rows.dart';

/// The user's departure alarms that are still to come, each removable.
/// Renders nothing when there are none. (Creating alarms needs a push
/// provider; listing and removing what is stored never does.)
class AlarmsSection extends StatelessWidget {
  const AlarmsSection({super.key});

  Future<void> _remove(BuildContext context, StoredAlarm alarm) async {
    final l10n = context.obaL10n;
    final alarms = ObaScope.of(context).core.alarms;
    String message;
    try {
      await alarms.removeAlarm(alarm);
      message = l10n.alarmsDeleted;
    } on Object {
      message = l10n.alarmsDeleteFailed;
    }
    if (context.mounted) obaNotify(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final store = ObaScope.of(context).core.userData;
    final l10n = context.obaL10n;
    return ListenableBuilder(
      listenable: store.listenable,
      builder: (context, _) {
        final now = clock.now();
        final due = [
          for (final a in store.alarms)
            if (a.deepLink != null && !a.isExpiredAt(now)) a,
        ];
        if (due.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ObaSectionHeader(title: l10n.alarmsSectionTitle),
            for (final alarm in due)
              _AlarmRow(alarm: alarm, onRemove: () => _remove(context, alarm)),
          ],
        );
      },
    );
  }
}

class _AlarmRow extends StatelessWidget {
  const _AlarmRow({required this.alarm, required this.onRemove});

  final StoredAlarm alarm;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final link = alarm.deepLink!;
    final time = alarm.tripDate == null
        ? ''
        : obaClockTime(context, alarm.tripDate!);
    final minutes = alarm.leadTimeMinutes;
    final details = minutes == null
        ? time
        : l10n.alarmsRowDetails(minutes, time);
    final row = ObaListRow(
      leading: const Icon(Icons.alarm),
      title: link.title,
      subtitle: details,
      semanticLabel: l10n.alarmsRowLabel(link.title, details),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        tooltip: l10n.alarmsDelete(link.title),
        onPressed: onRemove,
      ),
      onTap: () => ObaNavigator.of(context).push<void>(
        TripRoute(
          TripRef(
            tripId: link.tripId,
            serviceDate: link.serviceDate,
            vehicleId: link.vehicleId,
            stopId: link.stopId,
            stopSequence: link.stopSequence,
            destinationStopId: link.destinationStopId,
          ),
        ),
      ),
    );
    return MergeSemantics(
      child: Semantics(
        customSemanticsActions: {
          CustomSemanticsAction(label: l10n.alarmsDelete(link.title)): onRemove,
        },
        child: row,
      ),
    );
  }
}
