import 'package:url_launcher/url_launcher.dart';

/// Opens [uri] outside the app; true when it launched. Screens take one so
/// a host (or a test) can replace it.
typedef ObaUrlOpener = Future<bool> Function(Uri uri);

/// The default: `url_launcher` in the external application. Failures
/// (no handler, platform error) return false.
Future<bool> defaultUrlOpener(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Object {
    return false;
  }
}

/// Whether [uri] is a web link (http or https): the only kind an alert may
/// open (iOS `isValidAlertURL`).
bool isWebUri(Uri uri) {
  final scheme = uri.scheme.toLowerCase();
  return scheme == 'http' || scheme == 'https';
}
