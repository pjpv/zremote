
part of 'in_app_webview_settings.dart';

class InAppWebViewSettings {
  bool? accessibilityIgnoresInvertColors;

  bool? algorithmicDarkeningAllowed;

  bool? allowBackgroundAudioPlaying;

  bool? allowContentAccess;

  bool? allowFileAccess;

  bool? allowFileAccessFromFileURLs;

  bool? allowUniversalAccessFromFileURLs;

  WebUri? allowingReadAccessTo;

  bool? allowsAirPlayForMediaPlayback;

  bool? allowsBackForwardNavigationGestures;

  bool? allowsInlineMediaPlayback;

  bool? allowsLinkPreview;

  bool? allowsPictureInPictureMediaPlayback;

  bool? alwaysBounceHorizontal;

  bool? alwaysBounceVertical;

  String? androidWebProfile;

  String? appCachePath;

  bool? applePayAPIEnabled;

  String? applicationNameForUserAgent;

  bool? automaticallyAdjustsScrollIndicatorInsets;

  bool? blockNetworkImage;

  bool? blockNetworkLoads;

  bool? builtInZoomControls;

  bool? cacheEnabled;

  CacheMode? cacheMode;

  @Deprecated('Use InAppWebViewController.clearAllCache instead')
  bool? clearCache;

  @Deprecated('Use CookieManager.removeSessionCookies instead')
  bool? clearSessionCache;

  List<ContentBlocker>? contentBlockers;

  ScrollViewContentInsetAdjustmentBehavior? contentInsetAdjustmentBehavior;

  String? cursiveFontFamily;

  List<DataDetectorTypes>? dataDetectorTypes;

  bool? databaseEnabled;

  ScrollViewDecelerationRate? decelerationRate;

  int? defaultFixedFontSize;

  int? defaultFontSize;

  String? defaultTextEncodingName;

  Uint8List? defaultVideoPoster;

  bool? disableContextMenu;

  bool? disableDefaultErrorPage;

  bool? disableHorizontalScroll;

  bool? disableInputAccessoryView;

  bool? disableLongPressContextMenuOnLinks;

  bool? disableVerticalScroll;

  ActionModeMenuItem? disabledActionModeMenuItems;

  bool? disallowOverScroll;

  bool? displayZoomControls;

  bool? domStorageEnabled;

  bool? enableViewportScale;

  bool? enterpriseAuthenticationAppLinkPolicyEnabled;

  String? fantasyFontFamily;

  String? fixedFontFamily;

  ForceDark? forceDark;

  ForceDarkStrategy? forceDarkStrategy;

  bool? geolocationEnabled;

  bool? hardwareAcceleration;

  bool? horizontalScrollBarEnabled;

  Color? horizontalScrollbarThumbColor;

  Color? horizontalScrollbarTrackColor;

  String? iframeAllow;

  bool? iframeAllowFullscreen;

  String? iframeCsp;

  String? iframeName;

  ReferrerPolicy? iframeReferrerPolicy;

  Set<Sandbox>? iframeSandbox;

  bool? ignoresViewportScaleLimits;

  bool? incognito;

  int? initialScale;

  bool? interceptOnlyAsyncAjaxRequests;

  bool? isDirectionalLockEnabled;

  bool? isElementFullscreenEnabled;

  bool? isFindInteractionEnabled;

  bool? isFraudulentWebsiteWarningEnabled;

  bool? isInspectable;

  bool? isPagingEnabled;

  bool? isSiteSpecificQuirksModeEnabled;

  bool? isTextInteractionEnabled;

  bool? javaScriptCanOpenWindowsAutomatically;

  bool? javaScriptEnabled;

  LayoutAlgorithm? layoutAlgorithm;

  bool? limitsNavigationsToAppBoundDomains;

  bool? loadWithOverviewMode;

  bool? loadsImagesAutomatically;

  EdgeInsets? maximumViewportInset;

  double? maximumZoomScale;

  bool? mediaPlaybackRequiresUserGesture;

  String? mediaType;

  int? minimumFontSize;

  int? minimumLogicalFontSize;

  EdgeInsets? minimumViewportInset;

  double? minimumZoomScale;

  MixedContentMode? mixedContentMode;

  bool? needInitialFocus;

  bool? networkAvailable;

  bool? offscreenPreRaster;

  OverScrollMode? overScrollMode;

  double? pageZoom;

  UserPreferredContentMode? preferredContentMode;

  String? regexToCancelSubFramesLoading;

  RendererPriorityPolicy? rendererPriorityPolicy;

  Set<String>? requestedWithHeaderOriginAllowList;

  List<String>? resourceCustomSchemes;

  bool? safeBrowsingEnabled;

  String? sansSerifFontFamily;

  bool? saveFormData;

  int? scrollBarDefaultDelayBeforeFade;

