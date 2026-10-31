import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

import 'web_message_channel.dart';

@immutable
class AndroidWebMessagePortCreationParams
    extends PlatformWebMessagePortCreationParams {
  const AndroidWebMessagePortCreationParams({required super.index});

  factory AndroidWebMessagePortCreationParams.fromPlatformWebMessagePortCreationParams(
      // ignore: avoid_unused_constructor_parameters
      PlatformWebMessagePortCreationParams params) {
    return AndroidWebMessagePortCreationParams(index: params.index);
  }

  @override
  String toString() {
    return 'AndroidWebMessagePortCreationParams{index: $index}';
  }
}

class AndroidWebMessagePort extends PlatformWebMessagePort {
  WebMessageCallback? _onMessage;
  late AndroidWebMessageChannel _webMessageChannel;

  AndroidWebMessagePort(PlatformWebMessagePortCreationParams params)
      : super.implementation(
          params is AndroidWebMessagePortCreationParams
              ? params
              : AndroidWebMessagePortCreationParams
                  .fromPlatformWebMessagePortCreationParams(params),
        );

  @override
  Future<void> setWebMessageCallback(WebMessageCallback? onMessage) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('index', () => params.index);
    await _webMessageChannel.internalChannel
        ?.invokeMethod('setWebMessageCallback', args);
    this._onMessage = onMessage;
  }

  @override
  Future<void> postMessage(WebMessage message) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('index', () => params.index);
    args.putIfAbsent('message', () => message.toMap());
    await _webMessageChannel.internalChannel?.invokeMethod('postMessage', args);
  }

  @override
  Future<void> close() async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('index', () => params.index);
    await _webMessageChannel.internalChannel?.invokeMethod('close', args);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "index": params.index,
      "webMessageChannelId": this._webMessageChannel.params.id
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AndroidWebMessagePort{index: ${params.index}}';
  }
}

extension InternalWebMessagePort on AndroidWebMessagePort {
  WebMessageCallback? get onMessage => _onMessage;
  void set onMessage(WebMessageCallback? value) => _onMessage = value;

  AndroidWebMessageChannel get webMessageChannel => _webMessageChannel;
  void set webMessageChannel(AndroidWebMessageChannel value) =>
      _webMessageChannel = value;
}
