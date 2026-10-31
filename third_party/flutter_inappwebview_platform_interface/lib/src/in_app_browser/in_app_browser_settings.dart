import 'dart:ui';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../types/in_app_webview_rect.dart';
import '../types/modal_presentation_style.dart';
import '../types/modal_transition_style.dart';
import '../types/window_style_mask.dart';
import '../types/window_titlebar_separator_style.dart';
import '../types/window_type.dart';
import '../util.dart';

import '../in_app_webview/in_app_webview_settings.dart';

import 'android/in_app_browser_options.dart';
import '../in_app_webview/android/in_app_webview_options.dart';

import 'apple/in_app_browser_options.dart';
import '../in_app_webview/apple/in_app_webview_options.dart';

part 'in_app_browser_settings.g.dart';

class InAppBrowserClassSettings {
  late InAppBrowserSettings browserSettings;

  late InAppWebViewSettings webViewSettings;

  InAppBrowserClassSettings(
      {InAppBrowserSettings? browserSettings,
      InAppWebViewSettings? webViewSettings}) {
    this.browserSettings = browserSettings ?? InAppBrowserSettings();
    this.webViewSettings = webViewSettings ?? InAppWebViewSettings();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> options = {};

    options.addAll(browserSettings.toMap());
    options.addAll(webViewSettings.toMap());

    return options;
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  String toString() {
    return toMap().toString();
  }

  factory InAppBrowserClassSettings.fromMap(Map<String, dynamic> options,
      {InAppBrowserClassSettings? instance}) {
    if (instance == null) {
      instance = InAppBrowserClassSettings();
    }
    instance.browserSettings =
        InAppBrowserSettings.fromMap(options) ?? InAppBrowserSettings();
    instance.webViewSettings =
        InAppWebViewSettings.fromMap(options) ?? InAppWebViewSettings();
    return instance;
  }

  InAppBrowserClassSettings copy() {
    return InAppBrowserClassSettings.fromMap(toMap());
  }
}

class BrowserOptions {
  Map<String, dynamic> toMap() {
    return {};
  }

  static BrowserOptions fromMap(Map<String, dynamic> map) {
    return BrowserOptions();
  }

  BrowserOptions copy() {
    return BrowserOptions.fromMap(this.toMap());
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

@ExchangeableObject(copyMethod: true)
class InAppBrowserSettings_
    implements BrowserOptions, AndroidOptions, IosOptions {
  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(),
    MacOSPlatform(),
    WindowsPlatform()
  ])
  bool? hidden;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? hideToolbarTop;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  Color_? toolbarTopBackgroundColor;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? hideUrlBar;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? hideProgressBar;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  bool? hideDefaultMenuItems;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? hideTitleBar;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), MacOSPlatform(), WindowsPlatform()])
  String? toolbarTopFixedTitle;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? closeOnCannotGoBack;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? allowGoBackWithBackButton;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  bool? shouldCloseOnBackButtonPressed;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? toolbarTopTranslucent;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? toolbarTopBarTintColor;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? toolbarTopTintColor;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? hideToolbarBottom;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? toolbarBottomBackgroundColor;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? toolbarBottomTintColor;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? toolbarBottomTranslucent;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  String? closeButtonCaption;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? closeButtonColor;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  bool? hideCloseButton;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  Color_? menuButtonColor;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  ModalPresentationStyle_? presentationStyle;

  @SupportedPlatforms(platforms: [IOSPlatform()])
  ModalTransitionStyle_? transitionStyle;

  @SupportedPlatforms(platforms: [MacOSPlatform(), WindowsPlatform()])
  WindowType_? windowType;

  @SupportedPlatforms(platforms: [MacOSPlatform(), WindowsPlatform()])
  double? windowAlphaValue;

  @SupportedPlatforms(platforms: [MacOSPlatform()])
  WindowStyleMask_? windowStyleMask;

  @SupportedPlatforms(platforms: [MacOSPlatform(available: '11.0')])
  WindowTitlebarSeparatorStyle_? windowTitlebarSeparatorStyle;

  @SupportedPlatforms(platforms: [MacOSPlatform(), WindowsPlatform()])
  InAppWebViewRect_? windowFrame;

  InAppBrowserSettings_(
      {this.hidden = false,
      this.hideToolbarTop = false,
      this.toolbarTopBackgroundColor,
      this.hideUrlBar = false,
      this.hideProgressBar = false,
      this.hideDefaultMenuItems = false,
      this.toolbarTopTranslucent = true,
      this.toolbarTopTintColor,
      this.hideToolbarBottom = false,
      this.toolbarBottomBackgroundColor,
      this.toolbarBottomTintColor,
      this.toolbarBottomTranslucent = true,
      this.closeButtonCaption,
      this.closeButtonColor,
      this.hideCloseButton = false,
      this.menuButtonColor,
      this.presentationStyle = ModalPresentationStyle_.FULL_SCREEN,
      this.transitionStyle = ModalTransitionStyle_.COVER_VERTICAL,
      this.hideTitleBar = false,
      this.toolbarTopFixedTitle,
      this.closeOnCannotGoBack = true,
      this.allowGoBackWithBackButton = true,
      this.shouldCloseOnBackButtonPressed = false,
      this.windowType,
      this.windowAlphaValue = 1.0,
      this.windowStyleMask,
      this.windowTitlebarSeparatorStyle,
      this.windowFrame});

  @override
  @ExchangeableObjectMethod(ignore: true)
  InAppBrowserSettings_ copy() {
    throw UnimplementedError();
  }

  @override
  @ExchangeableObjectMethod(ignore: true)
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  @ExchangeableObjectMethod(ignore: true)
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}

