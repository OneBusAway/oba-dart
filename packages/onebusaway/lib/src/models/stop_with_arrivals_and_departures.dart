import '../core/json.dart';
import 'arrival_and_departure.dart';

class StopWithArrivalsAndDepartures {
  const StopWithArrivalsAndDepartures({
    required this.stopId,
    this.arrivalsAndDepartures = const [],
    this.nearbyStopIds = const [],
    this.situationIds = const [],
  });

  factory StopWithArrivalsAndDepartures.fromJson(JsonMap json) =>
      StopWithArrivalsAndDepartures(
        stopId: readString(json, 'stopId'),
        arrivalsAndDepartures: readList(
          json,
          'arrivalsAndDepartures',
          (item) => ArrivalAndDeparture.fromJson(
              asJsonMap(item, 'arrivalsAndDepartures[]')),
        ),
        nearbyStopIds: readStringList(json, 'nearbyStopIds'),
        situationIds: readStringList(json, 'situationIds'),
      );

  final String stopId;

  /// In server order.
  final List<ArrivalAndDeparture> arrivalsAndDepartures;
  final List<String> nearbyStopIds;
  final List<String> situationIds;
}
