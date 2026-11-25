import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:obakit_core/obakit_core.dart';

import 'heading.dart';
import '../l10n/l10n.dart';

/// Centred icon, title, message and optional action. For empty lists.
class ObaEmptyState extends StatelessWidget {
  const ObaEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.action,
  });

  final String title;
  final String? message;
  final IconData? icon;

  /// Typically a `FilledButton` or `TextButton`.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              ExcludeSemantics(
                child: Icon(
                  icon,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 12),
            ObaHeading(title, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// An error with a retry button. Maps OBA errors to friendly copy.
class ObaErrorState extends StatelessWidget {
  const ObaErrorState({super.key, this.error, this.message, this.onRetry});

  final Object? error;

  /// Overrides the message derived from [error].
  final String? message;
  final VoidCallback? onRetry;

  /// Friendly text for [error].
  static String messageFor(BuildContext context, Object? error) {
    final l10n = context.obaL10n;
    return switch (error) {
      ObaNetworkException() => l10n.commonOffline,
      ObaException() => l10n.commonServerError,
      _ => l10n.commonServerError,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return Semantics(
      liveRegion: true,
      child: ObaEmptyState(
        icon: Icons.error_outline,
        title: l10n.commonErrorTitle,
        message: message ?? messageFor(context, error),
        action: onRetry == null
            ? null
            : FilledButton.tonal(
                onPressed: onRetry,
                child: Text(l10n.commonRetry),
              ),
      ),
    );
  }
}

/// A progress indicator that screen readers announce as "Loading".
class ObaLoadingState extends StatelessWidget {
  const ObaLoadingState({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Semantics(
          liveRegion: true,
          label: label ?? context.obaL10n.commonLoading,
          child: const ExcludeSemantics(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

/// A sliver page's state before it has anything to show: [ObaErrorState]
/// (with [onRetry]; [errorMessage] overrides the text) when [error] is set,
/// otherwise [ObaLoadingState], filling the rest of the scroll view.
class ObaLoadingOrErrorSliver extends StatelessWidget {
  const ObaLoadingOrErrorSliver({
    super.key,
    this.error,
    this.errorMessage,
    this.onRetry,
  });

  final Object? error;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => SliverFillRemaining(
    hasScrollBody: false,
    child: error != null
        ? ObaErrorState(error: error, message: errorMessage, onRetry: onRetry)
        : const ObaLoadingState(),
  );
}

/// Announces [message] to screen readers (polite). Use after a refresh
/// changes what is on screen, e.g. "Updated" or "3 departures".
void obaAnnounce(BuildContext context, String message) {
  final view = View.maybeOf(context);
  if (view == null) return;
  SemanticsService.sendAnnouncement(
    view,
    message,
    Directionality.maybeOf(context) ?? TextDirection.ltr,
  );
}

/// Shows [message] in a snack bar (when there is a messenger) and
/// announces it to screen readers. Use it for every transient
/// confirmation or failure.
void obaNotify(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
  obaAnnounce(context, message);
}

/// Asks the rider to confirm a destructive action: [title], [message], a
/// Cancel button and a [confirmLabel] button. Completes with true only when
/// confirmed.
Future<bool> obaConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final l10n = context.obaL10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
