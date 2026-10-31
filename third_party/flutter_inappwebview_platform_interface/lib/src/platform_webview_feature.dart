import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import 'inappwebview_platform.dart';

part 'platform_webview_feature.g.dart';

@immutable
class PlatformWebViewFeatureCreationParams {
  const PlatformWebViewFeatureCreationParams();
}

abstract class PlatformWebViewFeature extends PlatformInterface {
  factory PlatformWebViewFeature(PlatformWebViewFeatureCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebViewFeature webViewFeature =
        InAppWebViewPlatform.instance!.createPlatformWebViewFeature(params);
    PlatformInterface.verify(webViewFeature, _token);
    return webViewFeature;
  }

  factory PlatformWebViewFeature.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebViewFeature webViewFeatureStatic =
        InAppWebViewPlatform.instance!.createPlatformWebViewFeatureStatic();
    PlatformInterface.verify(webViewFeatureStatic, _token);
    return webViewFeatureStatic;
  }

  @protected
  PlatformWebViewFeature.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformWebViewFeatureCreationParams params;

  Future<bool> isFeatureSupported(WebViewFeature feature) {
    throw UnimplementedError(
        'isFeatureSupported is not implemented on the current platform');
  }

  Future<bool> isStartupFeatureSupported(WebViewFeature startupFeature) {
    throw UnimplementedError(
        'isStartupFeatureSupported is not implemented on the current platform');
  }
}

@ExchangeableEnum()
class WebViewFeature_ {
  // ignore: unused_field
  final String _value;

  const WebViewFeature_._internal(this._value);

  @ExchangeableObjectMethod(ignore: true)
  String toNativeValue() => _value;

  static const CREATE_WEB_MESSAGE_CHANNEL =
      const WebViewFeature_._internal("CREATE_WEB_MESSAGE_CHANNEL");

  static const DISABLED_ACTION_MODE_MENU_ITEMS =
      const WebViewFeature_._internal("DISABLED_ACTION_MODE_MENU_ITEMS");

  static const FORCE_DARK = const WebViewFeature_._internal("FORCE_DARK");

  static const FORCE_DARK_STRATEGY =
      const WebViewFeature_._internal("FORCE_DARK_STRATEGY");

  static const GET_WEB_CHROME_CLIENT =
      const WebViewFeature_._internal("GET_WEB_CHROME_CLIENT");

  static const GET_WEB_VIEW_CLIENT =
      const WebViewFeature_._internal("GET_WEB_VIEW_CLIENT");

  static const GET_WEB_VIEW_RENDERER =
      const WebViewFeature_._internal("GET_WEB_VIEW_RENDERER");

  static const MULTI_PROCESS = const WebViewFeature_._internal("MULTI_PROCESS");

  static const OFF_SCREEN_PRERASTER =
      const WebViewFeature_._internal("OFF_SCREEN_PRERASTER");

  static const POST_WEB_MESSAGE =
      const WebViewFeature_._internal("POST_WEB_MESSAGE");

  static const PROXY_OVERRIDE =
      const WebViewFeature_._internal("PROXY_OVERRIDE");

  static const PROXY_OVERRIDE_REVERSE_BYPASS =
      const WebViewFeature_._internal("PROXY_OVERRIDE_REVERSE_BYPASS");

  static const RECEIVE_HTTP_ERROR =
      const WebViewFeature_._internal("RECEIVE_HTTP_ERROR");

  static const RECEIVE_WEB_RESOURCE_ERROR =
      const WebViewFeature_._internal("RECEIVE_WEB_RESOURCE_ERROR");

  static const SAFE_BROWSING_ALLOWLIST =
      const WebViewFeature_._internal("SAFE_BROWSING_ALLOWLIST");

  static const SAFE_BROWSING_ENABLE =
      const WebViewFeature_._internal("SAFE_BROWSING_ENABLE");

  static const SAFE_BROWSING_HIT =
      const WebViewFeature_._internal("SAFE_BROWSING_HIT");

  static const SAFE_BROWSING_PRIVACY_POLICY_URL =
      const WebViewFeature_._internal("SAFE_BROWSING_PRIVACY_POLICY_URL");

  static const SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY =
      const WebViewFeature_._internal("SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY");

  static const SAFE_BROWSING_RESPONSE_PROCEED =
      const WebViewFeature_._internal("SAFE_BROWSING_RESPONSE_PROCEED");

