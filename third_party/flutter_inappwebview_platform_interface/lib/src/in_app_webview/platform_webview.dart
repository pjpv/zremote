import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';

import '../find_interaction/platform_find_interaction_controller.dart';
import '../pull_to_refresh/platform_pull_to_refresh_controller.dart';

import '../context_menu/context_menu.dart';
import '../types/main.dart';

import '../web_uri.dart';
import 'in_app_webview_settings.dart';
import 'platform_inappwebview_controller.dart';
import '../print_job/main.dart';

class PlatformWebViewCreationParams<T> {
  final T Function(PlatformInAppWebViewController controller)?
      controllerFromPlatform;

  final int? windowId;

  final void Function(T controller)? onWebViewCreated;

  final void Function(T controller, WebUri? url)? onLoadStart;

  final void Function(T controller, WebUri? url)? onLoadStop;

  @Deprecated("Use onReceivedError instead")
  final void Function(T controller, Uri? url, int code, String message)?
      onLoadError;

  final void Function(
          T controller, WebResourceRequest request, WebResourceError error)?
      onReceivedError;

  @Deprecated("Use onReceivedHttpError instead")
  final void Function(
          T controller, Uri? url, int statusCode, String description)?
      onLoadHttpError;

  final void Function(T controller, WebResourceRequest request,
      WebResourceResponse errorResponse)? onReceivedHttpError;

  final void Function(T controller, int progress)? onProgressChanged;

  final void Function(T controller, ConsoleMessage consoleMessage)?
      onConsoleMessage;

  final Future<NavigationActionPolicy?> Function(
          T controller, NavigationAction navigationAction)?
      shouldOverrideUrlLoading;

  final void Function(T controller, LoadedResource resource)? onLoadResource;

  final void Function(T controller, int x, int y)? onScrollChanged;

  @Deprecated('Use onDownloadStartRequest instead')
  final void Function(T controller, Uri url)? onDownloadStart;

  final void Function(T controller, DownloadStartRequest downloadStartRequest)?
      onDownloadStartRequest;

  @Deprecated('Use onLoadResourceWithCustomScheme instead')
  final Future<CustomSchemeResponse?> Function(T controller, Uri url)?
      onLoadResourceCustomScheme;

  final Future<CustomSchemeResponse?> Function(
      T controller, WebResourceRequest request)? onLoadResourceWithCustomScheme;

  final Future<bool?> Function(
      T controller, CreateWindowAction createWindowAction)? onCreateWindow;

  final void Function(T controller)? onCloseWindow;

  final void Function(T controller)? onWindowFocus;

  final void Function(T controller)? onWindowBlur;

  final Future<JsAlertResponse?> Function(
      T controller, JsAlertRequest jsAlertRequest)? onJsAlert;

  final Future<JsConfirmResponse?> Function(
      T controller, JsConfirmRequest jsConfirmRequest)? onJsConfirm;

  final Future<JsPromptResponse?> Function(
      T controller, JsPromptRequest jsPromptRequest)? onJsPrompt;

  final Future<HttpAuthResponse?> Function(
          T controller, HttpAuthenticationChallenge challenge)?
      onReceivedHttpAuthRequest;

  final Future<ServerTrustAuthResponse?> Function(
          T controller, ServerTrustChallenge challenge)?
      onReceivedServerTrustAuthRequest;

  final Future<ClientCertResponse?> Function(
      T controller, ClientCertChallenge challenge)? onReceivedClientCertRequest;

  @Deprecated('Use FindInteractionController.onFindResultReceived instead')
  final void Function(T controller, int activeMatchOrdinal, int numberOfMatches,
      bool isDoneCounting)? onFindResultReceived;

  final Future<AjaxRequest?> Function(T controller, AjaxRequest ajaxRequest)?
      shouldInterceptAjaxRequest;

  final Future<AjaxRequestAction?> Function(
      T controller, AjaxRequest ajaxRequest)? onAjaxReadyStateChange;

  final Future<AjaxRequestAction?> Function(
      T controller, AjaxRequest ajaxRequest)? onAjaxProgress;

  final Future<FetchRequest?> Function(T controller, FetchRequest fetchRequest)?
      shouldInterceptFetchRequest;

