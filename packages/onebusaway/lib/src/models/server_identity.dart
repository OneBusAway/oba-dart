import '../core/json.dart';

/// Entry of `config`: who the server is.
class ServerIdentity {
  const ServerIdentity({
    this.id,
    this.name,
    this.serviceDateFrom,
    this.serviceDateTo,
    this.gitProperties = const {},
  });

  factory ServerIdentity.fromJson(JsonMap json) {
    final git = readOptMap(json, 'gitProperties') ?? const {};
    return ServerIdentity(
      id: readOptString(json, 'id'),
      name: readOptString(json, 'name'),
      serviceDateFrom: readOptString(json, 'serviceDateFrom'),
      serviceDateTo: readOptString(json, 'serviceDateTo'),
      gitProperties: {
        for (final MapEntry(:key, :value) in git.entries)
          if (value is String) key: value,
      },
    );
  }

  /// The id maglev reports.
  static const maglevId = 'oba-maglev';

  /// `oba-maglev` for maglev; the Java server sends a bundle UUID or `""`
  /// (which becomes null).
  final String? id;
  final String? name;
  final String? serviceDateFrom;
  final String? serviceDateTo;

  /// e.g. `{"git.build.version": "2.7.1"}`.
  final Map<String, String> gitProperties;

  /// Whether the server identifies itself as maglev. Version numbers can't
  /// tell maglev and Java apart; only [id] can.
  bool get isMaglev => id == maglevId;
}
