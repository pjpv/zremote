
part of 'url_protection_space.dart';

class URLProtectionSpace {
  URLProtectionSpaceAuthenticationMethod? authenticationMethod;

  List<X509Certificate>? distinguishedNames;

  String host;

  @Deprecated('Use authenticationMethod instead')
  IOSNSURLProtectionSpaceAuthenticationMethod? iosAuthenticationMethod;

  @Deprecated('Use distinguishedNames instead')
  List<X509Certificate>? iosDistinguishedNames;

  @Deprecated('Use proxyType instead')
  IOSNSURLProtectionSpaceProxyType? iosProxyType;

  @Deprecated('Use receivesCredentialSecurely instead')
  bool? iosReceivesCredentialSecurely;

  int? port;

  String? protocol;

  URLProtectionSpaceProxyType? proxyType;

  String? realm;

  bool? receivesCredentialSecurely;

  SslCertificate? sslCertificate;

  SslError? sslError;
  URLProtectionSpace(
      {this.authenticationMethod,
      this.distinguishedNames,
      required this.host,
      @Deprecated('Use authenticationMethod instead')
      this.iosAuthenticationMethod,
      @Deprecated('Use distinguishedNames instead') this.iosDistinguishedNames,
      @Deprecated('Use proxyType instead') this.iosProxyType,
      @Deprecated('Use receivesCredentialSecurely instead')
      this.iosReceivesCredentialSecurely,
      this.port,
      this.protocol,
      this.proxyType,
      this.realm,
      this.receivesCredentialSecurely,
      this.sslCertificate,
      this.sslError}) {
    authenticationMethod = authenticationMethod ??
        URLProtectionSpaceAuthenticationMethod.fromNativeValue(
            iosAuthenticationMethod?.toNativeValue());
    distinguishedNames = distinguishedNames ?? iosDistinguishedNames;
    proxyType = proxyType ??
        URLProtectionSpaceProxyType.fromNativeValue(
            iosProxyType?.toNativeValue());
    receivesCredentialSecurely =
        receivesCredentialSecurely ?? iosReceivesCredentialSecurely;
  }

  static URLProtectionSpace? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = URLProtectionSpace(
      authenticationMethod:
          URLProtectionSpaceAuthenticationMethod.fromNativeValue(
              map['authenticationMethod']),
      distinguishedNames:
          _distinguishedNamesDeserializer(map['distinguishedNames']),
      host: map['host'],
      iosAuthenticationMethod:
          IOSNSURLProtectionSpaceAuthenticationMethod.fromNativeValue(
              map['authenticationMethod']),
      iosDistinguishedNames:
          _distinguishedNamesDeserializer(map['distinguishedNames']),
      iosProxyType:
          IOSNSURLProtectionSpaceProxyType.fromNativeValue(map['proxyType']),
      iosReceivesCredentialSecurely: map['receivesCredentialSecurely'],
      port: map['port'],
      protocol: map['protocol'],
      proxyType: URLProtectionSpaceProxyType.fromNativeValue(map['proxyType']),
      realm: map['realm'],
      receivesCredentialSecurely: map['receivesCredentialSecurely'],
      sslCertificate: SslCertificate.fromMap(
          map['sslCertificate']?.cast<String, dynamic>()),
      sslError: SslError.fromMap(map['sslError']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "authenticationMethod": authenticationMethod?.toNativeValue(),
      "distinguishedNames": distinguishedNames?.map((e) => e.toMap()).toList(),
      "host": host,
      "port": port,
      "protocol": protocol,
      "proxyType": proxyType?.toNativeValue(),
      "realm": realm,
      "receivesCredentialSecurely": receivesCredentialSecurely,
      "sslCertificate": sslCertificate?.toMap(),
      "sslError": sslError?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'URLProtectionSpace{authenticationMethod: $authenticationMethod, distinguishedNames: $distinguishedNames, host: $host, port: $port, protocol: $protocol, proxyType: $proxyType, realm: $realm, receivesCredentialSecurely: $receivesCredentialSecurely, sslCertificate: $sslCertificate, sslError: $sslError}';
  }
}
