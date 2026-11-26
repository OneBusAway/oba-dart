/// One line of the troubleshooting block in a support email.
class DebugInfoEntry {
  const DebugInfoEntry(this.label, this.value);

  final String label;
  final String value;
}

enum ContactTarget { appDevelopers, transitAgency }

/// Builds the support email (iOS `ContactUsHelper`): a `mailto:` link, and
/// the same text for the clipboard when no mail app can be opened.
class ContactUsMessage {
  const ContactUsMessage({
    required this.target,
    required this.address,
    required this.subject,
    required this.intro,
    this.debugIntro,
    this.debugInfo = const [],
  });

  final ContactTarget target;
  final String address;
  final String subject;

  /// "How can we help? Please enter your response below:"
  final String intro;

  /// Explains the troubleshooting block. Null for agency mail.
  final String? debugIntro;
  final List<DebugInfoEntry> debugInfo;

  /// Plain text body.
  String get body {
    final b = StringBuffer(intro)..write('\n\n\n\n');
    if (debugIntro != null && debugInfo.isNotEmpty) {
      b
        ..write('---\n')
        ..write(debugIntro)
        ..write('\n\n');
      for (final e in debugInfo) {
        b.write('${e.label} = ${e.value}\n');
      }
    }
    return b.toString();
  }

  /// `mailto:` with the subject and body percent-encoded (spaces as %20).
  Uri get mailto => Uri(
    scheme: 'mailto',
    path: address,
    query:
        'subject=${Uri.encodeComponent(subject)}'
        '&body=${Uri.encodeComponent(body)}',
  );

  /// Everything the rider should paste into their own mail app.
  String get clipboardText => body;
}
