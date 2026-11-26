import 'package:flutter/material.dart';

import 'activity_screen.dart';
import 'buy_screen.dart';
import 'map_screen.dart';
import 'wallet_screen.dart';

/// Bottom navigation with Wallet, Map, Buy and Activity, plus the Ride
/// button (on every tab but Map, which has a ticket button in its app
/// bar).
///
/// The tabs live in an `IndexedStack`, so each keeps its state, and the SDK
/// widgets in hidden tabs stop polling and release location by themselves.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  /// The Map tab's index.
  static const mapTab = 1;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          WalletScreen(),
          MapScreen(),
          BuyScreen(),
          ActivityScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Not on the Map tab: there it would cover the map's attribution
      // link and the stop pins along the bottom edge. The Map's app bar has
      // its own ticket button.
      floatingActionButton: _index == HomeShell.mapTab
          ? null
          : FloatingActionButton.extended(
              heroTag: 'ride',
              tooltip: 'Show your ticket',
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Ride'),
              onPressed: () => openRide(context),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Buy',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Activity',
          ),
        ],
      ),
    );
  }
}
