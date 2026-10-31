import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'inappwebview_platform.dart';
import 'types/main.dart';

@immutable
class PlatformHttpAuthCredentialDatabaseCreationParams {
  const PlatformHttpAuthCredentialDatabaseCreationParams();
}

abstract class PlatformHttpAuthCredentialDatabase extends PlatformInterface {
  factory PlatformHttpAuthCredentialDatabase(
      PlatformHttpAuthCredentialDatabaseCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformHttpAuthCredentialDatabase cookieManager =
        InAppWebViewPlatform.instance!
            .createPlatformHttpAuthCredentialDatabase(params);
    PlatformInterface.verify(cookieManager, _token);
    return cookieManager;
  }

  @protected
  PlatformHttpAuthCredentialDatabase.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformHttpAuthCredentialDatabaseCreationParams params;

  Future<List<URLProtectionSpaceHttpAuthCredentials>> getAllAuthCredentials() {
    throw UnimplementedError(
        'getAllAuthCredentials is not implemented on the current platform');
  }

  Future<List<URLCredential>> getHttpAuthCredentials(
      {required URLProtectionSpace protectionSpace}) {
    throw UnimplementedError(
        'getHttpAuthCredentials is not implemented on the current platform');
  }

  Future<void> setHttpAuthCredential(
      {required URLProtectionSpace protectionSpace,
      required URLCredential credential}) {
    throw UnimplementedError(
        'setHttpAuthCredential is not implemented on the current platform');
  }

  Future<void> removeHttpAuthCredential(
      {required URLProtectionSpace protectionSpace,
      required URLCredential credential}) {
    throw UnimplementedError(
        'removeHttpAuthCredential is not implemented on the current platform');
  }

  Future<void> removeHttpAuthCredentials(
      {required URLProtectionSpace protectionSpace}) {
    throw UnimplementedError(
        'removeHttpAuthCredentials is not implemented on the current platform');
  }

  Future<void> clearAllAuthCredentials() {
    throw UnimplementedError(
        'clearAllAuthCredentials is not implemented on the current platform');
  }
}
