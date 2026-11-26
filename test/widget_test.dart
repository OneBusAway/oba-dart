import 'package:flutter/widgets.dart' show Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:oba_dart/app_config.dart';
import 'package:obakit/obakit.dart';

void main() {
  testWidgets('the shim boots ObaApp to the map shell', (tester) async {
    final app = await tester.runAsync(
      () => ObaApplication.create(
        map: const ObaMapConfig(userAgentPackageName: 'org.onebusaway.test'),
        services: ObaPlatformServices(
          keyValueStore: InMemoryKeyValueStore({
            'oba.settings.onboardingSeenVersions': '{"onboarding.welcome":1,"onboarding.location":1,"onboarding.region":1}',
          }),
          locationProvider: FakeLocationProvider(),
        ),
        config: (services) => buildObaAppConfig(
          services: services,
          kitConfig: buildObaKitConfig(fixedRegionName: 'Puget Sound'),
          httpClient: MockClient((_) async => http.Response('', 404)),
        ),
      ),
    );
    addTearDown(app!.dispose);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(ObaApp(application: app));
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    }

    expect(find.byType(ObaHomeShell), findsOneWidget);
    expect(find.byType(ObaMapView), findsOneWidget);
  });
}
