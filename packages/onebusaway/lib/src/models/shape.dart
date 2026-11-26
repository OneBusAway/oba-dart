import '../core/json.dart';

/// Entry of `shape/{id}`: an encoded polyline.
class Shape {
  const Shape({required this.points, this.length, this.levels});

  factory Shape.fromJson(JsonMap json) => Shape(
    points: readString(json, 'points'),
    length: readOptInt(json, 'length'),
    levels: readOptString(json, 'levels'),
  );

  /// Google polyline-algorithm encoded points.
  final String points;

  /// Number of points.
  final int? length;
  final String? levels;
}
