import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'chrome_safari_browser/platform_chrome_safari_browser.dart';
import 'find_interaction/platform_find_interaction_controller.dart';
import 'in_app_browser/platform_in_app_browser.dart';
import 'in_app_webview/platform_headless_in_app_webview.dart';
import 'in_app_webview/platform_inappwebview_controller.dart';
import 'in_app_webview/platform_inappwebview_widget.dart';
import 'platform_cookie_manager.dart';
import 'platform_http_auth_credentials_database.dart';
import 'platform_in_app_localhost_server.dart';
import 'print_job/platform_print_job_controller.dart';
import 'pull_to_refresh/platform_pull_to_refresh_controller.dart';
import 'web_authentication_session/platform_web_authenticate_session.dart';
import 'web_message/platform_web_message_channel.dart';
import 'web_message/platform_web_message_listener.dart';
import 'web_message/platform_web_message_port.dart';
import 'web_storage/platform_web_storage.dart';
import 'web_storage/platform_web_storage_manager.dart';
import 'platform_process_global_config.dart';
import 'platform_proxy_controller.dart';
import 'platform_service_worker_controller.dart';
import 'platform_tracing_controller.dart';
import 'platform_webview_asset_loader.dart';
import 'platform_webview_feature.dart';
import 'in_app_localhost_server.dart';
import 'webview_environment/platform_webview_environment.dart';

abstract class InAppWebViewPlatform extends PlatformInterface {
  InAppWebViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static InAppWebViewPlatform? _instance;

  static InAppWebViewPlatform? get instance => _instance;

  static set instance(InAppWebViewPlatform? instance) {
    if (instance == null) {
      throw AssertionError(
          'Platform interfaces can only be set to a non-null instance');
    }

    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  PlatformCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformCookieManager is not implemented on the current platform.');
  }

