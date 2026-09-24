import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

import 'all_arrivals_page.dart';
import 'demo_stops.dart';

void showArrivalSnackBar(BuildContext context, ArrivalAndDeparture arrival) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('${arrival.routeShortName ?? ''} → ${arrival.tripHeadsign ?? ''}'),
  ));
}

/// The Student Life "Shuttle" card, powered by ObaArrivalsPanel.
class ShuttleCard extends StatefulWidget {
  const ShuttleCard({super.key, required this.client});

  final OneBusAwayClient client;

  @override
  State<ShuttleCard> createState() => _ShuttleCardState();
}

class _ShuttleCardState extends State<ShuttleCard> {
  DemoStop _stop = demoStops.first;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 4, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text('SHUTTLE',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ),
                PopupMenuButton<DemoStop>(
                  tooltip: 'Choose stop',
                  icon: const Icon(Icons.more_vert),
                  initialValue: _stop,
                  onSelected: (stop) => setState(() => _stop = stop),
                  itemBuilder: (_) => [
                    for (final stop in demoStops)
                      PopupMenuItem(value: stop, child: Text(stop.label)),
                  ],
                ),
              ],
            ),
          ),
          ObaArrivalsPanel(
            client: widget.client,
            stopId: _stop.id,
            maxArrivals: 3,
            onArrivalTap: (a) => showArrivalSnackBar(context, a),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      AllArrivalsPage(client: widget.client, stop: _stop),
                )),
                child: const Text('SEE ALL ARRIVALS'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