  static const SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL =
      const WebViewFeature_._internal(
          "SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL");

  @Deprecated('Use SAFE_BROWSING_ALLOWLIST instead')
  static const SAFE_BROWSING_WHITELIST =
      const WebViewFeature_._internal("SAFE_BROWSING_WHITELIST");

  static const SERVICE_WORKER_BASIC_USAGE =
      const WebViewFeature_._internal("SERVICE_WORKER_BASIC_USAGE");

  static const SERVICE_WORKER_BLOCK_NETWORK_LOADS =
      const WebViewFeature_._internal("SERVICE_WORKER_BLOCK_NETWORK_LOADS");

  static const SERVICE_WORKER_CACHE_MODE =
      const WebViewFeature_._internal("SERVICE_WORKER_CACHE_MODE");

  static const SERVICE_WORKER_CONTENT_ACCESS =
      const WebViewFeature_._internal("SERVICE_WORKER_CONTENT_ACCESS");

  static const SERVICE_WORKER_FILE_ACCESS =
      const WebViewFeature_._internal("SERVICE_WORKER_FILE_ACCESS");

  static const SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST =
      const WebViewFeature_._internal(
          "SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST");

  static const SHOULD_OVERRIDE_WITH_REDIRECTS =
      const WebViewFeature_._internal("SHOULD_OVERRIDE_WITH_REDIRECTS");

  static const START_SAFE_BROWSING =
      const WebViewFeature_._internal("START_SAFE_BROWSING");

  static const TRACING_CONTROLLER_BASIC_USAGE =
      const WebViewFeature_._internal("TRACING_CONTROLLER_BASIC_USAGE");

  static const VISUAL_STATE_CALLBACK =
      const WebViewFeature_._internal("VISUAL_STATE_CALLBACK");

  static const WEB_MESSAGE_CALLBACK_ON_MESSAGE =
      const WebViewFeature_._internal("WEB_MESSAGE_CALLBACK_ON_MESSAGE");

  static const WEB_MESSAGE_LISTENER =
      const WebViewFeature_._internal("WEB_MESSAGE_LISTENER");

  static const WEB_MESSAGE_PORT_CLOSE =
      const WebViewFeature_._internal("WEB_MESSAGE_PORT_CLOSE");

  static const WEB_MESSAGE_PORT_POST_MESSAGE =
      const WebViewFeature_._internal("WEB_MESSAGE_PORT_POST_MESSAGE");

  static const WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK =
      const WebViewFeature_._internal("WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK");

  static const WEB_RESOURCE_ERROR_GET_CODE =
      const WebViewFeature_._internal("WEB_RESOURCE_ERROR_GET_CODE");

  static const WEB_RESOURCE_ERROR_GET_DESCRIPTION =
      const WebViewFeature_._internal("WEB_RESOURCE_ERROR_GET_DESCRIPTION");

  static const WEB_RESOURCE_REQUEST_IS_REDIRECT =
      const WebViewFeature_._internal("WEB_RESOURCE_REQUEST_IS_REDIRECT");

  static const WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE =
      const WebViewFeature_._internal("WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE");

  static const WEB_VIEW_RENDERER_TERMINATE =
      const WebViewFeature_._internal("WEB_VIEW_RENDERER_TERMINATE");

  static const DOCUMENT_START_SCRIPT =
      const WebViewFeature_._internal("DOCUMENT_START_SCRIPT");

  static const ALGORITHMIC_DARKENING =
      const WebViewFeature_._internal("ALGORITHMIC_DARKENING");

  static const ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY =
      const WebViewFeature_._internal(
          "ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY");

  static const GET_VARIATIONS_HEADER =
      const WebViewFeature_._internal("GET_VARIATIONS_HEADER");

  static const GET_COOKIE_INFO =
      const WebViewFeature_._internal("GET_COOKIE_INFO");

  static const REQUESTED_WITH_HEADER_ALLOW_LIST =
      const WebViewFeature_._internal("REQUESTED_WITH_HEADER_ALLOW_LIST");

  static const WEB_MESSAGE_ARRAY_BUFFER =
      const WebViewFeature_._internal("WEB_MESSAGE_ARRAY_BUFFER");

