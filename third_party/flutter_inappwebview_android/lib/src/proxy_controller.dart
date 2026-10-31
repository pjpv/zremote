import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

@immutable
class AndroidProxyControllerCreationParams
    extends PlatformProxyControllerCreationParams {
  const AndroidProxyControllerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformProxyControllerCreationParams params,
  ) : super();

  factory AndroidProxyControllerCreationParams.fromPlatformProxyControllerCreationParams(
      PlatformProxyControllerCreationParams params) {
    return AndroidProxyControllerCreationParams(params);
  }
}

class AndroidProxyController extends PlatformProxyController
    with ChannelController {
  AndroidProxyController(PlatformProxyControllerCreationParams params)
      : super.implementation(
          params is AndroidProxyControllerCreationParams
              ? params
              : AndroidProxyControllerCreationParams
                  .fromPlatformProxyControllerCreationParams(params),
        ) {
    channel = const MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_proxycontroller');
    handler = handleMethod;
    initMethodCallHandler();
  }

  static AndroidProxyController? _instance;

  static AndroidProxyController instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static AndroidProxyController _init() {
    _instance = AndroidProxyController(AndroidProxyControllerCreationParams(
        const PlatformProxyControllerCreationParams()));
    return _instance!;
  }

  Future<dynamic> _handleMethod(MethodCall call) async {}

  @override
  Future<void> setProxyOverride({required ProxySettings settings}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("settings", () => settings.toMap());
    await channel?.invokeMethod('setProxyOverride', args);
  }

  @override
  Future<void> clearProxyOverride() async {
    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('clearProxyOverride', args);
  }

  @override
  void dispose() {
  }
}

extension InternalProxyController on AndroidProxyController {
  get handleMethod => _handleMethod;
}
