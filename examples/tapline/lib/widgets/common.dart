import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme.dart';

/// A section heading, marked as a heading for screen readers.
class SectionHeading extends StatelessWidget {
  const SectionHeading(this.text, {super.key, this.padding});

  final String text;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding ?? const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 4),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
  );
}

/// A route short name on a teal pill. Grows with the text size.
class HostRouteBadge extends StatelessWidget {
  const HostRouteBadge(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: TaplineColors.teal,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

/// Formats a date and time with the Material localizations, e.g.
/// "Tue, Nov 24 · 8:12 AM".
String formatDateTime(BuildContext context, DateTime t) {
  final m = MaterialLocalizations.of(context);
  return '${m.formatMediumDate(t)} · '
      '${m.formatTimeOfDay(TimeOfDay.fromDateTime(t))}';
}

String formatTime(BuildContext context, DateTime t) =>
    MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(t));

/// "valid until 11:59 PM" today, or "valid until Dec 24" for a later day.
String passValidity(BuildContext context, Pass pass, DateTime now) {
  if (!pass.isActiveAt(now)) return 'Expired';
  final sameDay =
      pass.expiresAt.year == now.year &&
      pass.expiresAt.month == now.month &&
      pass.expiresAt.day == now.day;
  return sameDay
      ? 'valid until ${formatTime(context, pass.expiresAt)}'
      : 'valid until '
            '${MaterialLocalizations.of(context).formatMediumDate(pass.expiresAt)}';
}
