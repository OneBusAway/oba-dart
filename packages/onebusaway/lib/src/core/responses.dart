import 'references.dart';

/// A response whose `data` holds a single `entry`.
class ObaEntryResponse<T> {
  const ObaEntryResponse({
    required this.entry,
    required this.references,
    required this.currentTime,
    required this.version,
  });

  final T entry;
  final References references;

  /// The server's clock when it answered. Use it to correct device clock skew.
  final DateTime currentTime;
  final int version;
}

/// A response whose `data` holds a `list`.
class ObaListResponse<T> {
  const ObaListResponse({
    required this.list,
    required this.references,
    required this.currentTime,
    required this.version,
    required this.limitExceeded,
    required this.outOfRange,
  });

  final List<T> list;
  final References references;
  final DateTime currentTime;
  final int version;
  final bool limitExceeded;
  final bool outOfRange;
}
