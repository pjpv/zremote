import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'in_app_webview/platform_inappwebview_controller.dart';
import 'types/main.dart';
import 'web_uri.dart';
import 'inappwebview_platform.dart';
import 'in_app_webview/platform_headless_in_app_webview.dart';
import 'webview_environment/platform_webview_environment.dart';

@immutable
class PlatformCookieManagerCreationParams {
  const PlatformCookieManagerCreationParams({this.webViewEnvironment});

  final PlatformWebViewEnvironment? webViewEnvironment;
}

abstract class PlatformCookieManager extends PlatformInterface {
  factory PlatformCookieManager(PlatformCookieManagerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformCookieManager cookieManager =
        InAppWebViewPlatform.instance!.createPlatformCookieManager(params);
    PlatformInterface.verify(cookieManager, _token);
    return cookieManager;
  }

  @protected
  PlatformCookieManager.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformCookieManagerCreationParams params;

  Future<bool> setCookie(
      {required WebUri url,
      required String name,
      required String value,
      String path = "/",
      String? domain,
      int? expiresDate,
      int? maxAge,
      bool? isSecure,
      bool? isHttpOnly,
      HTTPCookieSameSitePolicy? sameSite,
      @Deprecated("Use webViewController instead")
      PlatformInAppWebViewController? iosBelow11WebViewController,
      PlatformInAppWebViewController? webViewController}) {
    throw UnimplementedError(
        'setCookie is not implemented on the current platform');
  }

  Future<List<Cookie>> getCookies(
      {required WebUri url,
      @Deprecated("Use webViewController instead")
      PlatformInAppWebViewController? iosBelow11WebViewController,
      PlatformInAppWebViewController? webViewController}) {
    throw UnimplementedError(
        'getCookies is not implemented on the current platform');
  }

  Future<Cookie?> getCookie(
      {required WebUri url,
      required String name,
      @Deprecated("Use webViewController instead")
      PlatformInAppWebViewController? iosBelow11WebViewController,
      PlatformInAppWebViewController? webViewController}) {
    throw UnimplementedError(
        'getCookie is not implemented on the current platform');
  }

  Future<bool> deleteCookie(
      {required WebUri url,
      required String name,
      String path = "/",
      String? domain,
      @Deprecated("Use webViewController instead")
      PlatformInAppWebViewController? iosBelow11WebViewController,
      PlatformInAppWebViewController? webViewController}) {
    throw UnimplementedError(
        'deleteCookie is not implemented on the current platform');
  }

  Future<bool> deleteCookies(
      {required WebUri url,
      String path = "/",
      String? domain,
      @Deprecated("Use webViewController instead")
      PlatformInAppWebViewController? iosBelow11WebViewController,
      PlatformInAppWebViewController? webViewController}) {
    throw UnimplementedError(
        'deleteCookies is not implemented on the current platform');
  }

  Future<bool> deleteAllCookies() {
    throw UnimplementedError(
        'deleteAllCookies is not implemented on the current platform');
  }

  Future<List<Cookie>> getAllCookies() {
    throw UnimplementedError(
        'getAllCookies is not implemented on the current platform');
  }

  Future<bool> removeSessionCookies() {
    throw UnimplementedError(
        'removeSessionCookies is not implemented on the current platform');
  }
}
