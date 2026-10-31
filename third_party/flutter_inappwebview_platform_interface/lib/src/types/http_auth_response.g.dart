
part of 'http_auth_response.dart';

class HttpAuthResponse {
  HttpAuthResponseAction? action;

  String password;

  bool permanentPersistence;

  String username;
  HttpAuthResponse(
      {this.action = HttpAuthResponseAction.CANCEL,
      this.password = "",
      this.permanentPersistence = false,
      this.username = ""});

  static HttpAuthResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = HttpAuthResponse();
    instance.action = HttpAuthResponseAction.fromNativeValue(map['action']);
    instance.password = map['password'];
    instance.permanentPersistence = map['permanentPersistence'];
    instance.username = map['username'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "password": password,
      "permanentPersistence": permanentPersistence,
      "username": username,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'HttpAuthResponse{action: $action, password: $password, permanentPersistence: $permanentPersistence, username: $username}';
  }
}
