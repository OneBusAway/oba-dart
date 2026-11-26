import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

import 'shuttle_card.dart';

class AllArrivalsPage extends StatelessWidget {
  const AllArrivalsPage({super.key, required this.controller});

  /// Shared with the card that pushed this page.
  final ArrivalsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arrivals')),
      body: SingleChildScrollView(
        child: SafeArea(
          child: ObaArrivalsPanel(
            controller: controller,
            onArrivalTap: (a) => showArrivalSnackBar(context, a),
          ),
        ),
      ),
    );
  }
}
