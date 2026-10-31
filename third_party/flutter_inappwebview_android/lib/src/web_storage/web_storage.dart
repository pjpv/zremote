import 'dart:convert';

import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

import '../in_app_webview/in_app_webview_controller.dart';

class AndroidWebStorageCreationParams extends PlatformWebStorageCreationParams {
  AndroidWebStorageCreationParams(
      {required super.localStorage, required super.sessionStorage});

  factory AndroidWebStorageCreationParams.fromPlatformWebStorageCreationParams(
      // ignore: avoid_unused_constructor_parameters
      PlatformWebStorageCreationParams params) {
    return AndroidWebStorageCreationParams(
        localStorage: params.localStorage,
        sessionStorage: params.sessionStorage);
  }
}

class AndroidWebStorage extends PlatformWebStorage {
  AndroidWebStorage(PlatformWebStorageCreationParams params)
      : super.implementation(
          params is AndroidWebStorageCreationParams
              ? params
              : AndroidWebStorageCreationParams
                  .fromPlatformWebStorageCreationParams(params),
        );

  @override
  PlatformLocalStorage get localStorage => params.localStorage;

  @override
  PlatformSessionStorage get sessionStorage => params.sessionStorage;

  @override
  void dispose() {
    localStorage.dispose();
    sessionStorage.dispose();
  }
}

class AndroidStorageCreationParams extends PlatformStorageCreationParams {
  AndroidStorageCreationParams(
      {required super.controller, required super.webStorageType});

  factory AndroidStorageCreationParams.fromPlatformStorageCreationParams(
      // ignore: avoid_unused_constructor_parameters
      PlatformStorageCreationParams params) {
    return AndroidStorageCreationParams(
        controller: params.controller, webStorageType: params.webStorageType);
  }
}

abstract mixin class AndroidStorage implements PlatformStorage {
  @override
  AndroidInAppWebViewController? controller;

  @override
  Future<int?> length() async {
    var result = await controller?.evaluateJavascript(source: """
    window.$webStorageType.length;
    """);
    return result != null ? int.parse(json.decode(result)) : null;
  }

  @override
  Future<void> setItem({required String key, required dynamic value}) async {
    var encodedValue = json.encode(value);
    await controller?.evaluateJavascript(source: """
    window.$webStorageType.setItem("$key", ${value is String ? encodedValue : "JSON.stringify($encodedValue)"});
    """);
  }

  @override
  Future<dynamic> getItem({required String key}) async {
    var itemValue = await controller?.evaluateJavascript(source: """
    window.$webStorageType.getItem("$key");
    """);

    if (itemValue == null) {
      return null;
    }

    try {
      return json.decode(itemValue);
    } catch (e) {}

    return itemValue;
  }

  @override
  Future<void> removeItem({required String key}) async {
    await controller?.evaluateJavascript(source: """
    window.$webStorageType.removeItem("$key");
    """);
  }

  @override
  Future<List<WebStorageItem>> getItems() async {
    var webStorageItems = <WebStorageItem>[];

    List<Map<dynamic, dynamic>>? items =
        (await controller?.evaluateJavascript(source: """
(function() {
  var webStorageItems = [];
  for(var i = 0; i < window.$webStorageType.length; i++){
    var key = window.$webStorageType.key(i);
    webStorageItems.push(
      {
        key: key,
        value: window.$webStorageType.getItem(key)
      }
    );
  }
  return webStorageItems;
})();
    """))?.cast<Map<dynamic, dynamic>>();

    if (items == null) {
      return webStorageItems;
    }

    for (var item in items) {
      webStorageItems
          .add(WebStorageItem(key: item["key"], value: item["value"]));
    }

    return webStorageItems;
  }

  @override
  Future<void> clear() async {
    await controller?.evaluateJavascript(source: """
    window.$webStorageType.clear();
    """);
  }

  @override
  Future<String> key({required int index}) async {
    var result = await controller?.evaluateJavascript(source: """
    window.$webStorageType.key($index);
    """);
    return result != null ? json.decode(result) : null;
  }

  @override
  void dispose() {
    controller = null;
  }
}

class AndroidLocalStorageCreationParams
    extends PlatformLocalStorageCreationParams {
  AndroidLocalStorageCreationParams(super.params);

  factory AndroidLocalStorageCreationParams.fromPlatformLocalStorageCreationParams(
      // ignore: avoid_unused_constructor_parameters
      PlatformLocalStorageCreationParams params) {
    return AndroidLocalStorageCreationParams(params);
  }
}

class AndroidLocalStorage extends PlatformLocalStorage with AndroidStorage {
  AndroidLocalStorage(PlatformLocalStorageCreationParams params)
      : super.implementation(
          params is AndroidLocalStorageCreationParams
              ? params
              : AndroidLocalStorageCreationParams
                  .fromPlatformLocalStorageCreationParams(params),
        );

  factory AndroidLocalStorage.defaultStorage(
      {required PlatformInAppWebViewController? controller}) {
    return AndroidLocalStorage(AndroidLocalStorageCreationParams(
        PlatformLocalStorageCreationParams(PlatformStorageCreationParams(
            controller: controller,
            webStorageType: WebStorageType.LOCAL_STORAGE))));
  }

  @override
  AndroidInAppWebViewController? get controller =>
      params.controller as AndroidInAppWebViewController?;
}

class AndroidSessionStorageCreationParams
    extends PlatformSessionStorageCreationParams {
  AndroidSessionStorageCreationParams(super.params);

  factory AndroidSessionStorageCreationParams.fromPlatformSessionStorageCreationParams(
      // ignore: avoid_unused_constructor_parameters
      PlatformSessionStorageCreationParams params) {
    return AndroidSessionStorageCreationParams(params);
  }
}

class AndroidSessionStorage extends PlatformSessionStorage with AndroidStorage {
  AndroidSessionStorage(PlatformSessionStorageCreationParams params)
      : super.implementation(
          params is AndroidSessionStorageCreationParams
              ? params
              : AndroidSessionStorageCreationParams
                  .fromPlatformSessionStorageCreationParams(params),
        );

  factory AndroidSessionStorage.defaultStorage(
      {required PlatformInAppWebViewController? controller}) {
    return AndroidSessionStorage(AndroidSessionStorageCreationParams(
        PlatformSessionStorageCreationParams(PlatformStorageCreationParams(
            controller: controller,
            webStorageType: WebStorageType.SESSION_STORAGE))));
  }

  @override
  AndroidInAppWebViewController? get controller =>
      params.controller as AndroidInAppWebViewController?;
}
