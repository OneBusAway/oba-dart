import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:oba_dart/app_config.dart';

ObaAppConfig build(Map<String, Object?> kit) => buildObaAppConfig(
  services: ObaPlatformServices(
    keyValueStore: InMemoryKeyValueStore(),
    locationProvider: FakeLocationProvider(),
  ),
  kitConfig: kit,
);

void main() {
  test('defaults mirror the iOS app', () {
    final c = build(buildObaKitConfig());
    expect(c.appName, 'OneBusAway');
    expect(c.apiKey, 'org.onebusaway.iphone');
    expect(c.regionsBaseUrl, Uri.parse('https://regions.onebusaway.org'));
    expect(c.regionsPath, '/regions-v3.json');
    expect(c.urlScheme, 'onebusaway');
    expect(c.developerEmail, 'iphone-app@onebusaway.org');
    expect(
      c.privacyPolicyUrl,
      Uri.parse(
        'https://opentransitsoftwarefoundation.org/onebusaway/privacy/',
      ),
    );
    expect(c.donations.enabled, isTrue);
    expect(
      c.donations.managementPortal,
      Uri.parse('https://opentransitsoftwarefoundation.org/manage-donations'),
    );
    expect(c.moreTab.showHelpOutSection, isTrue);
    expect(
      c.moreTab.developUrl,
      Uri.parse('https://github.com/oneBusAway/onebusaway-ios'),
    );
    expect(c.fixedRegion, isNull);
  });

  test('dart-define values override the defaults', () {
    final c = build(
      buildObaKitConfig(
        apiKey: 'my-key',
        fixedRegionName: 'San Diego',
        fixedRegionUrl: 'https://realtime.sdmts.com/api/',
      ),
    );
    expect(c.apiKey, 'my-key');
    expect(c.fixedRegion?.name, 'San Diego');
    expect(
      c.fixedRegion?.obaBaseUrl,
      Uri.parse('https://realtime.sdmts.com/api/'),
    );
  });

  test('the shim carries no regions list: obakit bundles it', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    expect(build(buildObaKitConfig()).bundledRegionsJson, isEmpty);
    final json = await ObaApplication.loadBundledRegionsJson();
    expect(json, contains('Puget Sound'));
  });
}
