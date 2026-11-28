import 'dart:async';

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

  /// Fires when the next active pass expires, so screens that show it
  /// rebuild. Runs only while someone listens.
  Timer? _expiryTimer;
  static const _maxExpiryWait = Duration(days: 1);

  @override
  void addListener(VoidCallback listener) {
    final first = !hasListeners;
    super.addListener(listener);
    if (first) _scheduleExpiry();
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) _cancelExpiry();
  }

  @override
  void dispose() {
    _cancelExpiry();
    super.dispose();
  }

  void _cancelExpiry() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
  }

  void _scheduleExpiry() {
    _cancelExpiry();
    if (!hasListeners) return;
    final t = now();
    DateTime? next;
    for (final p in _passes) {
      if (p.isActiveAt(t) && (next == null || p.expiresAt.isBefore(next))) {
        next = p.expiresAt;
      }
    }
    if (next == null) return;
    // Browsers fire a setTimeout longer than ~24.8 days at once, so a
    // 30-Day Pass would spin. Wake at least daily and check again.
    final wait = next.difference(t);
    final capped = wait > _maxExpiryWait;
    _expiryTimer = Timer(capped ? _maxExpiryWait : wait, () {
      if (!capped) notifyListeners();
      _scheduleExpiry();
    });
  }

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
        _scheduleExpiry();
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
  if (active == null || active.product.kind != FareProductKind.pass) {
    if (rides + 1 >= (dayPass.priceCents / rideCost).ceil()) {
      advice.add(
        '3 or more rides today? A Day Pass (${formatMoney(dayPass.priceCents)}) '
        'costs less than 3 single rides '
        '(${formatMoney(rideCost * 3)}).',
      );
    } else if (active?.product.kind == FareProductKind.ride) {
      advice.add(
        'Your ${active!.product.name} pays toward your next trip. For one or two '
        'more today, stored value (${formatMoney(rideCost)} a ride) is the '
        'cheapest way.',
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
  final usable = wallet.activePasses.where((p) => _passApplies(p, trip));
  final pass = usable
      .where(
        (p) =>
            p.product.kind == FareProductKind.pass ||
            p.product.priceCents >= cents,
      )
      .firstOrNull;
  // A 1-Ride worth less than the trip pays its value toward it, the way a
  // transfer to a pricier leg pays only the difference.
  final ride = pass == null ? usable.firstOrNull : null;
  final credit = ride?.product.priceCents ?? 0;
  final rest = cents - credit;
  final String covered;
  if (cents == 0) {
    covered = 'no fare to pay';
  } else if (pass != null) {
    covered = 'your ${pass.product.name} covers it';
  } else if (ride != null) {
    final part = 'your ${ride.product.name} covers ${formatMoney(credit)}';
    covered = wallet.balanceCents >= rest
        ? '$part and stored value the other ${formatMoney(rest)}'
        : '$part; add ${formatMoney(rest - wallet.balanceCents)} of stored '
              'value to cover the rest';
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

/// Whether [pass] can pay toward [trip]. An unlimited pass must last until
/// the trip ends. A 1-Ride pays for one fare (up to its price), and only
/// for boardings before it expires (its transfers run out, not the ride).
bool _passApplies(Pass pass, tp.Itinerary trip) {
  if (pass.product.kind == FareProductKind.pass) {
    return pass.expiresAt.isAfter(trip.endTime);
  }
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
