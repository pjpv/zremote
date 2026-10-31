import 'dart:typed_data';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';
import 'url_request_cache_policy.dart';
import 'url_request_network_service_type.dart';
import 'url_request_attribution.dart';

part 'url_request.g.dart';

@ExchangeableObject()
class URLRequest_ {
  WebUri? url;

  String? method;

  Uint8List? body;

  Map<String, String>? headers;

  @Deprecated("Use allowsCellularAccess instead")
  bool? iosAllowsCellularAccess;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLRequest.allowsCellularAccess",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011607-allowscellularaccess/"),
    MacOSPlatform(
        apiName: "URLRequest.allowsCellularAccess",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011607-allowscellularaccess/")
  ])
  bool? allowsCellularAccess;

  @Deprecated("Use allowsConstrainedNetworkAccess instead")
  bool? iosAllowsConstrainedNetworkAccess;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "13.0",
        apiName: "URLRequest.allowsConstrainedNetworkAccess",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/3358304-allowsconstrainednetworkaccess"),
    MacOSPlatform(
        available: "10.15",
        apiName: "URLRequest.allowsConstrainedNetworkAccess",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/3358304-allowsconstrainednetworkaccess")
  ])
  bool? allowsConstrainedNetworkAccess;

  @Deprecated("Use allowsExpensiveNetworkAccess instead")
  bool? iosAllowsExpensiveNetworkAccess;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "13.0",
        apiName: "URLRequest.allowsExpensiveNetworkAccess",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/3358305-allowsexpensivenetworkaccess"),
    MacOSPlatform(
        available: "10.15",
        apiName: "URLRequest.allowsExpensiveNetworkAccess",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/3358305-allowsexpensivenetworkaccess")
  ])
  bool? allowsExpensiveNetworkAccess;

  @Deprecated("Use cachePolicy instead")
  IOSURLRequestCachePolicy_? iosCachePolicy;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLRequest.cachePolicy",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011593-cachepolicy"),
    MacOSPlatform(
        apiName: "URLRequest.cachePolicy",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011593-cachepolicy")
  ])
  URLRequestCachePolicy_? cachePolicy;

  @Deprecated("Use httpShouldHandleCookies instead")
  bool? iosHttpShouldHandleCookies;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLRequest.httpShouldHandleCookies",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011548-httpshouldhandlecookies"),
    MacOSPlatform(
        apiName: "URLRequest.httpShouldHandleCookies",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011548-httpshouldhandlecookies")
  ])
  bool? httpShouldHandleCookies;

  @Deprecated("Use httpShouldUsePipelining instead")
  bool? iosHttpShouldUsePipelining;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLRequest.httpShouldUsePipelining",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011508-httpshouldusepipelining"),
    MacOSPlatform(
        apiName: "URLRequest.httpShouldUsePipelining",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011508-httpshouldusepipelining")
  ])
  bool? httpShouldUsePipelining;

  @Deprecated("Use networkServiceType instead")
  IOSURLRequestNetworkServiceType_? iosNetworkServiceType;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLRequest.networkServiceType",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011409-networkservicetype"),
    MacOSPlatform(
        apiName: "URLRequest.networkServiceType",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011409-networkservicetype")
  ])
  URLRequestNetworkServiceType_? networkServiceType;

  @Deprecated("Use timeoutInterval instead")
  double? iosTimeoutInterval;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLRequest.timeoutInterval",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011509-timeoutinterval"),
    MacOSPlatform(
        apiName: "URLRequest.timeoutInterval",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011509-timeoutinterval")
  ])
  double? timeoutInterval;

  @Deprecated("Use mainDocumentURL instead")
  Uri? iosMainDocumentURL;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "URLRequest.mainDocumentURL",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011552-maindocumenturl"),
    MacOSPlatform(
        apiName: "URLRequest.mainDocumentURL",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/2011552-maindocumenturl")
  ])
  WebUri? mainDocumentURL;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "14.5",
        apiName: "URLRequest.assumesHTTP3Capable",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/3738175-assumeshttp3capable"),
    MacOSPlatform(
        available: "11.3",
        apiName: "URLRequest.assumesHTTP3Capable",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/3738175-assumeshttp3capable")
  ])
  bool? assumesHTTP3Capable;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "15.0",
        apiName: "URLRequest.attribution",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/3767318-attribution"),
    MacOSPlatform(
        available: "12.0",
        apiName: "URLRequest.attribution",
        apiUrl:
            "https://developer.apple.com/documentation/foundation/urlrequest/3767318-attribution")
  ])
  URLRequestAttribution_? attribution;

  URLRequest_(
      {required this.url,
      this.method,
      this.headers,
      this.body,
      @Deprecated("Use allowsCellularAccess instead")
      this.iosAllowsCellularAccess,
      this.allowsCellularAccess,
      @Deprecated("Use allowsConstrainedNetworkAccess instead")
      this.iosAllowsConstrainedNetworkAccess,
      this.allowsConstrainedNetworkAccess,
      @Deprecated("Use allowsExpensiveNetworkAccess instead")
      this.iosAllowsExpensiveNetworkAccess,
      this.allowsExpensiveNetworkAccess,
      @Deprecated("Use cachePolicy instead") this.iosCachePolicy,
      this.cachePolicy,
      @Deprecated("Use httpShouldHandleCookies instead")
      this.iosHttpShouldHandleCookies,
      this.httpShouldHandleCookies,
      @Deprecated("Use httpShouldUsePipelining instead")
      this.iosHttpShouldUsePipelining,
      this.httpShouldUsePipelining,
      @Deprecated("Use networkServiceType instead") this.iosNetworkServiceType,
      this.networkServiceType,
      @Deprecated("Use timeoutInterval instead") this.iosTimeoutInterval,
      this.timeoutInterval,
      @Deprecated("Use mainDocumentURL instead") this.iosMainDocumentURL,
      this.mainDocumentURL,
      this.assumesHTTP3Capable,
      this.attribution});
}
