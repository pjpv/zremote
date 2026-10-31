import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../in_app_webview/in_app_webview_settings.dart';
import '../debug_logging_settings.dart';
import '../inappwebview_platform.dart';
import '../types/main.dart';
import 'pull_to_refresh_settings.dart';
import '../in_app_webview/platform_webview.dart';
import '../in_app_browser/platform_in_app_browser.dart';

class PlatformPullToRefreshControllerCreationParams {
  PlatformPullToRefreshControllerCreationParams(
      {@Deprecated("Use settings instead") PullToRefreshOptions? options,
      PullToRefreshSettings? settings,
      this.onRefresh})
      : this.options = options ?? PullToRefreshOptions(),
        this.settings = settings ?? PullToRefreshSettings();

  @Deprecated("Use settings instead")
  late PullToRefreshOptions options;

  late PullToRefreshSettings settings;

  final void Function()? onRefresh;
}

abstract class PlatformPullToRefreshController extends PlatformInterface
    implements Disposable {
  static DebugLoggingSettings debugLoggingSettings = DebugLoggingSettings();

  factory PlatformPullToRefreshController(
      PlatformPullToRefreshControllerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformPullToRefreshController webViewControllerDelegate =
        InAppWebViewPlatform.instance!
            .createPlatformPullToRefreshController(params);
    PlatformInterface.verify(webViewControllerDelegate, _token);
    return webViewControllerDelegate;
  }

  @protected
  PlatformPullToRefreshController.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformPullToRefreshControllerCreationParams params;

  @Deprecated("Use settings instead")
  PullToRefreshOptions get options => params.options;

  PullToRefreshSettings get settings => params.settings;

  void Function()? get onRefresh => params.onRefresh;

  Future<void> setEnabled(bool enabled) {
    throw UnimplementedError(
        'setEnabled is not implemented on the current platform');
  }

  Future<bool> isEnabled() {
    throw UnimplementedError(
        'isEnabled is not implemented on the current platform');
  }

  Future<void> beginRefreshing() {
    throw UnimplementedError(
        'beginRefreshing is not implemented on the current platform');
  }

  Future<void> endRefreshing() {
    throw UnimplementedError(
        'endRefreshing is not implemented on the current platform');
  }

  Future<bool> isRefreshing() {
    throw UnimplementedError(
        'isRefreshing is not implemented on the current platform');
  }

  Future<void> setColor(Color color) {
    throw UnimplementedError(
        'setColor is not implemented on the current platform');
  }

  Future<void> setBackgroundColor(Color color) {
    throw UnimplementedError(
        'setBackgroundColor is not implemented on the current platform');
  }

  Future<void> setDistanceToTriggerSync(int distanceToTriggerSync) {
    throw UnimplementedError(
        'setDistanceToTriggerSync is not implemented on the current platform');
  }

  Future<void> setSlingshotDistance(int slingshotDistance) {
    throw UnimplementedError(
        'setSlingshotDistance is not implemented on the current platform');
  }

  Future<int> getDefaultSlingshotDistance() {
    throw UnimplementedError(
        'getDefaultSlingshotDistance is not implemented on the current platform');
  }

  @Deprecated("Use setIndicatorSize instead")
  Future<void> setSize(AndroidPullToRefreshSize size) {
    throw UnimplementedError(
        'setSize is not implemented on the current platform');
  }

  Future<void> setIndicatorSize(PullToRefreshSize size) {
    throw UnimplementedError(
        'setIndicatorSize is not implemented on the current platform');
  }

  @Deprecated("Use setStyledTitle instead")
  Future<void> setAttributedTitle(IOSNSAttributedString attributedTitle) {
    throw UnimplementedError(
        'setAttributedTitle is not implemented on the current platform');
  }

  Future<void> setStyledTitle(AttributedString attributedTitle) {
    throw UnimplementedError(
        'setStyledTitle is not implemented on the current platform');
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    throw UnimplementedError(
        'dispose is not implemented on the current platform');
  }
}
