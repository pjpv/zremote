import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

@immutable
class AndroidPrintJobControllerCreationParams
    extends PlatformPrintJobControllerCreationParams {
  const AndroidPrintJobControllerCreationParams(
      {required super.id, super.onComplete});

  factory AndroidPrintJobControllerCreationParams.fromPlatformPrintJobControllerCreationParams(
      // ignore: avoid_unused_constructor_parameters
      PlatformPrintJobControllerCreationParams params) {
    return AndroidPrintJobControllerCreationParams(
        id: params.id, onComplete: params.onComplete);
  }
}

class AndroidPrintJobController extends PlatformPrintJobController
    with ChannelController {
  AndroidPrintJobController(PlatformPrintJobControllerCreationParams params)
      : super.implementation(
          params is AndroidPrintJobControllerCreationParams
              ? params
              : AndroidPrintJobControllerCreationParams
                  .fromPlatformPrintJobControllerCreationParams(params),
        ) {
    channel = MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_printjobcontroller_${params.id}');
    handler = _handleMethod;
    initMethodCallHandler();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

  @override
  Future<void> cancel() async {
    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('cancel', args);
  }

  @override
  Future<void> restart() async {
    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('restart', args);
  }

  @override
  Future<PrintJobInfo?> getInfo() async {
    Map<String, dynamic> args = <String, dynamic>{};
    Map<String, dynamic>? infoMap =
        (await channel?.invokeMethod('getInfo', args))?.cast<String, dynamic>();
    return PrintJobInfo.fromMap(infoMap);
  }

  @override
  Future<void> dispose() async {
    Map<String, dynamic> args = <String, dynamic>{};
    await channel?.invokeMethod('dispose', args);
    disposeChannel();
  }
}
