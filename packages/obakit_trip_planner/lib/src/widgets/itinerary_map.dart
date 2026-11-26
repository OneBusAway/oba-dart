import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../api/api.dart';
import '../display/itinerary_display.dart';
import '../map_config.dart';
import '../strings.dart';
import '../theme.dart';
import 'icons.dart';

LatLng _latLng(GeoPoint p) => LatLng(p.lat, p.lon);

/// A map of [itinerary]: one polyline per leg (walks dotted), boarding
/// points for transit legs, and origin/destination markers. The camera fits
/// the whole trip.
///
/// For screen readers the map is one labelled node
/// ([TripPlannerStrings.mapSemanticsLabel]) that points to the step list,
/// which is its text alternative; tiles, lines and markers are excluded as
/// decorative. The attribution stays a separate node (a link when
/// [TripMapConfig.onAttributionTap] is set, with a 48dp target).
class ItineraryMap extends StatelessWidget {
  const ItineraryMap({
    super.key,
    required this.itinerary,
    required this.config,
    this.strings = const TripPlannerStrings(),
  });

  final Itinerary itinerary;
  final TripMapConfig config;
  final TripPlannerStrings strings;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tripTheme = TripPlannerTheme.of(context);
    final legs = itinerary.legs;
    final points = [for (final p in itinerary.geometry) _latLng(p)];
    if (points.isEmpty) return const SizedBox.shrink();

    final origin = legs.isEmpty ? points.first : _latLng(legs.first.from.point);
    final destination = legs.isEmpty
        ? points.last
        : _latLng(legs.last.to.point);

    return Semantics(
      label: strings.mapSemanticsLabel,
      container: true,
      child: FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.coordinates(
            coordinates: points,
            padding: const EdgeInsets.all(40),
            maxZoom: 17,
          ),
          maxZoom: config.maxZoom,
          backgroundColor: scheme.surfaceContainer,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          ExcludeSemantics(
            child: TileLayer(
              urlTemplate: config.tileUrlTemplate,
              userAgentPackageName: config.userAgentPackageName,
              tileProvider: config.tileProvider,
              maxNativeZoom: config.maxZoom.floor(),
              subdomains: config.subdomains,
              retinaMode: config.retinaMode,
            ),
          ),
          PolylineLayer(
            polylines: [
              for (final leg in legs)
                Polyline(
                  points: [for (final p in leg.geometry) _latLng(p)],
                  color: tripTheme.colorForLeg(leg),
                  strokeWidth: tripTheme.polylineWidth,
                  borderColor: scheme.surface,
                  borderStrokeWidth: 1.5,
                  pattern: LegKind.of(leg) == LegKind.walk
                      ? const StrokePattern.dotted()
                      : const StrokePattern.solid(),
                ),
            ],
          ),
          // Markers duplicate the step list (origin, boardings, destination).
          ExcludeSemantics(
            child: MarkerLayer(
              markers: [
                for (final leg in legs.skip(1))
                  if (LegKind.of(leg) == LegKind.transit)
                    Marker(
                      point: _latLng(leg.from.point),
                      width: 26,
                      height: 26,
                      child: _Dot(
                        color: tripTheme.colorForLeg(leg),
                        border: scheme.surface,
                        icon: legIcon(leg),
                        iconColor: tripTheme.onColorForLeg(leg),
                      ),
                    ),
                Marker(
                  point: origin,
                  width: 24,
                  height: 24,
                  child: _Dot(
                    color: scheme.primary,
                    border: scheme.onPrimary,
                    icon: Icons.trip_origin,
                    iconColor: scheme.onPrimary,
                  ),
                ),
                Marker(
                  point: destination,
                  width: 40,
                  height: 40,
                  alignment: Alignment.topCenter,
                  child: Icon(Icons.location_on, size: 40, color: scheme.error),
                ),
              ],
            ),
          ),
          _Attribution(
            text: '© ${config.attribution}',
            onTap: config.onAttributionTap,
          ),
        ],
      ),
    );
  }
}

/// Bottom-end attribution that wraps at large text sizes (flutter_map's
/// `SimpleAttributionWidget` is a fixed Row and overflows) and is its own
/// semantics node, separate from the map's label.
class _Attribution extends StatelessWidget {
  const _Attribution({required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface,
        decoration: onTap == null ? null : TextDecoration.underline,
      ),
    );
    final radius = const BorderRadiusDirectional.only(
      topStart: Radius.circular(6),
    ).resolve(Directionality.of(context));
    final chip = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: radius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: label,
      ),
    );
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: FractionallySizedBox(
        widthFactor: 0.75,
        alignment: AlignmentDirectional.bottomEnd,
        child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Semantics(
            container: true,
            link: onTap != null,
            child: onTap == null
                ? chip
                // The visible chip is small; the transparent ink area above
                // and beside it makes the target at least 48x48dp.
                : Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: radius,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          widthFactor: 1,
                          heightFactor: 1,
                          child: chip,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.color,
    required this.border,
    required this.icon,
    required this.iconColor,
  });

  final Color color;
  final Color border;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: border, width: 2),
    ),
    child: Center(child: Icon(icon, size: 14, color: iconColor)),
  );
}
