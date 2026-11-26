import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import 'data/campus.dart';
import 'screens/home_shell.dart';
import 'settings.dart';
import 'theme.dart';
import 'widgets/host_page.dart';

/// The Student Life host app.
///
/// One `ObaScope` sits above the navigator (`MaterialApp.builder`), so
/// every route, the host's and the SDK's, can show SDK widgets. Its
/// `onNavigate` takes stop pages and shows them under the host's own app
/// bar; every other SDK destination (trips, schedules, alerts...) is left
/// to the SDK, which pushes its own full-screen page.
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

  bool _onNavigate(BuildContext context, ObaRoute route) {
    if (route is! StopRoute) return false;
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return false;
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => HostObaPage(
          title: campusStopById(route.stopId)?.name ?? 'Stop',
          sdkWidget: 'StopPage',
          // The page shows the stop's name and its actions (refresh,
          // bookmark, more) in its own compact header.
          showsHeader: true,
          // OBA embed: the full stop page, in a host route.
          child: StopPage(stopId: route.stopId),
        ),
      ),
    );
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
        builder: (context, child) => ObaScope(
          application: widget.oba,
          onNavigate: _onNavigate,
          child: child!,
        ),
        home: widget.home,
      ),
    ),
  );
}
