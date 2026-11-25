import 'package:flutter/material.dart';

import '../api/api.dart';
import '../display/itinerary_display.dart';

IconData transportModeIcon(TransportMode mode) => switch (mode) {
  TransportMode.transit => Icons.directions_transit,
  TransportMode.walk => Icons.directions_walk,
  TransportMode.bike => Icons.directions_bike,
  TransportMode.car => Icons.directions_car,
  TransportMode.bikeRental => Icons.pedal_bike,
  TransportMode.transitBikeRental => Icons.commute,
};

IconData legIcon(Leg leg) => switch (LegKind.of(leg)) {
  LegKind.walk => Icons.directions_walk,
  LegKind.bike => Icons.directions_bike,
  LegKind.rentalBike => Icons.pedal_bike,
  LegKind.car => Icons.directions_car,
  LegKind.transit => switch (leg.legMode) {
    LegMode.tram => Icons.tram,
    LegMode.subway || LegMode.monorail => Icons.subway,
    LegMode.rail => Icons.train,
    LegMode.ferry => Icons.directions_boat,
    LegMode.cableCar || LegMode.gondola || LegMode.funicular => Icons.cable,
    LegMode.airplane => Icons.flight,
    _ => Icons.directions_bus,
  },
};
