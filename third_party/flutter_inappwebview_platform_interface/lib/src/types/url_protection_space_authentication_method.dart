import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'url_protection_space.dart';

part 'url_protection_space_authentication_method.g.dart';

@ExchangeableEnum()
class URLProtectionSpaceAuthenticationMethod_ {
  // ignore: unused_field
  final String _value;
  const URLProtectionSpaceAuthenticationMethod_._internal(this._value);

  static const NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE =
      const URLProtectionSpaceAuthenticationMethod_._internal(
          "NSURLAuthenticationMethodClientCertificate");

  static const NSURL_AUTHENTICATION_METHOD_NEGOTIATE =
      const URLProtectionSpaceAuthenticationMethod_._internal(
          "NSURLAuthenticationMethodNegotiate");

  static const NSURL_AUTHENTICATION_METHOD_NTLM =
      const URLProtectionSpaceAuthenticationMethod_._internal(
          "NSURLAuthenticationMethodNTLM");

  static const NSURL_AUTHENTICATION_METHOD_SERVER_TRUST =
      const URLProtectionSpaceAuthenticationMethod_._internal(
          "NSURLAuthenticationMethodServerTrust");
}

@Deprecated("Use URLProtectionSpaceAuthenticationMethod instead")
@ExchangeableEnum()
class IOSNSURLProtectionSpaceAuthenticationMethod_ {
  // ignore: unused_field
  final String _value;
  const IOSNSURLProtectionSpaceAuthenticationMethod_._internal(this._value);

  static const NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE =
      const IOSNSURLProtectionSpaceAuthenticationMethod_._internal(
          "NSURLAuthenticationMethodClientCertificate");

  static const NSURL_AUTHENTICATION_METHOD_NEGOTIATE =
      const IOSNSURLProtectionSpaceAuthenticationMethod_._internal(
          "NSURLAuthenticationMethodNegotiate");

  static const NSURL_AUTHENTICATION_METHOD_NTLM =
      const IOSNSURLProtectionSpaceAuthenticationMethod_._internal(
          "NSURLAuthenticationMethodNTLM");

  static const NSURL_AUTHENTICATION_METHOD_SERVER_TRUST =
      const IOSNSURLProtectionSpaceAuthenticationMethod_._internal(
          "NSURLAuthenticationMethodServerTrust");
}