  final void Function(T controller, WebUri? url, bool? isReload)?
      onUpdateVisitedHistory;

  @Deprecated("Use onPrintRequest instead")
  final void Function(T controller, Uri? url)? onPrint;

  final Future<bool?> Function(T controller, WebUri? url,
      PlatformPrintJobController? printJobController)? onPrintRequest;

  final void Function(T controller, InAppWebViewHitTestResult hitTestResult)?
      onLongPressHitTestResult;

  final void Function(T controller)? onEnterFullscreen;

  final void Function(T controller)? onExitFullscreen;

  final void Function(T controller, WebUri? url)? onPageCommitVisible;

  final void Function(T controller, String? title)? onTitleChanged;

  final void Function(T controller, int x, int y, bool clampedX, bool clampedY)?
      onOverScrolled;

  final void Function(T controller, double oldScale, double newScale)?
      onZoomScaleChanged;

  @Deprecated("Use onSafeBrowsingHit instead")
  final Future<SafeBrowsingResponse?> Function(
          T controller, Uri url, SafeBrowsingThreat? threatType)?
      androidOnSafeBrowsingHit;

  final Future<SafeBrowsingResponse?> Function(
          T controller, WebUri url, SafeBrowsingThreat? threatType)?
      onSafeBrowsingHit;

  @Deprecated("Use onPermissionRequest instead")
  final Future<PermissionRequestResponse?> Function(
          T controller, String origin, List<String> resources)?
      androidOnPermissionRequest;

  final Future<PermissionResponse?> Function(
      T controller, PermissionRequest permissionRequest)? onPermissionRequest;

  @Deprecated("Use onGeolocationPermissionsShowPrompt instead")
  final Future<GeolocationPermissionShowPromptResponse?> Function(
      T controller, String origin)? androidOnGeolocationPermissionsShowPrompt;

  final Future<GeolocationPermissionShowPromptResponse?> Function(
      T controller, String origin)? onGeolocationPermissionsShowPrompt;

  @Deprecated("Use onGeolocationPermissionsHidePrompt instead")
  final void Function(T controller)? androidOnGeolocationPermissionsHidePrompt;

  final void Function(T controller)? onGeolocationPermissionsHidePrompt;

  @Deprecated("Use shouldInterceptRequest instead")
  final Future<WebResourceResponse?> Function(
      T controller, WebResourceRequest request)? androidShouldInterceptRequest;

  final Future<WebResourceResponse?> Function(
      T controller, WebResourceRequest request)? shouldInterceptRequest;

  @Deprecated("Use onRenderProcessUnresponsive instead")
  final Future<WebViewRenderProcessAction?> Function(T controller, Uri? url)?
      androidOnRenderProcessUnresponsive;

  final Future<WebViewRenderProcessAction?> Function(T controller, WebUri? url)?
      onRenderProcessUnresponsive;

  @Deprecated("Use onRenderProcessResponsive instead")
  final Future<WebViewRenderProcessAction?> Function(T controller, Uri? url)?
      androidOnRenderProcessResponsive;

  final Future<WebViewRenderProcessAction?> Function(T controller, WebUri? url)?
      onRenderProcessResponsive;

  @Deprecated("Use onRenderProcessGone instead")
  final void Function(T controller, RenderProcessGoneDetail detail)?
      androidOnRenderProcessGone;

  final void Function(T controller, RenderProcessGoneDetail detail)?
      onRenderProcessGone;

  @Deprecated('Use onFormResubmission instead')
  final Future<FormResubmissionAction?> Function(T controller, Uri? url)?
      androidOnFormResubmission;

  final Future<FormResubmissionAction?> Function(T controller, WebUri? url)?
      onFormResubmission;

  @Deprecated('Use onZoomScaleChanged instead')
  final void Function(T controller, double oldScale, double newScale)?
      androidOnScaleChanged;

  @Deprecated('Use onReceivedIcon instead')
  final void Function(T controller, Uint8List icon)? androidOnReceivedIcon;

  final void Function(T controller, Uint8List icon)? onReceivedIcon;

  @Deprecated('Use onReceivedTouchIconUrl instead')
  final void Function(T controller, Uri url, bool precomposed)?
      androidOnReceivedTouchIconUrl;

