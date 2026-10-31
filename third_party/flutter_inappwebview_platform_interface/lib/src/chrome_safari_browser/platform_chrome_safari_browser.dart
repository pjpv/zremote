import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

@immutable
class PlatformChromeSafariBrowserCreationParams {
  const PlatformChromeSafariBrowserCreationParams();
}

abstract class PlatformChromeSafariBrowser extends PlatformInterface
    implements Disposable {
  static DebugLoggingSettings debugLoggingSettings = DebugLoggingSettings();

  PlatformChromeSafariBrowserEvents? eventHandler;

  String get id {
    throw UnimplementedError('id is not implemented on the current platform');
  }

  factory PlatformChromeSafariBrowser(
      PlatformChromeSafariBrowserCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformChromeSafariBrowser chromeSafariBrowser = InAppWebViewPlatform
        .instance!
        .createPlatformChromeSafariBrowser(params);
    PlatformInterface.verify(chromeSafariBrowser, _token);
    return chromeSafariBrowser;
  }

  factory PlatformChromeSafariBrowser.static() {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformChromeSafariBrowser chromeSafariBrowserStatic =
        InAppWebViewPlatform.instance!
            .createPlatformChromeSafariBrowserStatic();
    PlatformInterface.verify(chromeSafariBrowserStatic, _token);
    return chromeSafariBrowserStatic;
  }

  @protected
  PlatformChromeSafariBrowser.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformChromeSafariBrowserCreationParams params;

  Future<void> open(
      {WebUri? url,
      Map<String, String>? headers,
      List<WebUri>? otherLikelyURLs,
      WebUri? referrer,
      @Deprecated('Use settings instead')
      // ignore: deprecated_member_use_from_same_package
      ChromeSafariBrowserClassOptions? options,
      ChromeSafariBrowserSettings? settings}) {
    throw UnimplementedError('open is not implemented on the current platform');
  }

  Future<void> launchUrl({
    required WebUri url,
    Map<String, String>? headers,
    List<WebUri>? otherLikelyURLs,
    WebUri? referrer,
  }) {
    throw UnimplementedError(
        'launchUrl is not implemented on the current platform');
  }

  Future<bool> mayLaunchUrl({WebUri? url, List<WebUri>? otherLikelyURLs}) {
    throw UnimplementedError(
        'mayLaunchUrl is not implemented on the current platform');
  }

  Future<bool> validateRelationship(
      {required CustomTabsRelationType relation, required WebUri origin}) {
    throw UnimplementedError(
        'validateRelationship is not implemented on the current platform');
  }

  Future<void> close() {
    throw UnimplementedError(
        'close is not implemented on the current platform');
  }

  void setActionButton(ChromeSafariBrowserActionButton actionButton) {
    throw UnimplementedError(
        'setActionButton is not implemented on the current platform');
  }

  Future<void> updateActionButton(
      {required Uint8List icon, required String description}) {
    throw UnimplementedError(
        'updateActionButton is not implemented on the current platform');
  }

  void setSecondaryToolbar(
      ChromeSafariBrowserSecondaryToolbar secondaryToolbar) {
    throw UnimplementedError(
        'setSecondaryToolbar is not implemented on the current platform');
  }

  Future<void> updateSecondaryToolbar(
      ChromeSafariBrowserSecondaryToolbar secondaryToolbar) {
    throw UnimplementedError(
        'updateSecondaryToolbar is not implemented on the current platform');
  }

  void addMenuItem(ChromeSafariBrowserMenuItem menuItem) {
    throw UnimplementedError(
        'addMenuItem is not implemented on the current platform');
  }

  void addMenuItems(List<ChromeSafariBrowserMenuItem> menuItems) {
    throw UnimplementedError(
        'addMenuItems is not implemented on the current platform');
  }

  Future<bool> requestPostMessageChannel(
      {required WebUri sourceOrigin, WebUri? targetOrigin}) {
    throw UnimplementedError(
        'requestPostMessageChannel is not implemented on the current platform');
  }

  Future<CustomTabsPostMessageResultType> postMessage(String message) {
    throw UnimplementedError(
        'postMessage is not implemented on the current platform');
  }

  Future<bool> isEngagementSignalsApiAvailable() {
    throw UnimplementedError(
        'isEngagementSignalsApiAvailable is not implemented on the current platform');
  }

  bool isOpened() {
    throw UnimplementedError(
        'isOpened is not implemented on the current platform');
  }

  Future<bool> isAvailable() {
    throw UnimplementedError(
        'isAvailable is not implemented on the current platform');
  }

  Future<int> getMaxToolbarItems() {
    throw UnimplementedError(
        'getMaxToolbarItems is not implemented on the current platform');
  }

  Future<String?> getPackageName(
      {List<String>? packages, bool ignoreDefault = false}) {
    throw UnimplementedError(
        'getPackageName is not implemented on the current platform');
  }

  Future<void> clearWebsiteData() {
    throw UnimplementedError(
        'clearWebsiteData is not implemented on the current platform');
  }

  Future<PrewarmingToken?> prewarmConnections(List<WebUri> URLs) {
    throw UnimplementedError(
        'prewarmConnections is not implemented on the current platform');
  }

  Future<void> invalidatePrewarmingToken(PrewarmingToken prewarmingToken) {
    throw UnimplementedError(
        'invalidatePrewarmingToken is not implemented on the current platform');
  }

  @override
  @mustCallSuper
  void dispose() {
    eventHandler = null;
  }
}

abstract class PlatformChromeSafariBrowserEvents {
  void onServiceConnected() {}

  void onOpened() {}

  void onCompletedInitialLoad(bool? didLoadSuccessfully) {}

  void onInitialLoadDidRedirect(WebUri? url) {}

  void onNavigationEvent(CustomTabsNavigationEventType? navigationEvent) {}

  void onRelationshipValidationResult(
      CustomTabsRelationType? relation, WebUri? requestedOrigin, bool result) {}

  void onWillOpenInBrowser() {}

  void onMessageChannelReady() {}

  void onPostMessage(String message) {}

  void onVerticalScrollEvent(bool isDirectionUp) {}

  void onGreatestScrollPercentageIncreased(int scrollPercentage) {}

  void onSessionEnded(bool didUserInteract) {}

  void onClosed() {}
}
