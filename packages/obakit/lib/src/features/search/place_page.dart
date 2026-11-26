import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:share_plus/share_plus.dart';

import '../../widgets/link_opener.dart';
import '../../app/scope.dart';
import '../../features/map/map_coordinator.dart';
import '../../features/map/map_logic.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import '../../l10n/strings_bridge.dart';

/// An OpenStreetMap link to [place], for sharing.
Uri placeWebUrl(Place place) {
  final lat = place.coordinate.lat.toStringAsFixed(6);
  final lon = place.coordinate.lon.toStringAsFixed(6);
  return Uri.parse(
    'https://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=17/$lat/$lon',
  );
}

/// A link that opens [place] in the platform's maps app: Apple Maps on iOS
/// and macOS, a `geo:` intent on Android, OpenStreetMap elsewhere.
Uri placeMapsAppUrl(Place place, TargetPlatform platform) {
  final lat = place.coordinate.lat.toStringAsFixed(6);
  final lon = place.coordinate.lon.toStringAsFixed(6);
  return switch (platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => Uri.https(
      'maps.apple.com',
      '/',
      {'ll': '$lat,$lon', 'q': place.name},
    ),
    TargetPlatform.android => Uri.parse(
      'geo:$lat,$lon?q=${Uri.encodeComponent('$lat,$lon(${place.name})')}',
    ),
    _ => placeWebUrl(place),
  };
}

/// A geocoded place or a dropped pin (iOS `MapItemView`): name, address,
/// coordinates and distance, with Directions to / from here (when the
/// region has trip planning), Nearby stops, Share, Open in maps app, and
/// Remove pin for dropped pins. Shows a marker on the map when there is
/// one.
///
/// Embeddable: needs only an `ObaScope`.
class PlacePage extends StatefulWidget {
  const PlacePage({super.key, required this.place, this.isDroppedPin = false});

  final Place place;
  final bool isDroppedPin;

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  bool _moved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_moved) return;
    _moved = true;
    final map = ObaMapCoordinator.maybeOf(context);
    if (map != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        map.moveTo(
          widget.place.coordinate,
          zoom: ObaMapLogic.focusStopZoom - 1,
        );
      });
    }
  }

  Future<void> _share(BuildContext buttonContext) async {
    final l10n = context.obaL10n;
    final place = widget.place;
    final box = buttonContext.findRenderObject() as RenderBox?;
    final text = [
      place.name,
      ?place.subtitle,
      placeWebUrl(place).toString(),
    ].join('\n');
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: place.name,
          sharePositionOrigin: box == null || !box.hasSize
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } catch (_) {
      if (mounted) obaNotify(context, l10n.searchPlaceShareFailed);
    }
  }

  Future<void> _openInMaps() async {
    final l10n = context.obaL10n;
    final uri = placeMapsAppUrl(widget.place, defaultTargetPlatform);
    // A `geo:` link needs a maps app; the web map is the fallback.
    if (uri.scheme == 'geo' && await ObaLinkOpenerScope.of(context).open(uri)) {
      return;
    }
    if (!mounted) return;
    await obaOpenLink(
      context,
      uri.scheme == 'geo' ? placeWebUrl(widget.place) : uri,
      failureMessage: l10n.searchPlaceOpenFailed,
    );
  }

  // The pin is this page's overlay ([ObaMapOverlays] below): closing the
  // page removes it and leaves the previous page's overlay alone.
  void _removePin() => ObaNavigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final app = ObaScope.of(context);
    final place = widget.place;
    final theme = Theme.of(context);
    final here = app.core.currentLocation?.coordinate;
    final canPlan = app.core.tripPlanningStatus == FeatureStatus.running;
    final coords =
        '${place.coordinate.lat.toStringAsFixed(5)}, '
        '${place.coordinate.lon.toStringAsFixed(5)}';
    final navigator = ObaNavigator.of(context);

    Widget detail(String label, String value) => MergeSemantics(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SelectableText(value, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );

    final actions = <Widget>[
      if (canPlan) ...[
        ObaListRow(
          leading: const Icon(Icons.directions),
          title: l10n.searchPlaceDirectionsTo,
          onTap: () => navigator.push(TripPlannerRoute(destination: place)),
        ),
        ObaListRow(
          leading: const Icon(Icons.trip_origin),
          title: l10n.searchPlaceDirectionsFrom,
          onTap: () => navigator.push(TripPlannerRoute(origin: place)),
        ),
      ],
      ObaListRow(
        leading: const Icon(Icons.near_me_outlined),
        title: l10n.searchPlaceNearbyStops,
        onTap: () =>
            navigator.push(NearbyStopsRoute(coordinate: place.coordinate)),
      ),
      Builder(
        builder: (buttonContext) => ObaListRow(
          leading: const Icon(Icons.share_outlined),
          title: l10n.searchPlaceShare,
          onTap: () => _share(buttonContext),
        ),
      ),
      ObaListRow(
        leading: const Icon(Icons.map_outlined),
        title: l10n.searchPlaceOpenInMaps,
        onTap: _openInMaps,
      ),
      if (widget.isDroppedPin)
        ObaListRow(
          leading: Icon(
            Icons.wrong_location_outlined,
            color: theme.colorScheme.error,
          ),
          title: l10n.searchPlaceRemovePin,
          onTap: _removePin,
        ),
    ];

    return ObaMapOverlays(
      overlay: ObaMapOverlay(
        markers: [
          ObaMapMarker(
            coordinate: place.coordinate,
            label: l10n.searchPlaceMarkerLabel(place.name),
            kind: ObaMapMarkerKind.place,
          ),
        ],
      ),
      child: ObaSheetPage(
        title: place.name,
        slivers: [
          SliverList.list(
            children: [
              if (place.subtitle != null && place.subtitle!.isNotEmpty)
                detail(l10n.searchPlaceAddress, place.subtitle!),
              detail(l10n.searchPlaceCoordinates, coords),
              if (here != null)
                detail(
                  l10n.searchPlaceDistance,
                  context.obaFormatters.distance(
                    distanceBetween(here, place.coordinate),
                  ),
                ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              ...actions,
            ],
          ),
        ],
      ),
    );
  }
}
