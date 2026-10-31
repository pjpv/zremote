import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../debug_logging_settings.dart';
import '../inappwebview_platform.dart';
import '../types/disposable.dart';
import 'webview_environment_settings.dart';

@immutable
class PlatformWebViewEnvironmentCreationParams {
  const PlatformWebViewEnvironmentCreationParams({this.settings});

  final WebViewEnvironmentSettings? settings;
}

abstract class PlatformWebViewEnvironment extends PlatformInterface
    implements Disposable {
  static DebugLoggingSettings debugLoggingSettings =
      DebugLoggingSettings(maxLogMessageLength: 1000);

  factory PlatformWebViewEnvironment(
      PlatformWebViewEnvironmentCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebViewEnvironment webViewEnvironment =
        InAppWebViewPlatform.instance!.createPlatformWebViewEnvironment(params);
    PlatformInterface.verify(webViewEnvironment, _token);
    return webViewEnvironment;
  }

  factory PlatformWebViewEnvironment.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebViewEnvironment webViewEnvironment =
        InAppWebViewPlatform.instance!.createPlatformWebViewEnvironmentStatic();
    PlatformInterface.verify(webViewEnvironment, _token);
    return webViewEnvironment;
  }

  @protected
  PlatformWebViewEnvironment.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformWebViewEnvironmentCreationParams params;

  String get id =>
      throw UnimplementedError('id is not implemented on the current platform');

  WebViewEnvironmentSettings? get settings => params.settings;

  Future<PlatformWebViewEnvironment> create(
      {WebViewEnvironmentSettings? settings}) {
    throw UnimplementedError(
        'create is not implemented on the current platform');
  }

  Future<String?> getAvailableVersion({String? browserExecutableFolder}) {
    throw UnimplementedError(
        'getAvailableVersion is not implemented on the current platform');
  }

  Future<int?> compareBrowserVersions(
      {required String version1, required String version2}) {
    throw UnimplementedError(
        'compareBrowserVersions is not implemented on the current platform');
  }

  Future<void> dispose() {
    throw UnimplementedError(
        'dispose is not implemented on the current platform');
  }
}
