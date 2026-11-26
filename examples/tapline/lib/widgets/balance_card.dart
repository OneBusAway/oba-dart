import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/wallet.dart';
import '../theme.dart';
import 'common.dart';

/// Stored value and the active pass, on the brand teal.
class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final pass = wallet.activePass;
    final now = wallet.now();
    final balance = formatMoney(wallet.balanceCents);
    final passLine = pass == null
        ? 'No active pass'
        : '${pass.product.name} · ${passValidity(context, pass, now)}';
    return Card(
      color: TaplineColors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Semantics(
        container: true,
        label: 'Stored value $balance. $passLine.',
        excludeSemantics: true,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stored value',
                style: text.labelLarge?.copyWith(color: Colors.white),
              ),
              Text(
                balance,
                style: text.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: pass == null ? Colors.white : TaplineColors.saffron,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        pass == null
                            ? Icons.info_outline
                            : Icons.confirmation_number_outlined,
                        size: 18,
                        color: TaplineColors.ink,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          pass == null ? passLine : 'Active: $passLine',
                          style: text.labelLarge?.copyWith(
                            color: TaplineColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
