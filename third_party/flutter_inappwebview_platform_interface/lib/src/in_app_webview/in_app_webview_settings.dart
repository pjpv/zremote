import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import 'dart:typed_data';

import '../platform_webview_asset_loader.dart';
import '../types/action_mode_menu_item.dart';
import '../types/cache_mode.dart';
import '../types/data_detector_types.dart';
import '../types/force_dark.dart';
import '../types/force_dark_strategy.dart';
import '../types/layout_algorithm.dart';
import '../types/mixed_content_mode.dart';
import '../types/over_scroll_mode.dart';
import '../types/referrer_policy.dart';
import '../types/renderer_priority_policy.dart';
import '../types/sandbox.dart';
import '../types/scrollbar_style.dart';
import '../types/scrollview_content_inset_adjustment_behavior.dart';
import '../types/scrollview_deceleration_rate.dart';
import '../types/selection_granularity.dart';
import '../types/user_preferred_content_mode.dart';
import '../types/vertical_scrollbar_position.dart';
import '../web_uri.dart';
import 'android/in_app_webview_options.dart';
import 'apple/in_app_webview_options.dart';
import '../content_blocker.dart';
import '../types/main.dart';
import '../util.dart';
import '../in_app_browser/in_app_browser_settings.dart';
import '../platform_webview_feature.dart';
import '../in_app_webview/platform_inappwebview_controller.dart';
import '../context_menu/context_menu.dart';
import '../in_app_browser/platform_in_app_browser.dart';
import 'platform_webview.dart';

part 'in_app_webview_settings.g.dart';

List<ContentBlocker> _deserializeContentBlockers(
    List<dynamic>? contentBlockersMapList) {
  List<ContentBlocker> contentBlockers = [];
  if (contentBlockersMapList != null) {
    contentBlockersMapList.forEach((contentBlocker) {
      contentBlockers.add(ContentBlocker.fromMap(
          Map<dynamic, Map<dynamic, dynamic>>.from(
              Map<dynamic, dynamic>.from(contentBlocker))));
    });
  }
  return contentBlockers;
}

