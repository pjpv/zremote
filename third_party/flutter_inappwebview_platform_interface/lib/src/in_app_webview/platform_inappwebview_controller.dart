import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../context_menu/main.dart';
import '../debug_logging_settings.dart';
import '../inappwebview_platform.dart';
import '../web_message/main.dart';
import '../web_storage/platform_web_storage.dart';
import '../web_uri.dart';

import '../types/main.dart';
import '../in_app_browser/platform_in_app_browser.dart';
import 'platform_headless_in_app_webview.dart';
import 'platform_inappwebview_widget.dart';
import '../platform_webview_feature.dart';
import '../find_interaction/platform_find_interaction_controller.dart';

import 'platform_webview.dart';
import 'in_app_webview_keep_alive.dart';
import 'in_app_webview_settings.dart';

import '../print_job/main.dart';

@immutable
class PlatformInAppWebViewControllerCreationParams {
  const PlatformInAppWebViewControllerCreationParams(
      {required this.id, this.webviewParams});

  final dynamic id;

  final PlatformWebViewCreationParams? webviewParams;
}

abstract class PlatformInAppWebViewController extends PlatformInterface
    implements Disposable {
  static DebugLoggingSettings debugLoggingSettings = DebugLoggingSettings(
      maxLogMessageLength: 1000,
      excludeFilter: [
        RegExp(r"onScrollChanged"),
        RegExp(r"onOverScrolled"),
        RegExp(r"onReceivedIcon")
      ]);

  factory PlatformInAppWebViewController(
      PlatformInAppWebViewControllerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformInAppWebViewController inAppWebViewController =
        InAppWebViewPlatform.instance!
            .createPlatformInAppWebViewController(params);
    PlatformInterface.verify(inAppWebViewController, _token);
    return inAppWebViewController;
  }

  factory PlatformInAppWebViewController.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformInAppWebViewController inAppWebViewControllerStatic =
        InAppWebViewPlatform.instance!
            .createPlatformInAppWebViewControllerStatic();
    PlatformInterface.verify(inAppWebViewControllerStatic, _token);
    return inAppWebViewControllerStatic;
  }

  @protected
  PlatformInAppWebViewController.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformInAppWebViewControllerCreationParams params;

  dynamic get id => params.id;

  PlatformWebViewCreationParams? get webviewParams => params.webviewParams;

  PlatformWebStorage get webStorage => throw UnimplementedError(
      'webStorage is not implemented on the current platform');

  Future<WebUri?> getUrl() {
    throw UnimplementedError(
        'getUrl is not implemented on the current platform');
  }

  Future<String?> getTitle() {
    throw UnimplementedError(
        'getTitle is not implemented on the current platform');
  }

  Future<int?> getProgress() {
    throw UnimplementedError(
        'getProgress is not implemented on the current platform');
  }

  Future<String?> getHtml() {
    throw UnimplementedError(
        'getHtml is not implemented on the current platform');
  }

  Future<List<Favicon>> getFavicons() {
    throw UnimplementedError(
        'getFavicons is not implemented on the current platform');
  }

  Future<void> loadUrl(
      {required URLRequest urlRequest,
      @Deprecated('Use allowingReadAccessTo instead')
      Uri? iosAllowingReadAccessTo,
      WebUri? allowingReadAccessTo}) {
    throw UnimplementedError(
        'loadUrl is not implemented on the current platform');
  }

  Future<void> postUrl({required WebUri url, required Uint8List postData}) {
    throw UnimplementedError(
        'postUrl is not implemented on the current platform');
  }

  Future<void> loadData(
      {required String data,
      String mimeType = "text/html",
      String encoding = "utf8",
      WebUri? baseUrl,
      @Deprecated('Use historyUrl instead') Uri? androidHistoryUrl,
      WebUri? historyUrl,
      @Deprecated('Use allowingReadAccessTo instead')
      Uri? iosAllowingReadAccessTo,
      WebUri? allowingReadAccessTo}) {
    throw UnimplementedError(
        'loadData is not implemented on the current platform');
  }

  Future<void> loadFile({required String assetFilePath}) {
    throw UnimplementedError(
        'loadFile is not implemented on the current platform');
  }

  Future<void> reload() {
    throw UnimplementedError(
        'reload is not implemented on the current platform');
  }

  Future<void> goBack() {
    throw UnimplementedError(
        'goBack is not implemented on the current platform');
  }

  Future<bool> canGoBack() {
    throw UnimplementedError(
        'canGoBack is not implemented on the current platform');
  }

  Future<void> goForward() {
    throw UnimplementedError(
        'goForward is not implemented on the current platform');
  }

  Future<bool> canGoForward() {
    throw UnimplementedError(
        'canGoForward is not implemented on the current platform');
  }

  Future<void> goBackOrForward({required int steps}) {
    throw UnimplementedError(
        'goBackOrForward is not implemented on the current platform');
  }

  Future<bool> canGoBackOrForward({required int steps}) {
    throw UnimplementedError(
        'canGoBackOrForward is not implemented on the current platform');
  }

  Future<void> goTo({required WebHistoryItem historyItem}) {
    throw UnimplementedError('goTo is not implemented on the current platform');
  }

  Future<bool> isLoading() {
    throw UnimplementedError(
        'isLoading is not implemented on the current platform');
  }

  Future<void> stopLoading() {
    throw UnimplementedError(
        'stopLoading is not implemented on the current platform');
  }

  Future<dynamic> evaluateJavascript(
      {required String source, ContentWorld? contentWorld}) {
    throw UnimplementedError(
        'evaluateJavascript is not implemented on the current platform');
  }

  Future<void> injectJavascriptFileFromUrl(
      {required WebUri urlFile,
      ScriptHtmlTagAttributes? scriptHtmlTagAttributes}) {
    throw UnimplementedError(
        'injectJavascriptFileFromUrl is not implemented on the current platform');
  }

  Future<dynamic> injectJavascriptFileFromAsset(
      {required String assetFilePath}) {
    throw UnimplementedError(
        'injectJavascriptFileFromAsset is not implemented on the current platform');
  }

  Future<void> injectCSSCode({required String source}) {
    throw UnimplementedError(
        'injectCSSCode is not implemented on the current platform');
  }

  Future<void> injectCSSFileFromUrl(
      {required WebUri urlFile,
      CSSLinkHtmlTagAttributes? cssLinkHtmlTagAttributes}) {
    throw UnimplementedError(
        'injectCSSFileFromUrl is not implemented on the current platform');
  }

  Future<void> injectCSSFileFromAsset({required String assetFilePath}) {
    throw UnimplementedError(
        'injectCSSFileFromAsset is not implemented on the current platform');
  }

  void addJavaScriptHandler(
      {required String handlerName,
      required JavaScriptHandlerCallback callback}) {
    throw UnimplementedError(
        'addJavaScriptHandler is not implemented on the current platform');
  }

  JavaScriptHandlerCallback? removeJavaScriptHandler(
      {required String handlerName}) {
    throw UnimplementedError(
        'removeJavaScriptHandler is not implemented on the current platform');
  }

  bool hasJavaScriptHandler({required String handlerName}) {
    throw UnimplementedError(
        'hasJavaScriptHandler is not implemented on the current platform');
  }

  Future<Uint8List?> takeScreenshot(
      {ScreenshotConfiguration? screenshotConfiguration}) {
    throw UnimplementedError(
        'takeScreenshot is not implemented on the current platform');
  }

  Future<void> setSettings({required InAppWebViewSettings settings}) {
    throw UnimplementedError(
        'setSettings is not implemented on the current platform');
  }

  Future<InAppWebViewSettings?> getSettings() {
    throw UnimplementedError(
        'getSettings is not implemented on the current platform');
  }

  Future<WebHistory?> getCopyBackForwardList() {
    throw UnimplementedError(
        'getCopyBackForwardList is not implemented on the current platform');
  }

  @Deprecated("Use InAppWebViewController.clearAllCache instead")
  Future<void> clearCache() {
    throw UnimplementedError(
        'clearCache is not implemented on the current platform');
  }

  Future<void> scrollTo(
      {required int x, required int y, bool animated = false}) {
    throw UnimplementedError(
        'scrollTo is not implemented on the current platform');
  }

  Future<void> scrollBy(
      {required int x, required int y, bool animated = false}) {
    throw UnimplementedError(
        'scrollBy is not implemented on the current platform');
  }

  Future<void> pauseTimers() {
    throw UnimplementedError(
        'pauseTimers is not implemented on the current platform');
  }

  Future<void> resumeTimers() {
    throw UnimplementedError(
        'resumeTimers is not implemented on the current platform');
  }

  Future<PlatformPrintJobController?> printCurrentPage(
      {PrintJobSettings? settings}) {
    throw UnimplementedError(
        'printCurrentPage is not implemented on the current platform');
  }

  Future<int?> getContentHeight() {
    throw UnimplementedError(
        'getContentHeight is not implemented on the current platform');
  }

  Future<int?> getContentWidth() {
    throw UnimplementedError(
        'getContentWidth is not implemented on the current platform');
  }

  Future<void> zoomBy(
      {required double zoomFactor,
      @Deprecated('Use animated instead') bool? iosAnimated,
      bool animated = false}) {
    throw UnimplementedError(
        'zoomBy is not implemented on the current platform');
  }

  Future<WebUri?> getOriginalUrl() {
    throw UnimplementedError(
        'getOriginalUrl is not implemented on the current platform');
  }

  Future<double?> getZoomScale() {
    throw UnimplementedError(
        'getZoomScale is not implemented on the current platform');
  }

  Future<String?> getSelectedText() {
    throw UnimplementedError(
        'getSelectedText is not implemented on the current platform');
  }

  Future<InAppWebViewHitTestResult?> getHitTestResult() {
    throw UnimplementedError(
        'getHitTestResult is not implemented on the current platform');
  }

  Future<void> clearFocus() {
    throw UnimplementedError(
        'clearFocus is not implemented on the current platform');
  }

  Future<void> setContextMenu(ContextMenu? contextMenu) {
    throw UnimplementedError(
        'setContextMenu is not implemented on the current platform');
  }

  Future<RequestFocusNodeHrefResult?> requestFocusNodeHref() {
    throw UnimplementedError(
        'requestFocusNodeHref is not implemented on the current platform');
  }

  Future<RequestImageRefResult?> requestImageRef() {
    throw UnimplementedError(
        'requestImageRef is not implemented on the current platform');
  }

  Future<List<MetaTag>> getMetaTags() {
    throw UnimplementedError(
        'getMetaTags is not implemented on the current platform');
  }

  Future<Color?> getMetaThemeColor() {
    throw UnimplementedError(
        'getMetaThemeColor is not implemented on the current platform');
  }

  Future<int?> getScrollX() {
    throw UnimplementedError(
        'getScrollX is not implemented on the current platform');
  }

  Future<int?> getScrollY() {
    throw UnimplementedError(
        'getScrollY is not implemented on the current platform');
  }

  Future<SslCertificate?> getCertificate() {
    throw UnimplementedError(
        'getCertificate is not implemented on the current platform');
  }

  Future<void> addUserScript({required UserScript userScript}) {
    throw UnimplementedError(
        'addUserScript is not implemented on the current platform');
  }

  Future<void> addUserScripts({required List<UserScript> userScripts}) {
    throw UnimplementedError(
        'addUserScripts is not implemented on the current platform');
  }

  Future<bool> removeUserScript({required UserScript userScript}) {
    throw UnimplementedError(
        'removeUserScript is not implemented on the current platform');
  }

  Future<void> removeUserScriptsByGroupName({required String groupName}) {
    throw UnimplementedError(
        'removeUserScriptsByGroupName is not implemented on the current platform');
  }

  Future<void> removeUserScripts({required List<UserScript> userScripts}) {
    throw UnimplementedError(
        'removeUserScripts is not implemented on the current platform');
  }

  Future<void> removeAllUserScripts() {
    throw UnimplementedError(
        'removeAllUserScripts is not implemented on the current platform');
  }

  bool hasUserScript({required UserScript userScript}) {
    throw UnimplementedError(
        'hasUserScript is not implemented on the current platform');
  }

  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript(
      {required String functionBody,
      Map<String, dynamic> arguments = const <String, dynamic>{},
      ContentWorld? contentWorld}) {
    throw UnimplementedError(
        'callAsyncJavaScript is not implemented on the current platform');
  }

  Future<String?> saveWebArchive(
      {required String filePath, bool autoname = false}) {
    throw UnimplementedError(
        'saveWebArchive is not implemented on the current platform');
  }

  Future<bool> isSecureContext() {
    throw UnimplementedError(
        'isSecureContext is not implemented on the current platform');
  }

  Future<PlatformWebMessageChannel?> createWebMessageChannel() {
    throw UnimplementedError(
        'createWebMessageChannel is not implemented on the current platform');
  }

  Future<void> postWebMessage(
      {required WebMessage message, WebUri? targetOrigin}) {
    throw UnimplementedError(
        'postWebMessage is not implemented on the current platform');
  }

  Future<void> addWebMessageListener(
      PlatformWebMessageListener webMessageListener) {
    throw UnimplementedError(
        'addWebMessageListener is not implemented on the current platform');
  }

  bool hasWebMessageListener(PlatformWebMessageListener webMessageListener) {
    throw UnimplementedError(
        'hasWebMessageListener is not implemented on the current platform');
  }

  Future<bool> canScrollVertically() {
    throw UnimplementedError(
        'canScrollVertically is not implemented on the current platform');
  }

  Future<bool> canScrollHorizontally() {
    throw UnimplementedError(
        'canScrollHorizontally is not implemented on the current platform');
  }

  Future<bool> startSafeBrowsing() {
    throw UnimplementedError(
        'startSafeBrowsing is not implemented on the current platform');
  }

  Future<void> clearSslPreferences() {
    throw UnimplementedError(
        'clearSslPreferences is not implemented on the current platform');
  }

  Future<void> pause() {
    throw UnimplementedError(
        'pause is not implemented on the current platform');
  }

  Future<void> resume() {
    throw UnimplementedError(
        'resume is not implemented on the current platform');
  }

  Future<bool> pageDown({required bool bottom}) {
    throw UnimplementedError(
        'pageDown is not implemented on the current platform');
  }

  Future<bool> pageUp({required bool top}) {
    throw UnimplementedError(
        'pageUp is not implemented on the current platform');
  }

  Future<bool> zoomIn() {
    throw UnimplementedError(
        'zoomIn is not implemented on the current platform');
  }

  Future<bool> zoomOut() {
    throw UnimplementedError(
        'zoomOut is not implemented on the current platform');
  }

  Future<void> clearHistory() {
    throw UnimplementedError(
        'clearHistory is not implemented on the current platform');
  }

  Future<void> clearFormData() {
    throw UnimplementedError(
        'clearFormData is not implemented on the current platform');
  }

  Future<void> reloadFromOrigin() {
    throw UnimplementedError(
        'reloadFromOrigin is not implemented on the current platform');
  }

  Future<Uint8List?> createPdf(
      {@Deprecated("Use pdfConfiguration instead")
      // ignore: deprecated_member_use_from_same_package
      IOSWKPDFConfiguration? iosWKPdfConfiguration,
      PDFConfiguration? pdfConfiguration}) {
    throw UnimplementedError(
        'createPdf is not implemented on the current platform');
  }

  Future<Uint8List?> createWebArchiveData() {
    throw UnimplementedError(
        'createWebArchiveData is not implemented on the current platform');
  }

  Future<bool> hasOnlySecureContent() {
    throw UnimplementedError(
        'hasOnlySecureContent is not implemented on the current platform');
  }

  Future<void> pauseAllMediaPlayback() {
    throw UnimplementedError(
        'pauseAllMediaPlayback is not implemented on the current platform');
  }

  Future<void> setAllMediaPlaybackSuspended({required bool suspended}) {
    throw UnimplementedError(
        'setAllMediaPlaybackSuspended is not implemented on the current platform');
  }

  Future<void> closeAllMediaPresentations() {
    throw UnimplementedError(
        'closeAllMediaPresentations is not implemented on the current platform');
  }

  Future<MediaPlaybackState?> requestMediaPlaybackState() {
    throw UnimplementedError(
        'requestMediaPlaybackState is not implemented on the current platform');
  }

  Future<bool> isInFullscreen() {
    throw UnimplementedError(
        'isInFullscreen is not implemented on the current platform');
  }

  Future<MediaCaptureState?> getCameraCaptureState() {
    throw UnimplementedError(
        'getCameraCaptureState is not implemented on the current platform');
  }

  Future<void> setCameraCaptureState({required MediaCaptureState state}) {
    throw UnimplementedError(
        'setCameraCaptureState is not implemented on the current platform');
  }

  Future<MediaCaptureState?> getMicrophoneCaptureState() {
    throw UnimplementedError(
        'getMicrophoneCaptureState is not implemented on the current platform');
  }

  Future<void> setMicrophoneCaptureState({required MediaCaptureState state}) {
    throw UnimplementedError(
        'setMicrophoneCaptureState is not implemented on the current platform');
  }

  Future<void> loadSimulatedRequest(
      {required URLRequest urlRequest,
      required Uint8List data,
      URLResponse? urlResponse}) {
    throw UnimplementedError(
        'loadSimulatedRequest is not implemented on the current platform');
  }

  Future<void> openDevTools() {
    throw UnimplementedError(
        'openDevTools is not implemented on the current platform');
  }

  Future<dynamic> callDevToolsProtocolMethod(
      {required String methodName, Map<String, dynamic>? parameters}) {
    throw UnimplementedError(
        'callDevToolsProtocolMethod is not implemented on the current platform');
  }

  Future<void> addDevToolsProtocolEventListener(
      {required String eventName, required Function(dynamic data) callback}) {
    throw UnimplementedError(
        'addDevToolsProtocolEventListener is not implemented on the current platform');
  }

  Future<void> removeDevToolsProtocolEventListener(
      {required String eventName}) {
    throw UnimplementedError(
        'removeDevToolsProtocolEventListener is not implemented on the current platform');
  }

  Future<String?> getIFrameId() {
    throw UnimplementedError(
        'getIFrameId is not implemented on the current platform');
  }

  dynamic getViewId() {
    throw UnimplementedError(
        'getViewId is not implemented on the current platform');
  }

  Future<String> getDefaultUserAgent() {
    throw UnimplementedError(
        'getDefaultUserAgent is not implemented on the current platform');
  }

  Future<void> clearClientCertPreferences() {
    throw UnimplementedError(
        'clearClientCertPreferences is not implemented on the current platform');
  }

  Future<WebUri?> getSafeBrowsingPrivacyPolicyUrl() {
    throw UnimplementedError(
        'getSafeBrowsingPrivacyPolicyUrl is not implemented on the current platform');
  }

  Future<bool> setSafeBrowsingAllowlist({required List<String> hosts}) {
    throw UnimplementedError(
        'setSafeBrowsingAllowlist is not implemented on the current platform');
  }

  Future<WebViewPackageInfo?> getCurrentWebViewPackage() {
    throw UnimplementedError(
        'getCurrentWebViewPackage is not implemented on the current platform');
  }

  Future<void> setWebContentsDebuggingEnabled(bool debuggingEnabled) {
    throw UnimplementedError(
        'setWebContentsDebuggingEnabled is not implemented on the current platform');
  }

  Future<String?> getVariationsHeader() {
    throw UnimplementedError(
        'getVariationsHeader is not implemented on the current platform');
  }

  Future<bool> isMultiProcessEnabled() {
    throw UnimplementedError(
        'isMultiProcessEnabled is not implemented on the current platform');
  }

  Future<void> disableWebView() {
    throw UnimplementedError(
        'disableWebView is not implemented on the current platform');
  }

  Future<bool> handlesURLScheme(String urlScheme) {
    throw UnimplementedError(
        'handlesURLScheme is not implemented on the current platform');
  }

  Future<void> disposeKeepAlive(InAppWebViewKeepAlive keepAlive) {
    throw UnimplementedError(
        'disposeKeepAlive is not implemented on the current platform');
  }

  Future<void> clearAllCache({bool includeDiskFiles = true}) {
    throw UnimplementedError(
        'clearAllCache is not implemented on the current platform');
  }

  Future<String> get tRexRunnerHtml => throw UnimplementedError(
      'tRexRunnerHtml is not implemented on the current platform');

  Future<String> get tRexRunnerCss => throw UnimplementedError(
      'tRexRunnerCss is not implemented on the current platform');

  @Deprecated('Use setSettings instead')
  Future<void> setOptions({required InAppWebViewGroupOptions options}) {
    throw UnimplementedError(
        'setOptions is not implemented on the current platform');
  }

  @Deprecated('Use getSettings instead')
  Future<InAppWebViewGroupOptions?> getOptions() {
    throw UnimplementedError(
        'getOptions is not implemented on the current platform');
  }

  @Deprecated("Use FindInteractionController.findAll instead")
  Future<void> findAllAsync({required String find}) {
    throw UnimplementedError(
        'findAllAsync is not implemented on the current platform');
  }

  @Deprecated("Use FindInteractionController.findNext instead")
  Future<void> findNext({required bool forward}) {
    throw UnimplementedError(
        'findNext is not implemented on the current platform');
  }

  @Deprecated("Use FindInteractionController.clearMatches instead")
  Future<void> clearMatches() {
    throw UnimplementedError(
        'clearMatches is not implemented on the current platform');
  }

  @Deprecated("Use tRexRunnerHtml instead")
  Future<String> getTRexRunnerHtml() {
    throw UnimplementedError(
        'getTRexRunnerHtml is not implemented on the current platform');
  }

  @Deprecated("Use tRexRunnerCss instead")
  Future<String> getTRexRunnerCss() {
    throw UnimplementedError(
        'getTRexRunnerCss is not implemented on the current platform');
  }

  @Deprecated('Use getZoomScale instead')
  Future<double?> getScale() {
    throw UnimplementedError(
        'getScale is not implemented on the current platform');
  }

  @Deprecated("Use setSafeBrowsingAllowlist instead")
  Future<bool> setSafeBrowsingWhitelist({required List<String> hosts}) {
    throw UnimplementedError(
        'setSafeBrowsingWhitelist is not implemented on the current platform');
  }

  void dispose({bool isKeepAlive = false}) {
    throw UnimplementedError(
        'dispose is not implemented on the current platform');
  }
}