  static const MULTI_PROFILE =
      const WebViewFeature_._internal("MULTI_PROFILE");

  static const STARTUP_FEATURE_SET_DATA_DIRECTORY_SUFFIX =
      const WebViewFeature_._internal(
          "STARTUP_FEATURE_SET_DATA_DIRECTORY_SUFFIX");

  static const STARTUP_FEATURE_SET_DIRECTORY_BASE_PATHS =
      const WebViewFeature_._internal(
          "STARTUP_FEATURE_SET_DIRECTORY_BASE_PATHS");

  static Future<bool> isFeatureSupported(WebViewFeature feature) =>
      PlatformWebViewFeature.static().isFeatureSupported(feature);

  static Future<bool> isStartupFeatureSupported(
          WebViewFeature startupFeature) =>
      PlatformWebViewFeature.static().isStartupFeatureSupported(startupFeature);
}

@Deprecated("Use WebViewFeature instead")
@ExchangeableEnum()
class AndroidWebViewFeature_ {
  // ignore: unused_field
  final String _value;

  const AndroidWebViewFeature_._internal(this._value);

  @ExchangeableObjectMethod(ignore: true)
  String toNativeValue() => _value;

  static const CREATE_WEB_MESSAGE_CHANNEL =
      const AndroidWebViewFeature_._internal("CREATE_WEB_MESSAGE_CHANNEL");

  static const DISABLED_ACTION_MODE_MENU_ITEMS =
      const AndroidWebViewFeature_._internal("DISABLED_ACTION_MODE_MENU_ITEMS");

  static const FORCE_DARK =
      const AndroidWebViewFeature_._internal("FORCE_DARK");

  static const FORCE_DARK_STRATEGY =
      const AndroidWebViewFeature_._internal("FORCE_DARK_STRATEGY");

  static const GET_WEB_CHROME_CLIENT =
      const AndroidWebViewFeature_._internal("GET_WEB_CHROME_CLIENT");

  static const GET_WEB_VIEW_CLIENT =
      const AndroidWebViewFeature_._internal("GET_WEB_VIEW_CLIENT");

  static const GET_WEB_VIEW_RENDERER =
      const AndroidWebViewFeature_._internal("GET_WEB_VIEW_RENDERER");

  static const MULTI_PROCESS =
      const AndroidWebViewFeature_._internal("MULTI_PROCESS");

  static const OFF_SCREEN_PRERASTER =
      const AndroidWebViewFeature_._internal("OFF_SCREEN_PRERASTER");

  static const POST_WEB_MESSAGE =
      const AndroidWebViewFeature_._internal("POST_WEB_MESSAGE");

  static const PROXY_OVERRIDE =
      const AndroidWebViewFeature_._internal("PROXY_OVERRIDE");

  static const RECEIVE_HTTP_ERROR =
      const AndroidWebViewFeature_._internal("RECEIVE_HTTP_ERROR");

  static const RECEIVE_WEB_RESOURCE_ERROR =
      const AndroidWebViewFeature_._internal("RECEIVE_WEB_RESOURCE_ERROR");

  static const SAFE_BROWSING_ALLOWLIST =
      const AndroidWebViewFeature_._internal("SAFE_BROWSING_ALLOWLIST");

  static const SAFE_BROWSING_ENABLE =
      const AndroidWebViewFeature_._internal("SAFE_BROWSING_ENABLE");

  static const SAFE_BROWSING_HIT =
      const AndroidWebViewFeature_._internal("SAFE_BROWSING_HIT");

  static const SAFE_BROWSING_PRIVACY_POLICY_URL =
      const AndroidWebViewFeature_._internal(
          "SAFE_BROWSING_PRIVACY_POLICY_URL");

  static const SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY =
      const AndroidWebViewFeature_._internal(
          "SAFE_BROWSING_RESPONSE_BACK_TO_SAFETY");

  static const SAFE_BROWSING_RESPONSE_PROCEED =
      const AndroidWebViewFeature_._internal("SAFE_BROWSING_RESPONSE_PROCEED");

  static const SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL =
      const AndroidWebViewFeature_._internal(
          "SAFE_BROWSING_RESPONSE_SHOW_INTERSTITIAL");

  @Deprecated('Use SAFE_BROWSING_ALLOWLIST instead')
  static const SAFE_BROWSING_WHITELIST =
      const AndroidWebViewFeature_._internal("SAFE_BROWSING_WHITELIST");

