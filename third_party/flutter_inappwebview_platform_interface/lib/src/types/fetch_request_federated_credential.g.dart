
part of 'fetch_request_federated_credential.dart';

class FetchRequestFederatedCredential extends FetchRequestCredential {
  WebUri? iconURL;

  dynamic id;

  String? name;

  String? protocol;

  String? provider;
  FetchRequestFederatedCredential(
      {this.iconURL,
      this.id,
      this.name,
      this.protocol,
      this.provider,
      String? type})
      : super(type: type);

  static FetchRequestFederatedCredential? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequestFederatedCredential(
      iconURL: map['iconURL'] != null ? WebUri(map['iconURL']) : null,
      id: map['id'],
      name: map['name'],
      protocol: map['protocol'],
      provider: map['provider'],
    );
    instance.type = map['type'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "iconURL": iconURL?.toString(),
      "id": id,
      "name": name,
      "protocol": protocol,
      "provider": provider,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequestFederatedCredential{type: $type, iconURL: $iconURL, id: $id, name: $name, protocol: $protocol, provider: $provider}';
  }
}
