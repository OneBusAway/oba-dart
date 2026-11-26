import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import 'app_scope.dart';
import 'data/wallet.dart';
import 'screens/home_shell.dart';
import 'theme.dart';

/// The Tapline app. Takes the OneBusAway application and the wallet from
/// outside, so tests can pass fakes.
class TaplineApp extends StatefulWidget {
  const TaplineApp({
    super.key,
    required this.application,
    required this.wallet,
    this.home,
  });

  final ObaApplication application;
  final Wallet wallet;

  /// Replaces the home shell (tests).
  final Widget? home;

  @override
  State<TaplineApp> createState() => _TaplineAppState();
}

class _TaplineAppState extends State<TaplineApp> {
  final _showEmbeds = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _showEmbeds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tapline',
      debugShowCheckedModeBanner: false,
      theme: TaplineTheme.light(),
      darkTheme: TaplineTheme.dark(),
      // The SDK's strings plus Material's. Tapline's own strings are
      // English only in this sample.
      localizationsDelegates: obaLocalizationsDelegates,
      supportedLocales: const [Locale('en')],
      // One ObaScope above the navigator covers every route: Tapline's own,
      // its bottom sheets, and the pages the SDK pushes.
      builder: (context, child) => TaplineScope(
        wallet: widget.wallet,
        showEmbeds: _showEmbeds,
        child: ObaScope(application: widget.application, child: child!),
      ),
      home: widget.home ?? const HomeShell(),
    );
  }
}
