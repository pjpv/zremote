import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'url_protection_space_proxy_type.g.dart';

@ExchangeableEnum()
class URLProtectionSpaceProxyType_ {
  // ignore: unused_field
  final String _value;
  const URLProtectionSpaceProxyType_._internal(this._value);

  static const URL_PROTECTION_SPACE_HTTP_PROXY =
      const URLProtectionSpaceProxyType_._internal(
          "NSURLProtectionSpaceHTTPProxy");

  static const URL_PROTECTION_SPACE_HTTPS_PROXY =
      const URLProtectionSpaceProxyType_._internal(
          "NSURLProtectionSpaceHTTPSProxy");

  static const URL_PROTECTION_SPACE_FTP_PROXY =
      const URLProtectionSpaceProxyType_._internal(
          "NSURLProtectionSpaceFTPProxy");

  static const URL_PROTECTION_SPACE_SOCKS_PROXY =
      const URLProtectionSpaceProxyType_._internal(
          "NSURLProtectionSpaceSOCKSProxy");
}

@Deprecated("Use URLProtectionSpaceProxyType instead")
@ExchangeableEnum()
class IOSNSURLProtectionSpaceProxyType_ {
  // ignore: unused_field
  final String _value;
  const IOSNSURLProtectionSpaceProxyType_._internal(this._value);

  static const NSUR_PROTECTION_SPACE_HTTP_PROXY =
      const IOSNSURLProtectionSpaceProxyType_._internal(
          "NSURLProtectionSpaceHTTPProxy");

  static const NSURL_PROTECTION_SPACE_HTTPS_PROXY =
      const IOSNSURLProtectionSpaceProxyType_._internal(
          "NSURLProtectionSpaceHTTPSProxy");

  static const NSURL_PROTECTION_SPACE_FTP_PROXY =
      const IOSNSURLProtectionSpaceProxyType_._internal(
          "NSURLProtectionSpaceFTPProxy");

  static const NSURL_PROTECTION_SPACE_SOCKS_PROXY =
      const IOSNSURLProtectionSpaceProxyType_._internal(
          "NSURLProtectionSpaceSOCKSProxy");
}