  int? scrollBarFadeDuration;

  ScrollBarStyle? scrollBarStyle;

  bool? scrollbarFadingEnabled;

  bool? scrollsToTop;

  SelectionGranularity? selectionGranularity;

  String? serifFontFamily;

  bool? sharedCookiesEnabled;

  bool? shouldPrintBackgrounds;

  String? standardFontFamily;

  bool? supportMultipleWindows;

  bool? supportZoom;

  bool? suppressesIncrementalRendering;

  int? textZoom;

  bool? thirdPartyCookiesEnabled;

  bool? transparentBackground;

  Color? underPageBackgroundColor;

  bool? upgradeKnownHostsToHTTPS;

  bool? useHybridComposition;

  bool? useOnDownloadStart;

  bool? useOnLoadResource;

  bool? useOnNavigationResponse;

  bool? useOnRenderProcessGone;

  bool? useShouldInterceptAjaxRequest;

  bool? useShouldInterceptFetchRequest;

  bool? useShouldInterceptRequest;

  bool? useShouldOverrideUrlLoading;

  bool? useWideViewPort;

  String? userAgent;

  bool? verticalScrollBarEnabled;

  VerticalScrollbarPosition? verticalScrollbarPosition;

  Color? verticalScrollbarThumbColor;

  Color? verticalScrollbarTrackColor;

