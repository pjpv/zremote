import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

@immutable
class AndroidProcessGlobalConfigCreationParams
    extends PlatformProcessGlobalConfigCreationParams {
  const AndroidProcessGlobalConfigCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformProcessGlobalConfigCreationParams params,
  ) : super();

  factory AndroidProcessGlobalConfigCreationParams.fromPlatformProcessGlobalConfigCreationParams(
      PlatformProcessGlobalConfigCreationParams params) {
    return AndroidProcessGlobalConfigCreationParams(params);
  }
}

class AndroidProcessGlobalConfig extends PlatformProcessGlobalConfig
    with ChannelController {
  AndroidProcessGlobalConfig(PlatformProcessGlobalConfigCreationParams params)
      : super.implementation(
          params is AndroidProcessGlobalConfigCreationParams
              ? params
              : AndroidProcessGlobalConfigCreationParams
                  .fromPlatformProcessGlobalConfigCreationParams(params),
        ) {
    channel = const MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_processglobalconfig');
    handler = handleMethod;
    initMethodCallHandler();
  }

  static AndroidProcessGlobalConfig? _instance;

  static AndroidProcessGlobalConfig instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static AndroidProcessGlobalConfig _init() {
    _instance = AndroidProcessGlobalConfig(
        AndroidProcessGlobalConfigCreationParams(
            const PlatformProcessGlobalConfigCreationParams()));
    return _instance!;
  }

  Future<dynamic> _handleMethod(MethodCall call) async {}

  @override
  Future<void> apply({required ProcessGlobalConfigSettings settings}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("settings", () => settings.toMap());
    await channel?.invokeMethod('apply', args);
  }

  @override
  void dispose() {
  }
}

extension InternalProcessGlobalConfig on AndroidProcessGlobalConfig {
  get handleMethod => _handleMethod;
}
