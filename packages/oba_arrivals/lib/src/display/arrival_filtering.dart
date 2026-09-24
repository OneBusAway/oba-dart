import 'package:onebusaway/onebusaway.dart';

import 'arrival_display.dart';

/// Drops rows that already arrived (negative ETA) or have no times.
List<ArrivalAndDeparture> filterDeparted(
  List<ArrivalAndDeparture> arrivals,
  DateTime now,
) =>
    arrivals.where((a) {
      final eta = minutesUntil(a, now);
      return eta != null && eta >= 0;
    }).toList();

/// Drops the arrival-at-final-stop row when the same vehicle's next trip in
/// the block departs from this stop, so a layover shows as one row
/// (port of Wayfinder's `collapseLayovers`).
List<ArrivalAndDeparture> collapseLayovers(List<ArrivalAndDeparture> arrivals) =>
    arrivals.where((a) {
      final total = a.totalStopsInTrip;
      final vehicle = a.vehicleId;
      final block = a.blockTripSequence;
      if (total == null || vehicle == null || block == null) return true;
      if (a.stopSequence != total - 1) return true;
      final departsNext = arrivals.any((b) =>
          b.stopSequence == 0 &&
          b.vehicleId == vehicle &&
          b.serviceDate == a.serviceDate &&
          b.blockTripSequence == block + 1);
      return !departsNext;
    }).toList();

/// The rows the panel shows, in server order.
List<ArrivalAndDeparture> visibleArrivals(
  List<ArrivalAndDeparture> raw,
  DateTime now,
) =>
    collapseLayovers(filterDeparted(raw, now));
