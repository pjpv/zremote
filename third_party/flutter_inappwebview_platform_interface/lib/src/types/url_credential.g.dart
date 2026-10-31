
part of 'url_credential.dart';

class URLCredential {
  List<X509Certificate>? certificates;

  @Deprecated('Use certificates instead')
  List<X509Certificate>? iosCertificates;

  @Deprecated('Use persistence instead')
  IOSURLCredentialPersistence? iosPersistence;

  String? password;

  URLCredentialPersistence? persistence;

  String? username;
  URLCredential(
      {this.certificates,
      @Deprecated('Use certificates instead') this.iosCertificates,
      @Deprecated('Use persistence instead') this.iosPersistence,
      this.password,
      this.persistence,
      this.username}) {
    certificates = certificates ?? iosCertificates;
    persistence = persistence ??
        URLCredentialPersistence.fromNativeValue(
            iosPersistence?.toNativeValue());
  }

  static URLCredential? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = URLCredential(
      certificates: _certificatesDeserializer(map['certificates']),
      iosCertificates: _certificatesDeserializer(map['certificates']),
      iosPersistence:
          IOSURLCredentialPersistence.fromNativeValue(map['persistence']),
      password: map['password'],
      persistence: URLCredentialPersistence.fromNativeValue(map['persistence']),
      username: map['username'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "certificates": certificates?.map((e) => e.toMap()).toList(),
      "password": password,
      "persistence": persistence?.toNativeValue(),
      "username": username,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'URLCredential{certificates: $certificates, password: $password, persistence: $persistence, username: $username}';
  }
}
