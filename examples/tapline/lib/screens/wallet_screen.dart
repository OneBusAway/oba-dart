import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../app_scope.dart';
import '../widgets/balance_card.dart';
import '../widgets/common.dart';
import '../widgets/embed_frame.dart';
import 'ride_screen.dart';

/// Opens the full-screen ticket.
void openRide(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RideScreen()));

/// Home: balance, the Ride button, then live transit from the SDK.
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
        builder: (context, _) {
          final lastTap = wallet.lastTap;
          return ListView(
            // Room for the floating Ride button.
            padding: const EdgeInsets.only(top: 8, bottom: 96),
            children: [
              BalanceCard(wallet: wallet),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(64),
                    textStyle: Theme.of(context).textTheme.titleLarge,
                  ),
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text('Ride'),
                  onPressed: () => openRide(context),
                ),
              ),
              // OBA embed: ServiceAlertsSection — urgent unread alerts for
              // the region. Renders nothing when there are none, so it can
              // sit permanently at the top of a fare app's home.
              const EmbedFrame(
                sdkWidget: 'ServiceAlertsSection',
                child: ServiceAlertsSection(),
              ),
              // OBA embed: ObaNearbyStopsCard — "Departures near you", a
              // self-contained card that polls only while visible.
              const EmbedFrame(
                sdkWidget: 'ObaNearbyStopsCard',
                child: ObaNearbyStopsCard(),
              ),
              if (lastTap != null) ...[
                const SectionHeading('From your last ride'),
                // OBA embed: ObaStopDeparturesCard — the next departures
                // from the stop of the rider's most recent tap.
                EmbedFrame(
                  sdkWidget: 'ObaStopDeparturesCard',
                  child: ObaStopDeparturesCard(
                    stopId: lastTap.stopId,
                    maxArrivals: 2,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
