import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import 'app_scope.dart';
import 'data/wallet.dart';
import 'screens/home_shell.dart';
import 'theme.dart';
import 'widgets/host_oba_page.dart';

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
  final _plannedTrip = ValueNotifier<tp.Itinerary?>(null);
  final _navigatorKey = GlobalKey<NavigatorState>();

  // Every SDK destination (stops, trips, schedules, alerts, the trip
  // planner...) opens as a Tapline route, so Tapline's app bar is the only
  // one on every page. Returning true for every route means the SDK never
  // pushes a page of its own.
  bool _onNavigate(BuildContext context, ObaRoute route) {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return false;
    navigator.push(hostObaRoute<void>(route));
    return true;
  }

  @override
  void dispose() {
    _showEmbeds.dispose();
    _plannedTrip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tapline',
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: TaplineTheme.light(),
      darkTheme: TaplineTheme.dark(),
      // The SDK's strings plus Material's. Tapline's own strings are
      // English only in this sample.
      localizationsDelegates: obaLocalizationsDelegates,
      supportedLocales: const [Locale('en')],
      // One ObaScope above the navigator covers every route: Tapline's own,
      // its bottom sheets, and the SDK pages its onNavigate pushes.
      builder: (context, child) => TaplineScope(
        wallet: widget.wallet,
        showEmbeds: _showEmbeds,
        plannedTrip: _plannedTrip,
        child: ObaScope(
          application: widget.application,
          onNavigate: _onNavigate,
          child: child!,
        ),
      ),
      home: widget.home ?? const HomeShell(),
    );
  }
}
