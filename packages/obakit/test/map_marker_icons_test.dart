// Hosts can draw their own map markers (#10): an icon in the SDK's round
// pin, or a whole custom widget. Either way the SDK keeps the marker's
// screen reader label, its tap and its 48dp target.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'features/bookmarks/bookmarks_support.dart';
import 'support/oba_test_harness.dart';

const _here = Coordinate(47.6062, -122.3321);

class _Building extends StatelessWidget {
  const _Building();
  @override
  Widget build(BuildContext context) => const SizedBox.square(
    dimension: 30,
    child: ColoredBox(color: Color(0xFF1B2F52)),
  );
}

void main() {
  late ObaTestEnv env;
  setUp(() async => env = await ObaTestEnv.create());
  tearDown(() => env.dispose());

  Future<void> pumpMarkers(
    WidgetTester tester,
    List<ObaMapMarker> markers,
  ) async {
    final coordinator = ObaMapCoordinator();
    addTearDown(coordinator.dispose);
    await env.pumpPage(
      tester,
      ObaMapOverlays(
        overlay: ObaMapOverlay(
          markers: markers,
          fitBounds: const RegionRect(
            minLat: 47.6,
            maxLat: 47.61,
            minLon: -122.34,
            maxLon: -122.32,
          ),
        ),
        child: ObaMapView(coordinator: coordinator),
      ),
      coordinator: coordinator,
      presentation: ObaPresentation.embedded,
    );
    await tester.pump();
  }

  testWidgets('by default a place marker shows the place glyph', (
    tester,
  ) async {
    await pumpMarkers(tester, const [
      ObaMapMarker(
        coordinate: _here,
        label: 'Library',
        kind: ObaMapMarkerKind.place,
      ),
    ]);
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Library'),
        matching: find.byIcon(Icons.place),
      ),
      findsOneWidget,
    );
    await unmount(tester);
  });

  testWidgets('an icon replaces the glyph in the SDK pin', (tester) async {
    var taps = 0;
    await pumpMarkers(tester, [
      ObaMapMarker(
        coordinate: _here,
        label: 'Library',
        kind: ObaMapMarkerKind.place,
        icon: Icons.local_library,
        onTap: () => taps++,
      ),
    ]);
    final pin = find.bySemanticsLabel('Library');
    expect(
      find.descendant(of: pin, matching: find.byIcon(Icons.local_library)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: pin, matching: find.byIcon(Icons.place)),
      findsNothing,
    );
    await tester.tap(pin);
    expect(taps, 1);
    await unmount(tester);
  });

  testWidgets('a builder draws the whole marker; the SDK keeps its label, '
      'tap and 48dp target', (tester) async {
    var taps = 0;
    await pumpMarkers(tester, [
      ObaMapMarker(
        coordinate: _here,
        label: 'Geisel Library',
        builder: (_) => const _Building(),
        onTap: () => taps++,
      ),
    ]);
    final pin = find.bySemanticsLabel('Geisel Library');
    expect(pin, findsOneWidget);
    expect(
      find.descendant(of: pin, matching: find.byType(_Building)),
      findsOneWidget,
    );
    // No SDK glyph or round pin around the host's widget.
    expect(find.descendant(of: pin, matching: find.byType(Icon)), findsNothing);
    expect(tester.getSize(pin), const Size.square(kObaMarkerTarget));
    await tester.tap(pin);
    expect(taps, 1);
    await expectObaAccessibility(tester);
    await unmount(tester);
  });

  test('a marker takes an icon or a builder, not both', () {
    expect(
      () => ObaMapMarker(
        coordinate: _here,
        label: 'x',
        icon: Icons.star,
        builder: (_) => const SizedBox(),
      ),
      throwsAssertionError,
    );
  });
}
