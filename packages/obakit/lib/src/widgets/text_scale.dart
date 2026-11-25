import 'package:flutter/widgets.dart';

/// Whether the rider's text size is large enough (150% or more) that
/// side-by-side layouts should stack or scroll instead of squeezing.
///
/// The one threshold for every obakit screen. The leaf packages keep their
/// own (`oba_arrivals` and `obakit_trip_planner` stack at 130%).
bool obaIsLargeText(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(10) >= 15;
