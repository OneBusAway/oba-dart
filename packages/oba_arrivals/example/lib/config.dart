/// Build-time configuration:
/// `flutter run --dart-define=OBA_BASE_URL=... --dart-define=OBA_API_KEY=...`
class AppConfig {
  /// OBA server root (endpoints live under `{baseUrl}api/where/`).
  static const baseUrl = String.fromEnvironment(
    'OBA_BASE_URL',
    defaultValue: 'https://realtime.sdmts.com/api/',
  );

  static const apiKey = String.fromEnvironment(
    'OBA_API_KEY',
    defaultValue: 'org.onebusaway.iphone',
  );
}
