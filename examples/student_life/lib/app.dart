import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import 'chosen_trip.dart';
import 'screens/home_shell.dart';
import 'settings.dart';
import 'theme.dart';
import 'widgets/host_page.dart';

/// The Student Life host app.
///
/// One `ObaScope` sits above the navigator (`MaterialApp.builder`), so
/// every route, the host's and the SDK's, can show SDK widgets. Its
/// `onNavigate` takes every SDK destination (stops, trips, schedules,
/// alerts, the trip planner...) and shows it under the host's own app bar
/// (see `hostObaRoute`).
class StudentLifeApp extends StatefulWidget {
  const StudentLifeApp({
    super.key,
    required this.oba,
    required this.settings,
    this.home = const HomeShell(),
  });

  final ObaApplication oba;
  final StudentLifeSettings settings;

  /// The first screen. Tests swap in a single screen here.
  final Widget home;

  @override
  State<StudentLifeApp> createState() => _StudentLifeAppState();
}

class _StudentLifeAppState extends State<StudentLifeApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  /// The itinerary the student last chose in the trip planner (Today shows
  /// it).
  final _chosenTrip = ChosenTrip();

  @override
  void dispose() {
    _chosenTrip.dispose();
    super.dispose();
  }

  // Every SDK destination opens as a host route, so the host's app bar is
  // the only one on every page. Returning true for every route means the
  // SDK never pushes a page of its own.
  bool _onNavigate(BuildContext context, ObaRoute route) {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return false;
    navigator.push(hostObaRoute<void>(route));
    return true;
  }

  @override
  Widget build(BuildContext context) => SettingsScope(
    settings: widget.settings,
    child: ValueListenableBuilder<ThemeMode>(
      valueListenable: widget.settings.themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'Student Life',
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: buildStudentLifeTheme(Brightness.light),
        darkTheme: buildStudentLifeTheme(Brightness.dark),
        themeMode: mode,
        localizationsDelegates: obaLocalizationsDelegates,
        supportedLocales: obaSupportedLocales,
        builder: (context, child) => ChosenTripScope(
          trip: _chosenTrip,
          child: ObaScope(
            application: widget.oba,
            onNavigate: _onNavigate,
            child: child!,
          ),
        ),
        home: widget.home,
      ),
    ),
  );
}
