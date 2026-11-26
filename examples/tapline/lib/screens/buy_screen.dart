import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../app_scope.dart';
import '../data/mock_data.dart';
import '../data/models.dart';
import '../data/wallet.dart';
import '../widgets/common.dart';

/// Fare products, host fare advice, and a way into the SDK trip planner.
class BuyScreen extends StatelessWidget {
  const BuyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = TaplineScope.of(context).wallet;
    return Scaffold(
      appBar: AppBar(title: const Text('Buy')),
      body: ListenableBuilder(
        listenable: wallet,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 96),
          children: [
            _FareAdviceCard(wallet: wallet),
            const _PlanTripCard(),
            const SectionHeading('Tickets and passes'),
            for (final p in passProducts) _ProductTile(product: p),
            const SectionHeading('Add stored value'),
            for (final p in topUps) _ProductTile(product: p),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
              child: Text(
                'Sample prices for a demo app. No real payment is taken.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FareAdviceCard extends StatelessWidget {
  const _FareAdviceCard({required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final advice = fareAdvice(wallet);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              'Which fare is right?',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            for (final line in advice)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ExcludeSemantics(
                      child: Icon(Icons.lightbulb_outline, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(line)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Opens the SDK trip planner as its own route. It goes through
/// `ObaNavigator`, so Tapline's `onNavigate` shows it under Tapline's app
/// bar.
// OBA embed: TripPlannerPage, via TripPlannerRoute.
void openTripPlanner(BuildContext context) =>
    ObaNavigator.of(context).push<void>(const TripPlannerRoute());

class _PlanTripCard extends StatelessWidget {
  const _PlanTripCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openTripPlanner(context),
        child: Semantics(
          button: true,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Icon(Icons.alt_route, color: scheme.primary, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Not sure which fare? Plan your trip',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('See the routes and transfers for your journey.'),
                    ],
                  ),
                ),
                const ExcludeSemantics(child: Icon(Icons.chevron_right)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final FareProduct product;

  @override
  Widget build(BuildContext context) {
    final price = formatMoney(product.priceCents);
    return MergeSemantics(
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        leading: ExcludeSemantics(
          child: Icon(
            product.isPass
                ? Icons.confirmation_number_outlined
                : Icons.account_balance_wallet_outlined,
          ),
        ),
        title: Text(product.name),
        subtitle: Text('${product.description}\n$price'),
        trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
        onTap: () => showCheckoutSheet(context, product),
      ),
    );
  }
}

/// The checkout sheet. Confirming is a demo purchase: nothing is charged,
/// and the in-memory wallet is updated.
Future<void> showCheckoutSheet(BuildContext context, FareProduct product) {
  final wallet = TaplineScope.of(context).wallet;
  final messenger = ScaffoldMessenger.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => CheckoutSheet(
      product: product,
      onConfirm: () {
        wallet.purchase(product);
        Navigator.of(sheetContext).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Demo purchase, no charge. ${_purchasedMessage(product, wallet)}',
            ),
          ),
        );
      },
    ),
  );
}

String _purchasedMessage(FareProduct product, Wallet wallet) =>
    product.kind == FareProductKind.storedValue
    ? 'Stored value is now ${formatMoney(wallet.balanceCents)}.'
    : '${product.name} added to your wallet.';

class CheckoutSheet extends StatelessWidget {
  const CheckoutSheet({
    super.key,
    required this.product,
    required this.onConfirm,
  });

  final FareProduct product;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final price = formatMoney(product.priceCents);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text('Checkout', style: text.headlineSmall),
            ),
            const SizedBox(height: 16),
            MergeSemantics(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: text.titleMedium),
                        Text(product.description),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(price, style: text.titleMedium),
                ],
              ),
            ),
            const Divider(height: 32),
            const MergeSemantics(
              child: Row(
                children: [
                  ExcludeSemantics(child: Icon(Icons.credit_card)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Pay with: Demo card (no real payment)'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: onConfirm,
              child: Text('Confirm demo purchase, $price'),
            ),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
