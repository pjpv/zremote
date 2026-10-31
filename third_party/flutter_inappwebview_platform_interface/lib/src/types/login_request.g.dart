
part of 'login_request.dart';

class LoginRequest {
  String? account;

  String args;

  String realm;
  LoginRequest({this.account, required this.args, required this.realm});

  static LoginRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = LoginRequest(
      account: map['account'],
      args: map['args'],
      realm: map['realm'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "account": account,
      "args": args,
      "realm": realm,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'LoginRequest{account: $account, args: $args, realm: $realm}';
  }
}
