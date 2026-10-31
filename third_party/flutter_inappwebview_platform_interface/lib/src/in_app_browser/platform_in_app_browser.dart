import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/src/types/disposable.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../context_menu/context_menu.dart';
import '../find_interaction/platform_find_interaction_controller.dart';
import '../inappwebview_platform.dart';
import '../pull_to_refresh/main.dart';
import '../types/main.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import '../in_app_webview/in_app_webview_settings.dart';

import '../print_job/main.dart';
import '../web_uri.dart';
import '../webview_environment/platform_webview_environment.dart';
import 'in_app_browser_menu_item.dart';
import 'in_app_browser_settings.dart';
import '../debug_logging_settings.dart';
import '../pull_to_refresh/platform_pull_to_refresh_controller.dart';

@immutable
class PlatformInAppBrowserCreationParams {
  const PlatformInAppBrowserCreationParams({
    this.contextMenu,
    this.pullToRefreshController,
    this.findInteractionController,
    this.initialUserScripts,
    this.windowId,
    this.webViewEnvironment,
  });

  final ContextMenu? contextMenu;

  final PlatformPullToRefreshController? pullToRefreshController;

  final PlatformFindInteractionController? findInteractionController;

  final UnmodifiableListView<UserScript>? initialUserScripts;

  final int? windowId;

  final PlatformWebViewEnvironment? webViewEnvironment;
}

abstract class PlatformInAppBrowser extends PlatformInterface
    implements Disposable {
  static DebugLoggingSettings debugLoggingSettings = DebugLoggingSettings();

  PlatformInAppBrowserEvents? eventHandler;

  String get id {
    throw UnimplementedError('id is not implemented on the current platform');
  }

  ContextMenu? get contextMenu => params.contextMenu;

  PlatformPullToRefreshController? get pullToRefreshController =>
      params.pullToRefreshController;

  PlatformFindInteractionController? get findInteractionController =>
      params.findInteractionController;

  UnmodifiableListView<UserScript>? get initialUserScripts =>
      params.initialUserScripts;

  int? get windowId => params.windowId;

  PlatformInAppWebViewController? get webViewController {
    throw UnimplementedError(
        'webViewController is not implemented on the current platform');
  }

  factory PlatformInAppBrowser(PlatformInAppBrowserCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformInAppBrowser inAppBrowser =
        InAppWebViewPlatform.instance!.createPlatformInAppBrowser(params);
    PlatformInterface.verify(inAppBrowser, _token);
    return inAppBrowser;
  }

  factory PlatformInAppBrowser.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformInAppBrowser inAppBrowserStatic =
        InAppWebViewPlatform.instance!.createPlatformInAppBrowserStatic();
    PlatformInterface.verify(inAppBrowserStatic, _token);
    return inAppBrowserStatic;
  }

  @protected
  PlatformInAppBrowser.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformInAppBrowserCreationParams params;

  Future<void> openUrlRequest(
      {required URLRequest urlRequest,
      // ignore: deprecated_member_use_from_same_package
      @Deprecated('Use settings instead') InAppBrowserClassOptions? options,
      InAppBrowserClassSettings? settings}) {
    throw UnimplementedError(
        'openUrlRequest is not implemented on the current platform');
  }

  Future<void> openFile(
      {required String assetFilePath,
      // ignore: deprecated_member_use_from_same_package
      @Deprecated('Use settings instead') InAppBrowserClassOptions? options,
      InAppBrowserClassSettings? settings}) {
    throw UnimplementedError(
        'openFile is not implemented on the current platform');
  }

  Future<void> openData(
      {required String data,
      String mimeType = "text/html",
      String encoding = "utf8",
      WebUri? baseUrl,
      @Deprecated("Use historyUrl instead") Uri? androidHistoryUrl,
      WebUri? historyUrl,
      // ignore: deprecated_member_use_from_same_package
      @Deprecated('Use settings instead') InAppBrowserClassOptions? options,
      InAppBrowserClassSettings? settings}) {
    throw UnimplementedError(
        'openData is not implemented on the current platform');
  }

  Future<void> openWithSystemBrowser({required WebUri url}) {
    throw UnimplementedError(
        'openWithSystemBrowser is not implemented on the current platform');
  }

  void addMenuItem(InAppBrowserMenuItem menuItem) {
    throw UnimplementedError(
        'addMenuItem is not implemented on the current platform');
  }

  void addMenuItems(List<InAppBrowserMenuItem> menuItems) {
    throw UnimplementedError(
        'addMenuItems is not implemented on the current platform');
  }

  bool removeMenuItem(InAppBrowserMenuItem menuItem) {
    throw UnimplementedError(
        'removeMenuItem is not implemented on the current platform');
  }

  void removeMenuItems(List<InAppBrowserMenuItem> menuItems) {
    throw UnimplementedError(
        'removeMenuItems is not implemented on the current platform');
  }

  void removeAllMenuItem() {
    throw UnimplementedError(
        'removeAllMenuItem is not implemented on the current platform');
  }

  bool hasMenuItem(InAppBrowserMenuItem menuItem) {
    throw UnimplementedError(
        'hasMenuItem is not implemented on the current platform');
  }

  Future<void> show() {
    throw UnimplementedError('show is not implemented on the current platform');
  }

  Future<void> hide() {
    throw UnimplementedError('hide is not implemented on the current platform');
  }

  Future<void> close() {
    throw UnimplementedError(
        'close is not implemented on the current platform');
  }

  Future<bool> isHidden() {
    throw UnimplementedError(
        'isHidden is not implemented on the current platform');
  }

  @Deprecated('Use setSettings instead')
  Future<void> setOptions({required InAppBrowserClassOptions options}) {
    throw UnimplementedError(
        'setOptions is not implemented on the current platform');
  }

  @Deprecated('Use getSettings instead')
  Future<InAppBrowserClassOptions?> getOptions() {
    throw UnimplementedError(
        'getOptions is not implemented on the current platform');
  }

  Future<void> setSettings({required InAppBrowserClassSettings settings}) {
    throw UnimplementedError(
        'setSettings is not implemented on the current platform');
  }

  Future<InAppBrowserClassSettings?> getSettings() {
    throw UnimplementedError(
        'getSettings is not implemented on the current platform');
  }

  bool isOpened() {
    throw UnimplementedError(
        'isOpened is not implemented on the current platform');
  }

  @override
  @mustCallSuper
  void dispose() {
    eventHandler = null;
  }
}