  final void Function(T controller, WebUri url, bool precomposed)?
      onReceivedTouchIconUrl;

  @Deprecated('Use onJsBeforeUnload instead')
  final Future<JsBeforeUnloadResponse?> Function(
          T controller, JsBeforeUnloadRequest jsBeforeUnloadRequest)?
      androidOnJsBeforeUnload;

  final Future<JsBeforeUnloadResponse?> Function(
          T controller, JsBeforeUnloadRequest jsBeforeUnloadRequest)?
      onJsBeforeUnload;

  @Deprecated('Use onReceivedLoginRequest instead')
  final void Function(T controller, LoginRequest loginRequest)?
      androidOnReceivedLoginRequest;

  final void Function(T controller, LoginRequest loginRequest)?
      onReceivedLoginRequest;

  final void Function(T controller, PermissionRequest permissionRequest)?
      onPermissionRequestCanceled;

  final void Function(T controller)? onRequestFocus;

  @Deprecated('Use onWebContentProcessDidTerminate instead')
  final void Function(T controller)? iosOnWebContentProcessDidTerminate;

  final void Function(T controller)? onWebContentProcessDidTerminate;

  @Deprecated('Use onDidReceiveServerRedirectForProvisionalNavigation instead')
  final void Function(T controller)?
      iosOnDidReceiveServerRedirectForProvisionalNavigation;

  final void Function(T controller)?
      onDidReceiveServerRedirectForProvisionalNavigation;

  @Deprecated('Use onNavigationResponse instead')
  final Future<IOSNavigationResponseAction?> Function(
          T controller, IOSWKNavigationResponse navigationResponse)?
      iosOnNavigationResponse;

  final Future<NavigationResponseAction?> Function(
          T controller, NavigationResponse navigationResponse)?
      onNavigationResponse;

  @Deprecated('Use shouldAllowDeprecatedTLS instead')
  final Future<IOSShouldAllowDeprecatedTLSAction?> Function(
          T controller, URLAuthenticationChallenge challenge)?
      iosShouldAllowDeprecatedTLS;

  final Future<ShouldAllowDeprecatedTLSAction?> Function(
          T controller, URLAuthenticationChallenge challenge)?
      shouldAllowDeprecatedTLS;

  final Future<void> Function(
    T controller,
    MediaCaptureState? oldState,
    MediaCaptureState? newState,
  )? onCameraCaptureStateChanged;

  final Future<void> Function(
    T controller,
    MediaCaptureState? oldState,
    MediaCaptureState? newState,
  )? onMicrophoneCaptureStateChanged;

  final void Function(T controller, Size oldContentSize, Size newContentSize)?
      onContentSizeChanged;

  final URLRequest? initialUrlRequest;

  final String? initialFile;

  final InAppWebViewInitialData? initialData;

  @Deprecated('Use initialSettings instead')
  final InAppWebViewGroupOptions? initialOptions;

  final InAppWebViewSettings? initialSettings;

  final ContextMenu? contextMenu;

  final UnmodifiableListView<UserScript>? initialUserScripts;

  final PlatformPullToRefreshController? pullToRefreshController;

  final PlatformFindInteractionController? findInteractionController;

