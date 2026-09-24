import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import 'home_page.dart';

const _navy = Color(0xFF182B49);
const _gold = Color(0xFFFFCD00);

/// A stand-in for the UCSD Student Life app shell.
class StudentLifeDemoApp extends StatefulWidget {
  const StudentLifeDemoApp({super.key, required this.client});

  final OneBusAwayClient client;

  @override
  State<StudentLifeDemoApp> createState() => _StudentLifeDemoAppState();
}

class _StudentLifeDemoAppState extends State<StudentLifeDemoApp> {
  ThemeMode _mode = ThemeMode.light;

  ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _navy,
      brightness: brightness,
    ).copyWith(secondary: _gold, onSecondary: Colors.black);
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      scaffoldBackgroundColor:
          brightness == Brightness.light ? const Color(0xFFE9ECF2) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBA Arrivals Demo',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: _mode,
      home: HomePage(
        client: widget.client,
        isDark: _mode == ThemeMode.dark,
        onToggleDark: () => setState(() {
          _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
      ),
    );
  }
}
