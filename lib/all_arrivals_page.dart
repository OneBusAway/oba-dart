import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

import 'demo_stops.dart';
import 'shuttle_card.dart';

class AllArrivalsPage extends StatelessWidget {
  const AllArrivalsPage({super.key, required this.client, required this.stop});

  final OneBusAwayClient client;
  final DemoStop stop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arrivals')),
      body: SingleChildScrollView(
        child: SafeArea(
          child: ObaArrivalsPanel(
            client: client,
            stopId: stop.id,
            onArrivalTap: (a) => showArrivalSnackBar(context, a),
          ),
        ),
      ),
    );
  }
}
