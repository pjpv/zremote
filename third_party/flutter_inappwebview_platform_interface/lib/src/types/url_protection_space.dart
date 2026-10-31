import 'dart:typed_data';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../x509_certificate/x509_certificate.dart';
import 'url_protection_space_proxy_type.dart';
import 'url_protection_space_authentication_method.dart';
import 'ssl_error.dart';
import 'ssl_certificate.dart';

part 'url_protection_space.g.dart';

List<X509Certificate>? _distinguishedNamesDeserializer(dynamic value) {
  List<X509Certificate>? distinguishedNames;
  if (value != null) {
    distinguishedNames = <X509Certificate>[];
    (value.cast<Uint8List>() as List<Uint8List>).forEach((data) {
      try {
        distinguishedNames!.add(X509Certificate.fromData(data: data));
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
      }
    });
  }
  return distinguishedNames;
}

@ExchangeableObject()
class URLProtectionSpace_ {
  String host;

  String? protocol;

  String? realm;

  int? port;

  SslCertificate_? sslCertificate;

  SslError_? sslError;

  @Deprecated("Use authenticationMethod instead")
  IOSNSURLProtectionSpaceAuthenticationMethod_? iosAuthenticationMethod;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLProtectionSpace.authenticationMethod",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlprotectionspace/1415028-authenticationmethod"),
    MacOSPlatform(
        apiName: "URLProtectionSpace.authenticationMethod",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlprotectionspace/1415028-authenticationmethod")
  ])
  URLProtectionSpaceAuthenticationMethod_? authenticationMethod;

  @Deprecated("Use distinguishedNames instead")
  @ExchangeableObjectProperty(deserializer: _distinguishedNamesDeserializer)
  List<X509Certificate>? iosDistinguishedNames;

  @ExchangeableObjectProperty(deserializer: _distinguishedNamesDeserializer)
  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLProtectionSpace.distinguishedNames",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlprotectionspace/1417061-distinguishednames"),
    MacOSPlatform(
        apiName: "URLProtectionSpace.distinguishedNames",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlprotectionspace/1417061-distinguishednames")
  ])
  List<X509Certificate>? distinguishedNames;

  @Deprecated("Use receivesCredentialSecurely instead")
  bool? iosReceivesCredentialSecurely;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLProtectionSpace.receivesCredentialSecurely",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlprotectionspace/1415176-receivescredentialsecurely"),
    MacOSPlatform(
        apiName: "URLProtectionSpace.receivesCredentialSecurely",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlprotectionspace/1415176-receivescredentialsecurely")
  ])
  bool? receivesCredentialSecurely;

  @Deprecated("Use proxyType instead")
  IOSNSURLProtectionSpaceProxyType_? iosProxyType;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLProtectionSpace.proxyType",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlprotectionspace/1411924-proxytype"),
    MacOSPlatform(
        apiName: "URLProtectionSpace.proxyType",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlprotectionspace/1411924-proxytype")
  ])
  URLProtectionSpaceProxyType_? proxyType;

  URLProtectionSpace_(
      {required this.host,
      this.protocol,
      this.realm,
      this.port,
      this.sslCertificate,
      this.sslError,
      @Deprecated("Use authenticationMethod instead")
      this.iosAuthenticationMethod,
      this.authenticationMethod,
      @Deprecated("Use distinguishedNames instead") this.iosDistinguishedNames,
      this.distinguishedNames,
      @Deprecated("Use receivesCredentialSecurely instead")
      this.iosReceivesCredentialSecurely,
      this.receivesCredentialSecurely,
      @Deprecated("Use proxyType instead") this.iosProxyType,
      this.proxyType});
}