@ExchangeableObject(copyMethod: true)
class InAppWebViewSettings_ {
  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(),
    MacOSPlatform(),
    WindowsPlatform()
  ])
  bool? useShouldOverrideUrlLoading;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? useOnLoadResource;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? useOnDownloadStart;

  @Deprecated("Use InAppWebViewController.clearAllCache instead")
  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? clearCache;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setUserAgentString",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setUserAgentString(java.lang.String)"),
    IOSPlatform(
        apiName: "WKWebView.customUserAgent",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/1414950-customuseragent"),
    MacOSPlatform(
        apiName: "WKWebView.customUserAgent",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/1414950-customuseragent"),
    WindowsPlatform(
        apiName: 'ICoreWebView2Settings2.put_UserAgent',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings2?view=webview2-1.0.2210.55#put_useragent')
  ])
  String? userAgent;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(
        apiName: "WKWebViewConfiguration.applicationNameForUserAgent",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1395665-applicationnameforuseragent"),
    MacOSPlatform(
        apiName: "WKWebViewConfiguration.applicationNameForUserAgent",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1395665-applicationnameforuseragent")
  ])
  String? applicationNameForUserAgent;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setJavaScriptEnabled",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setJavaScriptEnabled(boolean)"),
    IOSPlatform(
        apiName: "WKWebpagePreferences.allowsContentJavaScript",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebpagepreferences/3552422-allowscontentjavascript/"),
    MacOSPlatform(
        apiName: "WKWebpagePreferences.allowsContentJavaScript",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebpagepreferences/3552422-allowscontentjavascript/"),
    WebPlatform(requiresSameOrigin: false),
    WindowsPlatform(
        apiName: "ICoreWebView2Settings.put_IsScriptEnabled",
        apiUrl:
            "https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings?view=webview2-1.0.2210.55#put_isscriptenabled")
  ])
  bool? javaScriptEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setJavaScriptCanOpenWindowsAutomatically",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setJavaScriptCanOpenWindowsAutomatically(boolean)"),
    IOSPlatform(
        apiName: "WKPreferences.javaScriptCanOpenWindowsAutomatically",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/1536573-javascriptcanopenwindowsautomati/"),
    MacOSPlatform(
        apiName: "WKPreferences.javaScriptCanOpenWindowsAutomatically",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/1536573-javascriptcanopenwindowsautomati/"),
    WebPlatform()
  ])
  bool? javaScriptCanOpenWindowsAutomatically;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setMediaPlaybackRequiresUserGesture",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setMediaPlaybackRequiresUserGesture(boolean)"),
    IOSPlatform(
        apiName:
            "WKWebViewConfiguration.mediaTypesRequiringUserActionForPlayback",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1851524-mediatypesrequiringuseractionfor"),
    MacOSPlatform(
        available: "10.12",
        apiName:
            "WKWebViewConfiguration.mediaTypesRequiringUserActionForPlayback",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1851524-mediatypesrequiringuseractionfor")
  ])
  bool? mediaPlaybackRequiresUserGesture;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setMinimumFontSize",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setMinimumFontSize(int)"),
    IOSPlatform(
        apiName: "WKPreferences.minimumFontSize",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/1537155-minimumfontsize/"),
    MacOSPlatform(
        apiName: "WKPreferences.minimumFontSize",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/1537155-minimumfontsize/")
  ])
  int? minimumFontSize;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "View.setVerticalScrollBarEnabled",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setVerticalScrollBarEnabled(boolean)"),
    IOSPlatform(
        apiName: "UIScrollView.showsVerticalScrollIndicator",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619405-showsverticalscrollindicator/"),
    WebPlatform(
        note:
            "It must have the same value of [horizontalScrollBarEnabled] to take effect.")
  ])
  bool? verticalScrollBarEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "View.setHorizontalScrollBarEnabled",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setHorizontalScrollBarEnabled(boolean)"),
    IOSPlatform(
        apiName: "UIScrollView.showsHorizontalScrollIndicator",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619380-showshorizontalscrollindicator"),
    WebPlatform(
        note:
            "It must have the same value of [verticalScrollBarEnabled] to take effect.")
  ])
  bool? horizontalScrollBarEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(available: "11.0"),
    MacOSPlatform(available: "10.13")
  ])
  List<String>? resourceCustomSchemes;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(available: "11.0"),
    MacOSPlatform(available: "10.13")
  ])
  @ExchangeableObjectProperty(deserializer: _deserializeContentBlockers)
  List<ContentBlocker>? contentBlockers;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(
        available: "13.0",
        apiName: "WKWebpagePreferences.preferredContentMode",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebpagepreferences/3194426-preferredcontentmode/"),
    MacOSPlatform(
        available: "10.15",
        apiName: "WKWebpagePreferences.preferredContentMode",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebpagepreferences/3194426-preferredcontentmode/")
  ])
  UserPreferredContentMode_? preferredContentMode;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? useShouldInterceptAjaxRequest;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? interceptOnlyAsyncAjaxRequests;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? useShouldInterceptFetchRequest;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        note:
            """setting this to `true`, it will clear all the cookies of all WebView instances, 
because there isn't any way to make the website data store non-persistent for the specific WebView instance such as on iOS."""),
    IOSPlatform(),
    MacOSPlatform(),
    WindowsPlatform(
      apiName: "ICoreWebView2ControllerOptions.put_IsInPrivateModeEnabled",
      apiUrl: "https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controlleroptions?view=webview2-1.0.2792.45#put_isinprivatemodeenabled"
    )
  ])
  bool? incognito;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? cacheEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(),
    MacOSPlatform(available: "12.0"),
    WindowsPlatform(
        available: '1.0.774.44',
        apiName: 'ICoreWebView2Controller2.put_DefaultBackgroundColor',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2controller2?view=webview2-1.0.2210.55#put_defaultbackgroundcolor')
  ])
  bool? transparentBackground;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), WebPlatform()])
  bool? disableVerticalScroll;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), WebPlatform()])
  bool? disableHorizontalScroll;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(),
    WebPlatform(),
    WindowsPlatform(
        apiName: "ICoreWebView2Settings.put_AreDefaultContextMenusEnabled",
        apiUrl:
            "https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings?view=webview2-1.0.2210.55#put_aredefaultcontextmenusenabled")
  ])
  bool? disableContextMenu;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setSupportZoom",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setSupportZoom(boolean)"),
    IOSPlatform(),
    MacOSPlatform(),
    WindowsPlatform(
        apiName: "ICoreWebView2Settings.put_IsZoomControlEnabled",
        apiUrl:
            "https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings?view=webview2-1.0.2210.55#put_iszoomcontrolenabled")
  ])
  bool? supportZoom;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setAllowFileAccessFromFileURLs",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setAllowFileAccessFromFileURLs(boolean)"),
    IOSPlatform(),
    MacOSPlatform()
  ])
  bool? allowFileAccessFromFileURLs;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setAllowUniversalAccessFromFileURLs",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setAllowUniversalAccessFromFileURLs(boolean)"),
    IOSPlatform(),
    MacOSPlatform()
  ])
  bool? allowUniversalAccessFromFileURLs;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? allowBackgroundAudioPlaying;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  WebViewAssetLoader_? webViewAssetLoader;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setTextZoom",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setTextZoom(int)")
  ])
  int? textZoom;

  @Deprecated("Use CookieManager.removeSessionCookies instead")
  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? clearSessionCache;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setBuiltInZoomControls",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setBuiltInZoomControls(boolean)")
  ])
  bool? builtInZoomControls;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setDisplayZoomControls",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setDisplayZoomControls(boolean)")
  ])
  bool? displayZoomControls;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setDatabaseEnabled",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setDatabaseEnabled(boolean)")
  ])
  bool? databaseEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setDomStorageEnabled",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setDomStorageEnabled(boolean)")
  ])
  bool? domStorageEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setUseWideViewPort",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setUseWideViewPort(boolean)")
  ])
  bool? useWideViewPort;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "26",
        apiName: "WebSettings.setSafeBrowsingEnabled",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setSafeBrowsingEnabled(boolean)")
  ])
  bool? safeBrowsingEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "21",
        apiName: "WebSettings.setMixedContentMode",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setMixedContentMode(int)")
  ])
  MixedContentMode_? mixedContentMode;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setAllowContentAccess",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setAllowContentAccess(boolean)")
  ])
  bool? allowContentAccess;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setAllowFileAccess",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setAllowFileAccess(boolean)")
  ])
  bool? allowFileAccess;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(apiName: "WebSettings.setAppCachePath")])
  String? appCachePath;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setBlockNetworkImage",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setBlockNetworkImage(boolean)")
  ])
  bool? blockNetworkImage;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setBlockNetworkLoads",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setBlockNetworkLoads(boolean)")
  ])
  bool? blockNetworkLoads;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setCacheMode",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setCacheMode(int)")
  ])
  CacheMode_? cacheMode;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setCursiveFontFamily",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setCursiveFontFamily(java.lang.String)")
  ])
  String? cursiveFontFamily;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setDefaultFixedFontSize",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setDefaultFixedFontSize(int)")
  ])
  int? defaultFixedFontSize;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setDefaultFontSize",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setDefaultFontSize(int)")
  ])
  int? defaultFontSize;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setDefaultTextEncodingName",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setDefaultTextEncodingName(java.lang.String)")
  ])
  String? defaultTextEncodingName;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "24",
        apiName: "WebSettings.setDisabledActionModeMenuItems",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setDisabledActionModeMenuItems(int)")
  ])
  ActionModeMenuItem_? disabledActionModeMenuItems;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setFantasyFontFamily",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setFantasyFontFamily(java.lang.String)")
  ])
  String? fantasyFontFamily;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setFixedFontFamily",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setFixedFontFamily(java.lang.String)")
  ])
  String? fixedFontFamily;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "29",
        apiName: "WebSettings.setForceDark",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings#setForceDark(int)")
  ])
  ForceDark_? forceDark;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettingsCompat.setForceDarkStrategy",
        apiUrl:
            "https://developer.android.com/reference/androidx/webkit/WebSettingsCompat#setForceDarkStrategy(android.webkit.WebSettings,int)",
        note:
            "it will take effect only if [WebViewFeature.isFeatureSupported] returns `true` for [WebViewFeature.FORCE_DARK_STRATEGY].")
  ])
  ForceDarkStrategy_? forceDarkStrategy;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setGeolocationEnabled",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setGeolocationEnabled(boolean)",
        note:
            """Please note that in order for the Geolocation API to be usable by a page in the WebView, the following requirements must be met:
- an application must have permission to access the device location, see [Manifest.permission.ACCESS_COARSE_LOCATION](https://developer.android.com/reference/android/Manifest.permission#ACCESS_COARSE_LOCATION), [Manifest.permission.ACCESS_FINE_LOCATION](https://developer.android.com/reference/android/Manifest.permission#ACCESS_FINE_LOCATION);
- an application must provide an implementation of the [PlatformWebViewCreationParams.onGeolocationPermissionsShowPrompt] callback to receive notifications that a page is requesting access to location via the JavaScript Geolocation API.""")
  ])
  bool? geolocationEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setLayoutAlgorithm",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setLayoutAlgorithm(android.webkit.WebSettings.LayoutAlgorithm)")
  ])
  LayoutAlgorithm_? layoutAlgorithm;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setLoadWithOverviewMode",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setLoadWithOverviewMode(boolean)")
  ])
  bool? loadWithOverviewMode;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setLoadsImagesAutomatically",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setLoadsImagesAutomatically(boolean)")
  ])
  bool? loadsImagesAutomatically;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setMinimumLogicalFontSize",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setMinimumLogicalFontSize(int)")
  ])
  int? minimumLogicalFontSize;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebView.setInitialScale",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebView#setInitialScale(int)")
  ])
  int? initialScale;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setNeedInitialFocus",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setNeedInitialFocus(boolean)")
  ])
  bool? needInitialFocus;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "23",
        apiName: "WebSettings.setOffscreenPreRaster",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setOffscreenPreRaster(boolean)")
  ])
  bool? offscreenPreRaster;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setSansSerifFontFamily",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setSansSerifFontFamily(java.lang.String)")
  ])
  String? sansSerifFontFamily;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setSerifFontFamily",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setSerifFontFamily(java.lang.String)")
  ])
  String? serifFontFamily;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setStandardFontFamily",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setStandardFontFamily(java.lang.String)")
  ])
  String? standardFontFamily;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setSaveFormData",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setSaveFormData(boolean)")
  ])
  bool? saveFormData;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "21",
        apiName: "CookieManager.setAcceptThirdPartyCookies",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/CookieManager#setAcceptThirdPartyCookies(android.webkit.WebView,%20boolean)")
  ])
  bool? thirdPartyCookiesEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebView.setLayerType",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebView#setLayerType(int,%20android.graphics.Paint)")
  ])
  bool? hardwareAcceleration;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettings.setSupportMultipleWindows",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebSettings?hl=en#setSupportMultipleWindows(boolean)")
  ])
  bool? supportMultipleWindows;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  String? regexToCancelSubFramesLoading;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        note:
            """It is recommended to use Hybrid Composition only on Android 10+ for a release app,
as it can cause framerate drops on animations in Android 9 and lower (see [Hybrid-Composition#performance](https://github.com/flutter/flutter/wiki/Hybrid-Composition#performance)).""")
  ])
  bool? useHybridComposition;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? useShouldInterceptRequest;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? useOnRenderProcessGone;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "View.setOverScrollMode",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setOverScrollMode(int)")
  ])
  OverScrollMode_? overScrollMode;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebView.setNetworkAvailable",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebView#setNetworkAvailable(boolean)")
  ])
  bool? networkAvailable;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebView.setScrollBarStyle",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebView#setScrollBarStyle(int)")
  ])
  ScrollBarStyle_? scrollBarStyle;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "View.setVerticalScrollbarPosition",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setVerticalScrollbarPosition(int)")
  ])
  VerticalScrollbarPosition_? verticalScrollbarPosition;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "View.setScrollBarDefaultDelayBeforeFade",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setScrollBarDefaultDelayBeforeFade(int)")
  ])
  int? scrollBarDefaultDelayBeforeFade;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "View.setScrollbarFadingEnabled",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setScrollbarFadingEnabled(boolean)")
  ])
  bool? scrollbarFadingEnabled;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "View.setScrollBarFadeDuration",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setScrollBarFadeDuration(int)")
  ])
  int? scrollBarFadeDuration;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebView.setRendererPriorityPolicy",
        apiUrl:
            "https://developer.android.com/reference/android/webkit/WebView#setRendererPriorityPolicy(int,%20boolean)")
  ])
  RendererPriorityPolicy_? rendererPriorityPolicy;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? disableDefaultErrorPage;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "29",
        apiName: "View.setVerticalScrollbarThumbDrawable",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setVerticalScrollbarThumbDrawable(android.graphics.drawable.Drawable)")
  ])
  Color_? verticalScrollbarThumbColor;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "29",
        apiName: "View.setVerticalScrollbarTrackDrawable",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setVerticalScrollbarTrackDrawable(android.graphics.drawable.Drawable)")
  ])
  Color_? verticalScrollbarTrackColor;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "29",
        apiName: "View.setHorizontalScrollbarThumbDrawable",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setHorizontalScrollbarThumbDrawable(android.graphics.drawable.Drawable)")
  ])
  Color_? horizontalScrollbarThumbColor;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "29",
        apiName: "View.setHorizontalScrollbarTrackDrawable",
        apiUrl:
            "https://developer.android.com/reference/android/view/View#setHorizontalScrollbarTrackDrawable(android.graphics.drawable.Drawable)")
  ])
  Color_? horizontalScrollbarTrackColor;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        available: "29",
        apiName: "WebSettingsCompat.setAlgorithmicDarkeningAllowed",
        apiUrl:
            "https://developer.android.com/reference/androidx/webkit/WebSettingsCompat#setAlgorithmicDarkeningAllowed(android.webkit.WebSettings,boolean)",
        note:
            "available on Android only if [WebViewFeature.ALGORITHMIC_DARKENING] feature is supported.")
  ])
  bool? algorithmicDarkeningAllowed;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  String? androidWebProfile;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        note:
            "available on Android only if [WebViewFeature.ENTERPRISE_AUTHENTICATION_APP_LINK_POLICY] feature is supported.")
  ])
  bool? enterpriseAuthenticationAppLinkPolicyEnabled;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  Uint8List? defaultVideoPoster;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(
        apiName: "WebSettingsCompat.setRequestedWithHeaderOriginAllowList",
        apiUrl:
            "https://developer.android.com/reference/androidx/webkit/WebSettingsCompat#setRequestedWithHeaderOriginAllowList(android.webkit.WebSettings,java.util.Set%3Cjava.lang.String%3E)",
        note:
            "available on Android only if [WebViewFeature.REQUESTED_WITH_HEADER_ALLOW_LIST] feature is supported.")
  ])
  Set<String>? requestedWithHeaderOriginAllowList;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? disallowOverScroll;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  bool? enableViewportScale;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWebViewConfiguration.suppressesIncrementalRendering",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1395663-suppressesincrementalrendering"),
    MacOSPlatform(
        apiName: "WKWebViewConfiguration.suppressesIncrementalRendering",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1395663-suppressesincrementalrendering")
  ])
  bool? suppressesIncrementalRendering;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWebViewConfiguration.allowsAirPlayForMediaPlayback",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1395673-allowsairplayformediaplayback"),
    MacOSPlatform(
        apiName: "WKWebViewConfiguration.allowsAirPlayForMediaPlayback",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1395673-allowsairplayformediaplayback")
  ])
  bool? allowsAirPlayForMediaPlayback;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWebView.allowsBackForwardNavigationGestures",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/1414995-allowsbackforwardnavigationgestu"),
    MacOSPlatform(
        apiName: "WKWebView.allowsBackForwardNavigationGestures",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/1414995-allowsbackforwardnavigationgestu")
  ])
  bool? allowsBackForwardNavigationGestures;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWebView.allowsLinkPreview",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/1415000-allowslinkpreview"),
    MacOSPlatform(
        apiName: "WKWebView.allowsLinkPreview",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/1415000-allowslinkpreview")
  ])
  bool? allowsLinkPreview;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWebViewConfiguration.ignoresViewportScaleLimits",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/2274633-ignoresviewportscalelimits")
  ])
  bool? ignoresViewportScaleLimits;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWebViewConfiguration.allowsInlineMediaPlayback",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1614793-allowsinlinemediaplayback")
  ])
  bool? allowsInlineMediaPlayback;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWebViewConfiguration.allowsPictureInPictureMediaPlayback",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1614792-allowspictureinpicturemediaplayb")
  ])
  bool? allowsPictureInPictureMediaPlayback;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "13.0",
        apiName: "WKPreferences.isFraudulentWebsiteWarningEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/3335219-isfraudulentwebsitewarningenable"),
    MacOSPlatform(
        available: "10.15",
        apiName: "WKPreferences.isFraudulentWebsiteWarningEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/3335219-isfraudulentwebsitewarningenable")
  ])
  bool? isFraudulentWebsiteWarningEnabled;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "WKWebViewConfiguration.selectionGranularity",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1614756-selectiongranularity")
  ])
  SelectionGranularity_? selectionGranularity;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "10",
        apiName: "WKWebViewConfiguration.dataDetectorTypes",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1641937-datadetectortypes")
  ])
  List<DataDetectorTypes_>? dataDetectorTypes;

  @SupportedPlatforms(platforms: [
    IOSPlatform(available: "11.0"),
    MacOSPlatform(available: "10.13")
  ])
  bool? sharedCookiesEnabled;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "13.0",
        apiName: "UIScrollView.automaticallyAdjustsScrollIndicatorInsets",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/3198043-automaticallyadjustsscrollindica")
  ])
  bool? automaticallyAdjustsScrollIndicatorInsets;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "11.0",
        apiName: "UIView.accessibilityIgnoresInvertColors",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiview/2865843-accessibilityignoresinvertcolors")
  ])
  bool? accessibilityIgnoresInvertColors;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "UIScrollView.decelerationRate",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619438-decelerationrate")
  ])
  ScrollViewDecelerationRate_? decelerationRate;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "UIScrollView.alwaysBounceVertical",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619383-alwaysbouncevertical")
  ])
  bool? alwaysBounceVertical;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "UIScrollView.alwaysBounceHorizontal",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619393-alwaysbouncehorizontal")
  ])
  bool? alwaysBounceHorizontal;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "UIScrollView.scrollsToTop",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619421-scrollstotop")
  ])
  bool? scrollsToTop;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "UIScrollView.isPagingEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619432-ispagingenabled")
  ])
  bool? isPagingEnabled;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "UIScrollView.maximumZoomScale",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619408-maximumzoomscale")
  ])
  double? maximumZoomScale;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "UIScrollView.minimumZoomScale",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619428-minimumzoomscale")
  ])
  double? minimumZoomScale;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "11.0",
        apiName: "UIScrollView.contentInsetAdjustmentBehavior",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/2902261-contentinsetadjustmentbehavior")
  ])
  ScrollViewContentInsetAdjustmentBehavior_? contentInsetAdjustmentBehavior;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        apiName: "UIScrollView.isDirectionalLockEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/uikit/uiscrollview/1619390-isdirectionallockenabled")
  ])
  bool? isDirectionalLockEnabled;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "14.0",
        apiName: "WKWebView.mediaType",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/3516410-mediatype"),
    MacOSPlatform(
        available: "11.0",
        apiName: "WKWebView.mediaType",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/3516410-mediatype")
  ])
  String? mediaType;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "14.0",
        apiName: "WKWebView.pageZoom",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/3516411-pagezoom"),
    MacOSPlatform(
        available: "11.0",
        apiName: "WKWebView.pageZoom",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/3516411-pagezoom")
  ])
  double? pageZoom;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "14.0",
        apiName: "WKWebViewConfiguration.limitsNavigationsToAppBoundDomains",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/3585117-limitsnavigationstoappbounddomai"),
    MacOSPlatform(
        available: "11.0",
        apiName: "WKWebViewConfiguration.limitsNavigationsToAppBoundDomains",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/3585117-limitsnavigationstoappbounddomai")
  ])
  bool? limitsNavigationsToAppBoundDomains;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  bool? useOnNavigationResponse;

  @SupportedPlatforms(platforms: [
    IOSPlatform(available: "13.0"),
    MacOSPlatform(available: "10.15")
  ])
  bool? applePayAPIEnabled;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  WebUri? allowingReadAccessTo;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? disableLongPressContextMenuOnLinks;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? disableInputAccessoryView;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "15.0",
        apiName: "WKWebView.underPageBackgroundColor",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/3850574-underpagebackgroundcolor"),
    MacOSPlatform(
        available: "12.0",
        apiName: "WKWebView.underPageBackgroundColor",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/3850574-underpagebackgroundcolor")
  ])
  Color_? underPageBackgroundColor;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "15.0",
        apiName: "WKPreferences.isTextInteractionEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/3727362-istextinteractionenabled"),
    MacOSPlatform(
        available: "11.3",
        apiName: "WKPreferences.isTextInteractionEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/3727362-istextinteractionenabled")
  ])
  bool? isTextInteractionEnabled;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "15.4",
        apiName: "WKPreferences.isSiteSpecificQuirksModeEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/3916069-issitespecificquirksmodeenabled"),
    MacOSPlatform(
        available: "12.3",
        apiName: "WKPreferences.isSiteSpecificQuirksModeEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/3916069-issitespecificquirksmodeenabled")
  ])
  bool? isSiteSpecificQuirksModeEnabled;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "15.0",
        apiName: "WKWebViewConfiguration.upgradeKnownHostsToHTTPS",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/3752243-upgradeknownhoststohttps"),
    MacOSPlatform(
        available: "11.3",
        apiName: "WKWebViewConfiguration.upgradeKnownHostsToHTTPS",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/3752243-upgradeknownhoststohttps")
  ])
  bool? upgradeKnownHostsToHTTPS;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "15.4",
        apiName: "WKPreferences.isElementFullscreenEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/3917769-iselementfullscreenenabled"),
    MacOSPlatform(
        available: "12.3",
        apiName: "WKPreferences.isElementFullscreenEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/3917769-iselementfullscreenenabled")
  ])
  bool? isElementFullscreenEnabled;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "16.0",
        apiName: "WKWebView.isFindInteractionEnabled",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/4002044-isfindinteractionenabled/")
  ])
  bool? isFindInteractionEnabled;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "15.5",
        apiName: "WKWebView.setMinimumViewportInset",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/3974127-setminimumviewportinset/")
  ])
  EdgeInsets? minimumViewportInset;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "15.5",
        apiName: "WKWebView.setMinimumViewportInset",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/3974127-setminimumviewportinset/")
  ])
  EdgeInsets? maximumViewportInset;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "16.4",
        apiName: "WKWebView.isInspectable",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/4111163-isinspectable"),
    MacOSPlatform(
        available: "13.3",
        apiName: "WKWebView.isInspectable",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkwebview/4111163-isinspectable"),
    WindowsPlatform(
        apiName: "ICoreWebView2Settings.put_AreDevToolsEnabled",
        apiUrl:
            "https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2settings?view=webview2-1.0.2210.55#put_aredevtoolsenabled")
  ])
  bool? isInspectable;

  @SupportedPlatforms(platforms: [
    IOSPlatform(
        available: "16.4",
        apiName: "WKWebView.shouldPrintBackgrounds",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/4104043-shouldprintbackgrounds"),
    MacOSPlatform(
        available: "13.3",
        apiName: "WKWebView.shouldPrintBackgrounds",
        apiUrl:
            "https://developer.apple.com/documentation/webkit/wkpreferences/4104043-shouldprintbackgrounds")
  ])
  bool? shouldPrintBackgrounds;

  @SupportedPlatforms(platforms: [
    WebPlatform(
        requiresSameOrigin: false,
        apiName: "iframe.allow",
        apiUrl:
            "https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-allow")
  ])
  String? iframeAllow;

  @SupportedPlatforms(platforms: [
    WebPlatform(
        requiresSameOrigin: false,
        apiName: "iframe.allowfullscreen",
        apiUrl:
            "https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-allowfullscreen")
  ])
  bool? iframeAllowFullscreen;

  @SupportedPlatforms(platforms: [
    WebPlatform(
        requiresSameOrigin: false,
        apiName: "iframe.sandbox",
        apiUrl:
            "https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-sandbox")
  ])
  Set<Sandbox_>? iframeSandbox;

  @SupportedPlatforms(platforms: [
    WebPlatform(
        requiresSameOrigin: false,
        apiName: "iframe.referrerpolicy",
        apiUrl:
            "https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-referrerpolicy")
  ])
  ReferrerPolicy_? iframeReferrerPolicy;

  @SupportedPlatforms(platforms: [
    WebPlatform(
        requiresSameOrigin: false,
        apiName: "iframe.name",
        apiUrl:
            "https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-name")
  ])
  String? iframeName;

  @SupportedPlatforms(platforms: [
    WebPlatform(
        requiresSameOrigin: false,
        apiName: "iframe.csp",
        apiUrl:
            "https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-csp")
  ])
  String? iframeCsp;

  @ExchangeableObjectConstructor()
  InAppWebViewSettings_({
    this.useShouldOverrideUrlLoading,
    this.useOnLoadResource,
    this.useOnDownloadStart,
    this.clearCache = false,
    this.userAgent = "",
    this.applicationNameForUserAgent = "",
    this.javaScriptEnabled = true,
    this.javaScriptCanOpenWindowsAutomatically = false,
    this.mediaPlaybackRequiresUserGesture = true,
    this.minimumFontSize,
    this.verticalScrollBarEnabled = true,
    this.horizontalScrollBarEnabled = true,
    this.resourceCustomSchemes = const [],
    this.contentBlockers = const [],
    this.preferredContentMode = UserPreferredContentMode_.RECOMMENDED,
    this.useShouldInterceptAjaxRequest,
    this.interceptOnlyAsyncAjaxRequests = true,
    this.useShouldInterceptFetchRequest,
    this.incognito = false,
    this.cacheEnabled = true,
    this.transparentBackground = false,
    this.disableVerticalScroll = false,
    this.disableHorizontalScroll = false,
    this.disableContextMenu = false,
    this.supportZoom = true,
    this.allowFileAccessFromFileURLs = false,
    this.allowUniversalAccessFromFileURLs = false,
    this.textZoom = 100,
    this.clearSessionCache = false,
    this.builtInZoomControls = true,
    this.displayZoomControls = false,
    this.databaseEnabled = true,
    this.domStorageEnabled = true,
    this.useWideViewPort = true,
    this.safeBrowsingEnabled = true,
    this.mixedContentMode,
    this.allowContentAccess = true,
    this.allowFileAccess = true,
    this.appCachePath,
    this.blockNetworkImage = false,
    this.blockNetworkLoads = false,
    this.cacheMode = CacheMode_.LOAD_DEFAULT,
    this.cursiveFontFamily = "cursive",
    this.defaultFixedFontSize = 16,
    this.defaultFontSize = 16,
    this.defaultTextEncodingName = "UTF-8",
    this.disabledActionModeMenuItems,
    this.fantasyFontFamily = "fantasy",
    this.fixedFontFamily = "monospace",
    this.forceDark = ForceDark_.OFF,
    this.forceDarkStrategy =
        ForceDarkStrategy_.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING,
    this.geolocationEnabled = true,
    this.layoutAlgorithm,
    this.loadWithOverviewMode = true,
    this.loadsImagesAutomatically = true,
    this.minimumLogicalFontSize = 8,
    this.needInitialFocus = true,
    this.offscreenPreRaster = false,
    this.sansSerifFontFamily = "sans-serif",
    this.serifFontFamily = "sans-serif",
    this.standardFontFamily = "sans-serif",
    this.saveFormData = true,
    this.thirdPartyCookiesEnabled = true,
    this.hardwareAcceleration = true,
    this.initialScale = 0,
    this.supportMultipleWindows = false,
    this.regexToCancelSubFramesLoading,
    this.useHybridComposition = true,
    this.androidWebProfile,
    this.useShouldInterceptRequest,
    this.useOnRenderProcessGone,
    this.overScrollMode = OverScrollMode_.IF_CONTENT_SCROLLS,
    this.networkAvailable,
    this.scrollBarStyle = ScrollBarStyle_.SCROLLBARS_INSIDE_OVERLAY,
    this.verticalScrollbarPosition =
        VerticalScrollbarPosition_.SCROLLBAR_POSITION_DEFAULT,
    this.scrollBarDefaultDelayBeforeFade,
    this.scrollbarFadingEnabled = true,
    this.scrollBarFadeDuration,
    this.rendererPriorityPolicy,
    this.disableDefaultErrorPage = false,
    this.verticalScrollbarThumbColor,
    this.verticalScrollbarTrackColor,
    this.horizontalScrollbarThumbColor,
    this.horizontalScrollbarTrackColor,
    this.algorithmicDarkeningAllowed = false,
    this.enterpriseAuthenticationAppLinkPolicyEnabled = true,
    this.defaultVideoPoster,
    this.requestedWithHeaderOriginAllowList,
    this.disallowOverScroll = false,
    this.enableViewportScale = false,
    this.suppressesIncrementalRendering = false,
    this.allowsAirPlayForMediaPlayback = true,
    this.allowsBackForwardNavigationGestures = true,
    this.allowsLinkPreview = true,
    this.ignoresViewportScaleLimits = false,
    this.allowsInlineMediaPlayback = false,
    this.allowsPictureInPictureMediaPlayback = true,
    this.isFraudulentWebsiteWarningEnabled = true,
    this.selectionGranularity = SelectionGranularity_.DYNAMIC,
    this.dataDetectorTypes = const [DataDetectorTypes_.NONE],
    this.sharedCookiesEnabled = false,
    this.automaticallyAdjustsScrollIndicatorInsets = false,
    this.accessibilityIgnoresInvertColors = false,
    this.decelerationRate = ScrollViewDecelerationRate_.NORMAL,
    this.alwaysBounceVertical = false,
    this.alwaysBounceHorizontal = false,
    this.scrollsToTop = true,
    this.isPagingEnabled = false,
    this.maximumZoomScale = 1.0,
    this.minimumZoomScale = 1.0,
    this.contentInsetAdjustmentBehavior =
        ScrollViewContentInsetAdjustmentBehavior_.NEVER,
    this.isDirectionalLockEnabled = false,
    this.mediaType,
    this.pageZoom = 1.0,
    this.limitsNavigationsToAppBoundDomains = false,
    this.useOnNavigationResponse,
    this.applePayAPIEnabled = false,
    this.allowingReadAccessTo,
    this.disableLongPressContextMenuOnLinks = false,
    this.disableInputAccessoryView = false,
    this.underPageBackgroundColor,
    this.isTextInteractionEnabled = true,
    this.isSiteSpecificQuirksModeEnabled = true,
    this.upgradeKnownHostsToHTTPS = true,
    this.isElementFullscreenEnabled = true,
    this.isFindInteractionEnabled = false,
    this.minimumViewportInset,
    this.maximumViewportInset,
    this.isInspectable = false,
    this.shouldPrintBackgrounds = false,
    this.allowBackgroundAudioPlaying = false,
    this.webViewAssetLoader,
    this.iframeAllow,
    this.iframeAllowFullscreen,
    this.iframeSandbox,
    this.iframeReferrerPolicy,
    this.iframeName,
    this.iframeCsp,
  }) {
    if (this.minimumFontSize == null)
      this.minimumFontSize = Util.isAndroid ? 8 : 0;
    assert(this.resourceCustomSchemes == null ||
        (this.resourceCustomSchemes != null &&
            !this.resourceCustomSchemes!.contains("http") &&
            !this.resourceCustomSchemes!.contains("https")));
    assert(
        allowingReadAccessTo == null || allowingReadAccessTo!.isScheme("file"));
    assert(
        (minimumViewportInset == null && maximumViewportInset == null) ||
            minimumViewportInset != null &&
                maximumViewportInset != null &&
                minimumViewportInset!.isNonNegative &&
                maximumViewportInset!.isNonNegative &&
                minimumViewportInset!.vertical <=
                    maximumViewportInset!.vertical &&
                minimumViewportInset!.horizontal <=
                    maximumViewportInset!.horizontal,
        "minimumViewportInset cannot be larger than maximumViewportInset");
  }
}