abstract class PlatformInAppBrowserEvents {
  void onBrowserCreated() {}

  void onExit() {}

  void onMainWindowWillClose() {}

  void onLoadStart(WebUri? url) {}

  void onLoadStop(WebUri? url) {}

  @Deprecated("Use onReceivedError instead")
  void onLoadError(Uri? url, int code, String message) {}

  void onReceivedError(WebResourceRequest request, WebResourceError error) {}

  @Deprecated("Use onReceivedHttpError instead")
  void onLoadHttpError(Uri? url, int statusCode, String description) {}

  void onReceivedHttpError(
      WebResourceRequest request, WebResourceResponse errorResponse) {}

  void onProgressChanged(int progress) {}

  void onConsoleMessage(ConsoleMessage consoleMessage) {}

  Future<NavigationActionPolicy?>? shouldOverrideUrlLoading(
      NavigationAction navigationAction) {
    return null;
  }

  void onLoadResource(LoadedResource resource) {}

  void onScrollChanged(int x, int y) {}

  @Deprecated('Use onDownloadStartRequest instead')
  void onDownloadStart(Uri url) {}

  void onDownloadStartRequest(DownloadStartRequest downloadStartRequest) {}

  @Deprecated('Use onLoadResourceWithCustomScheme instead')
  Future<CustomSchemeResponse?>? onLoadResourceCustomScheme(Uri url) {
    return null;
  }

  Future<CustomSchemeResponse?>? onLoadResourceWithCustomScheme(
      WebResourceRequest request) {
    return null;
  }