  PlatformInAppWebViewController createPlatformInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformInAppWebViewController is not implemented on the current platform.');
  }

  PlatformInAppWebViewController createPlatformInAppWebViewControllerStatic() {
    throw UnimplementedError(
        'createPlatformInAppWebViewControllerStatic is not implemented on the current platform.');
  }

  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformInAppWebViewWidget is not implemented on the current platform.');
  }

  PlatformFindInteractionController createPlatformFindInteractionController(
    PlatformFindInteractionControllerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformFindInteractionController is not implemented on the current platform.');
  }

  PlatformPrintJobController createPlatformPrintJobController(
    PlatformPrintJobControllerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformPrintJobController is not implemented on the current platform.');
  }

  PlatformPullToRefreshController createPlatformPullToRefreshController(
    PlatformPullToRefreshControllerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformPullToRefreshController is not implemented on the current platform.');
  }

  PlatformWebAuthenticationSession createPlatformWebAuthenticationSession(
    PlatformWebAuthenticationSessionCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformWebAuthenticationSession is not implemented on the current platform.');
  }

  PlatformWebAuthenticationSession
      createPlatformWebAuthenticationSessionStatic() {
    throw UnimplementedError(
        'createPlatformWebAuthenticationSessionStatic is not implemented on the current platform.');
  }

  PlatformWebMessageChannel createPlatformWebMessageChannel(
    PlatformWebMessageChannelCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformWebMessageChannel is not implemented on the current platform.');
  }

  PlatformWebMessageChannel createPlatformWebMessageChannelStatic() {
    throw UnimplementedError(
        'createPlatformWebMessageChannelStatic is not implemented on the current platform.');
  }

  PlatformWebMessageListener createPlatformWebMessageListener(
    PlatformWebMessageListenerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformWebMessageListener is not implemented on the current platform.');
  }

  PlatformJavaScriptReplyProxy createPlatformJavaScriptReplyProxy(
    PlatformJavaScriptReplyProxyCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformJavaScriptReplyProxy is not implemented on the current platform.');
  }

  PlatformWebMessagePort createPlatformWebMessagePort(
    PlatformWebMessagePortCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformWebMessagePort is not implemented on the current platform.');
  }

  PlatformWebStorage createPlatformWebStorage(
    PlatformWebStorageCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformWebStorage is not implemented on the current platform.');
  }

  PlatformLocalStorage createPlatformLocalStorage(
    PlatformLocalStorageCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformLocalStorage is not implemented on the current platform.');
  }

  PlatformSessionStorage createPlatformSessionStorage(
    PlatformSessionStorageCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformSessionStorage is not implemented on the current platform.');
  }

  PlatformHeadlessInAppWebView createPlatformHeadlessInAppWebView(
    PlatformHeadlessInAppWebViewCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformHeadlessInAppWebView is not implemented on the current platform.');
  }

  PlatformWebStorageManager createPlatformWebStorageManager(
    PlatformWebStorageManagerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformWebStorageManager is not implemented on the current platform.');
  }

  PlatformHttpAuthCredentialDatabase createPlatformHttpAuthCredentialDatabase(
    PlatformHttpAuthCredentialDatabaseCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformHttpAuthCredentialDatabase is not implemented on the current platform.');
  }

  PlatformInAppBrowser createPlatformInAppBrowser(
    PlatformInAppBrowserCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformInAppBrowser is not implemented on the current platform.');
  }

  PlatformInAppBrowser createPlatformInAppBrowserStatic() {
    throw UnimplementedError(
        'createPlatformInAppBrowserStatic is not implemented on the current platform.');
  }

  PlatformProcessGlobalConfig createPlatformProcessGlobalConfig(
    PlatformProcessGlobalConfigCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformProcessGlobalConfig is not implemented on the current platform.');
  }

  PlatformProxyController createPlatformProxyController(
    PlatformProxyControllerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformProxyController is not implemented on the current platform.');
  }

  PlatformServiceWorkerController createPlatformServiceWorkerController(
    PlatformServiceWorkerControllerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformServiceWorkerController is not implemented on the current platform.');
  }

  PlatformServiceWorkerController
      createPlatformServiceWorkerControllerStatic() {
    throw UnimplementedError(
        'createPlatformServiceWorkerControllerStatic is not implemented on the current platform.');
  }

  PlatformTracingController createPlatformTracingController(
    PlatformTracingControllerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformTracingController is not implemented on the current platform.');
  }

  PlatformAssetsPathHandler createPlatformAssetsPathHandler(
    PlatformAssetsPathHandlerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformAssetsPathHandler is not implemented on the current platform.');
  }

  PlatformResourcesPathHandler createPlatformResourcesPathHandler(
    PlatformResourcesPathHandlerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformResourcesPathHandler is not implemented on the current platform.');
  }

  PlatformInternalStoragePathHandler createPlatformInternalStoragePathHandler(
    PlatformInternalStoragePathHandlerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformInternalStoragePathHandler is not implemented on the current platform.');
  }

  PlatformCustomPathHandler createPlatformCustomPathHandler(
    PlatformCustomPathHandlerCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformCustomPathHandler is not implemented on the current platform.');
  }

  PlatformWebViewFeature createPlatformWebViewFeature(
    PlatformWebViewFeatureCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformWebViewFeature is not implemented on the current platform.');
  }

  PlatformWebViewFeature createPlatformWebViewFeatureStatic() {
    throw UnimplementedError(
        'createPlatformWebViewFeatureStatic is not implemented on the current platform.');
  }

  PlatformInAppLocalhostServer createPlatformInAppLocalhostServer(
      PlatformInAppLocalhostServerCreationParams params) {
    return DefaultInAppLocalhostServer(params);
  }

  PlatformChromeSafariBrowser createPlatformChromeSafariBrowser(
    PlatformChromeSafariBrowserCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformChromeSafariBrowser is not implemented on the current platform.');
  }

  PlatformChromeSafariBrowser createPlatformChromeSafariBrowserStatic() {
    throw UnimplementedError(
        'createPlatformChromeSafariBrowserStatic is not implemented on the current platform.');
  }

  PlatformWebViewEnvironment createPlatformWebViewEnvironment(
    PlatformWebViewEnvironmentCreationParams params,
  ) {
    throw UnimplementedError(
        'createPlatformWebViewEnvironment is not implemented on the current platform.');
  }

  PlatformWebViewEnvironment createPlatformWebViewEnvironmentStatic() {
    throw UnimplementedError(
        'createPlatformWebViewEnvironmentStatic is not implemented on the current platform.');
  }
}
