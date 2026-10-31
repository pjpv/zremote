import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'inappwebview_platform.dart';
import 'types/proxy_rule.dart';
import 'platform_webview_feature.dart';

part 'platform_proxy_controller.g.dart';

@immutable
class PlatformProxyControllerCreationParams {
  const PlatformProxyControllerCreationParams();
}

abstract class PlatformProxyController extends PlatformInterface {
  factory PlatformProxyController(
      PlatformProxyControllerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformProxyController proxyController =
        InAppWebViewPlatform.instance!.createPlatformProxyController(params);
    PlatformInterface.verify(proxyController, _token);
    return proxyController;
  }

  @protected
  PlatformProxyController.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformProxyControllerCreationParams params;

  Future<void> setProxyOverride({required ProxySettings settings}) {
    throw UnimplementedError(
        'setProxyOverride is not implemented on the current platform');
  }

  Future<void> clearProxyOverride() {
    throw UnimplementedError(
        'clearProxyOverride is not implemented on the current platform');
  }
}

@ExchangeableObject(copyMethod: true)
class ProxySettings_ {
  List<String> bypassRules;

  List<String> directs;

  List<ProxyRule_> proxyRules;

  bool? bypassSimpleHostnames;

  bool? removeImplicitRules;

  bool reverseBypassEnabled;

  ProxySettings_(
      {this.bypassRules = const [],
      this.directs = const [],
      this.proxyRules = const [],
      this.bypassSimpleHostnames,
      this.removeImplicitRules,
      this.reverseBypassEnabled = false});
}
