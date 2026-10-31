import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

import 'chrome_safari_browser/chrome_safari_browser.dart';
import 'cookie_manager.dart';
import 'http_auth_credentials_database.dart';
import 'find_interaction/main.dart';
import 'in_app_browser/in_app_browser.dart';
import 'in_app_webview/main.dart';
import 'print_job/main.dart';
import 'pull_to_refresh/main.dart';
import 'web_message/main.dart';
import 'web_storage/main.dart';
import 'process_global_config.dart';
import 'proxy_controller.dart';
import 'service_worker_controller.dart';
import 'tracing_controller.dart';
import 'webview_asset_loader.dart';
import 'webview_feature.dart' as wv;

class AndroidInAppWebViewPlatform extends InAppWebViewPlatform {
  static void registerWith() {
    InAppWebViewPlatform.instance = AndroidInAppWebViewPlatform();
  }

  @override
  AndroidCookieManager createPlatformCookieManager(
    PlatformCookieManagerCreationParams params,
  ) {
    return AndroidCookieManager(params);
  }

  @override
  AndroidInAppWebViewController createPlatformInAppWebViewController(
    PlatformInAppWebViewControllerCreationParams params,
  ) {
    return AndroidInAppWebViewController(params);
  }

  @override
  AndroidInAppWebViewController createPlatformInAppWebViewControllerStatic() {
    return AndroidInAppWebViewController.static();
  }

  @override
  AndroidInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    return AndroidInAppWebViewWidget(params);
  }

  @override
  AndroidFindInteractionController createPlatformFindInteractionController(
    PlatformFindInteractionControllerCreationParams params,
  ) {
    return AndroidFindInteractionController(params);
  }

  @override
  AndroidPrintJobController createPlatformPrintJobController(
    PlatformPrintJobControllerCreationParams params,
  ) {
    return AndroidPrintJobController(params);
  }

  @override
  AndroidPullToRefreshController createPlatformPullToRefreshController(
    PlatformPullToRefreshControllerCreationParams params,
  ) {
    return AndroidPullToRefreshController(params);
  }

  @override
  AndroidWebMessageChannel createPlatformWebMessageChannel(
    PlatformWebMessageChannelCreationParams params,
  ) {
    return AndroidWebMessageChannel(params);
  }

  @override
  AndroidWebMessageChannel createPlatformWebMessageChannelStatic() {
    return AndroidWebMessageChannel.static();
  }

  @override
  AndroidWebMessageListener createPlatformWebMessageListener(
    PlatformWebMessageListenerCreationParams params,
  ) {
    return AndroidWebMessageListener(params);
  }

  @override
  AndroidJavaScriptReplyProxy createPlatformJavaScriptReplyProxy(
    PlatformJavaScriptReplyProxyCreationParams params,
  ) {
    return AndroidJavaScriptReplyProxy(params);
  }

  @override
  AndroidWebMessagePort createPlatformWebMessagePort(
    PlatformWebMessagePortCreationParams params,
  ) {
    return AndroidWebMessagePort(params);
  }

  @override
  AndroidWebStorage createPlatformWebStorage(
    PlatformWebStorageCreationParams params,
  ) {
    return AndroidWebStorage(params);
  }

  @override
  AndroidLocalStorage createPlatformLocalStorage(
    PlatformLocalStorageCreationParams params,
  ) {
    return AndroidLocalStorage(params);
  }

  @override
  AndroidSessionStorage createPlatformSessionStorage(
    PlatformSessionStorageCreationParams params,
  ) {
    return AndroidSessionStorage(params);
  }

  @override
  AndroidHeadlessInAppWebView createPlatformHeadlessInAppWebView(
    PlatformHeadlessInAppWebViewCreationParams params,
  ) {
    return AndroidHeadlessInAppWebView(params);
  }

  @override
  AndroidHttpAuthCredentialDatabase createPlatformHttpAuthCredentialDatabase(
    PlatformHttpAuthCredentialDatabaseCreationParams params,
  ) {
    return AndroidHttpAuthCredentialDatabase(params);
  }

  @override
  AndroidInAppBrowser createPlatformInAppBrowser(
    PlatformInAppBrowserCreationParams params,
  ) {
    return AndroidInAppBrowser(params);
  }

  @override
  AndroidInAppBrowser createPlatformInAppBrowserStatic() {
    return AndroidInAppBrowser.static();
  }

  @override
  AndroidProcessGlobalConfig createPlatformProcessGlobalConfig(
    PlatformProcessGlobalConfigCreationParams params,
  ) {
    return AndroidProcessGlobalConfig(params);
  }

  @override
  AndroidProxyController createPlatformProxyController(
    PlatformProxyControllerCreationParams params,
  ) {
    return AndroidProxyController(params);
  }

  @override
  AndroidServiceWorkerController createPlatformServiceWorkerController(
    PlatformServiceWorkerControllerCreationParams params,
  ) {
    return AndroidServiceWorkerController(params);
  }

  @override
  AndroidServiceWorkerController createPlatformServiceWorkerControllerStatic() {
    return AndroidServiceWorkerController.static();
  }

  @override
  AndroidTracingController createPlatformTracingController(
    PlatformTracingControllerCreationParams params,
  ) {
    return AndroidTracingController(params);
  }

  @override
  AndroidAssetsPathHandler createPlatformAssetsPathHandler(
    PlatformAssetsPathHandlerCreationParams params,
  ) {
    return AndroidAssetsPathHandler(params);
  }

  @override
  AndroidResourcesPathHandler createPlatformResourcesPathHandler(
    PlatformResourcesPathHandlerCreationParams params,
  ) {
    return AndroidResourcesPathHandler(params);
  }

  @override
  AndroidInternalStoragePathHandler createPlatformInternalStoragePathHandler(
    PlatformInternalStoragePathHandlerCreationParams params,
  ) {
    return AndroidInternalStoragePathHandler(params);
  }

  @override
  AndroidCustomPathHandler createPlatformCustomPathHandler(
    PlatformCustomPathHandlerCreationParams params,
  ) {
    return AndroidCustomPathHandler(params);
  }

  @override
  wv.AndroidWebViewFeature createPlatformWebViewFeature(
    PlatformWebViewFeatureCreationParams params,
  ) {
    return wv.AndroidWebViewFeature(params);
  }

  @override
  wv.AndroidWebViewFeature createPlatformWebViewFeatureStatic() {
    return wv.AndroidWebViewFeature.static();
  }

  @override
  AndroidChromeSafariBrowser createPlatformChromeSafariBrowser(
    PlatformChromeSafariBrowserCreationParams params,
  ) {
    return AndroidChromeSafariBrowser(params);
  }

  @override
  AndroidChromeSafariBrowser createPlatformChromeSafariBrowserStatic() {
    return AndroidChromeSafariBrowser.static();
  }

  @override
  AndroidWebStorageManager createPlatformWebStorageManager(
      PlatformWebStorageManagerCreationParams params) {
    return AndroidWebStorageManager(params);
  }
}
