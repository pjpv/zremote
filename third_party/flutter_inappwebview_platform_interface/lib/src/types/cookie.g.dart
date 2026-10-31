
part of 'cookie.dart';

class Cookie {
  String? domain;

  int? expiresDate;

  bool? isHttpOnly;

  bool? isSecure;

  bool? isSessionOnly;

  String name;

  String? path;

  HTTPCookieSameSitePolicy? sameSite;

  dynamic value;
  Cookie(
      {this.domain,
      this.expiresDate,
      this.isHttpOnly,
      this.isSecure,
      this.isSessionOnly,
      required this.name,
      this.path,
      this.sameSite,
      this.value});

  static Cookie? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = Cookie(
      domain: map['domain'],
      expiresDate: map['expiresDate'],
      isHttpOnly: map['isHttpOnly'],
      isSecure: map['isSecure'],
      isSessionOnly: map['isSessionOnly'],
      name: map['name'],
      path: map['path'],
      sameSite: HTTPCookieSameSitePolicy.fromNativeValue(map['sameSite']),
      value: map['value'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "domain": domain,
      "expiresDate": expiresDate,
      "isHttpOnly": isHttpOnly,
      "isSecure": isSecure,
      "isSessionOnly": isSessionOnly,
      "name": name,
      "path": path,
      "sameSite": sameSite?.toNativeValue(),
      "value": value,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'Cookie{domain: $domain, expiresDate: $expiresDate, isHttpOnly: $isHttpOnly, isSecure: $isSecure, isSessionOnly: $isSessionOnly, name: $name, path: $path, sameSite: $sameSite, value: $value}';
  }
}
