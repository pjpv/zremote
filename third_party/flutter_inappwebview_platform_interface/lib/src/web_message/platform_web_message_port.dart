import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../inappwebview_platform.dart';
import '../types/web_message_callback.dart';
import 'web_message.dart';

@immutable
class PlatformWebMessagePortCreationParams {
  const PlatformWebMessagePortCreationParams({required this.index});

  final int index;

  @override
  String toString() {
    return 'PlatformWebMessagePortCreationParams{index: $index}';
  }
}

abstract class PlatformWebMessagePort extends PlatformInterface
    implements IWebMessagePort {
  factory PlatformWebMessagePort(PlatformWebMessagePortCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebMessagePort webMessagePort =
        InAppWebViewPlatform.instance!.createPlatformWebMessagePort(params);
    PlatformInterface.verify(webMessagePort, _token);
    return webMessagePort;
  }

  @protected
  PlatformWebMessagePort.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformWebMessagePortCreationParams params;

  @override
  String toString() {
    return 'PlatformWebMessagePort{index: ${params.index}}';
  }
}

abstract class IWebMessagePort {
  Future<void> setWebMessageCallback(WebMessageCallback? onMessage) {
    throw UnimplementedError(
        'setWebMessageCallback is not implemented on the current platform');
  }

  Future<void> postMessage(WebMessage message) {
    throw UnimplementedError(
        'postMessage is not implemented on the current platform');
  }

  Future<void> close() {
    throw UnimplementedError(
        'close is not implemented on the current platform');
  }

  Map<String, dynamic> toMap() {
    throw UnimplementedError(
        'toMap is not implemented on the current platform');
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError(
        'toJson is not implemented on the current platform');
  }
}
