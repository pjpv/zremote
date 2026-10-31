import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'package:flutter/foundation.dart';

import 'server_trust_challenge.dart';

part 'ssl_error_type.g.dart';

@ExchangeableEnum()
class SslErrorType_ {
  // ignore: unused_field
  final String _value;
  // ignore: unused_field
  final int? _nativeValue = null;
  const SslErrorType_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'SslError.SSL_NOTYETVALID',
        apiUrl:
            'https://developer.android.com/reference/android/net/http/SslError#SSL_NOTYETVALID',
        value: 0)
  ])
  static const NOT_YET_VALID = SslErrorType_._internal('NOT_YET_VALID');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'SslError.SSL_EXPIRED',
        apiUrl:
            'https://developer.android.com/reference/android/net/http/SslError#SSL_EXPIRED',
        value: 1)
  ])
  static const EXPIRED = SslErrorType_._internal('EXPIRED');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'SslError.SSL_IDMISMATCH',
        apiUrl:
            'https://developer.android.com/reference/android/net/http/SslError#SSL_IDMISMATCH',
        value: 2)
  ])
  static const IDMISMATCH = SslErrorType_._internal('IDMISMATCH');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'SslError.SSL_UNTRUSTED',
        apiUrl:
            'https://developer.android.com/reference/android/net/http/SslError#SSL_UNTRUSTED',
        value: 3)
  ])
  static const UNTRUSTED = SslErrorType_._internal('UNTRUSTED');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'SslError.DATE_INVALID',
        apiUrl:
            'https://developer.android.com/reference/android/net/http/SslError#SSL_DATE_INVALID',
        value: 4)
  ])
  static const DATE_INVALID = SslErrorType_._internal('DATE_INVALID');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'SslError.SSL_INVALID',
        apiUrl:
            'https://developer.android.com/reference/android/net/http/SslError#SSL_INVALID',
        value: 5),
    EnumIOSPlatform(
        apiName: 'SecTrustResultType.invalid',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/invalid',
        value: 0),
    EnumMacOSPlatform(
        apiName: 'SecTrustResultType.invalid',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/invalid',
        value: 0)
  ])
  static const INVALID = SslErrorType_._internal('INVALID');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'SecTrustResultType.deny',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/deny',
        value: 3),
    EnumMacOSPlatform(
        apiName: 'SecTrustResultType.deny',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/deny',
        value: 3)
  ])
  static const DENY = SslErrorType_._internal('DENY');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'SecTrustResultType.unspecified',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/unspecified',
        value: 4),
    EnumMacOSPlatform(
        apiName: 'SecTrustResultType.unspecified',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/unspecified',
        value: 4)
  ])
  static const UNSPECIFIED = SslErrorType_._internal('UNSPECIFIED');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'SecTrustResultType.recoverableTrustFailure',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/recoverabletrustfailure',
        value: 5),
    EnumMacOSPlatform(
        apiName: 'SecTrustResultType.recoverableTrustFailure',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/recoverabletrustfailure',
        value: 5)
  ])
  static const RECOVERABLE_TRUST_FAILURE =
      SslErrorType_._internal('RECOVERABLE_TRUST_FAILURE');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'SecTrustResultType.fatalTrustFailure',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/fataltrustfailure',
        value: 6),
    EnumMacOSPlatform(
        apiName: 'SecTrustResultType.fatalTrustFailure',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/fataltrustfailure',
        value: 6)
  ])
  static const FATAL_TRUST_FAILURE =
      SslErrorType_._internal('FATAL_TRUST_FAILURE');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'SecTrustResultType.otherError',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/othererror',
        value: 7),
    EnumMacOSPlatform(
        apiName: 'SecTrustResultType.otherError',
        apiUrl:
            'https://developer.apple.com/documentation/security/sectrustresulttype/othererror',
        value: 7)
  ])
  static const OTHER_ERROR = SslErrorType_._internal('OTHER_ERROR');
}

@Deprecated("Use SslErrorType instead")
@ExchangeableEnum()
class AndroidSslError_ {
  // ignore: unused_field
  final int _value;
  const AndroidSslError_._internal(this._value);

  static const SSL_NOTYETVALID = const AndroidSslError_._internal(0);

  static const SSL_EXPIRED = const AndroidSslError_._internal(1);

  static const SSL_IDMISMATCH = const AndroidSslError_._internal(2);

  static const SSL_UNTRUSTED = const AndroidSslError_._internal(3);

  static const SSL_DATE_INVALID = const AndroidSslError_._internal(4);

  static const SSL_INVALID = const AndroidSslError_._internal(5);
}

@Deprecated("Use SslErrorType instead")
@ExchangeableEnum()
class IOSSslError_ {
  // ignore: unused_field
  final int _value;

  const IOSSslError_._internal(this._value);

  static const INVALID = const IOSSslError_._internal(0);

  static const DENY = const IOSSslError_._internal(3);

  static const UNSPECIFIED = const IOSSslError_._internal(4);

  static const RECOVERABLE_TRUST_FAILURE = const IOSSslError_._internal(5);

  static const FATAL_TRUST_FAILURE = const IOSSslError_._internal(6);

  static const OTHER_ERROR = const IOSSslError_._internal(7);
}
