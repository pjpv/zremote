import 'dart:typed_data';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../x509_certificate/x509_certificate.dart';
import 'url_credential_persistence.dart';

part 'url_credential.g.dart';

List<X509Certificate>? _certificatesDeserializer(dynamic value) {
  List<X509Certificate>? certificates;
  if (value != null) {
    certificates = <X509Certificate>[];
    (value.cast<Uint8List>() as List<Uint8List>).forEach((data) {
      try {
        certificates!.add(X509Certificate.fromData(data: data));
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
      }
    });
  }
  return certificates;
}

@ExchangeableObject()
class URLCredential_ {
  String? username;

  String? password;

  @Deprecated("Use certificates instead")
  @ExchangeableObjectProperty(deserializer: _certificatesDeserializer)
  List<X509Certificate>? iosCertificates;

  @ExchangeableObjectProperty(deserializer: _certificatesDeserializer)
  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  List<X509Certificate>? certificates;

  @Deprecated("Use persistence instead")
  IOSURLCredentialPersistence_? iosPersistence;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  URLCredentialPersistence_? persistence;

  URLCredential_(
      {this.username,
      this.password,
      @Deprecated("Use certificates instead") this.iosPersistence,
      this.persistence,
      @Deprecated("Use persistence instead") this.iosCertificates,
      this.certificates});
}
