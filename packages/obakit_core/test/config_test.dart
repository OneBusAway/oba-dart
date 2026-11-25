import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

void main() {
  ObaAppConfig fromMap(Map<String, Object?> map) =>
      ObaAppConfig.fromOBAKitConfig(
        map,
        appName: 'OBA',
        appVersion: '1.0',
        bundledRegionsJson: '',
        keyValueStore: InMemoryKeyValueStore(),
        locationProvider: FakeLocationProvider(),
      );

  test('fromOBAKitConfig reads the iOS keys', () {
    final c = fromMap({
      'RESTServerAPIKey': 'key',
      'RegionsServerBaseAddress': 'https://r.example.com',
      'RegionsServerAPIPath': '/r.json',
      'FixedRegionName': 'Spokane',
      'FixedRegionOBABaseURL': 'https://oba.example.com/',
      'DefaultArrivalDepartureFilter': 'estimatedOnly',
      'ExtensionURLScheme': 'kiedybus',
      'AppDevelopersEmailAddress': 'dev@example.com',
      'PrivacyPolicyURL': 'https://example.com/privacy',
      'AppStoreID': '123',
      'FeedbackPromptEnabled': false,
      'Donations': {
        'Enabled': true,
        'DonationManagementPortal': 'https://d.example.com',
      },
      'MoreTab': {
        'HeaderSupportText': 'Powered by goEuropa',
        'ShowHelpOutSection': false,
        'DevelopURL': '',
        'PhoneURL': 'tel:555',
        'CustomLinks': [
          {'Title': 'Site', 'URL': 'https://goeuropa.eu'},
          {'Title': 'Broken', 'URL': ''},
          {'URL': 'https://x'},
        ],
      },
    });
    expect(c.apiKey, 'key');
    expect(c.regionsBaseUrl.host, 'r.example.com');
    expect(c.regionsPath, '/r.json');
    expect(c.fixedRegion!.name, 'Spokane');
    expect(c.fixedRegion!.obaBaseUrl!.host, 'oba.example.com');
    expect(
      c.defaultArrivalDepartureFilter,
      ArrivalDepartureFilter.estimatedOnly,
    );
    expect(c.urlScheme, 'kiedybus');
    expect(c.feedbackPromptEnabled, isFalse);
    expect(c.donations.enabled, isTrue);
    expect(c.moreTab.headerSupportText, 'Powered by goEuropa');
    expect(c.moreTab.showHelpOutSection, isFalse);
    expect(c.moreTab.developUrl, isNull);
    expect(c.moreTab.phoneUrl.toString(), 'tel:555');
    expect(c.moreTab.customLinks.single.title, 'Site');
  });

  test('defaults match iOS', () {
    final c = fromMap({'DefaultArrivalDepartureFilter': 'bogus'});
    expect(c.defaultArrivalDepartureFilter, ArrivalDepartureFilter.all);
    expect(c.regionsBaseUrl.toString(), 'https://regions.onebusaway.org');
    expect(c.urlScheme, 'onebusaway');
    expect(c.feedbackPromptEnabled, isTrue);
    expect(c.donations.enabled, isFalse);
    expect(c.moreTab.showHelpOutSection, isTrue);
    expect(c.moreTab.developUrl.toString(), contains('onebusaway-ios'));
    expect(c.moreTab.translateUrl, isNull);
  });
}