  static const SERVICE_WORKER_BASIC_USAGE =
      const AndroidWebViewFeature_._internal("SERVICE_WORKER_BASIC_USAGE");

  static const SERVICE_WORKER_BLOCK_NETWORK_LOADS =
      const AndroidWebViewFeature_._internal(
          "SERVICE_WORKER_BLOCK_NETWORK_LOADS");

  static const SERVICE_WORKER_CACHE_MODE =
      const AndroidWebViewFeature_._internal("SERVICE_WORKER_CACHE_MODE");

  static const SERVICE_WORKER_CONTENT_ACCESS =
      const AndroidWebViewFeature_._internal("SERVICE_WORKER_CONTENT_ACCESS");

  static const SERVICE_WORKER_FILE_ACCESS =
      const AndroidWebViewFeature_._internal("SERVICE_WORKER_FILE_ACCESS");

  static const SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST =
      const AndroidWebViewFeature_._internal(
          "SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST");

  static const SHOULD_OVERRIDE_WITH_REDIRECTS =
      const AndroidWebViewFeature_._internal("SHOULD_OVERRIDE_WITH_REDIRECTS");

  static const START_SAFE_BROWSING =
      const AndroidWebViewFeature_._internal("START_SAFE_BROWSING");

  static const TRACING_CONTROLLER_BASIC_USAGE =
      const AndroidWebViewFeature_._internal("TRACING_CONTROLLER_BASIC_USAGE");

  static const VISUAL_STATE_CALLBACK =
      const AndroidWebViewFeature_._internal("VISUAL_STATE_CALLBACK");

  static const WEB_MESSAGE_CALLBACK_ON_MESSAGE =
      const AndroidWebViewFeature_._internal("WEB_MESSAGE_CALLBACK_ON_MESSAGE");

  static const WEB_MESSAGE_LISTENER =
      const AndroidWebViewFeature_._internal("WEB_MESSAGE_LISTENER");

  static const WEB_MESSAGE_PORT_CLOSE =
      const AndroidWebViewFeature_._internal("WEB_MESSAGE_PORT_CLOSE");

  static const WEB_MESSAGE_PORT_POST_MESSAGE =
      const AndroidWebViewFeature_._internal("WEB_MESSAGE_PORT_POST_MESSAGE");

  static const WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK =
      const AndroidWebViewFeature_._internal(
          "WEB_MESSAGE_PORT_SET_MESSAGE_CALLBACK");

  static const WEB_RESOURCE_ERROR_GET_CODE =
      const AndroidWebViewFeature_._internal("WEB_RESOURCE_ERROR_GET_CODE");

  static const WEB_RESOURCE_ERROR_GET_DESCRIPTION =
      const AndroidWebViewFeature_._internal(
          "WEB_RESOURCE_ERROR_GET_DESCRIPTION");

  static const WEB_RESOURCE_REQUEST_IS_REDIRECT =
      const AndroidWebViewFeature_._internal(
          "WEB_RESOURCE_REQUEST_IS_REDIRECT");

  static const WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE =
      const AndroidWebViewFeature_._internal(
          "WEB_VIEW_RENDERER_CLIENT_BASIC_USAGE");

  static const WEB_VIEW_RENDERER_TERMINATE =
      const AndroidWebViewFeature_._internal("WEB_VIEW_RENDERER_TERMINATE");

  static const DOCUMENT_START_SCRIPT =
      const AndroidWebViewFeature_._internal("DOCUMENT_START_SCRIPT");

  static const SUPPRESS_ERROR_PAGE =
      const AndroidWebViewFeature_._internal("SUPPRESS_ERROR_PAGE");

  static const ALGORITHMIC_DARKENING =
      const AndroidWebViewFeature_._internal("ALGORITHMIC_DARKENING");

  static const REQUESTED_WITH_HEADER_CONTROL =
      const AndroidWebViewFeature_._internal("REQUESTED_WITH_HEADER_CONTROL");

  static const ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY =
      const AndroidWebViewFeature_._internal(
          "ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY");

  static Future<bool> isFeatureSupported(AndroidWebViewFeature feature) =>
      PlatformWebViewFeature.static().isFeatureSupported(
          WebViewFeature.fromNativeValue(feature.toNativeValue())!);
}
