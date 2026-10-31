import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

@immutable
class PlatformInAppLocalhostServerCreationParams {
  const PlatformInAppLocalhostServerCreationParams({
    this.port = 8080,
    this.directoryIndex = 'index.html',
    this.documentRoot = './',
    this.shared = false,
  });

  final int port;

  final String directoryIndex;

  final String documentRoot;

  final bool shared;
}

abstract class PlatformInAppLocalhostServer extends PlatformInterface {
  factory PlatformInAppLocalhostServer(
      PlatformInAppLocalhostServerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformInAppLocalhostServer inAppLocalhostServer =
        InAppWebViewPlatform.instance!
            .createPlatformInAppLocalhostServer(params);
    PlatformInterface.verify(inAppLocalhostServer, _token);
    return inAppLocalhostServer;
  }

  @protected
  PlatformInAppLocalhostServer.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformInAppLocalhostServerCreationParams params;

  int get port => params.port;

  String get directoryIndex => params.directoryIndex;

  String get documentRoot => params.documentRoot;

  bool get shared => params.shared;

  Future<void> start() {
    throw UnimplementedError(
        'start is not implemented on the current platform');
  }

  Future<void> close() {
    throw UnimplementedError(
        'close is not implemented on the current platform');
  }

  bool isRunning() {
    throw UnimplementedError(
        'isRunning is not implemented on the current platform');
  }
}
