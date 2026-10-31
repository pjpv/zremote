
part of 'prewarming_token.dart';

class PrewarmingToken {
  final String id;
  PrewarmingToken({required this.id});

  static PrewarmingToken? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PrewarmingToken(
      id: map['id'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PrewarmingToken{id: $id}';
  }
}
