import 'dart:ui';

import '../../util.dart';
import '../../types/main.dart';
import '../../in_app_browser/in_app_browser_settings.dart';
import '../in_app_webview_settings.dart';

class AndroidOptions {}

@Deprecated('Use InAppWebViewSettings instead')
class AndroidInAppWebViewOptions
    implements WebViewOptions, BrowserOptions, AndroidOptions {
  int textZoom;

  bool clearSessionCache;

  bool builtInZoomControls;

  bool displayZoomControls;

  bool databaseEnabled;

  bool domStorageEnabled;

  bool useWideViewPort;

  bool safeBrowsingEnabled;

  AndroidMixedContentMode? mixedContentMode;

  bool allowContentAccess;

  bool allowFileAccess;

  String? appCachePath;

  bool blockNetworkImage;

  bool blockNetworkLoads;

  AndroidCacheMode? cacheMode;

  String cursiveFontFamily;

  int defaultFixedFontSize;

  int defaultFontSize;

  String defaultTextEncodingName;

  AndroidActionModeMenuItem? disabledActionModeMenuItems;

  String fantasyFontFamily;

  String fixedFontFamily;

  AndroidForceDark? forceDark;

  bool geolocationEnabled;

  AndroidLayoutAlgorithm? layoutAlgorithm;

  bool loadWithOverviewMode;

  bool loadsImagesAutomatically;

  int minimumLogicalFontSize;

  int initialScale;

  bool needInitialFocus;

  bool offscreenPreRaster;

  String sansSerifFontFamily;

  String serifFontFamily;

  String standardFontFamily;

  bool saveFormData;

  bool thirdPartyCookiesEnabled;

  bool hardwareAcceleration;

  bool supportMultipleWindows;

  String? regexToCancelSubFramesLoading;

  bool useHybridComposition;

  bool useShouldInterceptRequest;

  bool useOnRenderProcessGone;

  AndroidOverScrollMode? overScrollMode;

  bool? networkAvailable;

  AndroidScrollBarStyle? scrollBarStyle;

  AndroidVerticalScrollbarPosition? verticalScrollbarPosition;

  int? scrollBarDefaultDelayBeforeFade;

  bool scrollbarFadingEnabled;

  int? scrollBarFadeDuration;

  RendererPriorityPolicy? rendererPriorityPolicy;

  bool disableDefaultErrorPage;

  Color? verticalScrollbarThumbColor;

  Color? verticalScrollbarTrackColor;

  Color? horizontalScrollbarThumbColor;

  Color? horizontalScrollbarTrackColor;

  AndroidInAppWebViewOptions({
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
    this.cacheMode = AndroidCacheMode.LOAD_DEFAULT,
    this.cursiveFontFamily = "cursive",
    this.defaultFixedFontSize = 16,
    this.defaultFontSize = 16,
    this.defaultTextEncodingName = "UTF-8",
    this.disabledActionModeMenuItems,
    this.fantasyFontFamily = "fantasy",
    this.fixedFontFamily = "monospace",
    this.forceDark = AndroidForceDark.FORCE_DARK_OFF,
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
    this.useShouldInterceptRequest = false,
    this.useOnRenderProcessGone = false,
    this.overScrollMode = AndroidOverScrollMode.OVER_SCROLL_IF_CONTENT_SCROLLS,
    this.networkAvailable,
    this.scrollBarStyle = AndroidScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY,
    this.verticalScrollbarPosition =
        AndroidVerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT,
    this.scrollBarDefaultDelayBeforeFade,
    this.scrollbarFadingEnabled = true,
    this.scrollBarFadeDuration,
    this.rendererPriorityPolicy,
    this.disableDefaultErrorPage = false,
    this.verticalScrollbarThumbColor,
    this.verticalScrollbarTrackColor,
    this.horizontalScrollbarThumbColor,
    this.horizontalScrollbarTrackColor,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "textZoom": textZoom,
      "clearSessionCache": clearSessionCache,
      "builtInZoomControls": builtInZoomControls,
      "displayZoomControls": displayZoomControls,
      "databaseEnabled": databaseEnabled,
      "domStorageEnabled": domStorageEnabled,
      "useWideViewPort": useWideViewPort,
      "safeBrowsingEnabled": safeBrowsingEnabled,
      "mixedContentMode": mixedContentMode?.toNativeValue(),
      "allowContentAccess": allowContentAccess,
      "allowFileAccess": allowFileAccess,
      "appCachePath": appCachePath,
      "blockNetworkImage": blockNetworkImage,
      "blockNetworkLoads": blockNetworkLoads,
      "cacheMode": cacheMode?.toNativeValue(),
      "cursiveFontFamily": cursiveFontFamily,
      "defaultFixedFontSize": defaultFixedFontSize,
      "defaultFontSize": defaultFontSize,
      "defaultTextEncodingName": defaultTextEncodingName,
      "disabledActionModeMenuItems":
          disabledActionModeMenuItems?.toNativeValue(),
      "fantasyFontFamily": fantasyFontFamily,
      "fixedFontFamily": fixedFontFamily,
      "forceDark": forceDark?.toNativeValue(),
      "geolocationEnabled": geolocationEnabled,
      "layoutAlgorithm": layoutAlgorithm?.toNativeValue(),
      "loadWithOverviewMode": loadWithOverviewMode,
      "loadsImagesAutomatically": loadsImagesAutomatically,
      "minimumLogicalFontSize": minimumLogicalFontSize,
      "initialScale": initialScale,
      "needInitialFocus": needInitialFocus,
      "offscreenPreRaster": offscreenPreRaster,
      "sansSerifFontFamily": sansSerifFontFamily,
      "serifFontFamily": serifFontFamily,
      "standardFontFamily": standardFontFamily,
      "saveFormData": saveFormData,
      "thirdPartyCookiesEnabled": thirdPartyCookiesEnabled,
      "hardwareAcceleration": hardwareAcceleration,
      "supportMultipleWindows": supportMultipleWindows,
      "useHybridComposition": useHybridComposition,
      "regexToCancelSubFramesLoading": regexToCancelSubFramesLoading,
      "useShouldInterceptRequest": useShouldInterceptRequest,
      "useOnRenderProcessGone": useOnRenderProcessGone,
      "overScrollMode": overScrollMode?.toNativeValue(),
      "networkAvailable": networkAvailable,
      "scrollBarStyle": scrollBarStyle?.toNativeValue(),
      "verticalScrollbarPosition": verticalScrollbarPosition?.toNativeValue(),
      "scrollBarDefaultDelayBeforeFade": scrollBarDefaultDelayBeforeFade,
      "scrollbarFadingEnabled": scrollbarFadingEnabled,
      "scrollBarFadeDuration": scrollBarFadeDuration,
      "rendererPriorityPolicy": rendererPriorityPolicy?.toMap(),
      "disableDefaultErrorPage": disableDefaultErrorPage,
      "verticalScrollbarThumbColor": verticalScrollbarThumbColor?.toHex(),
      "verticalScrollbarTrackColor": verticalScrollbarTrackColor?.toHex(),
      "horizontalScrollbarThumbColor": horizontalScrollbarThumbColor?.toHex(),
      "horizontalScrollbarTrackColor": horizontalScrollbarTrackColor?.toHex(),
    };
  }

  static AndroidInAppWebViewOptions fromMap(Map<String, dynamic> map) {
    var instance = AndroidInAppWebViewOptions();
    instance.textZoom = map["textZoom"];
    instance.clearSessionCache = map["clearSessionCache"];
    instance.builtInZoomControls = map["builtInZoomControls"];
    instance.displayZoomControls = map["displayZoomControls"];
    instance.databaseEnabled = map["databaseEnabled"];
    instance.domStorageEnabled = map["domStorageEnabled"];
    instance.useWideViewPort = map["useWideViewPort"];
    instance.safeBrowsingEnabled = map["safeBrowsingEnabled"];
    instance.mixedContentMode =
        AndroidMixedContentMode.fromNativeValue(map["mixedContentMode"]);
    instance.allowContentAccess = map["allowContentAccess"];
    instance.allowFileAccess = map["allowFileAccess"];
    instance.appCachePath = map["appCachePath"];
    instance.blockNetworkImage = map["blockNetworkImage"];
    instance.blockNetworkLoads = map["blockNetworkLoads"];
    instance.cacheMode = AndroidCacheMode.fromNativeValue(map["cacheMode"]);
    instance.cursiveFontFamily = map["cursiveFontFamily"];
    instance.defaultFixedFontSize = map["defaultFixedFontSize"];
    instance.defaultFontSize = map["defaultFontSize"];
    instance.defaultTextEncodingName = map["defaultTextEncodingName"];
    instance.disabledActionModeMenuItems =
        AndroidActionModeMenuItem.fromNativeValue(
            map["disabledActionModeMenuItems"]);
    instance.fantasyFontFamily = map["fantasyFontFamily"];
    instance.fixedFontFamily = map["fixedFontFamily"];
    instance.forceDark = AndroidForceDark.fromNativeValue(map["forceDark"]);
    instance.geolocationEnabled = map["geolocationEnabled"];
    instance.layoutAlgorithm =
        AndroidLayoutAlgorithm.fromNativeValue(map["layoutAlgorithm"]);
    instance.loadWithOverviewMode = map["loadWithOverviewMode"];
    instance.loadsImagesAutomatically = map["loadsImagesAutomatically"];
    instance.minimumLogicalFontSize = map["minimumLogicalFontSize"];
    instance.initialScale = map["initialScale"];
    instance.needInitialFocus = map["needInitialFocus"];
    instance.offscreenPreRaster = map["offscreenPreRaster"];
    instance.sansSerifFontFamily = map["sansSerifFontFamily"];
    instance.serifFontFamily = map["serifFontFamily"];
    instance.standardFontFamily = map["standardFontFamily"];
    instance.saveFormData = map["saveFormData"];
    instance.thirdPartyCookiesEnabled = map["thirdPartyCookiesEnabled"];
    instance.hardwareAcceleration = map["hardwareAcceleration"];
    instance.supportMultipleWindows = map["supportMultipleWindows"];
    instance.regexToCancelSubFramesLoading =
        map["regexToCancelSubFramesLoading"];
    instance.useHybridComposition = map["useHybridComposition"];
    instance.useShouldInterceptRequest = map["useShouldInterceptRequest"];
    instance.useOnRenderProcessGone = map["useOnRenderProcessGone"];
    instance.overScrollMode =
        AndroidOverScrollMode.fromNativeValue(map["overScrollMode"]);
    instance.networkAvailable = map["networkAvailable"];
    instance.scrollBarStyle =
        AndroidScrollBarStyle.fromNativeValue(map["scrollBarStyle"]);
    instance.verticalScrollbarPosition =
        AndroidVerticalScrollbarPosition.fromNativeValue(
            map["verticalScrollbarPosition"]);
    instance.scrollBarDefaultDelayBeforeFade =
        map["scrollBarDefaultDelayBeforeFade"];
    instance.scrollbarFadingEnabled = map["scrollbarFadingEnabled"];
    instance.scrollBarFadeDuration = map["scrollBarFadeDuration"];
    instance.rendererPriorityPolicy = RendererPriorityPolicy.fromMap(
        map["rendererPriorityPolicy"]?.cast<String, dynamic>());
    instance.disableDefaultErrorPage = map["disableDefaultErrorPage"];
    instance.verticalScrollbarThumbColor =
        UtilColor.fromHex(map["verticalScrollbarThumbColor"]);
    instance.verticalScrollbarTrackColor =
        UtilColor.fromHex(map["verticalScrollbarTrackColor"]);
    instance.horizontalScrollbarThumbColor =
        UtilColor.fromHex(map["horizontalScrollbarThumbColor"]);
    instance.horizontalScrollbarTrackColor =
        UtilColor.fromHex(map["horizontalScrollbarTrackColor"]);
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
  AndroidInAppWebViewOptions copy() {
    return AndroidInAppWebViewOptions.fromMap(this.toMap());
  }
}
