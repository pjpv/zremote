import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_platform_interface/src/types/disposable.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import '../inappwebview_platform.dart';
import '../types/main.dart';
import 'web_storage_item.dart';

@immutable
class PlatformWebStorageCreationParams {
  const PlatformWebStorageCreationParams(
      {required this.localStorage, required this.sessionStorage});

  final PlatformLocalStorage localStorage;

  final PlatformSessionStorage sessionStorage;
}

abstract class PlatformWebStorage extends PlatformInterface
    implements Disposable {
  factory PlatformWebStorage(PlatformWebStorageCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebStorage webStorage =
        InAppWebViewPlatform.instance!.createPlatformWebStorage(params);
    PlatformInterface.verify(webStorage, _token);
    return webStorage;
  }

  @protected
  PlatformWebStorage.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformWebStorageCreationParams params;

  PlatformLocalStorage get localStorage => params.localStorage;

  PlatformSessionStorage get sessionStorage => params.sessionStorage;

  void dispose() {
    throw UnimplementedError(
        'dispose is not implemented on the current platform');
  }
}

@immutable
class PlatformStorageCreationParams {
  const PlatformStorageCreationParams(
      {required this.controller, required this.webStorageType});

  final PlatformInAppWebViewController? controller;

  final WebStorageType webStorageType;
}

abstract mixin class PlatformStorage implements Disposable {
  PlatformInAppWebViewController? get controller;

  WebStorageType get webStorageType {
    throw UnimplementedError(
        'webStorageType is not implemented on the current platform');
  }

  Future<int?> length() {
    throw UnimplementedError(
        'length is not implemented on the current platform');
  }

  Future<void> setItem({required String key, required dynamic value}) {
    throw UnimplementedError(
        'setItem is not implemented on the current platform');
  }

  Future<dynamic> getItem({required String key}) {
    throw UnimplementedError(
        'getItem is not implemented on the current platform');
  }

  Future<void> removeItem({required String key}) {
    throw UnimplementedError(
        'removeItem is not implemented on the current platform');
  }

  Future<List<WebStorageItem>> getItems() {
    throw UnimplementedError(
        'getItems is not implemented on the current platform');
  }

  Future<void> clear() {
    throw UnimplementedError(
        'clear is not implemented on the current platform');
  }

  Future<String> key({required int index}) {
    throw UnimplementedError('key is not implemented on the current platform');
  }

  @override
  void dispose() {
    throw UnimplementedError(
        'dispose is not implemented on the current platform');
  }
}

@immutable
class PlatformLocalStorageCreationParams extends PlatformStorageCreationParams {
  PlatformLocalStorageCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformStorageCreationParams params,
  ) : super(
            controller: params.controller,
            webStorageType: WebStorageType.LOCAL_STORAGE);

  factory PlatformLocalStorageCreationParams.fromPlatformStorageCreationParams(
      PlatformStorageCreationParams params) {
    return PlatformLocalStorageCreationParams(params);
  }
}

abstract class PlatformLocalStorage extends PlatformInterface
    with PlatformStorage {
  factory PlatformLocalStorage(PlatformLocalStorageCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformLocalStorage localStorage =
        InAppWebViewPlatform.instance!.createPlatformLocalStorage(params);
    PlatformInterface.verify(localStorage, _token);
    return localStorage;
  }

  @protected
  PlatformLocalStorage.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformLocalStorageCreationParams params;

  @override
  WebStorageType get webStorageType => params.webStorageType;
}

@immutable
class PlatformSessionStorageCreationParams
    extends PlatformStorageCreationParams {
  PlatformSessionStorageCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformStorageCreationParams params,
  ) : super(
            controller: params.controller,
            webStorageType: WebStorageType.SESSION_STORAGE);

  factory PlatformSessionStorageCreationParams.fromPlatformStorageCreationParams(
      PlatformStorageCreationParams params) {
    return PlatformSessionStorageCreationParams(params);
  }
}

abstract class PlatformSessionStorage extends PlatformInterface
    with PlatformStorage {
  factory PlatformSessionStorage(PlatformSessionStorageCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformSessionStorage sessionStorage =
        InAppWebViewPlatform.instance!.createPlatformSessionStorage(params);
    PlatformInterface.verify(sessionStorage, _token);
    return sessionStorage;
  }

  @protected
  PlatformSessionStorage.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformSessionStorageCreationParams params;

  @override
  WebStorageType get webStorageType => params.webStorageType;
}
