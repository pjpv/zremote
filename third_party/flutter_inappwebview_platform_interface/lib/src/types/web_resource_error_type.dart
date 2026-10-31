import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'web_resource_error_type.g.dart';

@ExchangeableEnum()
class WebResourceErrorType_ {
  // ignore: unused_field
  final String _value;
  // ignore: unused_field
  final int? _nativeValue = null;

  const WebResourceErrorType_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_AUTHENTICATION',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_AUTHENTICATION',
        value: -4)
  ])
  static const USER_AUTHENTICATION_FAILED =
      WebResourceErrorType_._internal("USER_AUTHENTICATION_FAILED");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_BAD_URL',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_BAD_URL',
        value: -12),
    EnumIOSPlatform(
        apiName: 'URLError.badURL',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293516-badurl',
        value: -1000),
    EnumMacOSPlatform(
        apiName: 'URLError.badURL',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293516-badurl',
        value: -1000)
  ])
  static const BAD_URL = WebResourceErrorType_._internal("BAD_URL");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_CONNECT',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_CONNECT',
        value: -6),
    EnumIOSPlatform(
        apiName: 'URLError.cannotConnectToHost',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883001-cannotconnecttohost',
        value: -1004),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotConnectToHost',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883001-cannotconnecttohost',
        value: -1004),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_CANNOT_CONNECT',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 12)
  ])
  static const CANNOT_CONNECT_TO_HOST =
      WebResourceErrorType_._internal("CANNOT_CONNECT_TO_HOST");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_FAILED_SSL_HANDSHAKE',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_FAILED_SSL_HANDSHAKE',
        value: -11)
  ])
  static const FAILED_SSL_HANDSHAKE =
      WebResourceErrorType_._internal("FAILED_SSL_HANDSHAKE");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_FILE',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_FILE',
        value: -13)
  ])
  static const GENERIC_FILE_ERROR =
      WebResourceErrorType_._internal("GENERIC_FILE_ERROR");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_FILE_NOT_FOUND',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_FILE_NOT_FOUND',
        value: -14),
    EnumIOSPlatform(
        apiName: 'URLError.fileDoesNotExist',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883074-filedoesnotexist',
        value: -1100),
    EnumMacOSPlatform(
        apiName: 'URLError.fileDoesNotExist',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883074-filedoesnotexist',
        value: -1100)
  ])
  static const FILE_NOT_FOUND =
      WebResourceErrorType_._internal("FILE_NOT_FOUND");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_HOST_LOOKUP',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_HOST_LOOKUP',
        value: -2),
    EnumIOSPlatform(
        apiName: 'URLError.cannotFindHost',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883157-cannotfindhost',
        value: -1003),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotFindHost',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883157-cannotfindhost',
        value: -1003),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_HOST_NAME_NOT_RESOLVED',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 13)
  ])
  static const HOST_LOOKUP = WebResourceErrorType_._internal("HOST_LOOKUP");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_IO',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_IO',
        value: -7)
  ])
  static const IO = WebResourceErrorType_._internal("IO");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_PROXY_AUTHENTICATION',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_PROXY_AUTHENTICATION',
        value: -5)
  ])
  static const PROXY_AUTHENTICATION =
      WebResourceErrorType_._internal("PROXY_AUTHENTICATION");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_REDIRECT_LOOP',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_REDIRECT_LOOP',
        value: -9),
    EnumIOSPlatform(
        apiName: 'URLError.httpTooManyRedirects',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883099-httptoomanyredirects',
        value: -1007),
    EnumMacOSPlatform(
        apiName: 'URLError.httpTooManyRedirects',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883099-httptoomanyredirects',
        value: -1007)
  ])
  static const TOO_MANY_REDIRECTS =
      WebResourceErrorType_._internal("TOO_MANY_REDIRECTS");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_TIMEOUT',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_TIMEOUT',
        value: -8),
    EnumIOSPlatform(
        apiName: 'URLError.timedOut',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883027-timedout',
        value: -1001),
    EnumMacOSPlatform(
        apiName: 'URLError.timedOut',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883027-timedout',
        value: -1001),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_TIMEOUT',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 7)
  ])
  static const TIMEOUT = WebResourceErrorType_._internal("TIMEOUT");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_TOO_MANY_REQUESTS',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_TOO_MANY_REQUESTS',
        value: -15)
  ])
  static const TOO_MANY_REQUESTS =
      WebResourceErrorType_._internal("TOO_MANY_REQUESTS");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_UNKNOWN',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_UNKNOWN',
        value: -1),
    EnumIOSPlatform(
        apiName: 'URLError.unknown',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293357-unknown',
        value: -1),
    EnumMacOSPlatform(
        apiName: 'URLError.unknown',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293357-unknown',
        value: -1),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_UNKNOWN',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 0)
  ])
  static const UNKNOWN = WebResourceErrorType_._internal("UNKNOWN");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_UNSAFE_RESOURCE',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_UNSAFE_RESOURCE',
        value: -16)
  ])
  static const UNSAFE_RESOURCE =
      WebResourceErrorType_._internal("UNSAFE_RESOURCE");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_UNSUPPORTED_AUTH_SCHEME',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_UNSUPPORTED_AUTH_SCHEME',
        value: -3)
  ])
  static const UNSUPPORTED_AUTH_SCHEME =
      WebResourceErrorType_._internal("UNSUPPORTED_AUTH_SCHEME");

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'WebViewClient.ERROR_UNSUPPORTED_SCHEME',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/WebViewClient#ERROR_UNSUPPORTED_SCHEME',
        value: -10),
    EnumIOSPlatform(
        apiName: 'URLError.unsupportedURL',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883043-unsupportedurl',
        value: -1002),
    EnumMacOSPlatform(
        apiName: 'URLError.unsupportedURL',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883043-unsupportedurl',
        value: -1002)
  ])
  static const UNSUPPORTED_SCHEME =
      WebResourceErrorType_._internal("UNSUPPORTED_SCHEME");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cancelled',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883178-cancelled',
        value: -999),
    EnumMacOSPlatform(
        apiName: 'URLError.cancelled',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883178-cancelled',
        value: -999),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_OPERATION_CANCELED',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 14)
  ])
  static const CANCELLED = WebResourceErrorType_._internal("CANCELLED");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.networkConnectionLost',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293759-networkconnectionlost',
        value: -1005),
    EnumMacOSPlatform(
        apiName: 'URLError.networkConnectionLost',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293759-networkconnectionlost',
        value: -1005),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_DISCONNECTED',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 11)
  ])
  static const NETWORK_CONNECTION_LOST =
      WebResourceErrorType_._internal("NETWORK_CONNECTION_LOST");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.resourceUnavailable',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293555-resourceunavailable',
        value: -1008),
    EnumMacOSPlatform(
        apiName: 'URLError.resourceUnavailable',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293555-resourceunavailable',
        value: -1008)
  ])
  static const RESOURCE_UNAVAILABLE =
      WebResourceErrorType_._internal("RESOURCE_UNAVAILABLE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.notConnectedToInternet',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293104-notconnectedtointernet',
        value: -1009),
    EnumMacOSPlatform(
        apiName: 'URLError.notConnectedToInternet',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293104-notconnectedtointernet',
        value: -1009)
  ])
  static const NOT_CONNECTED_TO_INTERNET =
      WebResourceErrorType_._internal("NOT_CONNECTED_TO_INTERNET");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.redirectToNonExistentLocation',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293066-redirecttononexistentlocation',
        value: -1010),
    EnumMacOSPlatform(
        apiName: 'URLError.redirectToNonExistentLocation',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293066-redirecttononexistentlocation',
        value: -1010)
  ])
  static const REDIRECT_TO_NON_EXISTENT_LOCATION =
      WebResourceErrorType_._internal("REDIRECT_TO_NON_EXISTENT_LOCATION");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.badServerResponse',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293606-badserverresponse',
        value: -1011),
    EnumMacOSPlatform(
        apiName: 'URLError.badServerResponse',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293606-badserverresponse',
        value: -1011),
    EnumWindowsPlatform(
        apiName:
            'COREWEBVIEW2_WEB_ERROR_STATUS_ERROR_HTTP_INVALID_SERVER_RESPONSE',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 8)
  ])
  static const BAD_SERVER_RESPONSE =
      WebResourceErrorType_._internal("BAD_SERVER_RESPONSE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.userCancelledAuthentication',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293330-usercancelledauthentication',
        value: -1012),
    EnumMacOSPlatform(
        apiName: 'URLError.userCancelledAuthentication',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293330-usercancelledauthentication',
        value: -1012)
  ])
  static const USER_CANCELLED_AUTHENTICATION =
      WebResourceErrorType_._internal("USER_CANCELLED_AUTHENTICATION");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.userAuthenticationRequired',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293560-userauthenticationrequired',
        value: -1013),
    EnumMacOSPlatform(
        apiName: 'URLError.userAuthenticationRequired',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293560-userauthenticationrequired',
        value: -1013),
    EnumWindowsPlatform(
        apiName:
            'COREWEBVIEW2_WEB_ERROR_STATUS_VALID_AUTHENTICATION_CREDENTIALS_REQUIRED',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 17),
  ])
  static const USER_AUTHENTICATION_REQUIRED =
      WebResourceErrorType_._internal("USER_AUTHENTICATION_REQUIRED");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.zeroByteResource',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293773-zerobyteresource',
        value: -1014),
    EnumMacOSPlatform(
        apiName: 'URLError.zeroByteResource',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293773-zerobyteresource',
        value: -1014)
  ])
  static const ZERO_BYTE_RESOURCE =
      WebResourceErrorType_._internal("ZERO_BYTE_RESOURCE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotDecodeRawData',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293573-cannotdecoderawdata',
        value: -1015),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotDecodeRawData',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2293573-cannotdecoderawdata',
        value: -1015)
  ])
  static const CANNOT_DECODE_RAW_DATA =
      WebResourceErrorType_._internal("CANNOT_DECODE_RAW_DATA");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotDecodeContentData',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2292983-cannotdecodecontentdata',
        value: -1016),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotDecodeContentData',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/2292983-cannotdecodecontentdata',
        value: -1016)
  ])
  static const CANNOT_DECODE_CONTENT_DATA =
      WebResourceErrorType_._internal("CANNOT_DECODE_CONTENT_DATA");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotParseResponse',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882919-cannotparseresponse',
        value: -1017),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotParseResponse',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882919-cannotparseresponse',
        value: -1017)
  ])
  static const CANNOT_PARSE_RESPONSE =
      WebResourceErrorType_._internal("CANNOT_PARSE_RESPONSE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.appTransportSecurityRequiresSecureConnection',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882980-apptransportsecurityrequiressecu',
        value: -1022),
    EnumMacOSPlatform(
        apiName: 'URLError.appTransportSecurityRequiresSecureConnection',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882980-apptransportsecurityrequiressecu',
        value: -1022)
  ])
  static const APP_TRANSPORT_SECURITY_REQUIRES_SECURE_CONNECTION =
      WebResourceErrorType_._internal(
          "APP_TRANSPORT_SECURITY_REQUIRES_SECURE_CONNECTION");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.fileIsDirectory',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883220-fileisdirectory',
        value: -1101),
    EnumMacOSPlatform(
        apiName: 'URLError.fileIsDirectory',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883220-fileisdirectory',
        value: -1101)
  ])
  static const FILE_IS_DIRECTORY =
      WebResourceErrorType_._internal("FILE_IS_DIRECTORY");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.noPermissionsToReadFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882941-nopermissionstoreadfile',
        value: -1102),
    EnumMacOSPlatform(
        apiName: 'URLError.noPermissionsToReadFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882941-nopermissionstoreadfile',
        value: -1102)
  ])
  static const NO_PERMISSIONS_TO_READ_FILE =
      WebResourceErrorType_._internal("NO_PERMISSIONS_TO_READ_FILE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.dataLengthExceedsMaximum',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882930-datalengthexceedsmaximum',
        value: -1103),
    EnumMacOSPlatform(
        apiName: 'URLError.dataLengthExceedsMaximum',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882930-datalengthexceedsmaximum',
        value: -1103)
  ])
  static const DATA_LENGTH_EXCEEDS_MAXIMUM =
      WebResourceErrorType_._internal("DATA_LENGTH_EXCEEDS_MAXIMUM");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.secureConnectionFailed',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883122-secureconnectionfailed',
        value: -1200),
    EnumMacOSPlatform(
        apiName: 'URLError.secureConnectionFailed',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883122-secureconnectionfailed',
        value: -1200)
  ])
  static const SECURE_CONNECTION_FAILED =
      WebResourceErrorType_._internal("SECURE_CONNECTION_FAILED");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.serverCertificateHasBadDate',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883088-servercertificatehasbaddate',
        value: -1201),
    EnumMacOSPlatform(
        apiName: 'URLError.serverCertificateHasBadDate',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883088-servercertificatehasbaddate',
        value: -1201)
  ])
  static const SERVER_CERTIFICATE_HAS_BAD_DATE =
      WebResourceErrorType_._internal("SERVER_CERTIFICATE_HAS_BAD_DATE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.serverCertificateUntrusted',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882976-servercertificateuntrusted',
        value: -1202),
    EnumMacOSPlatform(
        apiName: 'URLError.serverCertificateUntrusted',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882976-servercertificateuntrusted',
        value: -1202)
  ])
  static const SERVER_CERTIFICATE_UNTRUSTED =
      WebResourceErrorType_._internal("SERVER_CERTIFICATE_UNTRUSTED");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.serverCertificateHasUnknownRoot',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883085-servercertificatehasunknownroot',
        value: -1203),
    EnumMacOSPlatform(
        apiName: 'URLError.serverCertificateHasUnknownRoot',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883085-servercertificatehasunknownroot',
        value: -1203)
  ])
  static const SERVER_CERTIFICATE_HAS_UNKNOWN_ROOT =
      WebResourceErrorType_._internal("SERVER_CERTIFICATE_HAS_UNKNOWN_ROOT");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.serverCertificateNotYetValid',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882991-servercertificatenotyetvalid',
        value: -1204),
    EnumMacOSPlatform(
        apiName: 'URLError.serverCertificateNotYetValid',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882991-servercertificatenotyetvalid',
        value: -1204)
  ])
  static const SERVER_CERTIFICATE_NOT_YET_VALID =
      WebResourceErrorType_._internal("SERVER_CERTIFICATE_NOT_YET_VALID");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.clientCertificateRejected',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883091-clientcertificaterejected',
        value: -1205),
    EnumMacOSPlatform(
        apiName: 'URLError.clientCertificateRejected',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883091-clientcertificaterejected',
        value: -1205)
  ])
  static const CLIENT_CERTIFICATE_REJECTED =
      WebResourceErrorType_._internal("CLIENT_CERTIFICATE_REJECTED");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.clientCertificateRequired',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883199-clientcertificaterequired',
        value: -1206),
    EnumMacOSPlatform(
        apiName: 'URLError.clientCertificateRequired',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883199-clientcertificaterequired',
        value: -1206)
  ])
  static const CLIENT_CERTIFICATE_REQUIRED =
      WebResourceErrorType_._internal("CLIENT_CERTIFICATE_REQUIRED");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotLoadFromNetwork',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882968-cannotloadfromnetwork',
        value: -2000),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotLoadFromNetwork',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882968-cannotloadfromnetwork',
        value: -2000)
  ])
  static const CANNOT_LOAD_FROM_NETWORK =
      WebResourceErrorType_._internal("CANNOT_LOAD_FROM_NETWORK");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotCreateFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883204-cannotcreatefile',
        value: -3000),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotCreateFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883204-cannotcreatefile',
        value: -3000)
  ])
  static const CANNOT_CREATE_FILE =
      WebResourceErrorType_._internal("CANNOT_CREATE_FILE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotOpenFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883034-cannotopenfile',
        value: -3001),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotOpenFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883034-cannotopenfile',
        value: -3001)
  ])
  static const CANNOT_OPEN_FILE =
      WebResourceErrorType_._internal("CANNOT_OPEN_FILE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotCloseFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883215-cannotclosefile',
        value: -3002),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotCloseFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883215-cannotclosefile',
        value: -3002)
  ])
  static const CANNOT_CLOSE_FILE =
      WebResourceErrorType_._internal("CANNOT_CLOSE_FILE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotWriteToFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883098-cannotwritetofile',
        value: -3003),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotWriteToFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883098-cannotwritetofile',
        value: -3003)
  ])
  static const CANNOT_WRITE_TO_FILE =
      WebResourceErrorType_._internal("CANNOT_WRITE_TO_FILE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotRemoveFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883202-cannotremovefile',
        value: -3004),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotRemoveFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883202-cannotremovefile',
        value: -3004)
  ])
  static const CANNOT_REMOVE_FILE =
      WebResourceErrorType_._internal("CANNOT_REMOVE_FILE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.cannotMoveFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883180-cannotmovefile',
        value: -3005),
    EnumMacOSPlatform(
        apiName: 'URLError.cannotMoveFile',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883180-cannotmovefile',
        value: -3005)
  ])
  static const CANNOT_MOVE_FILE =
      WebResourceErrorType_._internal("CANNOT_MOVE_FILE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.downloadDecodingFailedMidStream',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883224-downloaddecodingfailedmidstream',
        value: -3006),
    EnumMacOSPlatform(
        apiName: 'URLError.downloadDecodingFailedMidStream',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883224-downloaddecodingfailedmidstream',
        value: -3006)
  ])
  static const DOWNLOAD_DECODING_FAILED_MID_STREAM =
      WebResourceErrorType_._internal("DOWNLOAD_DECODING_FAILED_MID_STREAM");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.downloadDecodingFailedToComplete',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882936-downloaddecodingfailedtocomplete',
        value: -3007),
    EnumMacOSPlatform(
        apiName: 'URLError.downloadDecodingFailedToComplete',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882936-downloaddecodingfailedtocomplete',
        value: -3007)
  ])
  static const DOWNLOAD_DECODING_FAILED_TO_COMPLETE =
      WebResourceErrorType_._internal("DOWNLOAD_DECODING_FAILED_TO_COMPLETE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.internationalRoamingOff',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883134-internationalroamingoff',
        value: -1018),
    EnumMacOSPlatform(
        apiName: 'URLError.internationalRoamingOff',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883134-internationalroamingoff',
        value: -1018)
  ])
  static const INTERNATIONAL_ROAMING_OFF =
      WebResourceErrorType_._internal("INTERNATIONAL_ROAMING_OFF");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.callIsActive',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883170-callisactive',
        value: -1019),
    EnumMacOSPlatform(
        apiName: 'URLError.callIsActive',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883170-callisactive',
        value: -1019)
  ])
  static const CALL_IS_ACTIVE =
      WebResourceErrorType_._internal("CALL_IS_ACTIVE");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.dataNotAllowed',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883217-datanotallowed',
        value: -1020),
    EnumMacOSPlatform(
        apiName: 'URLError.dataNotAllowed',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883217-datanotallowed',
        value: -1020)
  ])
  static const DATA_NOT_ALLOWED =
      WebResourceErrorType_._internal("DATA_NOT_ALLOWED");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.requestBodyStreamExhausted',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883176-requestbodystreamexhausted',
        value: -1021),
    EnumMacOSPlatform(
        apiName: 'URLError.requestBodyStreamExhausted',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883176-requestbodystreamexhausted',
        value: -1021)
  ])
  static const REQUEST_BODY_STREAM_EXHAUSTED =
      WebResourceErrorType_._internal("REQUEST_BODY_STREAM_EXHAUSTED");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.backgroundSessionRequiresSharedContainer',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883169-backgroundsessionrequiressharedc',
        value: -995),
    EnumMacOSPlatform(
        apiName: 'URLError.backgroundSessionRequiresSharedContainer',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883169-backgroundsessionrequiressharedc',
        value: -995)
  ])
  static const BACKGROUND_SESSION_REQUIRES_SHARED_CONTAINER =
      WebResourceErrorType_._internal(
          "BACKGROUND_SESSION_REQUIRES_SHARED_CONTAINER");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.backgroundSessionInUseByAnotherProcess',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882923-backgroundsessioninusebyanotherp',
        value: -996),
    EnumMacOSPlatform(
        apiName: 'URLError.backgroundSessionInUseByAnotherProcess',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2882923-backgroundsessioninusebyanotherp',
        value: -996)
  ])
  static const BACKGROUND_SESSION_IN_USE_BY_ANOTHER_PROCESS =
      WebResourceErrorType_._internal(
          "BACKGROUND_SESSION_IN_USE_BY_ANOTHER_PROCESS");

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        apiName: 'URLError.backgroundSessionWasDisconnected',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883075-backgroundsessionwasdisconnected',
        value: -997),
    EnumMacOSPlatform(
        apiName: 'URLError.backgroundSessionWasDisconnected',
        apiUrl:
            'https://developer.apple.com/documentation/foundation/urlerror/code/2883075-backgroundsessionwasdisconnected',
        value: -997)
  ])
  static const BACKGROUND_SESSION_WAS_DISCONNECTED =
      WebResourceErrorType_._internal("BACKGROUND_SESSION_WAS_DISCONNECTED");

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_SERVER_UNREACHABLE',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 6),
  ])
  static const SERVER_UNREACHABLE =
      WebResourceErrorType_._internal("SERVER_UNREACHABLE");

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_CONNECTION_ABORTED',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 9)
  ])
  static const CONNECTION_ABORTED =
      WebResourceErrorType_._internal("CONNECTION_ABORTED");

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_CONNECTION_RESET',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 10),
  ])
  static const RESET = WebResourceErrorType_._internal("RESET");

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_REDIRECT_FAILED',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 15),
  ])
  static const REDIRECT_FAILED =
      WebResourceErrorType_._internal("REDIRECT_FAILED");

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_WEB_ERROR_STATUS_UNEXPECTED_ERROR',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 16),
  ])
  static const UNEXPECTED_ERROR =
      WebResourceErrorType_._internal("UNEXPECTED_ERROR");

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName:
            'COREWEBVIEW2_WEB_ERROR_STATUS_VALID_PROXY_AUTHENTICATION_REQUIRED',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#corewebview2_web_error_status',
        value: 18),
  ])
  static const VALID_PROXY_AUTHENTICATION_REQUIRED =
      WebResourceErrorType_._internal("VALID_PROXY_AUTHENTICATION_REQUIRED");
}