  Future<bool?>? onCreateWindow(CreateWindowAction createWindowAction) {
    return null;
  }

  void onCloseWindow() {}

  void onWindowFocus() {}

  void onWindowBlur() {}

  Future<JsAlertResponse?>? onJsAlert(JsAlertRequest jsAlertRequest) {
    return null;
  }

  Future<JsConfirmResponse?>? onJsConfirm(JsConfirmRequest jsConfirmRequest) {
    return null;
  }

  Future<JsPromptResponse?>? onJsPrompt(JsPromptRequest jsPromptRequest) {
    return null;
  }

  Future<HttpAuthResponse?>? onReceivedHttpAuthRequest(
      URLAuthenticationChallenge challenge) {
    return null;
  }

  Future<ServerTrustAuthResponse?>? onReceivedServerTrustAuthRequest(
      URLAuthenticationChallenge challenge) {
    return null;
  }

  Future<ClientCertResponse?>? onReceivedClientCertRequest(
      URLAuthenticationChallenge challenge) {
    return null;
  }

  @Deprecated('Use FindInteractionController.onFindResultReceived instead')
  void onFindResultReceived(
      int activeMatchOrdinal, int numberOfMatches, bool isDoneCounting) {}

  Future<AjaxRequest?>? shouldInterceptAjaxRequest(AjaxRequest ajaxRequest) {
    return null;
  }

  Future<AjaxRequestAction?>? onAjaxReadyStateChange(AjaxRequest ajaxRequest) {
    return null;
  }

  Future<AjaxRequestAction?>? onAjaxProgress(AjaxRequest ajaxRequest) {
    return null;
  }

  Future<FetchRequest?>? shouldInterceptFetchRequest(
      FetchRequest fetchRequest) {
    return null;
  }

  void onUpdateVisitedHistory(WebUri? url, bool? isReload) {}

  @Deprecated("Use onPrintRequest instead")
  void onPrint(Uri? url) {}

  Future<bool?>? onPrintRequest(
      WebUri? url, PlatformPrintJobController? printJobController) {
    return null;
  }

  void onLongPressHitTestResult(InAppWebViewHitTestResult hitTestResult) {}

  void onEnterFullscreen() {}

  void onExitFullscreen() {}

  void onPageCommitVisible(WebUri? url) {}

  void onTitleChanged(String? title) {}

  void onOverScrolled(int x, int y, bool clampedX, bool clampedY) {}

  void onZoomScaleChanged(double oldScale, double newScale) {}

  @Deprecated("Use onSafeBrowsingHit instead")
  Future<SafeBrowsingResponse?>? androidOnSafeBrowsingHit(
      Uri url, SafeBrowsingThreat? threatType) {
    return null;
  }

  Future<SafeBrowsingResponse?>? onSafeBrowsingHit(
      WebUri url, SafeBrowsingThreat? threatType) {
    return null;
  }

  @Deprecated("Use onPermissionRequest instead")
  Future<PermissionRequestResponse?>? androidOnPermissionRequest(
      String origin, List<String> resources) {
    return null;
  }

  Future<PermissionResponse?>? onPermissionRequest(
      PermissionRequest permissionRequest) {
    return null;
  }

  @Deprecated("Use onGeolocationPermissionsShowPrompt instead")
  Future<GeolocationPermissionShowPromptResponse?>?
      androidOnGeolocationPermissionsShowPrompt(String origin) {
    return null;
  }

  Future<GeolocationPermissionShowPromptResponse?>?
      onGeolocationPermissionsShowPrompt(String origin) {
    return null;
  }

  @Deprecated("Use onGeolocationPermissionsHidePrompt instead")
  void androidOnGeolocationPermissionsHidePrompt() {}

  void onGeolocationPermissionsHidePrompt() {}

  @Deprecated("Use shouldInterceptRequest instead")
  Future<WebResourceResponse?>? androidShouldInterceptRequest(
      WebResourceRequest request) {
    return null;
  }

  Future<WebResourceResponse?>? shouldInterceptRequest(
      WebResourceRequest request) {
    return null;
  }

