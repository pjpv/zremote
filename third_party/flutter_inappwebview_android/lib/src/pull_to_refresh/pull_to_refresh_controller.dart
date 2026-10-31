import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';

class AndroidPullToRefreshControllerCreationParams
    extends PlatformPullToRefreshControllerCreationParams {
  AndroidPullToRefreshControllerCreationParams(
      {super.onRefresh, super.options, super.settings});

  factory AndroidPullToRefreshControllerCreationParams.fromPlatformPullToRefreshControllerCreationParams(
      // ignore: avoid_unused_constructor_parameters
      PlatformPullToRefreshControllerCreationParams params) {
    return AndroidPullToRefreshControllerCreationParams(
        onRefresh: params.onRefresh,
        options: params.options,
        settings: params.settings);
  }
}

class AndroidPullToRefreshController extends PlatformPullToRefreshController
    with ChannelController {
  AndroidPullToRefreshController(
      PlatformPullToRefreshControllerCreationParams params)
      : super.implementation(
          params is AndroidPullToRefreshControllerCreationParams
              ? params
              : AndroidPullToRefreshControllerCreationParams
                  .fromPlatformPullToRefreshControllerCreationParams(params),
        );

  _debugLog(String method, dynamic args) {
    debugLog(
        className: this.runtimeType.toString(),
        debugLoggingSettings:
            PlatformPullToRefreshController.debugLoggingSettings,
        method: method,
        args: args);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    _debugLog(call.method, call.arguments);

    switch (call.method) {
      case "onRefresh":
        if (params.onRefresh != null) params.onRefresh!();
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
    return null;
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('enabled', () => enabled);
    await channel?.invokeMethod('setEnabled', args);
  }

  @override
  Future<bool> isEnabled() async {
    Map<String, dynamic> args = <String, dynamic>{};
    return await channel?.invokeMethod<bool>('isEnabled', args) ?? false;
  }

  Future<void> _setRefreshing(bool refreshing) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('refreshing', () => refreshing);
    await channel?.invokeMethod('setRefreshing', args);
  }

  @override
  Future<void> beginRefreshing() async {
    return await _setRefreshing(true);
  }

  @override
  Future<void> endRefreshing() async {
    await _setRefreshing(false);
  }

  @override
  Future<bool> isRefreshing() async {
    Map<String, dynamic> args = <String, dynamic>{};
    return await channel?.invokeMethod<bool>('isRefreshing', args) ?? false;
  }

  @override
  Future<void> setColor(Color color) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('color', () => color.toHex());
    await channel?.invokeMethod('setColor', args);
  }

  @override
  Future<void> setBackgroundColor(Color color) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('color', () => color.toHex());
    await channel?.invokeMethod('setBackgroundColor', args);
  }

  @override
  Future<void> setDistanceToTriggerSync(int distanceToTriggerSync) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('distanceToTriggerSync', () => distanceToTriggerSync);
    await channel?.invokeMethod('setDistanceToTriggerSync', args);
  }

  @override
  Future<void> setSlingshotDistance(int slingshotDistance) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('slingshotDistance', () => slingshotDistance);
    await channel?.invokeMethod('setSlingshotDistance', args);
  }

  @override
  Future<int> getDefaultSlingshotDistance() async {
    Map<String, dynamic> args = <String, dynamic>{};
    return await channel?.invokeMethod<int>(
            'getDefaultSlingshotDistance', args) ??
        0;
  }

  @Deprecated("Use setIndicatorSize instead")
  @override
  Future<void> setSize(AndroidPullToRefreshSize size) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('size', () => size.toNativeValue());
    await channel?.invokeMethod('setSize', args);
  }

  @override
  Future<void> setIndicatorSize(PullToRefreshSize size) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('size', () => size.toNativeValue());
    await channel?.invokeMethod('setSize', args);
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    disposeChannel(removeMethodCallHandler: !isKeepAlive);
  }
}

extension InternalPullToRefreshController on AndroidPullToRefreshController {
  void init(dynamic id) {
    channel = MethodChannel(
        'com.pichillilorenzo/flutter_inappwebview_pull_to_refresh_$id');
    handler = _handleMethod;
    initMethodCallHandler();
  }
}
