/// Embeddable OneBusAway arrivals and departures panel.
library;

/// Apps get the OneBusAway client through this package, so they can depend
/// on `oba_arrivals` alone. The `Route` model is hidden because it collides
/// with Flutter's `Route`; import `package:onebusaway/onebusaway.dart` with a
/// prefix (`as oba`) if you need it.
export 'package:onebusaway/onebusaway.dart' hide Route;

export 'src/arrivals_controller.dart';
export 'src/arrivals_panel.dart';
export 'src/color_utils.dart';
export 'src/display/arrival_display.dart';
export 'src/display/arrival_filtering.dart';
export 'src/display/stop_display.dart';
export 'src/route_badge.dart';
export 'src/strings.dart';
export 'src/theme.dart';
export 'src/widgets/arrival_row.dart' show formatArrivalTime;