@Deprecated('Use InAppBrowserClassSettings instead')
class InAppBrowserClassOptions {
  late InAppBrowserOptions crossPlatform;

  late AndroidInAppBrowserOptions android;

  late IOSInAppBrowserOptions ios;

  late InAppWebViewGroupOptions inAppWebViewGroupOptions;

  InAppBrowserClassOptions(
      {InAppBrowserOptions? crossPlatform,
      AndroidInAppBrowserOptions? android,
      IOSInAppBrowserOptions? ios,
      InAppWebViewGroupOptions? inAppWebViewGroupOptions}) {
    this.crossPlatform = crossPlatform ?? InAppBrowserOptions();
    this.android = android ?? AndroidInAppBrowserOptions();
    this.ios = ios ?? IOSInAppBrowserOptions();
    this.inAppWebViewGroupOptions =
        inAppWebViewGroupOptions ?? InAppWebViewGroupOptions();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> options = {};

    options.addAll(this.crossPlatform.toMap());
    options.addAll(this.inAppWebViewGroupOptions.crossPlatform.toMap());
    if (Util.isAndroid) {
      options.addAll(this.android.toMap());
      options.addAll(this.inAppWebViewGroupOptions.android.toMap());
    } else if (Util.isIOS) {
      options.addAll(this.ios.toMap());
      options.addAll(this.inAppWebViewGroupOptions.ios.toMap());
    }

    return options;
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  static InAppBrowserClassOptions fromMap(Map<String, dynamic> options) {
    InAppBrowserClassOptions inAppBrowserClassOptions =
        InAppBrowserClassOptions();

    inAppBrowserClassOptions.crossPlatform =
        InAppBrowserOptions.fromMap(options);
    inAppBrowserClassOptions.inAppWebViewGroupOptions =
        InAppWebViewGroupOptions();
    inAppBrowserClassOptions.inAppWebViewGroupOptions.crossPlatform =
        InAppWebViewOptions.fromMap(options);
    if (Util.isAndroid) {
      inAppBrowserClassOptions.android =
          AndroidInAppBrowserOptions.fromMap(options);
      inAppBrowserClassOptions.inAppWebViewGroupOptions.android =
          AndroidInAppWebViewOptions.fromMap(options);
    } else if (Util.isIOS) {
      inAppBrowserClassOptions.ios = IOSInAppBrowserOptions.fromMap(options);
      inAppBrowserClassOptions.inAppWebViewGroupOptions.ios =
          IOSInAppWebViewOptions.fromMap(options);
    }

    return inAppBrowserClassOptions;
  }

  InAppBrowserClassOptions copy() {
    return InAppBrowserClassOptions.fromMap(this.toMap());
  }
}

@Deprecated('Use InAppBrowserClassSettings instead')
class InAppBrowserOptions
    implements BrowserOptions, AndroidOptions, IosOptions {
  bool hidden;

  bool hideToolbarTop;

  Color? toolbarTopBackgroundColor;

  bool hideUrlBar;

  bool hideProgressBar;

  InAppBrowserOptions(
      {this.hidden = false,
      this.hideToolbarTop = false,
      this.toolbarTopBackgroundColor,
      this.hideUrlBar = false,
      this.hideProgressBar = false});

  @override
  Map<String, dynamic> toMap() {
    return {
      "hidden": hidden,
      "hideToolbarTop": hideToolbarTop,
      "toolbarTopBackgroundColor": toolbarTopBackgroundColor?.toHex(),
      "hideUrlBar": hideUrlBar,
      "hideProgressBar": hideProgressBar
    };
  }

  static InAppBrowserOptions fromMap(Map<String, dynamic> map) {
    var instance = InAppBrowserOptions();
    instance.hidden = map["hidden"];
    instance.hideToolbarTop = map["hideToolbarTop"];
    instance.toolbarTopBackgroundColor =
        UtilColor.fromHex(map["toolbarTopBackgroundColor"]);
    instance.hideUrlBar = map["hideUrlBar"];
    instance.hideProgressBar = map["hideProgressBar"];
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
  InAppBrowserOptions copy() {
    return InAppBrowserOptions.fromMap(this.toMap());
  }
}
