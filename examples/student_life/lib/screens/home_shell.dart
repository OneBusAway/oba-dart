import 'package:flutter/material.dart';

import 'campus_tab.dart';
import 'me_tab.dart';
import 'today_tab.dart';
import 'transit_tab.dart';

/// Bottom navigation over four tabs kept alive in an [IndexedStack].
///
/// SDK widgets in a hidden tab notice it and stop polling (and release
/// location) by themselves; the host does nothing.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _index,
      children: const [TodayTab(), TransitTab(), CampusTab(), MeTab()],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.today_outlined),
          selectedIcon: Icon(Icons.today),
          label: 'Today',
        ),
        NavigationDestination(
          icon: Icon(Icons.directions_bus_outlined),
          selectedIcon: Icon(Icons.directions_bus),
          label: 'Transit',
        ),
        NavigationDestination(
          icon: Icon(Icons.location_city_outlined),
          selectedIcon: Icon(Icons.location_city),
          label: 'Campus',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Me',
        ),
      ],
    ),
  );
}
