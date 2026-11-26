import 'package:flutter/foundation.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import 'mock_data.dart';
import 'models.dart';

/// The rider's in-memory wallet: stored value, passes and tap history.
/// Nothing is persisted and no payment is ever taken.
class Wallet extends ChangeNotifier {
  Wallet({
    required this._balanceCents,
    required List<Pass> passes,
    required List<Tap> taps,
    DateTime Function()? now,
  }) : _passes = List.of(passes),
       _taps = List.of(taps),
       _now = now ?? DateTime.now;

  /// The demo wallet: $18.50 stored value, a Day Pass active today, and a
  /// few recent taps.
  factory Wallet.sample({DateTime Function()? now}) {
    final clock = now ?? DateTime.now;
    final t = clock();
    final morning = DateTime(t.year, t.month, t.day, 5);
    return Wallet(
      now: clock,
      balanceCents: 1850,
      passes: [
        Pass(
          id: 'pass-today',
          product: dayPass,
          activatedAt: t.isBefore(morning) ? t : morning,
          expiresAt: endOfServiceDay(t),
        ),
      ],
      taps: sampleTaps(t),
    );
  }

  final DateTime Function() _now;
  int _balanceCents;
  final List<Pass> _passes;
  final List<Tap> _taps;
  int _nextId = 1;

  DateTime now() => _now();

  int get balanceCents => _balanceCents;

  /// Newest first.
  List<Tap> get taps => List.unmodifiable(_taps);

  Tap? get lastTap => _taps.isEmpty ? null : _taps.first;

  /// The active pass that lasts longest, or null. An unlimited pass wins
  /// over a 1-Ride, even one bought late in the day that outlasts it.
  Pass? get activePass {
    final active = activePasses;
    return active.isEmpty ? null : active.first;
  }

  /// Every active pass, best first: unlimited passes before 1-Rides, then
  /// the one that lasts longest.
  List<Pass> get activePasses {
    final t = now();
    int unlimited(Pass p) => p.product.kind == FareProductKind.pass ? 0 : 1;
    return _passes.where((p) => p.isActiveAt(t)).toList()..sort((a, b) {
      final byKind = unlimited(a).compareTo(unlimited(b));
      return byKind != 0 ? byKind : b.expiresAt.compareTo(a.expiresAt);
    });
  }

  /// Taps since midnight today.
  int get ridesToday {
    final t = now();
    final midnight = DateTime(t.year, t.month, t.day);
    return _taps.where((tap) => !tap.time.isBefore(midnight)).length;
  }

  /// A demo purchase: adds stored value or a pass. No charge is made.
  void purchase(FareProduct product) {
    final t = now();
    switch (product.kind) {
      case FareProductKind.storedValue:
        _balanceCents += product.priceCents;
      case FareProductKind.ride:
      case FareProductKind.pass:
        _passes.add(
          Pass(
            id: 'bought-${_nextId++}',
            product: product,
            activatedAt: t,
            expiresAt: product.validity == null
                ? endOfServiceDay(t)
                : t.add(product.validity!),
          ),
        );
    }
    notifyListeners();
  }
}

/// Host fare advice, from the rider's own history and the sample prices.
/// This is Tapline logic, not something the OneBusAway SDK provides.
///
/// When the rider has opened an itinerary in the trip planner ([trip], from
/// `onItinerarySelected`), the first line is a fare suggestion for it (see
/// [tripFareSuggestion]).
List<String> fareAdvice(Wallet wallet, {tp.Itinerary? trip}) {
  final advice = <String>[
    if (trip != null) tripFareSuggestion(wallet, trip).text,
  ];
  // A 1-Ride only covers transfers for 2 hours, not the rest of the day.
  final active = wallet.activePass;
  final rides = wallet.ridesToday;
  final rideCost = oneRide.priceCents;
  final hasRide = wallet.activePasses.any(
    (p) => p.product.kind == FareProductKind.ride,
  );
  if (active == null || active.product.kind != FareProductKind.pass) {
    if (rides + 1 >= (dayPass.priceCents / rideCost).ceil()) {
      advice.add(
        '3 or more rides today? A Day Pass (${formatMoney(dayPass.priceCents)}) '
        'costs less than 3 single rides '
        '(${formatMoney(rideCost * 3)}).',
      );
    } else if (hasRide) {
      advice.add(
        'Your 1-Ride already covers your next trip (transfers for 2 hours). '
        'For trips after that, stored value is the cheapest way.',
      );
    } else {
      advice.add(
        'Just one or two trips today? A 1-Ride '
        '(${formatMoney(rideCost)}) or stored value is the cheapest way.',
      );
    }
  } else {
    advice.add(
      'Your ${active.product.name} already covers every ride today, so you '
      "don't need to buy anything.",
    );
  }
  final breakEven = (monthPass.priceCents / rideCost).ceil();
  advice.add(
    'Riding $breakEven or more times a month? The 30-Day Pass '
    '(${formatMoney(monthPass.priceCents)}) pays for itself.',
  );
  return advice;
}

