import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../debug_logging_settings.dart';
import '../inappwebview_platform.dart';
import '../types/main.dart';
import '../web_uri.dart';
import 'web_authenticate_session_settings.dart';

typedef WebAuthenticationSessionCompletionHandler = Future<void> Function(
    WebUri? url, WebAuthenticationSessionError? error)?;

class PlatformWebAuthenticationSessionCreationParams {
  const PlatformWebAuthenticationSessionCreationParams();
}

abstract class PlatformWebAuthenticationSession extends PlatformInterface
    implements Disposable {
  static DebugLoggingSettings debugLoggingSettings = DebugLoggingSettings();

  factory PlatformWebAuthenticationSession(
      PlatformWebAuthenticationSessionCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebAuthenticationSession webAuthenticationSession =
        InAppWebViewPlatform.instance!
            .createPlatformWebAuthenticationSession(params);
    PlatformInterface.verify(webAuthenticationSession, _token);
    return webAuthenticationSession;
  }

  factory PlatformWebAuthenticationSession.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebAuthenticationSession webAuthenticationSessionStatic =
        InAppWebViewPlatform.instance!
            .createPlatformWebAuthenticationSessionStatic();
    PlatformInterface.verify(webAuthenticationSessionStatic, _token);
    return webAuthenticationSessionStatic;
  }

  @protected
  PlatformWebAuthenticationSession.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformWebAuthenticationSessionCreationParams params;

  String get id =>
      throw UnimplementedError('id is not implemented on the current platform');

  WebUri get url => throw UnimplementedError(
      'url is not implemented on the current platform');

  String? get callbackURLScheme => throw UnimplementedError(
      'callbackURLScheme is not implemented on the current platform');

  WebAuthenticationSessionSettings? get initialSettings =>
      throw UnimplementedError(
          'initialSettings is not implemented on the current platform');

  WebAuthenticationSessionCompletionHandler get onComplete =>
      throw UnimplementedError(
          'onComplete is not implemented on the current platform');

  Future<PlatformWebAuthenticationSession> create(
      {required WebUri url,
      String? callbackURLScheme,
      WebAuthenticationSessionCompletionHandler onComplete,
      WebAuthenticationSessionSettings? initialSettings}) {
    throw UnimplementedError(
        'create is not implemented on the current platform');
  }

  Future<bool> canStart() {
    throw UnimplementedError(
        'canStart is not implemented on the current platform');
  }

  Future<bool> start() {
    throw UnimplementedError(
        'start is not implemented on the current platform');
  }

  Future<void> cancel() {
    throw UnimplementedError(
        'cancel is not implemented on the current platform');
  }

  @override
  Future<void> dispose() {
    throw UnimplementedError(
        'cancel is not implemented on the current platform');
  }

  Future<bool> isAvailable() {
    throw UnimplementedError(
        'isAvailable is not implemented on the current platform');
  }
}
