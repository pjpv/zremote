
part of 'url_protection_space_authentication_method.dart';

class URLProtectionSpaceAuthenticationMethod {
  final String _value;
  final String _nativeValue;
  const URLProtectionSpaceAuthenticationMethod._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory URLProtectionSpaceAuthenticationMethod._internalMultiPlatform(
          String value, Function nativeValue) =>
      URLProtectionSpaceAuthenticationMethod._internal(value, nativeValue());

  static const NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE =
      URLProtectionSpaceAuthenticationMethod._internal(
          'NSURLAuthenticationMethodClientCertificate',
          'NSURLAuthenticationMethodClientCertificate');

  static const NSURL_AUTHENTICATION_METHOD_NEGOTIATE =
      URLProtectionSpaceAuthenticationMethod._internal(
          'NSURLAuthenticationMethodNegotiate',
          'NSURLAuthenticationMethodNegotiate');

  static const NSURL_AUTHENTICATION_METHOD_NTLM =
      URLProtectionSpaceAuthenticationMethod._internal(
          'NSURLAuthenticationMethodNTLM', 'NSURLAuthenticationMethodNTLM');

  static const NSURL_AUTHENTICATION_METHOD_SERVER_TRUST =
      URLProtectionSpaceAuthenticationMethod._internal(
          'NSURLAuthenticationMethodServerTrust',
          'NSURLAuthenticationMethodServerTrust');

  static final Set<URLProtectionSpaceAuthenticationMethod> values = [
    URLProtectionSpaceAuthenticationMethod
        .NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE,
    URLProtectionSpaceAuthenticationMethod
        .NSURL_AUTHENTICATION_METHOD_NEGOTIATE,
    URLProtectionSpaceAuthenticationMethod.NSURL_AUTHENTICATION_METHOD_NTLM,
    URLProtectionSpaceAuthenticationMethod
        .NSURL_AUTHENTICATION_METHOD_SERVER_TRUST,
  ].toSet();

  static URLProtectionSpaceAuthenticationMethod? fromValue(String? value) {
    if (value != null) {
      try {
        return URLProtectionSpaceAuthenticationMethod.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static URLProtectionSpaceAuthenticationMethod? fromNativeValue(
      String? value) {
    if (value != null) {
      try {
        return URLProtectionSpaceAuthenticationMethod.values
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

@Deprecated('Use URLProtectionSpaceAuthenticationMethod instead')
class IOSNSURLProtectionSpaceAuthenticationMethod {
  final String _value;
  final String _nativeValue;
  const IOSNSURLProtectionSpaceAuthenticationMethod._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSNSURLProtectionSpaceAuthenticationMethod._internalMultiPlatform(
          String value, Function nativeValue) =>
      IOSNSURLProtectionSpaceAuthenticationMethod._internal(
          value, nativeValue());

  static const NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE =
      IOSNSURLProtectionSpaceAuthenticationMethod._internal(
          'NSURLAuthenticationMethodClientCertificate',
          'NSURLAuthenticationMethodClientCertificate');

  static const NSURL_AUTHENTICATION_METHOD_NEGOTIATE =
      IOSNSURLProtectionSpaceAuthenticationMethod._internal(
          'NSURLAuthenticationMethodNegotiate',
          'NSURLAuthenticationMethodNegotiate');

  static const NSURL_AUTHENTICATION_METHOD_NTLM =
      IOSNSURLProtectionSpaceAuthenticationMethod._internal(
          'NSURLAuthenticationMethodNTLM', 'NSURLAuthenticationMethodNTLM');

  static const NSURL_AUTHENTICATION_METHOD_SERVER_TRUST =
      IOSNSURLProtectionSpaceAuthenticationMethod._internal(
          'NSURLAuthenticationMethodServerTrust',
          'NSURLAuthenticationMethodServerTrust');

  static final Set<IOSNSURLProtectionSpaceAuthenticationMethod> values = [
    IOSNSURLProtectionSpaceAuthenticationMethod
        .NSURL_AUTHENTICATION_METHOD_CLIENT_CERTIFICATE,
    IOSNSURLProtectionSpaceAuthenticationMethod
        .NSURL_AUTHENTICATION_METHOD_NEGOTIATE,
    IOSNSURLProtectionSpaceAuthenticationMethod
        .NSURL_AUTHENTICATION_METHOD_NTLM,
    IOSNSURLProtectionSpaceAuthenticationMethod
        .NSURL_AUTHENTICATION_METHOD_SERVER_TRUST,
  ].toSet();

  static IOSNSURLProtectionSpaceAuthenticationMethod? fromValue(String? value) {
    if (value != null) {
      try {
        return IOSNSURLProtectionSpaceAuthenticationMethod.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSNSURLProtectionSpaceAuthenticationMethod? fromNativeValue(
      String? value) {
    if (value != null) {
      try {
        return IOSNSURLProtectionSpaceAuthenticationMethod.values
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
