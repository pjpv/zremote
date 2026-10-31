import 'dart:ui';

import '../../in_app_webview/apple/in_app_webview_options.dart';

import '../in_app_browser_settings.dart';
import '../platform_in_app_browser.dart';

import '../../types/main.dart';
import '../../util.dart';

@Deprecated('Use InAppBrowserSettings instead')
class IOSInAppBrowserOptions implements BrowserOptions, IosOptions {
  bool toolbarTopTranslucent;

  Color? toolbarTopBarTintColor;

  Color? toolbarTopTintColor;

  bool hideToolbarBottom;

  Color? toolbarBottomBackgroundColor;

  Color? toolbarBottomTintColor;

  bool toolbarBottomTranslucent;

  String? closeButtonCaption;

  Color? closeButtonColor;

  IOSUIModalPresentationStyle presentationStyle;

  IOSUIModalTransitionStyle transitionStyle;

  IOSInAppBrowserOptions(
      {this.toolbarTopTranslucent = true,
      this.toolbarTopTintColor,
      this.hideToolbarBottom = false,
      this.toolbarBottomBackgroundColor,
      this.toolbarBottomTintColor,
      this.toolbarBottomTranslucent = true,
      this.closeButtonCaption,
      this.closeButtonColor,
      this.presentationStyle = IOSUIModalPresentationStyle.FULL_SCREEN,
      this.transitionStyle = IOSUIModalTransitionStyle.COVER_VERTICAL});

  @override
  Map<String, dynamic> toMap() {
    return {
      "toolbarTopTranslucent": toolbarTopTranslucent,
      "toolbarTopTintColor": toolbarTopTintColor?.toHex(),
      "hideToolbarBottom": hideToolbarBottom,
      "toolbarBottomBackgroundColor": toolbarBottomBackgroundColor?.toHex(),
      "toolbarBottomTintColor": toolbarBottomTintColor?.toHex(),
      "toolbarBottomTranslucent": toolbarBottomTranslucent,
      "closeButtonCaption": closeButtonCaption,
      "closeButtonColor": closeButtonColor?.toHex(),
      "presentationStyle": presentationStyle.toNativeValue(),
      "transitionStyle": transitionStyle.toNativeValue(),
    };
  }

  static IOSInAppBrowserOptions fromMap(Map<String, dynamic> map) {
    var instance = IOSInAppBrowserOptions();
    instance.toolbarTopTranslucent = map["toolbarTopTranslucent"];
    instance.toolbarTopTintColor =
        UtilColor.fromHex(map["toolbarTopTintColor"]);
    instance.hideToolbarBottom = map["hideToolbarBottom"];
    instance.toolbarBottomBackgroundColor =
        UtilColor.fromHex(map["toolbarBottomBackgroundColor"]);
    instance.toolbarBottomTintColor =
        UtilColor.fromHex(map["toolbarBottomTintColor"]);
    instance.toolbarBottomTranslucent = map["toolbarBottomTranslucent"];
    instance.closeButtonCaption = map["closeButtonCaption"];
    instance.closeButtonColor = UtilColor.fromHex(map["closeButtonColor"]);
    instance.presentationStyle =
        IOSUIModalPresentationStyle.fromNativeValue(map["presentationStyle"])!;
    instance.transitionStyle =
        IOSUIModalTransitionStyle.fromNativeValue(map["transitionStyle"])!;
    return instance;
  }

  @override
  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  IOSInAppBrowserOptions copy() {
    return IOSInAppBrowserOptions.fromMap(this.toMap());
  }
}
