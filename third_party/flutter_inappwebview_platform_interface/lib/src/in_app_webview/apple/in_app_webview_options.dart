import '../../types/main.dart';

import '../../in_app_browser/in_app_browser_settings.dart';

import '../in_app_webview_settings.dart';
import '../platform_inappwebview_controller.dart';

class IosOptions {}

@Deprecated('Use InAppWebViewSettings instead')
class IOSInAppWebViewOptions
    implements WebViewOptions, BrowserOptions, IosOptions {
  bool disallowOverScroll;

  bool enableViewportScale;

  bool suppressesIncrementalRendering;

  bool allowsAirPlayForMediaPlayback;

  bool allowsBackForwardNavigationGestures;

  bool allowsLinkPreview;

  bool ignoresViewportScaleLimits;

  bool allowsInlineMediaPlayback;

  bool allowsPictureInPictureMediaPlayback;

  bool isFraudulentWebsiteWarningEnabled;

  IOSWKSelectionGranularity selectionGranularity;

  List<IOSWKDataDetectorTypes> dataDetectorTypes;

  bool sharedCookiesEnabled;

  bool automaticallyAdjustsScrollIndicatorInsets;

  bool accessibilityIgnoresInvertColors;

  IOSUIScrollViewDecelerationRate decelerationRate;

  bool alwaysBounceVertical;

  bool alwaysBounceHorizontal;

  bool scrollsToTop;

  bool isPagingEnabled;

  double maximumZoomScale;

  double minimumZoomScale;

  IOSUIScrollViewContentInsetAdjustmentBehavior contentInsetAdjustmentBehavior;

  bool isDirectionalLockEnabled;

  String? mediaType;

  double pageZoom;

  bool limitsNavigationsToAppBoundDomains;

  bool useOnNavigationResponse;

  bool applePayAPIEnabled;

  Uri? allowingReadAccessTo;

  bool disableLongPressContextMenuOnLinks;

  bool disableInputAccessoryView;

  IOSInAppWebViewOptions(
      {this.disallowOverScroll = false,
      this.enableViewportScale = false,
      this.suppressesIncrementalRendering = false,
      this.allowsAirPlayForMediaPlayback = true,
      this.allowsBackForwardNavigationGestures = true,
      this.allowsLinkPreview = true,
      this.ignoresViewportScaleLimits = false,
      this.allowsInlineMediaPlayback = false,
      this.allowsPictureInPictureMediaPlayback = true,
      this.isFraudulentWebsiteWarningEnabled = true,
      this.selectionGranularity = IOSWKSelectionGranularity.DYNAMIC,
      this.dataDetectorTypes = const [IOSWKDataDetectorTypes.NONE],
      this.sharedCookiesEnabled = false,
      this.automaticallyAdjustsScrollIndicatorInsets = false,
      this.accessibilityIgnoresInvertColors = false,
      this.decelerationRate = IOSUIScrollViewDecelerationRate.NORMAL,
      this.alwaysBounceVertical = false,
      this.alwaysBounceHorizontal = false,
      this.scrollsToTop = true,
      this.isPagingEnabled = false,
      this.maximumZoomScale = 1.0,
      this.minimumZoomScale = 1.0,
      this.contentInsetAdjustmentBehavior =
          IOSUIScrollViewContentInsetAdjustmentBehavior.NEVER,
      this.isDirectionalLockEnabled = false,
      this.mediaType,
      this.pageZoom = 1.0,
      this.limitsNavigationsToAppBoundDomains = false,
      this.useOnNavigationResponse = false,
      this.applePayAPIEnabled = false,
      this.allowingReadAccessTo,
      this.disableLongPressContextMenuOnLinks = false,
      this.disableInputAccessoryView = false}) {
    assert(
        allowingReadAccessTo == null || allowingReadAccessTo!.isScheme("file"));
  }

  @override
  Map<String, dynamic> toMap() {
    List<String> dataDetectorTypesList = [];
    dataDetectorTypes.forEach((dataDetectorType) {
      dataDetectorTypesList.add(dataDetectorType.toNativeValue());
    });

    return {
      "disallowOverScroll": disallowOverScroll,
      "enableViewportScale": enableViewportScale,
      "suppressesIncrementalRendering": suppressesIncrementalRendering,
      "allowsAirPlayForMediaPlayback": allowsAirPlayForMediaPlayback,
      "allowsBackForwardNavigationGestures":
          allowsBackForwardNavigationGestures,
      "allowsLinkPreview": allowsLinkPreview,
      "ignoresViewportScaleLimits": ignoresViewportScaleLimits,
      "allowsInlineMediaPlayback": allowsInlineMediaPlayback,
      "allowsPictureInPictureMediaPlayback":
          allowsPictureInPictureMediaPlayback,
      "isFraudulentWebsiteWarningEnabled": isFraudulentWebsiteWarningEnabled,
      "selectionGranularity": selectionGranularity.toNativeValue(),
      "dataDetectorTypes": dataDetectorTypesList,
      "sharedCookiesEnabled": sharedCookiesEnabled,
      "automaticallyAdjustsScrollIndicatorInsets":
          automaticallyAdjustsScrollIndicatorInsets,
      "accessibilityIgnoresInvertColors": accessibilityIgnoresInvertColors,
      "decelerationRate": decelerationRate.toNativeValue(),
      "alwaysBounceVertical": alwaysBounceVertical,
      "alwaysBounceHorizontal": alwaysBounceHorizontal,
      "scrollsToTop": scrollsToTop,
      "isPagingEnabled": isPagingEnabled,
      "maximumZoomScale": maximumZoomScale,
      "minimumZoomScale": minimumZoomScale,
      "contentInsetAdjustmentBehavior":
          contentInsetAdjustmentBehavior.toNativeValue(),
      "isDirectionalLockEnabled": isDirectionalLockEnabled,
      "mediaType": mediaType,
      "pageZoom": pageZoom,
      "limitsNavigationsToAppBoundDomains": limitsNavigationsToAppBoundDomains,
      "useOnNavigationResponse": useOnNavigationResponse,
      "applePayAPIEnabled": applePayAPIEnabled,
      "allowingReadAccessTo": allowingReadAccessTo.toString(),
      "disableLongPressContextMenuOnLinks": disableLongPressContextMenuOnLinks,
      "disableInputAccessoryView": disableInputAccessoryView,
    };
  }

  static IOSInAppWebViewOptions fromMap(Map<String, dynamic> map) {
    List<IOSWKDataDetectorTypes> dataDetectorTypes = [];
    List<String> dataDetectorTypesList =
        List<String>.from(map["dataDetectorTypes"] ?? []);
    dataDetectorTypesList.forEach((dataDetectorTypeValue) {
      var dataDetectorType =
          IOSWKDataDetectorTypes.fromNativeValue(dataDetectorTypeValue);
      if (dataDetectorType != null) {
        dataDetectorTypes.add(dataDetectorType);
      }
    });

    var instance = IOSInAppWebViewOptions();
    instance.disallowOverScroll = map["disallowOverScroll"];
    instance.enableViewportScale = map["enableViewportScale"];
    instance.suppressesIncrementalRendering =
        map["suppressesIncrementalRendering"];
    instance.allowsAirPlayForMediaPlayback =
        map["allowsAirPlayForMediaPlayback"];
    instance.allowsBackForwardNavigationGestures =
        map["allowsBackForwardNavigationGestures"];
    instance.allowsLinkPreview = map["allowsLinkPreview"];
    instance.ignoresViewportScaleLimits = map["ignoresViewportScaleLimits"];
    instance.allowsInlineMediaPlayback = map["allowsInlineMediaPlayback"];
    instance.allowsPictureInPictureMediaPlayback =
        map["allowsPictureInPictureMediaPlayback"];
    instance.isFraudulentWebsiteWarningEnabled =
        map["isFraudulentWebsiteWarningEnabled"];
    instance.selectionGranularity =
        IOSWKSelectionGranularity.fromNativeValue(map["selectionGranularity"])!;
    instance.dataDetectorTypes = dataDetectorTypes;
    instance.sharedCookiesEnabled = map["sharedCookiesEnabled"];
    instance.automaticallyAdjustsScrollIndicatorInsets =
        map["automaticallyAdjustsScrollIndicatorInsets"];
    instance.accessibilityIgnoresInvertColors =
        map["accessibilityIgnoresInvertColors"];
    instance.decelerationRate = IOSUIScrollViewDecelerationRate.fromNativeValue(
        map["decelerationRate"])!;
    instance.alwaysBounceVertical = map["alwaysBounceVertical"];
    instance.alwaysBounceHorizontal = map["alwaysBounceHorizontal"];
    instance.scrollsToTop = map["scrollsToTop"];
    instance.isPagingEnabled = map["isPagingEnabled"];
    instance.maximumZoomScale = map["maximumZoomScale"];
    instance.minimumZoomScale = map["minimumZoomScale"];
    instance.contentInsetAdjustmentBehavior =
        IOSUIScrollViewContentInsetAdjustmentBehavior.fromNativeValue(
            map["contentInsetAdjustmentBehavior"])!;
    instance.isDirectionalLockEnabled = map["isDirectionalLockEnabled"];
    instance.mediaType = map["mediaType"];
    instance.pageZoom = map["pageZoom"];
    instance.limitsNavigationsToAppBoundDomains =
        map["limitsNavigationsToAppBoundDomains"];
    instance.useOnNavigationResponse = map["useOnNavigationResponse"];
    instance.applePayAPIEnabled = map["applePayAPIEnabled"];
    instance.allowingReadAccessTo = map["allowingReadAccessTo"] != null
        ? Uri.tryParse(map["allowingReadAccessTo"])
        : null;
    instance.disableLongPressContextMenuOnLinks =
        map["disableLongPressContextMenuOnLinks"];
    instance.disableInputAccessoryView = map["disableInputAccessoryView"];
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
  IOSInAppWebViewOptions copy() {
    return IOSInAppWebViewOptions.fromMap(this.toMap());
  }
}
