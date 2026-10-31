import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../platform_cookie_manager.dart';
import '../platform_webview_feature.dart';
import 'http_cookie_same_site_policy.dart';

part 'cookie.g.dart';

@ExchangeableObject()
class Cookie_ {
  @SupportedPlatforms(platforms: [
    IOSPlatform(),
    MacOSPlatform(),
    AndroidPlatform(),
    WebPlatform(),
    WindowsPlatform()
  ])
  String name;

  @SupportedPlatforms(platforms: [
    IOSPlatform(),
    MacOSPlatform(),
    AndroidPlatform(),
    WebPlatform(),
    WindowsPlatform()
  ])
  dynamic value;

  @SupportedPlatforms(platforms: [
    IOSPlatform(),
    MacOSPlatform(),
    AndroidPlatform(
        note:
            "available on Android only if [WebViewFeature.GET_COOKIE_INFO] feature is supported."),
    WindowsPlatform()
  ])
  int? expiresDate;

  @SupportedPlatforms(
      platforms: [IOSPlatform(), MacOSPlatform(), WindowsPlatform()])
  bool? isSessionOnly;

  @SupportedPlatforms(platforms: [
    IOSPlatform(),
    MacOSPlatform(),
    AndroidPlatform(
        note:
            "available on Android only if [WebViewFeature.GET_COOKIE_INFO] feature is supported."),
    WindowsPlatform()
  ])
  String? domain;

  @SupportedPlatforms(platforms: [
    IOSPlatform(),
    MacOSPlatform(),
    AndroidPlatform(
        note:
            "available on Android only if [WebViewFeature.GET_COOKIE_INFO] feature is supported."),
    WindowsPlatform()
  ])
  HTTPCookieSameSitePolicy_? sameSite;

  @SupportedPlatforms(platforms: [
    IOSPlatform(),
    MacOSPlatform(),
    AndroidPlatform(
        note:
            "available on Android only if [WebViewFeature.GET_COOKIE_INFO] feature is supported."),
    WindowsPlatform()
  ])
  bool? isSecure;

  @SupportedPlatforms(platforms: [
    IOSPlatform(),
    MacOSPlatform(),
    AndroidPlatform(
        note:
            "available on Android only if [WebViewFeature.GET_COOKIE_INFO] feature is supported."),
    WindowsPlatform()
  ])
  bool? isHttpOnly;

  @SupportedPlatforms(platforms: [
    IOSPlatform(),
    MacOSPlatform(),
    AndroidPlatform(
        note:
            "available on Android only if [WebViewFeature.GET_COOKIE_INFO] feature is supported."),
    WindowsPlatform()
  ])
  String? path;

  Cookie_(
      {required this.name,
      required this.value,
      this.expiresDate,
      this.isSessionOnly,
      this.domain,
      this.sameSite,
      this.isSecure,
      this.isHttpOnly,
      this.path});
}
