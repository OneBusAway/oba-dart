// Tile styles a host can choose: high-density raster tiles and a custom
// (for example vector) base layer, with a raster fallback for the trip
// planner's itinerary map.
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import 'features/bookmarks/bookmarks_support.dart';
import 'support/oba_test_harness.dart';

const _retinaTiles = ObaTileSource(
  urlTemplate: 'https://tiles.example/{z}/{x}/{y}{r}.png',
  attribution: 'Example Tiles',
);

const _fallback = ObaTileSource(
  urlTemplate: 'https://raster.example/{z}/{x}/{y}{r}.png',
  attribution: 'Raster Example',
);

class _FakeVectorLayer extends StatelessWidget {
  const _FakeVectorLayer();
  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

final _custom = ObaTileSource.custom(
  layerBuilder: (_) => const _FakeVectorLayer(),
  attribution: 'Vector Example',
  rasterFallback: _fallback,
);

void main() {
  group('retina', () {
    test('is automatic for templates with {r} on high-density screens', () {
      expect(_retinaTiles.usesRetina(highDensity: true), isTrue);
      expect(_retinaTiles.usesRetina(highDensity: false), isFalse);
      // No {r}: simulated retina would shrink labels, so it stays off.
      expect(
        ObaTileSource.openStreetMap.usesRetina(highDensity: true),
        isFalse,
      );
      const forced = ObaTileSource(
        urlTemplate: 'https://x/{z}/{x}/{y}.png',
        attribution: 'X',
        retinaMode: true,
      );
      expect(forced.usesRetina(highDensity: false), isTrue);
      expect(_custom.usesRetina(highDensity: true), isFalse);
    });

    testWidgets('the map passes it to the tile layer', (tester) async {
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetDevicePixelRatio);
      final env = await ObaTestEnv.create(streetTiles: _retinaTiles);
      addTearDown(env.dispose);
      await env.pumpPage(
        tester,
        const ObaMapView(),
        presentation: ObaPresentation.embedded,
      );
      final layer = tester.widget<fm.TileLayer>(find.byType(fm.TileLayer));
      expect(layer.resolvedRetinaMode, fm.RetinaMode.server);
      await unmount(tester);
    });
  });

  group('custom base layer', () {
    test('raster sources are their own raster; custom ones fall back', () {
      expect(_retinaTiles.raster, same(_retinaTiles));
      expect(_custom.raster, same(_fallback));
      expect(_custom.urlTemplate, isNull);
      expect(
        ObaTileSource.custom(
          layerBuilder: (_) => const SizedBox(),
          attribution: 'V',
        ).raster,
        same(ObaTileSource.openStreetMap),
      );
    });

    testWidgets('replaces the raster tiles, with its own attribution', (
      tester,
    ) async {
      final env = await ObaTestEnv.create(streetTiles: _custom);
      addTearDown(env.dispose);
      await env.pumpPage(
        tester,
        const ObaMapView(),
        presentation: ObaPresentation.embedded,
      );
      expect(find.byType(_FakeVectorLayer), findsOneWidget);
      expect(find.byType(fm.TileLayer), findsNothing);
      expect(find.text('© Vector Example'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('the trip planner map uses the raster fallback', (
      tester,
    ) async {
      final env = await ObaTestEnv.create(streetTiles: _custom);
      addTearDown(env.dispose);
      await env.pumpPage(
        tester,
        const TripPlannerPage(),
        presentation: ObaPresentation.embedded,
      );
      final view = tester.widget<tp.TripPlannerView>(
        find.byType(tp.TripPlannerView),
      );
      expect(view.mapConfig.tileUrlTemplate, _fallback.urlTemplate);
      expect(view.mapConfig.attribution, 'Raster Example');
      await unmount(tester);
    });
  });
}
