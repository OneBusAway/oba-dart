import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryKeyValueStore kv;
  late ObaSettings s;
  late int n;

  setUp(() {
    kv = InMemoryKeyValueStore();
    s = ObaSettings(
      kv,
      defaultArrivalDepartureFilter: ArrivalDepartureFilter.scheduledOnly,
    );
    n = 0;
    s.addListener(() => n++);
  });

  test('defaults', () {
    expect(s.arrivalDepartureFilter, ArrivalDepartureFilter.scheduledOnly);
    expect(s.walkingSpeedMetersPerSecond, 1.4);
    expect(s.walkingSpeedPreset, WalkingSpeedPreset.average);
    expect(s.bikeModeEnabled, isFalse);
    expect(s.bikeSpeedMetersPerSecond, 4.2);
    expect(s.effectiveTravelSpeedMetersPerSecond, 1.4);
    expect(s.mapType, MapType.standard);
    expect(s.mapShowsScale, isTrue);
    expect(s.walkingDirectionsProvider, WalkingDirectionsProvider.askEveryTime);
    expect(s.analyticsReportingEnabled, isTrue);
    expect(s.debugMode, isFalse);
    expect(s.defaultAlarmLeadTimeMinutes, 10);
    expect(s.clustersStops, isFalse);
    expect(s.showRegionTimeZone, isFalse);
  });

  test('setters persist and notify only on change', () {
    s.arrivalDepartureFilter = ArrivalDepartureFilter.all;
    s.arrivalDepartureFilter = ArrivalDepartureFilter.all;
    s.mapType = MapType.hybrid;
    s.compactMode = true;
    s.reducedColors = true;
    s.debugMode = true;
    s.clustersStops = true;
    expect(n, 6);
    final r = ObaSettings(kv);
    expect(r.arrivalDepartureFilter, ArrivalDepartureFilter.all);
    expect(r.mapType, MapType.hybrid);
    expect(
      r.compactMode && r.reducedColors && r.debugMode && r.clustersStops,
      isTrue,
    );
  });

  test('speeds clamp and presets map', () {
    s.walkingSpeedPreset = WalkingSpeedPreset.slow;
    expect(s.walkingSpeedMetersPerSecond, 0.9);
    s.walkingSpeedMetersPerSecond = 99;
    expect(s.walkingSpeedMetersPerSecond, 5.0);
    expect(s.walkingSpeedPreset, isNull);
    s.bikeSpeedMetersPerSecond = 0;
    expect(s.bikeSpeedMetersPerSecond, 2.0);
    s.bikeModeEnabled = true;
    expect(s.effectiveTravelSpeedMetersPerSecond, 2.0);
    expect(WalkingSpeedPreset.fast.metersPerSecond, 1.8);
  });

  test('unknown stored enum values fall back to defaults', () {
    kv.writeJson('oba.settings.mapType', 'neon');
    kv.writeJson('oba.settings.walkingSpeed', 'fast');
    expect(s.mapType, MapType.standard);
    expect(s.walkingSpeedMetersPerSecond, 1.4);
  });

  test('onboarding step versions', () {
    expect(s.needsOnboardingStep('welcome', 1), isTrue);
    s.markOnboardingStepSeen('welcome', 1);
    expect(s.needsOnboardingStep('welcome', 1), isFalse);
    expect(s.needsOnboardingStep('welcome', 2), isTrue);
    expect(ObaSettings(kv).onboardingSeenVersion('welcome'), 1);
  });

  test('alarm lead time clamps', () {
    s.defaultAlarmLeadTimeMinutes = 500;
    expect(s.defaultAlarmLeadTimeMinutes, 120);
  });
}
