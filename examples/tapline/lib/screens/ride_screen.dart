import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../app_scope.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../widgets/common.dart';
import '../widgets/embed_frame.dart';
import '../widgets/ticket_code.dart';

/// The active ticket, shown full screen to a driver or validator, with
/// departures from the stop of the rider's last tap (or near the rider)
/// below it.
class RideScreen extends StatelessWidget {
  const RideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = TaplineScope.of(context).wallet;
    return Scaffold(
      appBar: AppBar(title: const Text('Your ticket')),
      body: ListenableBuilder(
        listenable: wallet,
        builder: (context, _) {
          final text = Theme.of(context).textTheme;
          final pass = wallet.activePass;
          final now = wallet.now();
          final ticketName = pass?.product.name ?? 'Stored value';
          final validity = pass == null
              ? '${formatMoney(wallet.balanceCents)} left · '
                    '${formatMoney(oneRide.priceCents)} per ride'
              : passValidity(context, pass, now);
          final lastTap = wallet.lastTap;
          final lastStopId = lastTap?.stopId;
          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        ticketName,
                        style: text.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(validity, style: text.titleMedium),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: RotatingTicketToken(
                      passId: pass?.id ?? 'stored-value',
                      now: wallet.now,
                      builder: (context, token) => TicketCode(
                        token: token,
                        label:
                            'Ticket code for $ticketName, $validity. '
                            'Show it to the driver or hold it to the '
                            'validator. It changes every 30 seconds.',
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: LiveTicketBand(),
              ),
              const _Note(
                icon: Icons.verified_outlined,
                text:
                    'Live ticket. On a real ticket the band moves and the '
                    'code changes every 30 seconds. Screenshots are not '
                    'valid.',
              ),
              const _Note(
                icon: Icons.brightness_high_outlined,
                text:
                    'Turn your screen brightness up so the validator can '
                    'read the code.',
              ),
              const SizedBox(height: 8),
              if (lastStopId != null)
                // OBA embed: ObaStopDeparturesCard — live departures at the
                // stop of the rider's last tap. Not "your next ride": on a
                // return trip the rider is somewhere else. Tapping a
                // departure opens the SDK's TripPage through Tapline's
                // onNavigate.
                EmbedFrame(
                  sdkWidget: 'ObaStopDeparturesCard',
                  child: ObaStopDeparturesCard(
                    stopId: lastStopId,
                    // The card shows the stop's name under this title.
                    title: 'Ride again',
                  ),
                )
              else
                // OBA embed: ObaNearbyStopsCard — no tap with a known stop
                // yet, so departures near the rider instead.
                const EmbedFrame(
                  sdkWidget: 'ObaNearbyStopsCard',
                  child: ObaNearbyStopsCard(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(child: Icon(icon)),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
