import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_platform_interface/src/types/disposable.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../in_app_webview/in_app_webview_settings.dart';
import '../debug_logging_settings.dart';
import '../inappwebview_platform.dart';
import '../types/main.dart';

@immutable
class PlatformFindInteractionControllerCreationParams {
  const PlatformFindInteractionControllerCreationParams(
      {this.onFindResultReceived});

  final void Function(
      PlatformFindInteractionController controller,
      int activeMatchOrdinal,
      int numberOfMatches,
      bool isDoneCounting)? onFindResultReceived;
}

abstract class PlatformFindInteractionController extends PlatformInterface
    implements Disposable {
  static DebugLoggingSettings debugLoggingSettings = DebugLoggingSettings();

  factory PlatformFindInteractionController(
      PlatformFindInteractionControllerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`InAppWebViewPlatform.instance` before use. For unit testing, '
      '`InAppWebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformFindInteractionController webViewControllerDelegate =
        InAppWebViewPlatform.instance!
            .createPlatformFindInteractionController(params);
    PlatformInterface.verify(webViewControllerDelegate, _token);
    return webViewControllerDelegate;
  }

  @protected
  PlatformFindInteractionController.implementation(this.params)
      : super(token: _token);

  static final Object _token = Object();

  final PlatformFindInteractionControllerCreationParams params;

  void Function(PlatformFindInteractionController controller,
          int activeMatchOrdinal, int numberOfMatches, bool isDoneCounting)?
      get onFindResultReceived => params.onFindResultReceived;

  Future<void> findAll({String? find}) {
    throw UnimplementedError(
        'findAll is not implemented on the current platform');
  }

  Future<void> findNext({bool forward = true}) {
    throw UnimplementedError(
        'findNext is not implemented on the current platform');
  }

  Future<void> clearMatches() {
    throw UnimplementedError(
        'clearMatches is not implemented on the current platform');
  }

  Future<void> setSearchText(String? searchText) {
    throw UnimplementedError(
        'setSearchText is not implemented on the current platform');
  }

  Future<String?> getSearchText() {
    throw UnimplementedError(
        'getSearchText is not implemented on the current platform');
  }

  Future<bool?> isFindNavigatorVisible() {
    throw UnimplementedError(
        'isFindNavigatorVisible is not implemented on the current platform');
  }

  Future<void> updateResultCount() {
    throw UnimplementedError(
        'updateResultCount is not implemented on the current platform');
  }

  Future<void> presentFindNavigator() {
    throw UnimplementedError(
        'presentFindNavigator is not implemented on the current platform');
  }

  Future<void> dismissFindNavigator() {
    throw UnimplementedError(
        'dismissFindNavigator is not implemented on the current platform');
  }

  Future<FindSession?> getActiveFindSession() {
    throw UnimplementedError(
        'getActiveFindSession is not implemented on the current platform');
  }

  @override
  void dispose({bool isKeepAlive = false}) {
    throw UnimplementedError(
        'dispose is not implemented on the current platform');
  }
}
