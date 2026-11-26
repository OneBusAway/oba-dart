import 'package:obakit/obakit.dart' show Coordinate;

import 'models.dart';

// Everything in this file is mock data for the demo. Prices are SAMPLE
// values, not real MTS fares, and the stores are fictional.

/// Real MTS stop ids (OneBusAway San Diego), so the embedded SDK widgets
/// show live departures.
abstract final class Stops {
  static const gilmanTransitCenter = 'MTS_11902';
  static const ucsdCentralCampus = 'MTS_88986';
  static const eighthCollege = 'MTS_24151';
}

/// Sample prices.
const oneRide = FareProduct(
  id: 'ride-1',
  name: '1-Ride',
  description: 'One trip, transfers for 2 hours',
  priceCents: 250, // sample
  kind: FareProductKind.ride,
  validity: Duration(hours: 2),
);

const dayPass = FareProduct(
  id: 'pass-day',
  name: 'Day Pass',
  description: 'Unlimited rides until the end of the service day',
  priceCents: 600, // sample
  kind: FareProductKind.pass,
);

const monthPass = FareProduct(
  id: 'pass-30',
  name: '30-Day Pass',
  description: 'Unlimited rides for 30 days',
  priceCents: 7200, // sample
  kind: FareProductKind.pass,
  validity: Duration(days: 30),
);

/// Stored-value top-ups (sample amounts).
const topUps = [
  FareProduct(
    id: 'sv-5',
    name: 'Add \$5.00',
    description: 'Stored value, pays \$2.50 per ride',
    priceCents: 500,
    kind: FareProductKind.storedValue,
  ),
  FareProduct(
    id: 'sv-10',
    name: 'Add \$10.00',
    description: 'Stored value, pays \$2.50 per ride',
    priceCents: 1000,
    kind: FareProductKind.storedValue,
  ),
  FareProduct(
    id: 'sv-20',
    name: 'Add \$20.00',
    description: 'Stored value, pays \$2.50 per ride',
    priceCents: 2000,
    kind: FareProductKind.storedValue,
  ),
];

const passProducts = [oneRide, dayPass, monthPass];

/// End of the service day (11:59 PM) for [now].
DateTime endOfServiceDay(DateTime now) =>
    DateTime(now.year, now.month, now.day, 23, 59);

/// Sample tap history, newest first, relative to [now].
List<Tap> sampleTaps(DateTime now) => [
  Tap(
    id: 'tap-5',
    time: now.subtract(const Duration(minutes: 40)),
    routeShortName: 'Blue',
    routeName: 'UC San Diego Blue Line',
    stopId: Stops.ucsdCentralCampus,
    stopName: 'UCSD Central Campus',
    baseFareCents: 250,
    chargedCents: 0,
    paidWith: 'Day Pass',
  ),
  Tap(
    id: 'tap-4',
    time: now.subtract(const Duration(hours: 3, minutes: 5)),
    routeShortName: '201',
    routeName: 'SuperLoop',
    stopId: Stops.gilmanTransitCenter,
    stopName: 'Gilman Transit Center',
    baseFareCents: 250,
    chargedCents: 0,
    paidWith: 'Day Pass',
  ),
  Tap(
    id: 'tap-3',
    time: now.subtract(const Duration(days: 1, hours: 2)),
    routeShortName: '30',
    routeName: 'Old Town - UTC',
    stopId: Stops.eighthCollege,
    stopName: 'Eighth College / Theatre District',
    baseFareCents: 250,
    chargedCents: 250,
    paidWith: 'Stored value',
  ),
  Tap(
    id: 'tap-2',
    time: now.subtract(const Duration(days: 1, hours: 9)),
    routeShortName: '202',
    routeName: 'SuperLoop',
    stopId: Stops.gilmanTransitCenter,
    stopName: 'Gilman Transit Center',
    baseFareCents: 250,
    chargedCents: 250,
    paidWith: 'Stored value',
  ),
  Tap(
    id: 'tap-1',
    time: now.subtract(const Duration(days: 3, hours: 4)),
    routeShortName: 'Blue',
    routeName: 'UC San Diego Blue Line',
    stopId: Stops.ucsdCentralCampus,
    stopName: 'UCSD Central Campus',
    baseFareCents: 250,
    chargedCents: 250,
    paidWith: 'Stored value',
  ),
];

/// Fictional cash reload stores near UC San Diego.
const reloadLocations = [
  ReloadLocation(
    id: 'store-1',
    name: 'Campus Corner Market',
    address: 'Library Walk, La Jolla',
    hours: 'Daily 7 AM to 11 PM',
    coordinate: Coordinate(32.8795, -117.2368),
  ),
  ReloadLocation(
    id: 'store-2',
    name: 'Gilman Drive Pharmacy',
    address: 'Gilman Dr, La Jolla',
    hours: 'Mon to Sat 8 AM to 9 PM',
    coordinate: Coordinate(32.8768, -117.2331),
  ),
  ReloadLocation(
    id: 'store-3',
    name: 'Village Square Grocery',
    address: 'Villa La Jolla Dr, La Jolla',
    hours: 'Daily 6 AM to midnight',
    coordinate: Coordinate(32.8662, -117.2297),
  ),
  ReloadLocation(
    id: 'store-4',
    name: 'Town Centre News',
    address: 'Genesee Ave, University City',
    hours: 'Daily 9 AM to 9 PM',
    coordinate: Coordinate(32.8707, -117.2113),
  ),
];