/// A fare suggestion for one planned trip.
typedef TripFareSuggestion = ({int cents, bool fromPlanner, String text});

/// Suggests what [trip] costs and whether the [wallet] already covers it.
///
/// Uses the fare the trip planner reports when there is one (in US
/// dollars, the currency of Tapline's sample prices). Most OTP servers
/// report none, so otherwise the fare comes from [sampleTripFareCents].
TripFareSuggestion tripFareSuggestion(Wallet wallet, tp.Itinerary trip) {
  final fare = trip.fare;
  final fromPlanner = fare != null && fare.currencyCode == 'USD';
  final cents = fromPlanner ? fare.cents : sampleTripFareCents(trip);
  // Any active pass that pays for it: a Day Pass that runs out mid-trip
  // doesn't, but a 1-Ride bought late in the day still might.
  final pass = wallet.activePasses
      .where((p) => _passCovers(p, trip, cents))
      .firstOrNull;
  // A 1-Ride that doesn't pay the whole fare still pays part of it, so
  // only the difference is left for stored value.
  final ride = wallet.activePasses
      .where(
        (p) => p.product.kind == FareProductKind.ride && _rideApplies(p, trip),
      )
      .firstOrNull;
  final rideCredit = ride == null
      ? 0
      : (cents < ride.product.priceCents ? cents : ride.product.priceCents);
  final remaining = cents - rideCredit;
  final String covered;
  if (cents == 0) {
    covered = 'no fare to pay';
  } else if (pass != null) {
    covered = 'your ${pass.product.name} covers it';
  } else if (ride != null) {
    covered = wallet.balanceCents >= remaining
        ? 'your ${ride.product.name} plus stored value covers it'
        : 'add ${formatMoney(remaining - wallet.balanceCents)} of stored '
              'value to cover it';
  } else if (wallet.balanceCents >= cents) {
    covered = 'stored value covers it';
  } else {
    covered =
        'add ${formatMoney(cents - wallet.balanceCents)} of stored value '
        'to cover it';
  }
  return (
    cents: cents,
    fromPlanner: fromPlanner,
    text: 'Suggested fare for your trip: ${formatMoney(cents)} ($covered)',
  );
}

/// Whether [pass] pays for [trip], which costs [cents]. An unlimited pass
/// must last until the trip ends. A 1-Ride pays for one fare, and only for
/// boardings before it expires (its transfers run out, not the ride).
bool _passCovers(Pass pass, tp.Itinerary trip, int cents) {
  if (pass.product.kind == FareProductKind.pass) {
    return pass.expiresAt.isAfter(trip.endTime);
  }
  if (cents > pass.product.priceCents) return false;
  return _rideApplies(pass, trip);
}

/// Whether a 1-Ride's 2-hour window reaches the trip's last boarding.
bool _rideApplies(Pass pass, tp.Itinerary trip) {
  final boardings = trip.legs.where((l) => l.transitLeg);
  final lastBoarding = boardings.isEmpty
      ? trip.endTime
      : boardings.last.startTime;
  return pass.expiresAt.isAfter(lastBoarding);
}

/// SAMPLE prices per boarding, by agency name, then by OTP mode. Made up
/// for the demo, like every other Tapline price.
const sampleFareByAgency = {'Sound Transit': 300};
const sampleFareByMode = {
  'BUS': 250,
  'TROLLEYBUS': 250,
  'TRAM': 250,
  'SUBWAY': 300,
  'RAIL': 500,
  'FERRY': 600,
};

/// [trip]'s fare from the sample tables, counting its transit legs.
///
/// Like the 1-Ride, one fare covers transfers for 2 hours: a boarding
/// within 2 hours of the one that paid is free, except that a pricier leg
/// pays the difference. A boarding after that pays a new fare.
int sampleTripFareCents(tp.Itinerary trip) {
  var total = 0;
  DateTime? windowStart;
  var windowPrice = 0;
  for (final leg in trip.legs.where((l) => l.transitLeg)) {
    final price =
        sampleFareByAgency[leg.agencyName] ??
        sampleFareByMode[leg.mode.toUpperCase()] ??
        oneRide.priceCents;
    final start = windowStart;
    if (start == null ||
        leg.startTime.difference(start) > const Duration(hours: 2)) {
      windowStart = leg.startTime;
      windowPrice = price;
      total += price;
    } else if (price > windowPrice) {
      total += price - windowPrice;
      windowPrice = price;
    }
  }
  return total;
}
