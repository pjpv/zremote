import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'inappwebview_platform.dart';
import 'in_app_webview/platform_inappwebview_controller.dart';
import 'platform_webview_feature.dart';

part 'platform_process_global_config.g.dart';

@immutable
class PlatformProcessGlobalConfigCreationParams {
  const PlatformProcessGlobalConfigCreationParams();
}

abstract class PlatformProcessGlobalConfig extends PlatformInterface {
  factory PlatformProcessGlobalConfig(
      PlatformProcessGlobalConfigCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformProcessGlobalConfig processGlobalConfig = InAppWebViewPlatform
        .instance!
        .createPlatformProcessGlobalConfig(params);
    PlatformInterface.verify(processGlobalConfig, _token);
    return processGlobalConfig;
  }

  @protected
  PlatformProcessGlobalConfig.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformProcessGlobalConfigCreationParams params;

  Future<void> apply({required ProcessGlobalConfigSettings settings}) {
    throw UnimplementedError(
        'apply is not implemented on the current platform');
  }
}

@ExchangeableObject(copyMethod: true)
class ProcessGlobalConfigSettings_ {
  String? dataDirectorySuffix;

  ProcessGlobalConfigDirectoryBasePaths_? directoryBasePaths;

  ProcessGlobalConfigSettings_(
      {this.dataDirectorySuffix, this.directoryBasePaths});
}

@ExchangeableObject()
class ProcessGlobalConfigDirectoryBasePaths_ {
  String dataDirectoryBasePath;

  String cacheDirectoryBasePath;

  ProcessGlobalConfigDirectoryBasePaths_(
      {required this.dataDirectoryBasePath,
      required this.cacheDirectoryBasePath});
}
