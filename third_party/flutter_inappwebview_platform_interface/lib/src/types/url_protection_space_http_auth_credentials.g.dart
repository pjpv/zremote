
part of 'url_protection_space_http_auth_credentials.dart';

class URLProtectionSpaceHttpAuthCredentials {
  List<URLCredential>? credentials;

  URLProtectionSpace? protectionSpace;
  URLProtectionSpaceHttpAuthCredentials(
      {this.credentials, this.protectionSpace});

  static URLProtectionSpaceHttpAuthCredentials? fromMap(
      Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = URLProtectionSpaceHttpAuthCredentials(
      credentials: map['credentials'] != null
          ? List<URLCredential>.from(map['credentials']
              .map((e) => URLCredential.fromMap(e?.cast<String, dynamic>())!))
          : null,
      protectionSpace: URLProtectionSpace.fromMap(
          map['protectionSpace']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "credentials": credentials?.map((e) => e.toMap()).toList(),
      "protectionSpace": protectionSpace?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'URLProtectionSpaceHttpAuthCredentials{credentials: $credentials, protectionSpace: $protectionSpace}';
  }
}
