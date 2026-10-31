import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../util.dart';
import '../x509_certificate/x509_certificate.dart';
import '../x509_certificate/asn1_distinguished_names.dart';

import 'ssl_certificate_dname.dart';

part 'ssl_certificate.g.dart';

@ExchangeableObject()
class SslCertificate_ {
  SslCertificateDName_? issuedBy;

  SslCertificateDName_? issuedTo;

  DateTime? validNotAfterDate;

  DateTime? validNotBeforeDate;

  X509Certificate? x509Certificate;

  SslCertificate_(
      {this.issuedBy,
      this.issuedTo,
      this.validNotAfterDate,
      this.validNotBeforeDate,
      this.x509Certificate});

  static SslCertificate? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    X509Certificate? x509Certificate;
    try {
      x509Certificate = X509Certificate.fromData(data: map["x509Certificate"]);
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }

    if (Util.isIOS) {
      if (x509Certificate != null) {
        return SslCertificate(
          issuedBy: SslCertificateDName(
              CName: x509Certificate.issuer(
                      dn: ASN1DistinguishedNames.COMMON_NAME) ??
                  "",
              DName: x509Certificate.issuerDistinguishedName ?? "",
              OName: x509Certificate.issuer(
                      dn: ASN1DistinguishedNames.ORGANIZATION_NAME) ??
                  "",
              UName: x509Certificate.issuer(
                      dn: ASN1DistinguishedNames.ORGANIZATIONAL_UNIT_NAME) ??
                  ""),
          issuedTo: SslCertificateDName(
              CName: x509Certificate.subject(
                      dn: ASN1DistinguishedNames.COMMON_NAME) ??
                  "",
              DName: x509Certificate.subjectDistinguishedName ?? "",
              OName: x509Certificate.subject(
                      dn: ASN1DistinguishedNames.ORGANIZATION_NAME) ??
                  "",
              UName: x509Certificate.subject(
                      dn: ASN1DistinguishedNames.ORGANIZATIONAL_UNIT_NAME) ??
                  ""),
          validNotAfterDate: x509Certificate.notAfter,
          validNotBeforeDate: x509Certificate.notBefore,
          x509Certificate: x509Certificate,
        );
      }
      return null;
    }

    return SslCertificate(
      issuedBy:
          SslCertificateDName.fromMap(map["issuedBy"]?.cast<String, dynamic>()),
      issuedTo:
          SslCertificateDName.fromMap(map["issuedTo"]?.cast<String, dynamic>()),
      validNotAfterDate: map["validNotAfterDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["validNotAfterDate"])
          : null,
      validNotBeforeDate: map["validNotBeforeDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["validNotBeforeDate"])
          : null,
      x509Certificate: x509Certificate,
    );
  }
}
