import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import 'embed_frame.dart';

/// A full-screen host route: the host's own app bar over one embedded OBA
/// page.
///
/// The app's single `ObaScope` sits above the navigator (see `app.dart`),
/// so this route needs no scope of its own. The page is marked embedded, so
/// it drops its own Scaffold and AppBar and the host's app bar is the only
/// one.
class HostObaPage extends StatelessWidget {
  const HostObaPage({
    super.key,
    required this.title,
    required this.sdkWidget,
    required this.child,
    this.showsHeader = false,
  });

  final String title;

  /// The SDK widget's name, for the embed overlay.
  final String sdkWidget;
  final Widget child;

  /// Whether the page shows its own compact header (title and actions).
  final bool showsHeader;

  /// Pushes [page] under a host app bar titled [title].
  static Future<void> push(
    BuildContext context, {
    required String title,
    required String sdkWidget,
    required Widget page,
    bool showsHeader = false,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => HostObaPage(
        title: title,
        sdkWidget: sdkWidget,
        showsHeader: showsHeader,
        child: page,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    // OBA embed: a whole SDK page under the host app bar.
    body: EmbedFrame(
      sdkWidget: sdkWidget,
      fills: true,
      child: ObaPresentationScope.embedded(
        showsHeader: showsHeader,
        child: child,
      ),
    ),
  );
}

/// The trip planner to [name] at [coordinate], under a host app bar.
Future<void> openTripPlanner(
  BuildContext context, {
  required String name,
  required Coordinate coordinate,
}) => HostObaPage.push(
  context,
  title: 'Directions to $name',
  sdkWidget: 'TripPlannerPage',
  // OBA embed: the OTP trip planner, destination prefilled.
  page: TripPlannerPage(
    destination: Place(name: name, coordinate: coordinate),
  ),
);
