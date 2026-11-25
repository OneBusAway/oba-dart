// Right-to-left (Arabic) layout: key rows mirror, directional arrows flip,
// and the wide layout's side panel moves to the right. Each check compares
// with English so a regression to a left/right-fixed layout fails here.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import '../support/oba_test_harness.dart';

const arabic = Locale('ar');
const english = Locale('en');

final trip = TripRef(
  tripId: '1_18196913',
  serviceDate: DateTime.fromMillisecondsSinceEpoch(1343631600000),
  stopId: '1_29930',
  stopSequence: 10,
  vehicleId: '1_4011',
);

/// Whether the icon [finder] is drawn mirrored (an Icon with a
/// matchTextDirection glyph in a right-to-left Directionality).
bool isMirrored(WidgetTester tester, Finder finder) {
  final icon = tester.widget<Icon>(finder);
  return (icon.icon?.matchTextDirection ?? false) &&
      Directionality.of(tester.element(finder)) == TextDirection.rtl;
}

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  for (final locale in [english, arabic]) {
    final rtl = locale == arabic;
    final side = rtl ? 'right' : 'left';

    testWidgets(
      'departure row: route badge on the $side (${locale.languageCode})',
      (tester) async {
        env = await ObaTestEnv.create(
          responses: {
            'arrivals-and-departures-for-stop': fixture(
              'arrivals_and_departures_for_stop_1_10020.json',
            ),
          },
        );
        await env.pumpPage(
          tester,
          const StopPage(stopId: '1_10020'),
          locale: locale,
          surfaceSize: const Size(390, 844),
        );
        final row = find.byType(ObaDepartureRow).first;
        final rowRect = tester.getRect(row);
        final badge = tester.getRect(
          find.descendant(of: row, matching: find.byType(ObaRouteBadge)),
        );
        final headsign = tester.getRect(
          find.descendant(of: row, matching: find.text('LAKE CITY WEDGWOOD')),
        );
        if (rtl) {
          expect(badge.left, greaterThan(headsign.right));
          expect(rowRect.right - badge.right, lessThan(24));
        } else {
          expect(badge.right, lessThan(headsign.left));
          expect(badge.left - rowRect.left, lessThan(24));
        }
      },
    );

    testWidgets('list rows: leading icon on the $side, chevron points onward '
        '(${locale.languageCode})', (tester) async {
      env = await ObaTestEnv.create();
      await env.pumpPage(
        tester,
        const MorePage(),
        locale: locale,
        surfaceSize: const Size(390, 844),
      );
      final chevron = find.byIcon(Icons.chevron_right).first;
      final row = find.ancestor(of: chevron, matching: find.byType(ObaListRow));
      final rowRect = tester.getRect(row.first);
      final chevronRect = tester.getRect(chevron);
      if (rtl) {
        expect(chevronRect.center.dx, lessThan(rowRect.center.dx));
      } else {
        expect(chevronRect.center.dx, greaterThan(rowRect.center.dx));
      }
      expect(isMirrored(tester, chevron), rtl);
    });

    testWidgets('trip page: block arrows follow reading direction '
        '(${locale.languageCode})', (tester) async {
      env = await ObaTestEnv.create(
        responses: {
          'trip-details': fixture('trip_details_1_18196913.json'),
          'arrival-and-departure-for-stop': fixture(
            'arrival_for_trip_1_18196913.json',
          ),
          'shape': fixture('shape_1_20010002.json'),
        },
      );
      await env.pumpPage(
        tester,
        TripPage(trip: trip),
        locale: locale,
        surfaceSize: const Size(800, 2400),
      );
      // Previous trip: back arrow; next trip: forward arrow. Both mirror.
      expect(isMirrored(tester, find.byIcon(Icons.arrow_back)), rtl);
      expect(isMirrored(tester, find.byIcon(Icons.arrow_forward)), rtl);
      expect(find.byIcon(Icons.east), findsNothing);
      expect(find.byIcon(Icons.west), findsNothing);
    });

    testWidgets(
      'wide layout: side panel on the $side (${locale.languageCode})',
      (tester) async {
        env = await ObaTestEnv.create();
        await env.pumpPage(
          tester,
          const ObaHomeShell(),
          locale: locale,
          surfaceSize: const Size(1200, 800),
        );
        final shell = tester.state<ObaHomeShellState>(
          find.byType(ObaHomeShell),
        );
        shell.navigator.push(const SettingsRoute());
        await ObaTestEnv.settle(tester);
        final panel = tester.getRect(find.byType(SettingsPage));
        if (rtl) {
          expect(panel.right, 1200);
        } else {
          expect(panel.left, 0);
        }
      },
    );

    testWidgets('itinerary steps: times on the $side '
        '(${locale.languageCode})', (tester) async {
      env = await ObaTestEnv.create();
      final plan = tp.parseRestPlanResponse(
        jsonDecode(
          File(
            '../obakit_trip_planner/test/fixtures/rest/'
            'sdmts_ucsd_to_downtown.json',
          ).readAsStringSync(),
        ) as Map<String, dynamic>,
      );
      await env.pumpPage(
        tester,
        Builder(
          builder: ItineraryRoute(
            plan.itineraries.first,
            mapConfig: tp.TripMapConfig(
              userAgentPackageName: 'org.onebusaway.test',
              tileProvider: FakeTileProvider(),
            ),
          ).build,
        ),
        locale: locale,
        surfaceSize: const Size(390, 2400),
      );
      final detail = tester.getRect(find.byType(tp.ItineraryDetailView));
      // The first leg's start time sits in the 72dp time column.
      final times = find.descendant(
        of: find.byType(tp.ItineraryDetailView),
        matching: find.byWidgetPredicate(
          (w) => w is Text && w.textAlign == TextAlign.center,
        ),
      );
      final time = tester.getRect(times.first);
      if (rtl) {
        expect(time.left, greaterThan(detail.right - 80));
      } else {
        expect(time.right, lessThan(detail.left + 80));
      }
    });
  }

  testWidgets('server names are bidi-isolated in right-to-left rows', (
    tester,
  ) async {
    env = await ObaTestEnv.create();
    for (final locale in [english, arabic]) {
      await env.pumpPage(
        tester,
        const Material(child: ObaListRow(title: 'Washington, D.C.')),
        locale: locale,
      );
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byType(ObaListRow),
          matching: find.byType(Text),
        ),
      );
      expect(
        text.data,
        locale == arabic ? '\u2068Washington, D.C.\u2069' : 'Washington, D.C.',
      );
    }
  });
}
