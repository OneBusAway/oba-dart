@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

import '../support/fixtures.dart';

/// Finds `<flutter>/bin/cache/artifacts/material_fonts` by walking up from
/// the flutter_tester executable.
Directory materialFontsDir() {
  var dir = File(Platform.resolvedExecutable).parent;
  while (dir.parent.path != dir.path) {
    final candidate =
        Directory('${dir.path}/bin/cache/artifacts/material_fonts');
    if (candidate.existsSync()) return candidate;
    dir = dir.parent;
  }
  throw StateError('material_fonts not found above ${Platform.resolvedExecutable}');
}

Future<void> loadFonts() async {
  final fonts = materialFontsDir();
  Future<ByteData> bytes(String name) async =>
      ByteData.sublistView(File('${fonts.path}/$name').readAsBytesSync());
  final roboto = FontLoader('Roboto')
    ..addFont(bytes('Roboto-Regular.ttf'))
    ..addFont(bytes('Roboto-Medium.ttf'))
    ..addFont(bytes('Roboto-Bold.ttf'));
  final icons = FontLoader('MaterialIcons')
    ..addFont(bytes('MaterialIcons-Regular.otf'));
  await Future.wait([roboto.load(), icons.load()]);
}

/// Goldens contain local times, so they only match in US Pacific time.
final bool inPacificTime =
    fixtureServerTime.toLocal().timeZoneOffset == const Duration(hours: -7);

void main() {
  final skip = !Platform.isMacOS || !inPacificTime
      ? 'Goldens are generated on macOS with TZ=America/Los_Angeles'
      : null;

  setUpAll(loadFonts);

  for (final (name, theme) in [
    ('light', ThemeData(colorSchemeSeed: const Color(0xFF182B49))),
    ('dark', ThemeData(
        colorSchemeSeed: const Color(0xFF182B49), brightness: Brightness.dark)),
  ]) {
    testWidgets('panel $name', (tester) async {
      tester.view.physicalSize = const Size(400, 520);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          body: ObaArrivalsPanel(
            client: fakeClient((_) async => okResponse()),
            stopId: 'MTS_24151',
            onArrivalTap: (_) {},
          ),
        ),
      ));
      await tester.pump();
      await tester.pump();

      await expectLater(
        find.byType(ObaArrivalsPanel),
        matchesGoldenFile('goldens/panel_$name.png'),
      );
    }, skip: skip != null);
  }
}