  const PlatformWebViewCreationParams(
      {this.controllerFromPlatform,
      this.windowId,
      this.onWebViewCreated,
      this.onLoadStart,
      this.onLoadStop,
      @Deprecated('Use onReceivedError instead') this.onLoadError,
      this.onReceivedError,
      @Deprecated("Use onReceivedHttpError instead") this.onLoadHttpError,
      this.onReceivedHttpError,
      this.onProgressChanged,
      this.onConsoleMessage,
      this.shouldOverrideUrlLoading,
      this.onLoadResource,
      this.onScrollChanged,
      @Deprecated('Use onDownloadStartRequest instead') this.onDownloadStart,
      this.onDownloadStartRequest,
      @Deprecated('Use onLoadResourceWithCustomScheme instead')
      this.onLoadResourceCustomScheme,
      this.onLoadResourceWithCustomScheme,
      this.onCreateWindow,
      this.onCloseWindow,
      this.onJsAlert,
      this.onJsConfirm,
      this.onJsPrompt,
      this.onReceivedHttpAuthRequest,
      this.onReceivedServerTrustAuthRequest,
      this.onReceivedClientCertRequest,
      @Deprecated('Use FindInteractionController.onFindResultReceived instead')
      this.onFindResultReceived,
      this.shouldInterceptAjaxRequest,
      this.onAjaxReadyStateChange,
      this.onAjaxProgress,
      this.shouldInterceptFetchRequest,
      this.onUpdateVisitedHistory,
      @Deprecated("Use onPrintRequest instead") this.onPrint,
      this.onPrintRequest,
      this.onLongPressHitTestResult,
      this.onEnterFullscreen,
      this.onExitFullscreen,
      this.onPageCommitVisible,
      this.onTitleChanged,
      this.onWindowFocus,
      this.onWindowBlur,
      this.onOverScrolled,
      this.onZoomScaleChanged,
      @Deprecated('Use onSafeBrowsingHit instead')
      this.androidOnSafeBrowsingHit,
      this.onSafeBrowsingHit,
      @Deprecated('Use onPermissionRequest instead')
      this.androidOnPermissionRequest,
      this.onPermissionRequest,
      @Deprecated('Use onGeolocationPermissionsShowPrompt instead')
      this.androidOnGeolocationPermissionsShowPrompt,
      this.onGeolocationPermissionsShowPrompt,
      @Deprecated('Use onGeolocationPermissionsHidePrompt instead')
      this.androidOnGeolocationPermissionsHidePrompt,
      this.onGeolocationPermissionsHidePrompt,
      @Deprecated('Use shouldInterceptRequest instead')
      this.androidShouldInterceptRequest,
      this.shouldInterceptRequest,
      @Deprecated('Use onRenderProcessGone instead')
      this.androidOnRenderProcessGone,
      this.onRenderProcessGone,
      @Deprecated('Use onRenderProcessResponsive instead')
      this.androidOnRenderProcessResponsive,
      this.onRenderProcessResponsive,
      @Deprecated('Use onRenderProcessUnresponsive instead')
      this.androidOnRenderProcessUnresponsive,
      this.onRenderProcessUnresponsive,
      @Deprecated('Use onFormResubmission instead')
      this.androidOnFormResubmission,
      this.onFormResubmission,
      @Deprecated('Use onZoomScaleChanged instead') this.androidOnScaleChanged,
      @Deprecated('Use onReceivedIcon instead') this.androidOnReceivedIcon,
      this.onReceivedIcon,
      @Deprecated('Use onReceivedTouchIconUrl instead')
      this.androidOnReceivedTouchIconUrl,
      this.onReceivedTouchIconUrl,
      @Deprecated('Use onJsBeforeUnload instead') this.androidOnJsBeforeUnload,
      this.onJsBeforeUnload,
      @Deprecated('Use onReceivedLoginRequest instead')
      this.androidOnReceivedLoginRequest,
      this.onReceivedLoginRequest,
      this.onPermissionRequestCanceled,
      this.onRequestFocus,
      @Deprecated('Use onWebContentProcessDidTerminate instead')
      this.iosOnWebContentProcessDidTerminate,
      this.onWebContentProcessDidTerminate,
      @Deprecated(
          'Use onDidReceiveServerRedirectForProvisionalNavigation instead')
      this.iosOnDidReceiveServerRedirectForProvisionalNavigation,
      this.onDidReceiveServerRedirectForProvisionalNavigation,
      @Deprecated('Use onNavigationResponse instead')
      this.iosOnNavigationResponse,
      this.onNavigationResponse,
      @Deprecated('Use shouldAllowDeprecatedTLS instead')
      this.iosShouldAllowDeprecatedTLS,
      this.shouldAllowDeprecatedTLS,
      this.onCameraCaptureStateChanged,
      this.onMicrophoneCaptureStateChanged,
      this.onContentSizeChanged,
      this.initialUrlRequest,
      this.initialFile,
      this.initialData,
      @Deprecated('Use initialSettings instead') this.initialOptions,
      this.initialSettings,
      this.contextMenu,
      this.initialUserScripts,
      this.pullToRefreshController,
      this.findInteractionController});
}