@Deprecated('Use InAppWebViewSettings instead')
class InAppWebViewGroupOptions {
  late InAppWebViewOptions crossPlatform;

  late AndroidInAppWebViewOptions android;

  late IOSInAppWebViewOptions ios;

  InAppWebViewGroupOptions(
      {InAppWebViewOptions? crossPlatform,
      AndroidInAppWebViewOptions? android,
      IOSInAppWebViewOptions? ios}) {
    this.crossPlatform = crossPlatform ?? InAppWebViewOptions();
    this.android = android ?? AndroidInAppWebViewOptions();
    this.ios = ios ?? IOSInAppWebViewOptions();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> options = {};
    options.addAll(this.crossPlatform.toMap());
    if (Util.isAndroid)
      options.addAll(this.android.toMap());
    else if (Util.isIOS) options.addAll(this.ios.toMap());

    return options;
  }

  static InAppWebViewGroupOptions fromMap(Map<String, dynamic> options) {
    InAppWebViewGroupOptions inAppWebViewGroupOptions =
        InAppWebViewGroupOptions();

    inAppWebViewGroupOptions.crossPlatform =
        InAppWebViewOptions.fromMap(options);
    if (Util.isAndroid)
      inAppWebViewGroupOptions.android =
          AndroidInAppWebViewOptions.fromMap(options);
    else if (Util.isIOS)
      inAppWebViewGroupOptions.ios = IOSInAppWebViewOptions.fromMap(options);

    return inAppWebViewGroupOptions;
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  InAppWebViewGroupOptions copy() {
    return InAppWebViewGroupOptions.fromMap(this.toMap());
  }
}

class WebViewOptions {
  Map<String, dynamic> toMap() {
    return {};
  }

