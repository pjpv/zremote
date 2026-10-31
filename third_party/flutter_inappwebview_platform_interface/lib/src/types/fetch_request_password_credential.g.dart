
part of 'fetch_request_password_credential.dart';

class FetchRequestPasswordCredential extends FetchRequestCredential {
  WebUri? iconURL;

  dynamic id;

  String? name;

  String? password;
  FetchRequestPasswordCredential(
      {this.iconURL, this.id, this.name, this.password, String? type})
      : super(type: type);

  static FetchRequestPasswordCredential? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequestPasswordCredential(
      iconURL: map['iconURL'] != null ? WebUri(map['iconURL']) : null,
      id: map['id'],
      name: map['name'],
      password: map['password'],
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
      "password": password,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequestPasswordCredential{type: $type, iconURL: $iconURL, id: $id, name: $name, password: $password}';
  }
}
