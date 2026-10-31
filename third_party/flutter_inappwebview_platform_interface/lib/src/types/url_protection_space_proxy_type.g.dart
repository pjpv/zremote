
part of 'url_protection_space_proxy_type.dart';

class URLProtectionSpaceProxyType {
  final String _value;
  final String _nativeValue;
  const URLProtectionSpaceProxyType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory URLProtectionSpaceProxyType._internalMultiPlatform(
          String value, Function nativeValue) =>
      URLProtectionSpaceProxyType._internal(value, nativeValue());

  static const URL_PROTECTION_SPACE_FTP_PROXY =
      URLProtectionSpaceProxyType._internal(
          'NSURLProtectionSpaceFTPProxy', 'NSURLProtectionSpaceFTPProxy');

  static const URL_PROTECTION_SPACE_HTTPS_PROXY =
      URLProtectionSpaceProxyType._internal(
          'NSURLProtectionSpaceHTTPSProxy', 'NSURLProtectionSpaceHTTPSProxy');

  static const URL_PROTECTION_SPACE_HTTP_PROXY =
      URLProtectionSpaceProxyType._internal(
          'NSURLProtectionSpaceHTTPProxy', 'NSURLProtectionSpaceHTTPProxy');

  static const URL_PROTECTION_SPACE_SOCKS_PROXY =
      URLProtectionSpaceProxyType._internal(
          'NSURLProtectionSpaceSOCKSProxy', 'NSURLProtectionSpaceSOCKSProxy');

  static final Set<URLProtectionSpaceProxyType> values = [
    URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_FTP_PROXY,
    URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTPS_PROXY,
    URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_HTTP_PROXY,
    URLProtectionSpaceProxyType.URL_PROTECTION_SPACE_SOCKS_PROXY,
  ].toSet();

  static URLProtectionSpaceProxyType? fromValue(String? value) {
    if (value != null) {
      try {
        return URLProtectionSpaceProxyType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static URLProtectionSpaceProxyType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return URLProtectionSpaceProxyType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}

@Deprecated('Use URLProtectionSpaceProxyType instead')
class IOSNSURLProtectionSpaceProxyType {
  final String _value;
  final String _nativeValue;
  const IOSNSURLProtectionSpaceProxyType._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSNSURLProtectionSpaceProxyType._internalMultiPlatform(
          String value, Function nativeValue) =>
      IOSNSURLProtectionSpaceProxyType._internal(value, nativeValue());

  static const NSURL_PROTECTION_SPACE_FTP_PROXY =
      IOSNSURLProtectionSpaceProxyType._internal(
          'NSURLProtectionSpaceFTPProxy', 'NSURLProtectionSpaceFTPProxy');

  static const NSURL_PROTECTION_SPACE_HTTPS_PROXY =
      IOSNSURLProtectionSpaceProxyType._internal(
          'NSURLProtectionSpaceHTTPSProxy', 'NSURLProtectionSpaceHTTPSProxy');

  static const NSURL_PROTECTION_SPACE_SOCKS_PROXY =
      IOSNSURLProtectionSpaceProxyType._internal(
          'NSURLProtectionSpaceSOCKSProxy', 'NSURLProtectionSpaceSOCKSProxy');

  static const NSUR_PROTECTION_SPACE_HTTP_PROXY =
      IOSNSURLProtectionSpaceProxyType._internal(
          'NSURLProtectionSpaceHTTPProxy', 'NSURLProtectionSpaceHTTPProxy');

  static final Set<IOSNSURLProtectionSpaceProxyType> values = [
    IOSNSURLProtectionSpaceProxyType.NSURL_PROTECTION_SPACE_FTP_PROXY,
    IOSNSURLProtectionSpaceProxyType.NSURL_PROTECTION_SPACE_HTTPS_PROXY,
    IOSNSURLProtectionSpaceProxyType.NSURL_PROTECTION_SPACE_SOCKS_PROXY,
    IOSNSURLProtectionSpaceProxyType.NSUR_PROTECTION_SPACE_HTTP_PROXY,
  ].toSet();

  static IOSNSURLProtectionSpaceProxyType? fromValue(String? value) {
    if (value != null) {
      try {
        return IOSNSURLProtectionSpaceProxyType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSNSURLProtectionSpaceProxyType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return IOSNSURLProtectionSpaceProxyType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
