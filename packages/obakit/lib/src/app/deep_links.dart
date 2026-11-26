import 'package:obakit_core/obakit_core.dart';

import '../navigation/oba_route.dart';

/// What to do with an incoming link.
sealed class DeepLinkAction {
  const DeepLinkAction();
}

/// Push [route] (after switching to [switchToRegion], when set).
final class OpenRouteAction extends DeepLinkAction {
  const OpenRouteAction(this.route, {this.switchToRegion});
  final ObaRoute route;
  final Region? switchToRegion;
}

/// The link is for a region the app does not know.
final class UnknownRegionAction extends DeepLinkAction {
  const UnknownRegionAction(this.regionId);
  final int regionId;
}

/// Turns links into SDK routes, using obakit_core's `DeepLinkRouter` for
/// parsing. The SDK does not own platform link plumbing: the host passes
/// links to `ObaApp(initialLink:, links:)` (or calls [resolve] itself).
class ObaDeepLinkHandler {
  const ObaDeepLinkHandler(this.app);

  final ObaCoreApplication app;

  /// The action for [uri], or null when it is not a OneBusAway link.
  DeepLinkAction? resolve(Uri uri) {
    final link = app.deepLinks.parse(uri);
    if (link == null) return null;
    return actionFor(link);
  }

  DeepLinkAction actionFor(DeepLink link) {
    switch (link) {
      case ViewStopDeepLink(:final stopId, :final regionId):
        return _inRegion(regionId, StopRoute(stopId));
      case TripArrivalDeepLink(:final link):
        return _inRegion(link.regionId, TripRoute(TripRef.fromDeepLink(link)));
      case AddRegionDeepLink(:final data):
        return OpenRouteAction(CustomRegionRoute(prefill: data));
    }
  }

  DeepLinkAction _inRegion(int? regionId, ObaRoute route) {
    if (regionId == null || regionId == app.currentRegion?.id) {
      return OpenRouteAction(route);
    }
    final region = app.regions.find(regionId);
    if (region == null) return UnknownRegionAction(regionId);
    return OpenRouteAction(route, switchToRegion: region);
  }
}
