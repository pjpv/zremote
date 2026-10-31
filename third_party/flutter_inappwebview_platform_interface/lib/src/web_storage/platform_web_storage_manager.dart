import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../inappwebview_platform.dart';
import '../types/main.dart';

@immutable
class PlatformWebStorageManagerCreationParams {
  const PlatformWebStorageManagerCreationParams();
}

abstract class PlatformWebStorageManager extends PlatformInterface {
  factory PlatformWebStorageManager(
      PlatformWebStorageManagerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformWebStorageManager cookieManager =
        InAppWebViewPlatform.instance!.createPlatformWebStorageManager(params);
    PlatformInterface.verify(cookieManager, _token);
    return cookieManager;
  }

  @protected
  PlatformWebStorageManager.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformWebStorageManagerCreationParams params;

  Future<List<WebStorageOrigin>> getOrigins() {
    throw UnimplementedError(
        'getOrigins is not implemented on the current platform');
  }

  Future<void> deleteAllData() {
    throw UnimplementedError(
        'deleteAllData is not implemented on the current platform');
  }

  Future<void> deleteOrigin({required String origin}) {
    throw UnimplementedError(
        'deleteOrigin is not implemented on the current platform');
  }

  Future<int> getQuotaForOrigin({required String origin}) {
    throw UnimplementedError(
        'getQuotaForOrigin is not implemented on the current platform');
  }

  Future<int> getUsageForOrigin({required String origin}) {
    throw UnimplementedError(
        'getUsageForOrigin is not implemented on the current platform');
  }

  Future<List<WebsiteDataRecord>> fetchDataRecords(
      {required Set<WebsiteDataType> dataTypes}) {
    throw UnimplementedError(
        'fetchDataRecords is not implemented on the current platform');
  }

  Future<void> removeDataFor(
      {required Set<WebsiteDataType> dataTypes,
      required List<WebsiteDataRecord> dataRecords}) {
    throw UnimplementedError(
        'removeDataFor is not implemented on the current platform');
  }

  Future<void> removeDataModifiedSince(
      {required Set<WebsiteDataType> dataTypes, required DateTime date}) {
    throw UnimplementedError(
        'removeDataModifiedSince is not implemented on the current platform');
  }
}
