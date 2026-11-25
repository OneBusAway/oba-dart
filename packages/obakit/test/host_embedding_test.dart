// Embedding contract details a host relies on: the bundled regions list,
// ObaScope's rebuild behaviour, consistent feed cards, and dark map tiles.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';

import 'features/bookmarks/bookmarks_support.dart';
import 'support/oba_test_harness.dart';

const _darkTiles = ObaTileSource(
  urlTemplate: 'https://dark.example/{z}/{x}/{y}.png',
  attribution: 'Dark Tiles Inc',
);

void main() {
  group('bundled regions list', () {
    setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

    test('is a package asset that parses', () async {
      final json = await ObaApplication.loadBundledRegionsJson();
      final names = Region.listFromJson(json).map((r) => r.regionName);
      expect(names, containsAll(['Puget Sound', 'San Diego']));
    });

    Future<(ObaApplication, List<http.Request>)> create({
      String? regionsJson,
    }) async {
      final requests = <http.Request>[];
      final app = await ObaApplication.create(
        map: const ObaMapConfig(userAgentPackageName: 'org.onebusaway.test'),
        services: ObaPlatformServices(
          keyValueStore: InMemoryKeyValueStore(),
          locationProvider: const NoLocationProvider(),
        ),
        config: (s) => ObaAppConfig(
          appName: 'Host',
          apiKey: 'test',
          appVersion: '1.0.0',
          bundledRegionsJson: regionsJson,
          keyValueStore: s.keyValueStore,
          locationProvider: s.locationProvider,
          regionsPath: null,
          fixedRegion: const FixedRegionConfig(name: 'San Diego'),
          httpClient: MockClient((r) async {
            requests.add(r);
            return http.Response('', 404);
          }),
        ),
      );
      return (app, requests);
    }

    test(
      'is the default: a fixed-region host needs no asset or fetch',
      () async {
        final (app, requests) = await create();
        addTearDown(app.dispose);
        expect(app.core.currentRegion?.regionName, 'San Diego');
        expect(app.core.regions.regions.length, greaterThan(1));
        await Future<void>.delayed(Duration.zero);
        expect(requests.where((r) => r.url.path.contains('regions')), isEmpty);
      },
    );

    test("the host's own list overrides it", () async {
      final full = await ObaApplication.loadBundledRegionsJson();
      final sd = Region.listFromJson(full)
          .where((r) => r.regionName == 'San Diego')
          .toList();
      final own =
          '{"version":3,"code":200,"text":"OK","data":{"list":'
          '[${jsonEncodeRegion(sd.single)}]}}';
      final (app, _) = await create(regionsJson: own);
      addTearDown(app.dispose);
      expect(app.core.regions.regions.map((r) => r.regionName), ['San Diego']);
    });
  });

  group('ObaScope', () {
    testWidgets('a new onNavigate closure does not rebuild dependents, and '
        'navigation calls the newest one', (tester) async {
      final env = await ObaTestEnv.create();
      addTearDown(env.dispose);
      final calls = <int>[];
      final host = GlobalKey<_HostState>();
      await tester.pumpWidget(_Host(key: host, app: env.app, calls: calls));
      expect(_Dependent.builds, 1);
      final ctx = tester.element(find.byType(_Dependent));
      final kept = ObaNavigator.of(ctx); // held across host rebuilds

      host.currentState!.bump(); // a new inline closure
      await tester.pump();
      host.currentState!.bump();
      await tester.pump();
      expect(_Dependent.builds, 1, reason: 'no rebuild for a new closure');

      ObaNavigator.of(ctx).push(const StopRoute('1_75403'));
      kept.push(const StopRoute('1_75403'));
      expect(calls, [2, 2], reason: 'the newest closure handles both');

      // A different application still notifies.
      final other = await ObaTestEnv.create();
      addTearDown(other.dispose);
      host.currentState!.swap(other.app);
      await tester.pump();
      expect(_Dependent.builds, 2);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('feed cards', () {
    const cardColor = Color(0xFFFFFFFF);
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    ThemeData hostTheme() => ObaTheme.buildThemeData().copyWith(
      cardTheme: const CardThemeData(
        color: cardColor,
        shape: shape,
        margin: EdgeInsets.all(20),
        elevation: 0,
      ),
    );

    Widget feed() => ListView(
      children: const [
        ObaNearbyStopsCard(around: Coordinate(47.6564, -122.3122)),
        ObaBookmarksCard(),
      ],
    );

    Future<ObaTestEnv> cardsEnv() async {
      final env = await ObaTestEnv.create(
        responses: {
          'stops-for-location': fixture('stops_for_location_seattle.json'),
          'arrivals-and-departures-for-stop': fixture(
            'arrivals_mts_24151.json',
          ),
        },
      );
      env.app.core.userData
        ..addBookmark(stopBookmark('Home'))
        ..addBookmark(stopBookmark('Work', stopId: 'MTS_2'));
      return env;
    }

    testWidgets('both use the same host-themed card, heading and padding', (
      tester,
    ) async {
      await atFixtureTime(() async {
        final env = await cardsEnv();
        addTearDown(env.dispose);
        await env.pumpPage(
          tester,
          feed(),
          theme: hostTheme(),
          presentation: ObaPresentation.embedded,
        );
        for (final (type, title) in [
          (ObaNearbyStopsCard, 'Departures near you'),
          (ObaBookmarksCard, 'Bookmarks'),
        ]) {
          final cards = find.descendant(
            of: find.byType(type),
            matching: find.byType(Card),
          );
          // One card: the bookmarks inside aren't cards of their own.
          expect(cards, findsOneWidget, reason: '$type');
          final materialFinder = find
              .descendant(of: cards, matching: find.byType(Material))
              .first;
          final material = tester.widget<Material>(materialFinder);
          expect(material.color, cardColor, reason: '$type colour');
          expect(material.shape, shape, reason: '$type shape');
          expect(
            tester.getTopLeft(materialFinder).dx,
            20,
            reason: '$type margin',
          );
          // Inside the card, the content (from its heading down) sits on
          // the same 8dp bottom padding.
          final contentPadding = find.ancestor(
            of: find.text(title),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Padding && w.padding == const EdgeInsets.only(bottom: 8),
            ),
          );
          expect(
            find.descendant(of: cards, matching: contentPadding),
            findsOneWidget,
            reason: '$type padding',
          );
          expect(
            tester.getSemantics(find.text(title)),
            matchesSemantics(label: title, isHeader: true),
          );
        }
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Work'), findsOneWidget);
        for (final mode in [ThemeMode.light, ThemeMode.dark]) {
          await env.pumpPage(
            tester,
            feed(),
            presentation: ObaPresentation.embedded,
            themeMode: mode,
          );
          await expectObaAccessibility(tester);
        }
        await env.expectNoOverflowAtTextScale(
          tester,
          feed(),
          presentation: ObaPresentation.embedded,
        );
        await unmount(tester);
      });
    });

    testWidgets('the home sheet section stays unboxed, one card per bookmark', (
      tester,
    ) async {
      await atFixtureTime(() async {
        final env = await cardsEnv();
        addTearDown(env.dispose);
        await env.pumpPage(
          tester,
          const SingleChildScrollView(child: BookmarksSection()),
          presentation: ObaPresentation.embedded,
        );
        expect(
          find.ancestor(
            of: find.text('Bookmarks'),
            matching: find.byType(Card),
          ),
          findsNothing,
        );
        expect(find.byType(Card), findsNWidgets(2));
        await unmount(tester);
      });
    });
  });

  group('dark map tiles', () {
    test('config picks the street tiles for the theme', () {
      const plain = ObaMapConfig(userAgentPackageName: 'x');
      expect(plain.standardFor(Brightness.dark), ObaTileSource.openStreetMap);
      expect(
        plain.showsDarkStreetTiles(MapType.standard, Brightness.dark),
        isFalse,
      );
      const sat = ObaTileSource(urlTemplate: 'sat', attribution: 'Sat');
      const cfg = ObaMapConfig(
        userAgentPackageName: 'x',
        standardDark: _darkTiles,
        satellite: sat,
      );
      expect(cfg.standardFor(Brightness.light), ObaTileSource.openStreetMap);
      expect(cfg.standardFor(Brightness.dark), _darkTiles);
      expect(cfg.sourceFor(MapType.satellite, Brightness.dark), sat);
      // Hybrid isn't configured: the street tiles stand in.
      expect(cfg.sourceFor(MapType.hybrid, Brightness.dark), _darkTiles);
      expect(
        cfg.showsDarkStreetTiles(MapType.standard, Brightness.dark),
        isTrue,
      );
      expect(
        cfg.showsDarkStreetTiles(MapType.standard, Brightness.light),
        isFalse,
      );
      expect(
        cfg.showsDarkStreetTiles(MapType.satellite, Brightness.dark),
        isFalse,
      );
      expect(cfg.copyWith().standardDark, _darkTiles);
    });

    String tileUrl(WidgetTester tester) =>
        tester.widget<fm.TileLayer>(find.byType(fm.TileLayer)).urlTemplate!;

    testWidgets('the map shows them, with their attribution, in dark mode', (
      tester,
    ) async {
      final env = await ObaTestEnv.create(darkTiles: _darkTiles);
      addTearDown(env.dispose);
      await env.pumpPage(
        tester,
        const ObaMapView(),
        themeMode: ThemeMode.dark,
        presentation: ObaPresentation.embedded,
      );
      expect(tileUrl(tester), _darkTiles.urlTemplate);
      expect(find.text('© Dark Tiles Inc'), findsOneWidget);
      await env.pumpPage(
        tester,
        const ObaMapView(),
        presentation: ObaPresentation.embedded,
      );
      expect(tileUrl(tester), ObaTileSource.openStreetMap.urlTemplate);
      expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('without them, dark mode keeps the default tiles', (
      tester,
    ) async {
      final env = await ObaTestEnv.create();
      addTearDown(env.dispose);
      await env.pumpPage(
        tester,
        const ObaMapView(),
        themeMode: ThemeMode.dark,
        presentation: ObaPresentation.embedded,
      );
      expect(tileUrl(tester), ObaTileSource.openStreetMap.urlTemplate);
      await unmount(tester);
    });

    testWidgets('status bar icons turn light over dark tiles only', (
      tester,
    ) async {
      final env = await ObaTestEnv.create(darkTiles: _darkTiles);
      addTearDown(env.dispose);
      Brightness icons() => tester
          .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
            find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first,
          )
          .value
          .statusBarIconBrightness!;
      await env.pumpPage(
        tester,
        const ObaHomeShell(),
        themeMode: ThemeMode.dark,
      );
      expect(icons(), Brightness.light);
      await env.pumpPage(tester, const ObaHomeShell());
      expect(icons(), Brightness.dark);
      await unmount(tester);
    });
  });
}

String jsonEncodeRegion(Region r) => jsonEncode(r.toJson());

class _Host extends StatefulWidget {
  const _Host({super.key, required this.app, required this.calls});
  final ObaApplication app;
  final List<int> calls;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  int generation = 0;
  late ObaApplication app = widget.app;

  void bump() => setState(() => generation++);
  void swap(ObaApplication a) => setState(() => app = a);

  @override
  Widget build(BuildContext context) {
    final g = generation;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ObaScope(
        application: app,
        // Inline, as hosts write it: a new closure on every build.
        onNavigate: (context, route) {
          widget.calls.add(g);
          return true;
        },
        child: const MaterialApp(home: _Dependent()),
      ),
    );
  }
}

class _Dependent extends StatelessWidget {
  const _Dependent();
  static int builds = 0;

  @override
  Widget build(BuildContext context) {
    ObaScope.of(context);
    builds++;
    return const SizedBox();
  }
}
