import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../app_scope.dart';
import '../widgets/balance_card.dart';
import '../widgets/embed_frame.dart';
import 'ride_screen.dart';

/// Opens the full-screen ticket.
void openRide(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RideScreen()));

/// Home: balance, then live transit from the SDK. The shell's floating
/// Ride button opens the ticket.
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = TaplineScope.of(context);
    final wallet = scope.wallet;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tapline'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: scope.showEmbeds,
            builder: (context, show, _) => IconButton(
              isSelected: show,
              icon: const Icon(Icons.border_clear),
              selectedIcon: const Icon(Icons.border_outer),
              tooltip: show ? 'Hide OBA embeds' : 'Show OBA embeds',
              onPressed: () => scope.showEmbeds.value = !show,
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: wallet,
        builder: (context, _) => ListView(
          // Room for the floating Ride button, the one way to the ticket.
          padding: const EdgeInsets.only(top: 8, bottom: 96),
          children: [
            BalanceCard(wallet: wallet),
            // OBA embed: ServiceAlertsSection — urgent unread alerts for
            // the rider's stops. Renders nothing when there are none, so it
            // can sit permanently at the top of a fare app's home.
            const EmbedFrame(
              sdkWidget: 'ServiceAlertsSection',
              child: ServiceAlertsSection(),
            ),
            // OBA embed: ObaNearbyStopsCard — "Departures near you", a
            // self-contained card that polls only while visible. Departures
            // from the last tap's stop are on the Ride screen, so they
            // aren't repeated here.
            const EmbedFrame(
              sdkWidget: 'ObaNearbyStopsCard',
              child: ObaNearbyStopsCard(),
            ),
          ],
        ),
      ),
    );
  }
}
