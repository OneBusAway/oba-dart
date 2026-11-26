import 'package:obakit/obakit.dart' show Coordinate;

/// Formats cents as dollars, e.g. `$18.50`.
String formatMoney(int cents) {
  final sign = cents < 0 ? '-' : '';
  final abs = cents.abs();
  return '$sign\$${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
}

enum FareProductKind { ride, pass, storedValue }

/// Something a rider can buy.
class FareProduct {
  const FareProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCents,
    required this.kind,
    this.validity,
  });

  final String id;
  final String name;
  final String description;
  final int priceCents;
  final FareProductKind kind;

  /// How long a ride or pass lasts once bought. Null for stored value, and
  /// for the Day Pass (which runs to the end of the service day).
  final Duration? validity;

  bool get isPass => kind != FareProductKind.storedValue;
}

/// A ticket or pass in the wallet.
class Pass {
  const Pass({
    required this.id,
    required this.product,
    required this.activatedAt,
    required this.expiresAt,
  });

  final String id;
  final FareProduct product;
  final DateTime activatedAt;
  final DateTime expiresAt;

  bool isActiveAt(DateTime now) =>
      !now.isBefore(activatedAt) && now.isBefore(expiresAt);
}

/// One tap at a validator.
class Tap {
  const Tap({
    required this.id,
    required this.time,
    required this.routeShortName,
    required this.routeName,
    required this.stopId,
    required this.stopName,
    required this.baseFareCents,
    required this.chargedCents,
    required this.paidWith,
  });

  final String id;
  final DateTime time;
  final String routeShortName;
  final String routeName;

  /// An OneBusAway stop id (e.g. `MTS_11902`), so the app can show live
  /// departures for the stop.
  final String stopId;
  final String stopName;
  final int baseFareCents;
  final int chargedCents;

  /// The pass name, or "Stored value".
  final String paidWith;

  int get coveredCents => baseFareCents - chargedCents;
}

/// A store where riders can reload their card with cash.
class ReloadLocation {
  const ReloadLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.hours,
    required this.coordinate,
  });

  final String id;
  final String name;
  final String address;
  final String hours;
  final Coordinate coordinate;
}
