import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

import 'shuttle_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.client,
    required this.isDark,
    required this.onToggleDark,
  });

  final OneBusAwayClient client;
  final bool isDark;
  final VoidCallback onToggleDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UC San Diego',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleDark,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ShuttleCard(client: client),
          const SizedBox(height: 12),
          const _PlaceholderCard(title: 'MY STUDENT CHART'),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
