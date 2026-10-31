import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'inappwebview_platform.dart';
import 'types/main.dart';

@immutable
class PlatformServiceWorkerControllerCreationParams {
  const PlatformServiceWorkerControllerCreationParams();
}

abstract class PlatformServiceWorkerController extends PlatformInterface {
  factory PlatformServiceWorkerController(
      PlatformServiceWorkerControllerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformServiceWorkerController serviceWorkerController =
        InAppWebViewPlatform.instance!
            .createPlatformServiceWorkerController(params);
    PlatformInterface.verify(serviceWorkerController, _token);
    return serviceWorkerController;
  }

  factory PlatformServiceWorkerController.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformServiceWorkerController serviceWorkerControllerStatic =
        InAppWebViewPlatform.instance!
            .createPlatformServiceWorkerControllerStatic();
    PlatformInterface.verify(serviceWorkerControllerStatic, _token);
    return serviceWorkerControllerStatic;
  }

  @protected
  PlatformServiceWorkerController.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformServiceWorkerControllerCreationParams params;

  ServiceWorkerClient? get serviceWorkerClient;

  Future<void> setServiceWorkerClient(ServiceWorkerClient? value) {
    throw UnimplementedError(
        'setServiceWorkerClient is not implemented on the current platform');
  }

  Future<bool> getAllowContentAccess() {
    throw UnimplementedError(
        'getAllowContentAccess is not implemented on the current platform');
  }

  Future<bool> getAllowFileAccess() {
    throw UnimplementedError(
        'getAllowFileAccess is not implemented on the current platform');
  }

  Future<bool> getBlockNetworkLoads() {
    throw UnimplementedError(
        'getBlockNetworkLoads is not implemented on the current platform');
  }

  Future<CacheMode?> getCacheMode() {
    throw UnimplementedError(
        'getCacheMode is not implemented on the current platform');
  }

  Future<void> setAllowContentAccess(bool allow) {
    throw UnimplementedError(
        'setAllowContentAccess is not implemented on the current platform');
  }

  Future<void> setAllowFileAccess(bool allow) {
    throw UnimplementedError(
        'setAllowFileAccess is not implemented on the current platform');
  }

  Future<void> setBlockNetworkLoads(bool flag) {
    throw UnimplementedError(
        'setBlockNetworkLoads is not implemented on the current platform');
  }

  Future<void> setCacheMode(CacheMode mode) {
    throw UnimplementedError(
        'setCacheMode is not implemented on the current platform');
  }
}

class ServiceWorkerClient {
  final Future<WebResourceResponse?> Function(WebResourceRequest request)?
      shouldInterceptRequest;

  ServiceWorkerClient({this.shouldInterceptRequest});
}
