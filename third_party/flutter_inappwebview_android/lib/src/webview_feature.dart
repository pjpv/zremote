import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

@immutable
class AndroidWebViewFeatureCreationParams
    extends PlatformWebViewFeatureCreationParams {
  const AndroidWebViewFeatureCreationParams(
    // ignore: avoid_unused_constructor_parameters
    PlatformWebViewFeatureCreationParams params,
  ) : super();

  factory AndroidWebViewFeatureCreationParams.fromPlatformWebViewFeatureCreationParams(
      PlatformWebViewFeatureCreationParams params) {
    return AndroidWebViewFeatureCreationParams(params);
  }
}

class AndroidWebViewFeature extends PlatformWebViewFeature
    with ChannelController {
  AndroidWebViewFeature(PlatformWebViewFeatureCreationParams params)
      : super.implementation(
          params is AndroidWebViewFeatureCreationParams
              ? params
              : AndroidWebViewFeatureCreationParams
                  .fromPlatformWebViewFeatureCreationParams(params),
        ) {
    channel = const MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_webviewfeature');
    handler = handleMethod;
    initMethodCallHandler();
  }

  factory AndroidWebViewFeature.static() {
    return instance();
  }

  static AndroidWebViewFeature? _instance;

  static AndroidWebViewFeature instance() {
    return (_instance != null) ? _instance! : _init();
  }

  static AndroidWebViewFeature _init() {
    _instance = AndroidWebViewFeature(AndroidWebViewFeatureCreationParams(
        const PlatformWebViewFeatureCreationParams()));
    return _instance!;
  }

  Future<dynamic> _handleMethod(MethodCall call) async {}

  @override
  Future<bool> isFeatureSupported(WebViewFeature feature) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("feature", () => feature.toNativeValue());
    return await channel?.invokeMethod<bool>('isFeatureSupported', args) ??
        false;
  }

  @override
  Future<bool> isStartupFeatureSupported(WebViewFeature startupFeature) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("startupFeature", () => startupFeature.toNativeValue());
    return await channel?.invokeMethod<bool>(
            'isStartupFeatureSupported', args) ??
        false;
  }

  @override
  void dispose() {
  }
}

extension InternalWebViewFeature on AndroidWebViewFeature {
  get handleMethod => _handleMethod;
}
