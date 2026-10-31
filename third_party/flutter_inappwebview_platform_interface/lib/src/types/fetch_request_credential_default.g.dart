
part of 'fetch_request_credential_default.dart';

class FetchRequestCredentialDefault extends FetchRequestCredential {
  String? value;
  FetchRequestCredentialDefault({this.value, String? type}) : super(type: type);

  static FetchRequestCredentialDefault? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequestCredentialDefault(
      value: map['value'],
    );
    instance.type = map['type'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "value": value,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequestCredentialDefault{type: $type, value: $value}';
  }
}
