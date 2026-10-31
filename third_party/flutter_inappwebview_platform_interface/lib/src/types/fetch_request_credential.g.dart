
part of 'fetch_request_credential.dart';

class FetchRequestCredential {
  String? type;
  FetchRequestCredential({this.type});

  static FetchRequestCredential? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequestCredential(
      type: map['type'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequestCredential{type: $type}';
  }
}
