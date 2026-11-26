import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Whether text is large enough that side-by-side layouts should stack
/// (at or above 130% of the base size).
bool isLargeTextScale(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(100) >= 130;

/// [size] scaled with the user's text size, for icons that sit in text.
double scaledIconSize(BuildContext context, double size) =>
    MediaQuery.textScalerOf(context).scale(size);

/// A polite screen-reader announcement for [context]'s view.
void announce(BuildContext context, String message) {
  final view = View.maybeOf(context);
  if (view == null) return;
  SemanticsService.sendAnnouncement(
    view,
    message,
    Directionality.maybeOf(context) ?? TextDirection.ltr,
  );
}

/// A progress indicator that stands still when the platform asks for
/// reduced motion (`MediaQuery.disableAnimationsOf`).
class TripProgressIndicator extends StatelessWidget {
  const TripProgressIndicator({
    super.key,
    this.semanticsLabel,
    this.linear = false,
  });

  final String? semanticsLabel;
  final bool linear;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      final scheme = Theme.of(context).colorScheme;
      if (linear) {
        return LinearProgressIndicator(
          value: 1,
          semanticsLabel: semanticsLabel,
          color: scheme.primary,
        );
      }
      return Semantics(
        label: semanticsLabel,
        child: Icon(Icons.hourglass_empty, color: scheme.onSurfaceVariant),
      );
    }
    return linear
        ? LinearProgressIndicator(semanticsLabel: semanticsLabel)
        : CircularProgressIndicator(semanticsLabel: semanticsLabel);
  }
}
