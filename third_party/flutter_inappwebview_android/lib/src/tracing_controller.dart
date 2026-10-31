import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

@immutable
class AndroidTracingControllerCreationParams
    extends PlatformTracingControllerCreationParams {
  const AndroidTracingControllerCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformTracingControllerCreationParams params,
  ) : super();

  factory AndroidTracingControllerCreationParams.fromPlatformTracingControllerCreationParams(
      PlatformTracingControllerCreationParams params) {
    return AndroidTracingControllerCreationParams(params);
  }
}

class AndroidTracingController extends PlatformTracingController
    with ChannelController {
  AndroidTracingController(PlatformTracingControllerCreationParams params)
      : super.implementation(
          params is AndroidTracingControllerCreationParams
              ? params
              : AndroidTracingControllerCreationParams
                  .fromPlatformTracingControllerCreationParams(params),
        ) {
    channel = const MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_tracingcontroller');
    handler = handleMethod;
    initMethodCallHandler();
  }

  static AndroidTracingController? _instance;

  static AndroidTracingController instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static AndroidTracingController _init() {
    _instance = AndroidTracingController(AndroidTracingControllerCreationParams(
        const PlatformTracingControllerCreationParams()));
    return _instance!;
  }

  Future<dynamic> _handleMethod(MethodCall call) async {}

  @override
  Future<void> start({required TracingSettings settings}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("settings", () => settings.toMap());
    await channel?.invokeMethod('start', args);
  }

  @override
  Future<bool> stop({String? filePath}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("filePath", () => filePath);
    return await channel?.invokeMethod<bool>('stop', args) ?? false;
  }

  @override
  Future<bool> isTracing() async {
    Map<String, dynamic> args = <String, dynamic>{};
    return await channel?.invokeMethod<bool>('isTracing', args) ?? false;
  }

  @override
  void dispose() {
  }
}

extension InternalTracingController on AndroidTracingController {
  get handleMethod => _handleMethod;
}