  WebViewAssetLoader? webViewAssetLoader;
  InAppWebViewSettings(
      {this.useShouldOverrideUrlLoading,
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
      this.preferredContentMode = UserPreferredContentMode.RECOMMENDED,
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
      this.cacheMode = CacheMode.LOAD_DEFAULT,
      this.cursiveFontFamily = "cursive",
      this.defaultFixedFontSize = 16,
      this.defaultFontSize = 16,
      this.defaultTextEncodingName = "UTF-8",
      this.disabledActionModeMenuItems,
      this.fantasyFontFamily = "fantasy",
      this.fixedFontFamily = "monospace",
      this.forceDark = ForceDark.OFF,
      this.forceDarkStrategy =
          ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING,
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
      this.useShouldInterceptRequest,
      this.useOnRenderProcessGone,
      this.overScrollMode = OverScrollMode.IF_CONTENT_SCROLLS,
      this.networkAvailable,
      this.scrollBarStyle = ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY,
      this.verticalScrollbarPosition =
          VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT,
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
      this.selectionGranularity = SelectionGranularity.DYNAMIC,
      this.dataDetectorTypes = const [DataDetectorTypes.NONE],
      this.sharedCookiesEnabled = false,
      this.automaticallyAdjustsScrollIndicatorInsets = false,
      this.accessibilityIgnoresInvertColors = false,
      this.decelerationRate = ScrollViewDecelerationRate.NORMAL,
      this.alwaysBounceVertical = false,
      this.androidWebProfile,
      this.alwaysBounceHorizontal = false,
      this.scrollsToTop = true,
      this.isPagingEnabled = false,
      this.maximumZoomScale = 1.0,
      this.minimumZoomScale = 1.0,
      this.contentInsetAdjustmentBehavior =
          ScrollViewContentInsetAdjustmentBehavior.NEVER,
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
      this.iframeCsp}) {
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

  static InAppWebViewSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = InAppWebViewSettings(
      allowingReadAccessTo: map['allowingReadAccessTo'] != null
          ? WebUri(map['allowingReadAccessTo'])
          : null,
      appCachePath: map['appCachePath'],
      defaultVideoPoster: map['defaultVideoPoster'] != null
          ? Uint8List.fromList(map['defaultVideoPoster'].cast<int>())
          : null,
      disabledActionModeMenuItems: ActionModeMenuItem.fromNativeValue(
          map['disabledActionModeMenuItems']),
      horizontalScrollbarThumbColor:
          map['horizontalScrollbarThumbColor'] != null
              ? UtilColor.fromStringRepresentation(
                  map['horizontalScrollbarThumbColor'])
              : null,
      horizontalScrollbarTrackColor:
          map['horizontalScrollbarTrackColor'] != null
              ? UtilColor.fromStringRepresentation(
                  map['horizontalScrollbarTrackColor'])
              : null,
      iframeAllow: map['iframeAllow'],
      iframeAllowFullscreen: map['iframeAllowFullscreen'],
      iframeCsp: map['iframeCsp'],
      iframeName: map['iframeName'],
      iframeReferrerPolicy:
          ReferrerPolicy.fromNativeValue(map['iframeReferrerPolicy']),
      iframeSandbox: map['iframeSandbox'] != null
          ? Set<Sandbox>.from(
              map['iframeSandbox'].map((e) => Sandbox.fromNativeValue(e)!))
          : null,
      layoutAlgorithm: LayoutAlgorithm.fromNativeValue(map['layoutAlgorithm']),
      maximumViewportInset: MapEdgeInsets.fromMap(
          map['maximumViewportInset']?.cast<String, dynamic>()),
      mediaType: map['mediaType'],
      minimumFontSize: map['minimumFontSize'],
      minimumViewportInset: MapEdgeInsets.fromMap(
          map['minimumViewportInset']?.cast<String, dynamic>()),
      mixedContentMode:
          MixedContentMode.fromNativeValue(map['mixedContentMode']),
      networkAvailable: map['networkAvailable'],
      regexToCancelSubFramesLoading: map['regexToCancelSubFramesLoading'],
      rendererPriorityPolicy: RendererPriorityPolicy.fromMap(
          map['rendererPriorityPolicy']?.cast<String, dynamic>()),
      requestedWithHeaderOriginAllowList:
          map['requestedWithHeaderOriginAllowList'] != null
              ? Set<String>.from(
                  map['requestedWithHeaderOriginAllowList']!.cast<String>())
              : null,
      scrollBarDefaultDelayBeforeFade: map['scrollBarDefaultDelayBeforeFade'],
      scrollBarFadeDuration: map['scrollBarFadeDuration'],
      underPageBackgroundColor: map['underPageBackgroundColor'] != null
          ? UtilColor.fromStringRepresentation(map['underPageBackgroundColor'])
          : null,
      useOnDownloadStart: map['useOnDownloadStart'],
      useOnLoadResource: map['useOnLoadResource'],
      useOnNavigationResponse: map['useOnNavigationResponse'],
      useOnRenderProcessGone: map['useOnRenderProcessGone'],
      useShouldInterceptAjaxRequest: map['useShouldInterceptAjaxRequest'],
      useShouldInterceptFetchRequest: map['useShouldInterceptFetchRequest'],
      useShouldInterceptRequest: map['useShouldInterceptRequest'],
      useShouldOverrideUrlLoading: map['useShouldOverrideUrlLoading'],
      verticalScrollbarThumbColor: map['verticalScrollbarThumbColor'] != null
          ? UtilColor.fromStringRepresentation(
              map['verticalScrollbarThumbColor'])
          : null,
      verticalScrollbarTrackColor: map['verticalScrollbarTrackColor'] != null
          ? UtilColor.fromStringRepresentation(
              map['verticalScrollbarTrackColor'])
          : null,
      webViewAssetLoader: WebViewAssetLoader.fromMap(
          map['webViewAssetLoader']?.cast<String, dynamic>()),
    );
    instance.accessibilityIgnoresInvertColors =
        map['accessibilityIgnoresInvertColors'];
    instance.algorithmicDarkeningAllowed = map['algorithmicDarkeningAllowed'];
    instance.allowBackgroundAudioPlaying = map['allowBackgroundAudioPlaying'];
    instance.allowContentAccess = map['allowContentAccess'];
    instance.allowFileAccess = map['allowFileAccess'];
    instance.allowFileAccessFromFileURLs = map['allowFileAccessFromFileURLs'];
    instance.allowUniversalAccessFromFileURLs =
        map['allowUniversalAccessFromFileURLs'];
    instance.allowsAirPlayForMediaPlayback =
        map['allowsAirPlayForMediaPlayback'];
    instance.allowsBackForwardNavigationGestures =
        map['allowsBackForwardNavigationGestures'];
    instance.allowsInlineMediaPlayback = map['allowsInlineMediaPlayback'];
    instance.allowsLinkPreview = map['allowsLinkPreview'];
    instance.allowsPictureInPictureMediaPlayback =
        map['allowsPictureInPictureMediaPlayback'];
    instance.alwaysBounceHorizontal = map['alwaysBounceHorizontal'];
    instance.alwaysBounceVertical = map['alwaysBounceVertical'];
    instance.androidWebProfile = map['androidWebProfile'];
    instance.applePayAPIEnabled = map['applePayAPIEnabled'];
    instance.applicationNameForUserAgent = map['applicationNameForUserAgent'];
    instance.automaticallyAdjustsScrollIndicatorInsets =
        map['automaticallyAdjustsScrollIndicatorInsets'];
    instance.blockNetworkImage = map['blockNetworkImage'];
    instance.blockNetworkLoads = map['blockNetworkLoads'];
    instance.builtInZoomControls = map['builtInZoomControls'];
    instance.cacheEnabled = map['cacheEnabled'];
    instance.cacheMode = CacheMode.fromNativeValue(map['cacheMode']);
    instance.clearCache = map['InAppWebViewController.clearAllCache'];
    instance.clearSessionCache = map['CookieManager.removeSessionCookies'];
    instance.contentBlockers =
        _deserializeContentBlockers(map['contentBlockers']);
    instance.contentInsetAdjustmentBehavior =
        ScrollViewContentInsetAdjustmentBehavior.fromNativeValue(
            map['contentInsetAdjustmentBehavior']);
    instance.cursiveFontFamily = map['cursiveFontFamily'];
    instance.dataDetectorTypes = map['dataDetectorTypes'] != null
        ? List<DataDetectorTypes>.from(map['dataDetectorTypes']
            .map((e) => DataDetectorTypes.fromNativeValue(e)!))
        : null;
    instance.databaseEnabled = map['databaseEnabled'];
    instance.decelerationRate =
        ScrollViewDecelerationRate.fromNativeValue(map['decelerationRate']);
    instance.defaultFixedFontSize = map['defaultFixedFontSize'];
    instance.defaultFontSize = map['defaultFontSize'];
    instance.defaultTextEncodingName = map['defaultTextEncodingName'];
    instance.disableContextMenu = map['disableContextMenu'];
    instance.disableDefaultErrorPage = map['disableDefaultErrorPage'];
    instance.disableHorizontalScroll = map['disableHorizontalScroll'];
    instance.disableInputAccessoryView = map['disableInputAccessoryView'];
    instance.disableLongPressContextMenuOnLinks =
        map['disableLongPressContextMenuOnLinks'];
    instance.disableVerticalScroll = map['disableVerticalScroll'];
    instance.disallowOverScroll = map['disallowOverScroll'];
    instance.displayZoomControls = map['displayZoomControls'];
    instance.domStorageEnabled = map['domStorageEnabled'];
    instance.enableViewportScale = map['enableViewportScale'];
    instance.enterpriseAuthenticationAppLinkPolicyEnabled =
        map['enterpriseAuthenticationAppLinkPolicyEnabled'];
    instance.fantasyFontFamily = map['fantasyFontFamily'];
    instance.fixedFontFamily = map['fixedFontFamily'];
    instance.forceDark = ForceDark.fromNativeValue(map['forceDark']);
    instance.forceDarkStrategy =
        ForceDarkStrategy.fromNativeValue(map['forceDarkStrategy']);
    instance.geolocationEnabled = map['geolocationEnabled'];
    instance.hardwareAcceleration = map['hardwareAcceleration'];
    instance.horizontalScrollBarEnabled = map['horizontalScrollBarEnabled'];
    instance.ignoresViewportScaleLimits = map['ignoresViewportScaleLimits'];
    instance.incognito = map['incognito'];
    instance.initialScale = map['initialScale'];
    instance.interceptOnlyAsyncAjaxRequests =
        map['interceptOnlyAsyncAjaxRequests'];
    instance.isDirectionalLockEnabled = map['isDirectionalLockEnabled'];
    instance.isElementFullscreenEnabled = map['isElementFullscreenEnabled'];
    instance.isFindInteractionEnabled = map['isFindInteractionEnabled'];
    instance.isFraudulentWebsiteWarningEnabled =
        map['isFraudulentWebsiteWarningEnabled'];
    instance.isInspectable = map['isInspectable'];
    instance.isPagingEnabled = map['isPagingEnabled'];
    instance.isSiteSpecificQuirksModeEnabled =
        map['isSiteSpecificQuirksModeEnabled'];
    instance.isTextInteractionEnabled = map['isTextInteractionEnabled'];
    instance.javaScriptCanOpenWindowsAutomatically =
        map['javaScriptCanOpenWindowsAutomatically'];
    instance.javaScriptEnabled = map['javaScriptEnabled'];
    instance.limitsNavigationsToAppBoundDomains =
        map['limitsNavigationsToAppBoundDomains'];
    instance.loadWithOverviewMode = map['loadWithOverviewMode'];
    instance.loadsImagesAutomatically = map['loadsImagesAutomatically'];
    instance.maximumZoomScale = map['maximumZoomScale'];
    instance.mediaPlaybackRequiresUserGesture =
        map['mediaPlaybackRequiresUserGesture'];
    instance.minimumLogicalFontSize = map['minimumLogicalFontSize'];
    instance.minimumZoomScale = map['minimumZoomScale'];
    instance.needInitialFocus = map['needInitialFocus'];
    instance.offscreenPreRaster = map['offscreenPreRaster'];
    instance.overScrollMode =
        OverScrollMode.fromNativeValue(map['overScrollMode']);
    instance.pageZoom = map['pageZoom'];
    instance.preferredContentMode =
        UserPreferredContentMode.fromNativeValue(map['preferredContentMode']);
    instance.resourceCustomSchemes = map['resourceCustomSchemes'] != null
        ? List<String>.from(map['resourceCustomSchemes']!.cast<String>())
        : null;
    instance.safeBrowsingEnabled = map['safeBrowsingEnabled'];
    instance.sansSerifFontFamily = map['sansSerifFontFamily'];
    instance.saveFormData = map['saveFormData'];
    instance.scrollBarStyle =
        ScrollBarStyle.fromNativeValue(map['scrollBarStyle']);
    instance.scrollbarFadingEnabled = map['scrollbarFadingEnabled'];
    instance.scrollsToTop = map['scrollsToTop'];
    instance.selectionGranularity =
        SelectionGranularity.fromNativeValue(map['selectionGranularity']);
    instance.serifFontFamily = map['serifFontFamily'];
    instance.sharedCookiesEnabled = map['sharedCookiesEnabled'];
    instance.shouldPrintBackgrounds = map['shouldPrintBackgrounds'];
    instance.standardFontFamily = map['standardFontFamily'];
    instance.supportMultipleWindows = map['supportMultipleWindows'];
    instance.supportZoom = map['supportZoom'];
    instance.suppressesIncrementalRendering =
        map['suppressesIncrementalRendering'];
    instance.textZoom = map['textZoom'];
    instance.thirdPartyCookiesEnabled = map['thirdPartyCookiesEnabled'];
    instance.transparentBackground = map['transparentBackground'];
    instance.upgradeKnownHostsToHTTPS = map['upgradeKnownHostsToHTTPS'];
    instance.useHybridComposition = map['useHybridComposition'];
    instance.useWideViewPort = map['useWideViewPort'];
    instance.userAgent = map['userAgent'];
    instance.verticalScrollBarEnabled = map['verticalScrollBarEnabled'];
    instance.verticalScrollbarPosition =
        VerticalScrollbarPosition.fromNativeValue(
            map['verticalScrollbarPosition']);
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "accessibilityIgnoresInvertColors": accessibilityIgnoresInvertColors,
      "algorithmicDarkeningAllowed": algorithmicDarkeningAllowed,
      "allowBackgroundAudioPlaying": allowBackgroundAudioPlaying,
      "allowContentAccess": allowContentAccess,
      "allowFileAccess": allowFileAccess,
      "allowFileAccessFromFileURLs": allowFileAccessFromFileURLs,
      "allowUniversalAccessFromFileURLs": allowUniversalAccessFromFileURLs,
      "allowingReadAccessTo": allowingReadAccessTo?.toString(),
      "allowsAirPlayForMediaPlayback": allowsAirPlayForMediaPlayback,
      "allowsBackForwardNavigationGestures":
          allowsBackForwardNavigationGestures,
      "allowsInlineMediaPlayback": allowsInlineMediaPlayback,
      "allowsLinkPreview": allowsLinkPreview,
      "allowsPictureInPictureMediaPlayback":
          allowsPictureInPictureMediaPlayback,
      "alwaysBounceHorizontal": alwaysBounceHorizontal,
      "alwaysBounceVertical": alwaysBounceVertical,
      "androidWebProfile": androidWebProfile,
      "appCachePath": appCachePath,
      "applePayAPIEnabled": applePayAPIEnabled,
      "applicationNameForUserAgent": applicationNameForUserAgent,
      "automaticallyAdjustsScrollIndicatorInsets":
          automaticallyAdjustsScrollIndicatorInsets,
      "blockNetworkImage": blockNetworkImage,
      "blockNetworkLoads": blockNetworkLoads,
      "builtInZoomControls": builtInZoomControls,
      "cacheEnabled": cacheEnabled,
      "cacheMode": cacheMode?.toNativeValue(),
      "contentBlockers": contentBlockers?.map((e) => e.toMap()).toList(),
      "contentInsetAdjustmentBehavior":
          contentInsetAdjustmentBehavior?.toNativeValue(),
      "cursiveFontFamily": cursiveFontFamily,
      "dataDetectorTypes":
          dataDetectorTypes?.map((e) => e.toNativeValue()).toList(),
      "databaseEnabled": databaseEnabled,
      "decelerationRate": decelerationRate?.toNativeValue(),
      "defaultFixedFontSize": defaultFixedFontSize,
      "defaultFontSize": defaultFontSize,
      "defaultTextEncodingName": defaultTextEncodingName,
      "defaultVideoPoster": defaultVideoPoster,
      "disableContextMenu": disableContextMenu,
      "disableDefaultErrorPage": disableDefaultErrorPage,
      "disableHorizontalScroll": disableHorizontalScroll,
      "disableInputAccessoryView": disableInputAccessoryView,
      "disableLongPressContextMenuOnLinks": disableLongPressContextMenuOnLinks,
      "disableVerticalScroll": disableVerticalScroll,
      "disabledActionModeMenuItems":
          disabledActionModeMenuItems?.toNativeValue(),
      "disallowOverScroll": disallowOverScroll,
      "displayZoomControls": displayZoomControls,
      "domStorageEnabled": domStorageEnabled,
      "enableViewportScale": enableViewportScale,
      "enterpriseAuthenticationAppLinkPolicyEnabled":
          enterpriseAuthenticationAppLinkPolicyEnabled,
      "fantasyFontFamily": fantasyFontFamily,
      "fixedFontFamily": fixedFontFamily,
      "forceDark": forceDark?.toNativeValue(),
      "forceDarkStrategy": forceDarkStrategy?.toNativeValue(),
      "geolocationEnabled": geolocationEnabled,
      "hardwareAcceleration": hardwareAcceleration,
      "horizontalScrollBarEnabled": horizontalScrollBarEnabled,
      "horizontalScrollbarThumbColor": horizontalScrollbarThumbColor?.toHex(),
      "horizontalScrollbarTrackColor": horizontalScrollbarTrackColor?.toHex(),
      "iframeAllow": iframeAllow,
      "iframeAllowFullscreen": iframeAllowFullscreen,
      "iframeCsp": iframeCsp,
      "iframeName": iframeName,
      "iframeReferrerPolicy": iframeReferrerPolicy?.toNativeValue(),
      "iframeSandbox": iframeSandbox?.map((e) => e.toNativeValue()).toList(),
      "ignoresViewportScaleLimits": ignoresViewportScaleLimits,
      "incognito": incognito,
      "initialScale": initialScale,
      "interceptOnlyAsyncAjaxRequests": interceptOnlyAsyncAjaxRequests,
      "isDirectionalLockEnabled": isDirectionalLockEnabled,
      "isElementFullscreenEnabled": isElementFullscreenEnabled,
      "isFindInteractionEnabled": isFindInteractionEnabled,
      "isFraudulentWebsiteWarningEnabled": isFraudulentWebsiteWarningEnabled,
      "isInspectable": isInspectable,
      "isPagingEnabled": isPagingEnabled,
      "isSiteSpecificQuirksModeEnabled": isSiteSpecificQuirksModeEnabled,
      "isTextInteractionEnabled": isTextInteractionEnabled,
      "javaScriptCanOpenWindowsAutomatically":
          javaScriptCanOpenWindowsAutomatically,
      "javaScriptEnabled": javaScriptEnabled,
      "layoutAlgorithm": layoutAlgorithm?.toNativeValue(),
      "limitsNavigationsToAppBoundDomains": limitsNavigationsToAppBoundDomains,
      "loadWithOverviewMode": loadWithOverviewMode,
      "loadsImagesAutomatically": loadsImagesAutomatically,
      "maximumViewportInset": maximumViewportInset?.toMap(),
      "maximumZoomScale": maximumZoomScale,
      "mediaPlaybackRequiresUserGesture": mediaPlaybackRequiresUserGesture,
      "mediaType": mediaType,
      "minimumFontSize": minimumFontSize,
      "minimumLogicalFontSize": minimumLogicalFontSize,
      "minimumViewportInset": minimumViewportInset?.toMap(),
      "minimumZoomScale": minimumZoomScale,
      "mixedContentMode": mixedContentMode?.toNativeValue(),
      "needInitialFocus": needInitialFocus,
      "networkAvailable": networkAvailable,
      "offscreenPreRaster": offscreenPreRaster,
      "overScrollMode": overScrollMode?.toNativeValue(),
      "pageZoom": pageZoom,
      "preferredContentMode": preferredContentMode?.toNativeValue(),
      "regexToCancelSubFramesLoading": regexToCancelSubFramesLoading,
      "rendererPriorityPolicy": rendererPriorityPolicy?.toMap(),
      "requestedWithHeaderOriginAllowList":
          requestedWithHeaderOriginAllowList?.toList(),
      "resourceCustomSchemes": resourceCustomSchemes,
      "safeBrowsingEnabled": safeBrowsingEnabled,
      "sansSerifFontFamily": sansSerifFontFamily,
      "saveFormData": saveFormData,
      "scrollBarDefaultDelayBeforeFade": scrollBarDefaultDelayBeforeFade,
      "scrollBarFadeDuration": scrollBarFadeDuration,
      "scrollBarStyle": scrollBarStyle?.toNativeValue(),
      "scrollbarFadingEnabled": scrollbarFadingEnabled,
      "scrollsToTop": scrollsToTop,
      "selectionGranularity": selectionGranularity?.toNativeValue(),
      "serifFontFamily": serifFontFamily,
      "sharedCookiesEnabled": sharedCookiesEnabled,
      "shouldPrintBackgrounds": shouldPrintBackgrounds,
      "standardFontFamily": standardFontFamily,
      "supportMultipleWindows": supportMultipleWindows,
      "supportZoom": supportZoom,
      "suppressesIncrementalRendering": suppressesIncrementalRendering,
      "textZoom": textZoom,
      "thirdPartyCookiesEnabled": thirdPartyCookiesEnabled,
      "transparentBackground": transparentBackground,
      "underPageBackgroundColor": underPageBackgroundColor?.toHex(),
      "upgradeKnownHostsToHTTPS": upgradeKnownHostsToHTTPS,
      "useHybridComposition": useHybridComposition,
      "useOnDownloadStart": useOnDownloadStart,
      "useOnLoadResource": useOnLoadResource,
      "useOnNavigationResponse": useOnNavigationResponse,
      "useOnRenderProcessGone": useOnRenderProcessGone,
      "useShouldInterceptAjaxRequest": useShouldInterceptAjaxRequest,
      "useShouldInterceptFetchRequest": useShouldInterceptFetchRequest,
      "useShouldInterceptRequest": useShouldInterceptRequest,
      "useShouldOverrideUrlLoading": useShouldOverrideUrlLoading,
      "useWideViewPort": useWideViewPort,
      "userAgent": userAgent,
      "verticalScrollBarEnabled": verticalScrollBarEnabled,
      "verticalScrollbarPosition": verticalScrollbarPosition?.toNativeValue(),
      "verticalScrollbarThumbColor": verticalScrollbarThumbColor?.toHex(),
      "verticalScrollbarTrackColor": verticalScrollbarTrackColor?.toHex(),
      "webViewAssetLoader": webViewAssetLoader?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  InAppWebViewSettings copy() {
    return InAppWebViewSettings.fromMap(toMap()) ?? InAppWebViewSettings();
  }

  @override
  String toString() {
    return 'InAppWebViewSettings{accessibilityIgnoresInvertColors: $accessibilityIgnoresInvertColors, algorithmicDarkeningAllowed: $algorithmicDarkeningAllowed, allowBackgroundAudioPlaying: $allowBackgroundAudioPlaying, allowContentAccess: $allowContentAccess, allowFileAccess: $allowFileAccess, allowFileAccessFromFileURLs: $allowFileAccessFromFileURLs, allowUniversalAccessFromFileURLs: $allowUniversalAccessFromFileURLs, allowingReadAccessTo: $allowingReadAccessTo, allowsAirPlayForMediaPlayback: $allowsAirPlayForMediaPlayback, allowsBackForwardNavigationGestures: $allowsBackForwardNavigationGestures, allowsInlineMediaPlayback: $allowsInlineMediaPlayback, allowsLinkPreview: $allowsLinkPreview, allowsPictureInPictureMediaPlayback: $allowsPictureInPictureMediaPlayback, alwaysBounceHorizontal: $alwaysBounceHorizontal, alwaysBounceVertical: $alwaysBounceVertical, androidWebProfile: $androidWebProfile, appCachePath: $appCachePath, applePayAPIEnabled: $applePayAPIEnabled, applicationNameForUserAgent: $applicationNameForUserAgent, automaticallyAdjustsScrollIndicatorInsets: $automaticallyAdjustsScrollIndicatorInsets, blockNetworkImage: $blockNetworkImage, blockNetworkLoads: $blockNetworkLoads, builtInZoomControls: $builtInZoomControls, cacheEnabled: $cacheEnabled, cacheMode: $cacheMode, contentBlockers: $contentBlockers, contentInsetAdjustmentBehavior: $contentInsetAdjustmentBehavior, cursiveFontFamily: $cursiveFontFamily, dataDetectorTypes: $dataDetectorTypes, databaseEnabled: $databaseEnabled, decelerationRate: $decelerationRate, defaultFixedFontSize: $defaultFixedFontSize, defaultFontSize: $defaultFontSize, defaultTextEncodingName: $defaultTextEncodingName, defaultVideoPoster: $defaultVideoPoster, disableContextMenu: $disableContextMenu, disableDefaultErrorPage: $disableDefaultErrorPage, disableHorizontalScroll: $disableHorizontalScroll, disableInputAccessoryView: $disableInputAccessoryView, disableLongPressContextMenuOnLinks: $disableLongPressContextMenuOnLinks, disableVerticalScroll: $disableVerticalScroll, disabledActionModeMenuItems: $disabledActionModeMenuItems, disallowOverScroll: $disallowOverScroll, displayZoomControls: $displayZoomControls, domStorageEnabled: $domStorageEnabled, enableViewportScale: $enableViewportScale, enterpriseAuthenticationAppLinkPolicyEnabled: $enterpriseAuthenticationAppLinkPolicyEnabled, fantasyFontFamily: $fantasyFontFamily, fixedFontFamily: $fixedFontFamily, forceDark: $forceDark, forceDarkStrategy: $forceDarkStrategy, geolocationEnabled: $geolocationEnabled, hardwareAcceleration: $hardwareAcceleration, horizontalScrollBarEnabled: $horizontalScrollBarEnabled, horizontalScrollbarThumbColor: $horizontalScrollbarThumbColor, horizontalScrollbarTrackColor: $horizontalScrollbarTrackColor, iframeAllow: $iframeAllow, iframeAllowFullscreen: $iframeAllowFullscreen, iframeCsp: $iframeCsp, iframeName: $iframeName, iframeReferrerPolicy: $iframeReferrerPolicy, iframeSandbox: $iframeSandbox, ignoresViewportScaleLimits: $ignoresViewportScaleLimits, incognito: $incognito, initialScale: $initialScale, interceptOnlyAsyncAjaxRequests: $interceptOnlyAsyncAjaxRequests, isDirectionalLockEnabled: $isDirectionalLockEnabled, isElementFullscreenEnabled: $isElementFullscreenEnabled, isFindInteractionEnabled: $isFindInteractionEnabled, isFraudulentWebsiteWarningEnabled: $isFraudulentWebsiteWarningEnabled, isInspectable: $isInspectable, isPagingEnabled: $isPagingEnabled, isSiteSpecificQuirksModeEnabled: $isSiteSpecificQuirksModeEnabled, isTextInteractionEnabled: $isTextInteractionEnabled, javaScriptCanOpenWindowsAutomatically: $javaScriptCanOpenWindowsAutomatically, javaScriptEnabled: $javaScriptEnabled, layoutAlgorithm: $layoutAlgorithm, limitsNavigationsToAppBoundDomains: $limitsNavigationsToAppBoundDomains, loadWithOverviewMode: $loadWithOverviewMode, loadsImagesAutomatically: $loadsImagesAutomatically, maximumViewportInset: $maximumViewportInset, maximumZoomScale: $maximumZoomScale, mediaPlaybackRequiresUserGesture: $mediaPlaybackRequiresUserGesture, mediaType: $mediaType, minimumFontSize: $minimumFontSize, minimumLogicalFontSize: $minimumLogicalFontSize, minimumViewportInset: $minimumViewportInset, minimumZoomScale: $minimumZoomScale, mixedContentMode: $mixedContentMode, needInitialFocus: $needInitialFocus, networkAvailable: $networkAvailable, offscreenPreRaster: $offscreenPreRaster, overScrollMode: $overScrollMode, pageZoom: $pageZoom, preferredContentMode: $preferredContentMode, regexToCancelSubFramesLoading: $regexToCancelSubFramesLoading, rendererPriorityPolicy: $rendererPriorityPolicy, requestedWithHeaderOriginAllowList: $requestedWithHeaderOriginAllowList, resourceCustomSchemes: $resourceCustomSchemes, safeBrowsingEnabled: $safeBrowsingEnabled, sansSerifFontFamily: $sansSerifFontFamily, saveFormData: $saveFormData, scrollBarDefaultDelayBeforeFade: $scrollBarDefaultDelayBeforeFade, scrollBarFadeDuration: $scrollBarFadeDuration, scrollBarStyle: $scrollBarStyle, scrollbarFadingEnabled: $scrollbarFadingEnabled, scrollsToTop: $scrollsToTop, selectionGranularity: $selectionGranularity, serifFontFamily: $serifFontFamily, sharedCookiesEnabled: $sharedCookiesEnabled, shouldPrintBackgrounds: $shouldPrintBackgrounds, standardFontFamily: $standardFontFamily, supportMultipleWindows: $supportMultipleWindows, supportZoom: $supportZoom, suppressesIncrementalRendering: $suppressesIncrementalRendering, textZoom: $textZoom, thirdPartyCookiesEnabled: $thirdPartyCookiesEnabled, transparentBackground: $transparentBackground, underPageBackgroundColor: $underPageBackgroundColor, upgradeKnownHostsToHTTPS: $upgradeKnownHostsToHTTPS, useHybridComposition: $useHybridComposition, useOnDownloadStart: $useOnDownloadStart, useOnLoadResource: $useOnLoadResource, useOnNavigationResponse: $useOnNavigationResponse, useOnRenderProcessGone: $useOnRenderProcessGone, useShouldInterceptAjaxRequest: $useShouldInterceptAjaxRequest, useShouldInterceptFetchRequest: $useShouldInterceptFetchRequest, useShouldInterceptRequest: $useShouldInterceptRequest, useShouldOverrideUrlLoading: $useShouldOverrideUrlLoading, useWideViewPort: $useWideViewPort, userAgent: $userAgent, verticalScrollBarEnabled: $verticalScrollBarEnabled, verticalScrollbarPosition: $verticalScrollbarPosition, verticalScrollbarThumbColor: $verticalScrollbarThumbColor, verticalScrollbarTrackColor: $verticalScrollbarTrackColor, webViewAssetLoader: $webViewAssetLoader}';
  }
}
