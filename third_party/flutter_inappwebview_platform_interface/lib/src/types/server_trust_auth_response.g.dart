
part of 'server_trust_auth_response.dart';

class ServerTrustAuthResponse {
  ServerTrustAuthResponseAction? action;
  ServerTrustAuthResponse({this.action = ServerTrustAuthResponseAction.CANCEL});

  static ServerTrustAuthResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ServerTrustAuthResponse();
    instance.action =
        ServerTrustAuthResponseAction.fromNativeValue(map['action']);
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ServerTrustAuthResponse{action: $action}';
  }
}