  static WebViewOptions fromMap(Map<String, dynamic> map) {
    return WebViewOptions();
  }

  WebViewOptions copy() {
    return WebViewOptions.fromMap(this.toMap());
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

@Deprecated('Use InAppWebViewSettings instead')
class InAppWebViewOptions
    implements WebViewOptions, BrowserOptions, AndroidOptions, IosOptions {
  bool useShouldOverrideUrlLoading;

  bool useOnLoadResource;

  bool useOnDownloadStart;

  bool clearCache;

  String userAgent;

  String applicationNameForUserAgent;

  bool javaScriptEnabled;

  bool javaScriptCanOpenWindowsAutomatically;

  bool mediaPlaybackRequiresUserGesture;

  int? minimumFontSize;

  bool verticalScrollBarEnabled;

  bool horizontalScrollBarEnabled;

  List<String> resourceCustomSchemes;

  List<ContentBlocker> contentBlockers;

  UserPreferredContentMode? preferredContentMode;

  bool useShouldInterceptAjaxRequest;

  bool useShouldInterceptFetchRequest;

  bool incognito;

  bool cacheEnabled;

  bool transparentBackground;

  bool disableVerticalScroll;

  bool disableHorizontalScroll;

  bool disableContextMenu;

  bool supportZoom;

  bool allowFileAccessFromFileURLs;

  bool allowUniversalAccessFromFileURLs;

  InAppWebViewOptions(
      {this.useShouldOverrideUrlLoading = false,
      this.useOnLoadResource = false,
      this.useOnDownloadStart = false,
      this.clearCache = false,
      this.userAgent = "",
      this.applicationNameForUserAgent = "",
      this.javaScriptEnabled = true,
      this.javaScriptCanOpenWindowsAutomatically = false,
      this.mediaPlaybackRequiresUserGesture = true,
      this.minimumFontSize,
      this.verticalScrollBarEnabled = true,
      this.horizontalScrollBarEnabled = true,
      this.resourceCustomSchemes = const [],
      this.contentBlockers = const [],
      this.preferredContentMode = UserPreferredContentMode.RECOMMENDED,
      this.useShouldInterceptAjaxRequest = false,
      this.useShouldInterceptFetchRequest = false,
      this.incognito = false,
      this.cacheEnabled = true,
      this.transparentBackground = false,
      this.disableVerticalScroll = false,
      this.disableHorizontalScroll = false,
      this.disableContextMenu = false,
      this.supportZoom = true,
      this.allowFileAccessFromFileURLs = false,
      this.allowUniversalAccessFromFileURLs = false}) {
    if (this.minimumFontSize == null)
      this.minimumFontSize = Util.isAndroid ? 8 : 0;
    assert(!this.resourceCustomSchemes.contains("http") &&
        !this.resourceCustomSchemes.contains("https"));
  }

  @override
  Map<String, dynamic> toMap() {
    List<Map<String, Map<String, dynamic>>> contentBlockersMapList = [];
    contentBlockers.forEach((contentBlocker) {
      contentBlockersMapList.add(contentBlocker.toMap());
    });

    return {
      "useShouldOverrideUrlLoading": useShouldOverrideUrlLoading,
      "useOnLoadResource": useOnLoadResource,
      "useOnDownloadStart": useOnDownloadStart,
      "clearCache": clearCache,
      "userAgent": userAgent,
      "applicationNameForUserAgent": applicationNameForUserAgent,
      "javaScriptEnabled": javaScriptEnabled,
      "javaScriptCanOpenWindowsAutomatically":
          javaScriptCanOpenWindowsAutomatically,
      "mediaPlaybackRequiresUserGesture": mediaPlaybackRequiresUserGesture,
      "verticalScrollBarEnabled": verticalScrollBarEnabled,
      "horizontalScrollBarEnabled": horizontalScrollBarEnabled,
      "resourceCustomSchemes": resourceCustomSchemes,
      "contentBlockers": contentBlockersMapList,
      "preferredContentMode": preferredContentMode?.toNativeValue(),
      "useShouldInterceptAjaxRequest": useShouldInterceptAjaxRequest,
      "useShouldInterceptFetchRequest": useShouldInterceptFetchRequest,
      "incognito": incognito,
      "cacheEnabled": cacheEnabled,
      "transparentBackground": transparentBackground,
      "disableVerticalScroll": disableVerticalScroll,
      "disableHorizontalScroll": disableHorizontalScroll,
      "disableContextMenu": disableContextMenu,
      "supportZoom": supportZoom,
      "allowFileAccessFromFileURLs": allowFileAccessFromFileURLs,
      "allowUniversalAccessFromFileURLs": allowUniversalAccessFromFileURLs
    };
  }

  static InAppWebViewOptions fromMap(Map<String, dynamic> map) {
    List<ContentBlocker> contentBlockers = [];
    List<dynamic>? contentBlockersMapList = map["contentBlockers"];
    if (contentBlockersMapList != null) {
      contentBlockersMapList.forEach((contentBlocker) {
        contentBlockers.add(ContentBlocker.fromMap(
            Map<String, Map<String, dynamic>>.from(
                Map<String, dynamic>.from(contentBlocker))));
      });
    }

    var instance = InAppWebViewOptions();
    instance.useShouldOverrideUrlLoading = map["useShouldOverrideUrlLoading"];
    instance.useOnLoadResource = map["useOnLoadResource"];
    instance.useOnDownloadStart = map["useOnDownloadStart"];
    instance.clearCache = map["clearCache"];
    instance.userAgent = map["userAgent"];
    instance.applicationNameForUserAgent = map["applicationNameForUserAgent"];
    instance.javaScriptEnabled = map["javaScriptEnabled"];
    instance.javaScriptCanOpenWindowsAutomatically =
        map["javaScriptCanOpenWindowsAutomatically"];
    instance.mediaPlaybackRequiresUserGesture =
        map["mediaPlaybackRequiresUserGesture"];
    instance.verticalScrollBarEnabled = map["verticalScrollBarEnabled"];
    instance.horizontalScrollBarEnabled = map["horizontalScrollBarEnabled"];
    instance.resourceCustomSchemes =
        List<String>.from(map["resourceCustomSchemes"] ?? []);
    instance.contentBlockers = contentBlockers;
    instance.preferredContentMode =
        UserPreferredContentMode.fromNativeValue(map["preferredContentMode"]);
    instance.useShouldInterceptAjaxRequest =
        map["useShouldInterceptAjaxRequest"];
    instance.useShouldInterceptFetchRequest =
        map["useShouldInterceptFetchRequest"];
    instance.incognito = map["incognito"];
    instance.cacheEnabled = map["cacheEnabled"];
    instance.transparentBackground = map["transparentBackground"];
    instance.disableVerticalScroll = map["disableVerticalScroll"];
    instance.disableHorizontalScroll = map["disableHorizontalScroll"];
    instance.disableContextMenu = map["disableContextMenu"];
    instance.supportZoom = map["supportZoom"];
    instance.allowFileAccessFromFileURLs = map["allowFileAccessFromFileURLs"];
    instance.allowUniversalAccessFromFileURLs =
        map["allowUniversalAccessFromFileURLs"];
    return instance;
  }

  @override
  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  InAppWebViewOptions copy() {
    return InAppWebViewOptions.fromMap(this.toMap());
  }
}
