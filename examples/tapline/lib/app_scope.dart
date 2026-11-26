import 'package:flutter/widgets.dart';

import 'data/wallet.dart';

/// Host state shared by every Tapline screen: the wallet and the
/// "Show OBA embeds" toggle. Sits above the navigator (in
/// `MaterialApp.builder`), so pushed routes and sheets see it too.
class TaplineScope extends InheritedWidget {
  const TaplineScope({
    super.key,
    required this.wallet,
    required this.showEmbeds,
    required super.child,
  });

  final Wallet wallet;

  /// Whether [EmbedFrame]s outline the embedded SDK widgets. Off by default.
  final ValueNotifier<bool> showEmbeds;

  static TaplineScope of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<TaplineScope>();
    assert(scope != null, 'No TaplineScope above this context');
    return scope!;
  }

  @override
  bool updateShouldNotify(TaplineScope oldWidget) =>
      !identical(wallet, oldWidget.wallet) ||
      !identical(showEmbeds, oldWidget.showEmbeds);
}