  @Deprecated("Use onRenderProcessUnresponsive instead")
  Future<WebViewRenderProcessAction?>? androidOnRenderProcessUnresponsive(
      Uri? url) {
    return null;
  }

  Future<WebViewRenderProcessAction?>? onRenderProcessUnresponsive(
      WebUri? url) {
    return null;
  }

  @Deprecated("Use onRenderProcessResponsive instead")
  Future<WebViewRenderProcessAction?>? androidOnRenderProcessResponsive(
      Uri? url) {
    return null;
  }

  Future<WebViewRenderProcessAction?>? onRenderProcessResponsive(WebUri? url) {
    return null;
  }

  @Deprecated("Use onRenderProcessGone instead")
  void androidOnRenderProcessGone(RenderProcessGoneDetail detail) {}

  void onRenderProcessGone(RenderProcessGoneDetail detail) {}

  @Deprecated('Use onFormResubmission instead')
  Future<FormResubmissionAction?>? androidOnFormResubmission(Uri? url) {
    return null;
  }

  Future<FormResubmissionAction?>? onFormResubmission(WebUri? url) {
    return null;
  }

  @Deprecated('Use onZoomScaleChanged instead')
  void androidOnScaleChanged(double oldScale, double newScale) {}

  @Deprecated('Use onReceivedIcon instead')
  void androidOnReceivedIcon(Uint8List icon) {}

  void onReceivedIcon(Uint8List icon) {}

  @Deprecated('Use onReceivedTouchIconUrl instead')
  void androidOnReceivedTouchIconUrl(Uri url, bool precomposed) {}

  void onReceivedTouchIconUrl(WebUri url, bool precomposed) {}

  @Deprecated('Use onJsBeforeUnload instead')
  Future<JsBeforeUnloadResponse?>? androidOnJsBeforeUnload(
      JsBeforeUnloadRequest jsBeforeUnloadRequest) {
    return null;
  }

  Future<JsBeforeUnloadResponse?>? onJsBeforeUnload(
      JsBeforeUnloadRequest jsBeforeUnloadRequest) {
    return null;
  }

  @Deprecated('Use onReceivedLoginRequest instead')
  void androidOnReceivedLoginRequest(LoginRequest loginRequest) {}

  void onReceivedLoginRequest(LoginRequest loginRequest) {}

  void onPermissionRequestCanceled(PermissionRequest permissionRequest) {}

  void onRequestFocus() {}

  @Deprecated('Use onWebContentProcessDidTerminate instead')
  void iosOnWebContentProcessDidTerminate() {}

  void onWebContentProcessDidTerminate() {}

  @Deprecated('Use onDidReceiveServerRedirectForProvisionalNavigation instead')
  void iosOnDidReceiveServerRedirectForProvisionalNavigation() {}

  void onDidReceiveServerRedirectForProvisionalNavigation() {}

  @Deprecated('Use onNavigationResponse instead')
  Future<IOSNavigationResponseAction?>? iosOnNavigationResponse(
      IOSWKNavigationResponse navigationResponse) {
    return null;
  }

  Future<NavigationResponseAction?>? onNavigationResponse(
      NavigationResponse navigationResponse) {
    return null;
  }

  @Deprecated('Use shouldAllowDeprecatedTLS instead')
  Future<IOSShouldAllowDeprecatedTLSAction?>? iosShouldAllowDeprecatedTLS(
      URLAuthenticationChallenge challenge) {
    return null;
  }

  Future<ShouldAllowDeprecatedTLSAction?>? shouldAllowDeprecatedTLS(
      URLAuthenticationChallenge challenge) {
    return null;
  }

  void onCameraCaptureStateChanged(
    MediaCaptureState? oldState,
    MediaCaptureState? newState,
  ) {}

  void onMicrophoneCaptureStateChanged(
    MediaCaptureState? oldState,
    MediaCaptureState? newState,
  ) {}

  void onContentSizeChanged(Size oldContentSize, Size newContentSize) {}
}
