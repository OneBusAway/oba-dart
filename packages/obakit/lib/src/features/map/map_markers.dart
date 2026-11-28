import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../l10n/l10n.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/rows.dart';
import 'map_coordinator.dart';
import 'map_logic.dart';

/// Touch target of every map marker (WCAG / Material 48dp).
const double kObaMarkerTarget = 48;

/// A stop pin: route-type glyph in a rounded square, an arrow pointing the
/// stop's direction, brand fill when bookmarked, and a ring when selected.
/// It is a labelled button for screen readers ("Main St & 3rd, Bus stop,
/// Northbound, Bookmarked").
class ObaStopPin extends StatelessWidget {
  const ObaStopPin({super.key, required this.spec, this.onTap});

  final StopMarkerSpec spec;
  final VoidCallback? onTap;

  static String semanticLabel(ObaLocalizations l10n, StopMarkerSpec spec) {
    final parts = [
      l10n.mapStopMarkerLabel(
        spec.stop.name,
        routeTypeLabel(l10n, spec.routeType),
      ),
      ?stopDirectionLabel(l10n, spec.stop.compassDirection),
      if (spec.stop.code != null && spec.stop.code!.isNotEmpty)
        l10n.stopCode(spec.stop.code!),
      if (spec.isBookmarked) l10n.mapBookmarkedStop,
    ];
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = ObaTheme.of(context);
    final l10n = context.obaL10n;
    final size = math.min(theme.stopPinSize, kObaMarkerTarget);
    final fill = spec.isBookmarked
        ? theme.bookmarkedPinFill
        : theme.stopPinFill;
    final glyph = spec.isBookmarked
        ? theme.bookmarkedPinGlyph
        : theme.stopPinGlyph;
    final arrow = _arrowAngle(spec.stop.compassDirection);
    return Semantics(
      container: true,
      button: true,
      selected: spec.isSelected,
      label: semanticLabel(l10n, spec),
      hint: l10n.mapStopMarkerHint,
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox.square(
          dimension: kObaMarkerTarget,
          child: Center(
            child: spec.compact
                ? _StopDot(fill: fill, stroke: theme.stopPinStroke)
                : CustomPaint(
                    size: Size.square(size),
                    painter: _StopPinPainter(
                      fill: fill,
                      stroke: theme.stopPinStroke,
                      ring: spec.isSelected ? theme.selectedPinRing : null,
                      arrowAngle: arrow,
                    ),
                    child: SizedBox.square(
                      dimension: size,
                      child: Icon(
                        routeTypeIconData(spec.routeType),
                        size: size * 0.45,
                        color: glyph,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  static double? _arrowAngle(StopDirection d) => switch (d) {
    StopDirection.n => 0,
    StopDirection.ne => 45,
    StopDirection.e => 90,
    StopDirection.se => 135,
    StopDirection.s => 180,
    StopDirection.sw => 225,
    StopDirection.w => 270,
    StopDirection.nw => 315,
    StopDirection.unknown => null,
  };
}

class _StopPinPainter extends CustomPainter {
  _StopPinPainter({
    required this.fill,
    required this.stroke,
    required this.ring,
    required this.arrowAngle,
  });

  final Color fill;
  final Color stroke;
  final Color? ring;
  final double? arrowAngle;

  static const track = 7.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final body = Rect.fromCenter(
      center: center,
      width: size.width - track * 2,
      height: size.height - track * 2,
    );
    final rrect = RRect.fromRectAndRadius(
      body,
      Radius.circular(body.width * 0.3),
    );
    if (ring != null) {
      // Two-tone ring: visible on light and dark tiles alike.
      canvas.drawRRect(
        rrect.inflate(5),
        Paint()
          ..color = stroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5,
      );
      canvas.drawRRect(
        rrect.inflate(4),
        Paint()
          ..color = ring!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
    canvas.drawRRect(rrect, Paint()..color = fill);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final angle = arrowAngle;
    if (angle != null) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle * math.pi / 180);
      final tipY = -size.height / 2;
      final path = Path()
        ..moveTo(0, tipY)
        ..lineTo(6, tipY + track - 1)
        ..lineTo(-6, tipY + track - 1)
        ..close();
      canvas.drawPath(path, Paint()..color = stroke);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_StopPinPainter old) =>
      old.fill != fill ||
      old.stroke != stroke ||
      old.ring != ring ||
      old.arrowAngle != arrowAngle;
}

/// The user's position: a dot with a halo, and a heading cone when known.
class ObaUserLocationDot extends StatelessWidget {
  const ObaUserLocationDot({super.key, this.heading});

  final double? heading;

  @override
  Widget build(BuildContext context) {
    final theme = ObaTheme.of(context);
    return Semantics(
      container: true,
      label: context.obaL10n.mapCurrentLocation,
      excludeSemantics: true,
      child: CustomPaint(
        size: const Size.square(kObaMarkerTarget),
        painter: _UserDotPainter(color: theme.userLocation, heading: heading),
      ),
    );
  }
}

class _UserDotPainter extends CustomPainter {
  _UserDotPainter({required this.color, required this.heading});

  final Color color;
  final double? heading;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final h = heading;
    if (h != null) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(h * math.pi / 180);
      final cone = Path()
        ..moveTo(0, 0)
        ..lineTo(-10, -22)
        ..quadraticBezierTo(0, -26, 10, -22)
        ..close();
      canvas.drawPath(cone, Paint()..color = color.withValues(alpha: 0.35));
      canvas.restore();
    }
    canvas.drawCircle(c, 10, Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawCircle(c, 7, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_UserDotPainter old) =>
      old.color != color || old.heading != heading;
}

/// A marker from an [ObaMapOverlay].
class ObaOverlayMarker extends StatelessWidget {
  const ObaOverlayMarker({super.key, required this.marker});

  final ObaMapMarker marker;

  @override
  Widget build(BuildContext context) {
    final label =
        marker.label.isEmpty && marker.kind == ObaMapMarkerKind.vehicle
        ? context.obaL10n.mapVehicle
        : marker.label;
    final builder = marker.builder;
    return Semantics(
      container: true,
      label: label,
      button: marker.onTap != null,
      onTap: marker.onTap,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: marker.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.square(
          dimension: kObaMarkerTarget,
          child: ClipRect(
            child: Center(
              child: builder != null ? builder(context) : _pin(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pin(BuildContext context) {
    final theme = ObaTheme.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (
      IconData kindIcon,
      Color color,
      Color onColor,
    ) = switch (marker.kind) {
      ObaMapMarkerKind.vehicle => (
        Icons.navigation,
        marker.color ?? theme.vehicle,
        theme.onVehicle,
      ),
      ObaMapMarkerKind.origin => (
        Icons.trip_origin,
        marker.color ?? theme.brand,
        theme.onBrand,
      ),
      ObaMapMarkerKind.destination => (
        Icons.flag,
        marker.color ?? scheme.error,
        scheme.onError,
      ),
      _ => (Icons.place, marker.color ?? scheme.primary, scheme.onPrimary),
    };
    Widget glyph = Icon(marker.icon ?? kindIcon, size: 22, color: onColor);
    if (marker.kind == ObaMapMarkerKind.vehicle && marker.heading != null) {
      glyph = Transform.rotate(
        angle: marker.heading! * math.pi / 180,
        child: glyph,
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: theme.stopPinFill, width: 2),
      ),
      child: Padding(padding: const EdgeInsets.all(5), child: glyph),
    );
  }
}

/// A compact stop: a 14dp dot, filled and outlined like the full pin so it
/// reads on light and dark tiles.
class _StopDot extends StatelessWidget {
  const _StopDot({required this.fill, required this.stroke});

  final Color fill;
  final Color stroke;

  @override
  Widget build(BuildContext context) => Container(
    width: 14,
    height: 14,
    decoration: BoxDecoration(
      color: fill,
      shape: BoxShape.circle,
      border: Border.all(color: stroke, width: 2.5),
    ),
  );
}
