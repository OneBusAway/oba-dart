import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../app_scope.dart';
import '../data/models.dart';
import '../widgets/common.dart';
import '../widgets/embed_frame.dart';

/// Tap history.
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = TaplineScope.of(context).wallet;
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: ListenableBuilder(
        listenable: wallet,
        builder: (context, _) {
          final taps = wallet.taps;
          if (taps.isEmpty) {
            return const Center(child: Text('No rides yet'));
          }
          return ListView.separated(
            padding: const EdgeInsets.only(top: 8, bottom: 96),
            itemCount: taps.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => TapRow(tap: taps[i]),
          );
        },
      ),
    );
  }
}

class TapRow extends StatelessWidget {
  const TapRow({super.key, required this.tap});

  final Tap tap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final when = formatDateTime(context, tap.time);
    final fare = formatMoney(tap.chargedCents);
    final stopName = tap.stopName;
    final from = stopName == null ? '' : ', from $stopName';
    final sentence =
        'Route ${tap.routeShortName}, ${tap.routeName}$from. '
        '$when. Fare $fare, paid with ${tap.paidWith}.';
    return Semantics(
      button: true,
      label: sentence,
      excludeSemantics: true,
      onTap: () => openTapDetail(context, tap),
      child: InkWell(
        onTap: () => openTapDetail(context, tap),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 8, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HostRouteBadge(tap.routeShortName),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The route name when the validator didn't record
                      // the stop.
                      Text(stopName ?? tap.routeName, style: text.titleMedium),
                      Text(when, style: text.bodyMedium),
                      Text(
                        '$fare · ${tap.paidWith}',
                        style: text.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void openTapDetail(BuildContext context, Tap tap) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => TapDetailScreen(tap: tap)));

/// One tap: the fare breakdown, and live departures to ride again.
class TapDetailScreen extends StatelessWidget {
  const TapDetailScreen({super.key, required this.tap});

  final Tap tap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final stopId = tap.stopId;
    return Scaffold(
      appBar: AppBar(title: const Text('Ride details')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                HostRouteBadge(tap.routeShortName),
                Semantics(
                  header: true,
                  child: Text(tap.routeName, style: text.titleLarge),
                ),
              ],
            ),
          ),
          // The stop's name is in the departures card's title below, so it
          // isn't repeated here.
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: Text(formatDateTime(context, tap.time)),
          ),
          const SectionHeading('Fare'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _FareLine('Base fare', formatMoney(tap.baseFareCents)),
                  if (tap.paidWithStoredValue) ...[
                    const Divider(height: 24),
                    _FareLine(
                      'Deducted from stored value',
                      formatMoney(tap.chargedCents),
                      bold: true,
                    ),
                  ] else ...[
                    _FareLine(
                      'Covered by ${tap.paidWith}',
                      formatMoney(-tap.coveredCents),
                    ),
                    const Divider(height: 24),
                    _FareLine(
                      'Charged (${tap.paidWith})',
                      formatMoney(tap.chargedCents),
                      bold: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (stopId != null) ...[
            const SizedBox(height: 16),
            // OBA embed: ObaStopDeparturesCard — live departures at the
            // stop of this tap, so a past ride turns into the next one. The
            // card shows the stop's name under the host's title, and this is
            // the only place it appears.
            EmbedFrame(
              sdkWidget: 'ObaStopDeparturesCard',
              child: ObaStopDeparturesCard(stopId: stopId, title: 'Ride again'),
            ),
          ],
        ],
      ),
    );
  }
}

class _FareLine extends StatelessWidget {
  const _FareLine(this.label, this.amount, {this.bold = false});

  final String label;
  final String amount;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700)
        : Theme.of(context).textTheme.bodyLarge;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label, style: style)),
            const SizedBox(width: 12),
            Text(amount, style: style),
          ],
        ),
      ),
    );
  }
}
