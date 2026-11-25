import 'package:onebusaway/onebusaway.dart';

import '../settings/settings.dart';

/// Which maps app opens walking directions, once the user has chosen.
enum DirectionsApp { appleMaps, googleMaps }

/// The app [provider] names, or null when the user wants to be asked.
DirectionsApp? directionsAppFor(WalkingDirectionsProvider provider) =>
    switch (provider) {
      WalkingDirectionsProvider.appleMaps => DirectionsApp.appleMaps,
      WalkingDirectionsProvider.googleMaps => DirectionsApp.googleMaps,
      WalkingDirectionsProvider.askEveryTime => null,
    };

/// A universal (https) link for walking (or, with [bike], cycling)
/// directions to [destination] (iOS `AppInterop`). The https forms open
/// the native app when installed and the web site otherwise, on every
/// platform.
Uri walkingDirectionsUrl(
  DirectionsApp app,
  Coordinate destination, {
  bool bike = false,
}) {
  final ll = '${destination.lat},${destination.lon}';
  return switch (app) {
    DirectionsApp.appleMaps => Uri.https('maps.apple.com', '/', {
      'daddr': ll,
      'dirflg': bike ? 'b' : 'w',
    }),
    DirectionsApp.googleMaps => Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': ll,
      'travelmode': bike ? 'bicycling' : 'walking',
    }),
  };
}
