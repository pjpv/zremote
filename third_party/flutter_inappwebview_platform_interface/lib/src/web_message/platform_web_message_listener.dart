import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_platform_interface/src/types/disposable.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../in_app_webview/platform_inappwebview_controller.dart';
import '../inappwebview_platform.dart';
import '../types/main.dart';
import 'web_message.dart';

@immutable
class PlatformWebMessageListenerCreationParams {
  const PlatformWebMessageListenerCreationParams(
      {required this.jsObjectName,
      this.allowedOriginRules,
      this.onPostMessage});

  final String jsObjectName;

  final Set<String>? allowedOriginRules;

  final OnPostMessageCallback? onPostMessage;

  @override
  String toString() {
    return 'PlatformWebMessageListenerCreationParams{jsObjectName: $jsObjectName, allowedOriginRules: $allowedOriginRules, onPostMessage: $onPostMessage}';
  }
}

abstract class PlatformWebMessageListener extends PlatformInterface
    implements Disposable {
  factory PlatformWebMessageListener(
      PlatformWebMessageListenerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebMessageListener webMessageListener =
        InAppWebViewPlatform.instance!.createPlatformWebMessageListener(params);
    PlatformInterface.verify(webMessageListener, _token);
    return webMessageListener;
  }

  @protected
  PlatformWebMessageListener.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformWebMessageListenerCreationParams params;

  String get jsObjectName => params.jsObjectName;

  Set<String>? get allowedOriginRules => params.allowedOriginRules;

  OnPostMessageCallback? get onPostMessage => params.onPostMessage;

  Map<String, dynamic> toMap() {
    throw UnimplementedError(
        'toMap is not implemented on the current platform.');
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError(
        'toJson is not implemented on the current platform.');
  }

  @override
  void dispose() {
    throw UnimplementedError(
        'dispose is not implemented on the current platform.');
  }

  @override
  String toString() {
    return 'PlatformWebMessageListener{jsObjectName: $jsObjectName, allowedOriginRules: $allowedOriginRules, onPostMessage: $onPostMessage}';
  }
}

@immutable
class PlatformJavaScriptReplyProxyCreationParams {
  const PlatformJavaScriptReplyProxyCreationParams(
      {required this.webMessageListener});

  final PlatformWebMessageListener webMessageListener;
}

abstract class PlatformJavaScriptReplyProxy extends PlatformInterface {
  factory PlatformJavaScriptReplyProxy(
      PlatformJavaScriptReplyProxyCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformJavaScriptReplyProxy javaScriptReplyProxy =
        InAppWebViewPlatform.instance!
            .createPlatformJavaScriptReplyProxy(params);
    PlatformInterface.verify(javaScriptReplyProxy, _token);
    return javaScriptReplyProxy;
  }

  @protected
  PlatformJavaScriptReplyProxy.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformJavaScriptReplyProxyCreationParams params;

  Future<void> postMessage(WebMessage message) {
    throw UnimplementedError(
        'postMessage is not implemented on the current platform.');
  }

  @override
  String toString() {
    return 'JavaScriptReplyProxy{}';
  }
}
