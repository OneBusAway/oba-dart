import 'package:onebusaway/onebusaway.dart';

import '../foundation/json.dart';
import 'stored_stop.dart';

/// A recently viewed stop and the region it belongs to.
class RecentStop {
  const RecentStop({required this.stop, required this.regionId});

  factory RecentStop.fromJson(JsonObject j) {
    final stop = jObject(j, 'stop');
    if (stop == null) throw const FormatException('recent stop');
    return RecentStop(
      stop: StoredStop.fromJson(stop),
      regionId: jInt(j, 'regionId') ?? (throw const FormatException('region')),
    );
  }

  final StoredStop stop;
  final int regionId;

  JsonObject toJson() => {'stop': stop.toJson(), 'regionId': regionId};

  @override
  bool operator ==(Object other) =>
      other is RecentStop && other.stop == stop && other.regionId == regionId;

  @override
  int get hashCode => Object.hash(stop, regionId);
}

/// A recently chosen search result place (iOS `recentMapItems`).
class RecentPlace {
  const RecentPlace({
    required this.name,
    required this.lat,
    required this.lon,
    this.subtitle,
  });

  factory RecentPlace.fromJson(JsonObject j) => RecentPlace(
    name: jString(j, 'name') ?? '',
    subtitle: jString(j, 'subtitle'),
    lat: jDouble(j, 'lat') ?? (throw const FormatException('lat')),
    lon: jDouble(j, 'lon') ?? (throw const FormatException('lon')),
  );

  final String name;
  final String? subtitle;
  final double lat;
  final double lon;

  Coordinate get coordinate => Coordinate(lat, lon);

  JsonObject toJson() => {
    'name': name,
    'subtitle': ?subtitle,
    'lat': lat,
    'lon': lon,
  };

  @override
  bool operator ==(Object other) =>
      other is RecentPlace &&
      other.name == name &&
      other.subtitle == subtitle &&
      other.lat == lat &&
      other.lon == lon;

  @override
  int get hashCode => Object.hash(name, subtitle, lat, lon);
}
