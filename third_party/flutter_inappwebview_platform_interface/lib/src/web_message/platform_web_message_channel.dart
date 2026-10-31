import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_platform_interface/src/types/disposable.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../inappwebview_platform.dart';
import 'platform_web_message_port.dart';

@immutable
class PlatformWebMessageChannelCreationParams {
  const PlatformWebMessageChannelCreationParams(
      {required this.id, required this.port1, required this.port2});

  final String id;

  final PlatformWebMessagePort port1;

  final PlatformWebMessagePort port2;

  @override
  String toString() {
    return 'PlatformWebMessageChannelCreationParams{id: $id, port1: $port1, port2: $port2}';
  }
}

abstract class PlatformWebMessageChannel extends PlatformInterface
    implements Disposable {
  factory PlatformWebMessageChannel(
      PlatformWebMessageChannelCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebMessageChannel webMessageChannel =
        InAppWebViewPlatform.instance!.createPlatformWebMessageChannel(params);
    PlatformInterface.verify(webMessageChannel, _token);
    return webMessageChannel;
  }

  factory PlatformWebMessageChannel.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebMessageChannel webMessageChannelStatic =
        InAppWebViewPlatform.instance!.createPlatformWebMessageChannelStatic();
    PlatformInterface.verify(webMessageChannelStatic, _token);
    return webMessageChannelStatic;
  }

  @protected
  PlatformWebMessageChannel.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformWebMessageChannelCreationParams params;

  String get id => params.id;

  PlatformWebMessagePort get port1 => params.port1;

  PlatformWebMessagePort get port2 => params.port2;

  PlatformWebMessageChannel? fromMap(Map<String, dynamic>? map) {
    throw UnimplementedError(
        'fromMap is not implemented on the current platform');
  }

  @override
  void dispose() {
    throw UnimplementedError(
        'dispose is not implemented on the current platform');
  }

  @override
  String toString() {
    return 'PlatformWebMessageChannel{id: $id, port1: $port1, port2: $port2}';
  }
}
