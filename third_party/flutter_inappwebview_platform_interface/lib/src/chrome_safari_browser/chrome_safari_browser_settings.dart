import 'dart:ui';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../types/activity_button.dart';
import '../types/android_resource.dart';
import '../types/custom_tabs_share_state.dart';
import '../types/dismiss_button_style.dart';
import '../types/main.dart';
import '../types/modal_presentation_style.dart';
import '../types/modal_transition_style.dart';
import '../types/trusted_web_activity_display_mode.dart';
import '../types/trusted_web_activity_screen_orientation.dart';
import '../types/ui_event_attribution.dart';
import '../util.dart';
import 'android/chrome_custom_tabs_options.dart';
import 'apple/safari_options.dart';

part 'chrome_safari_browser_settings.g.dart';

TrustedWebActivityDisplayMode? _deserializeDisplayMode(
    Map<String, dynamic>? displayMode) {
  if (displayMode == null) {
    return null;
  }
  switch (displayMode["type"]) {
    case "IMMERSIVE_MODE":
      return TrustedWebActivityImmersiveDisplayMode.fromMap(displayMode);
    case "DEFAULT_MODE":
    default:
      return TrustedWebActivityDefaultDisplayMode();
  }
}

class ChromeSafariBrowserOptions {
  Map<String, dynamic> toMap() {
    return {};
  }

  static ChromeSafariBrowserOptions fromMap(Map<String, dynamic> map) {
    return new ChromeSafariBrowserOptions();
  }

  ChromeSafariBrowserOptions copy() {
    return ChromeSafariBrowserOptions.fromMap(this.toMap());
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
class ChromeSafariBrowserSettings_ implements ChromeSafariBrowserOptions {
  CustomTabsShareState_? shareState;

  bool? showTitle;

  Color_? toolbarBackgroundColor;

  Color_? navigationBarColor;

  Color_? navigationBarDividerColor;

  Color_? secondaryToolbarColor;

  bool? enableUrlBarHiding;

  bool? instantAppsEnabled;

  String? packageName;

  bool? keepAliveEnabled;

  bool? isSingleInstance;

  bool? noHistory;

  bool? isTrustedWebActivity;

  List<String>? additionalTrustedOrigins;

  @ExchangeableObjectProperty(deserializer: _deserializeDisplayMode)
  TrustedWebActivityDisplayMode_? displayMode;

  TrustedWebActivityScreenOrientation_? screenOrientation;

  List<AndroidResource_>? startAnimations;

  List<AndroidResource_>? exitAnimations;

  bool? alwaysUseBrowserUI;

  bool? entersReaderIfAvailable;

  bool? barCollapsingEnabled;

  DismissButtonStyle_? dismissButtonStyle;

  Color_? preferredBarTintColor;

  Color_? preferredControlTintColor;

  ModalPresentationStyle_? presentationStyle;

  ModalTransitionStyle_? transitionStyle;

  ActivityButton_? activityButton;

  UIEventAttribution_? eventAttribution;

  @ExchangeableObjectConstructor()
  ChromeSafariBrowserSettings_(
      {this.shareState = CustomTabsShareState_.SHARE_STATE_DEFAULT,
      this.showTitle = true,
      this.toolbarBackgroundColor,
      this.navigationBarColor,
      this.navigationBarDividerColor,
      this.secondaryToolbarColor,
      this.enableUrlBarHiding = false,
      this.instantAppsEnabled = false,
      this.packageName,
      this.keepAliveEnabled = false,
      this.isSingleInstance = false,
      this.noHistory = false,
      this.isTrustedWebActivity = false,
      this.additionalTrustedOrigins = const [],
      this.displayMode,
      this.screenOrientation = TrustedWebActivityScreenOrientation_.DEFAULT,
      this.startAnimations,
      this.exitAnimations,
      this.alwaysUseBrowserUI = false,
      this.entersReaderIfAvailable = false,
      this.barCollapsingEnabled = false,
      this.dismissButtonStyle = DismissButtonStyle_.DONE,
      this.preferredBarTintColor,
      this.preferredControlTintColor,
      this.presentationStyle = ModalPresentationStyle_.FULL_SCREEN,
      this.transitionStyle = ModalTransitionStyle_.COVER_VERTICAL,
      this.activityButton,
      this.eventAttribution}) {
    if (startAnimations != null) {
      assert(startAnimations!.length == 2,
          "start animations must be have 2 android resources");
    }
    if (exitAnimations != null) {
      assert(exitAnimations!.length == 2,
          "exit animations must be have 2 android resources");
    }
  }

  @override
  @ExchangeableObjectMethod(ignore: true)
  ChromeSafariBrowserSettings_ copy() {
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

@Deprecated('Use ChromeSafariBrowserSettings instead')
class ChromeSafariBrowserClassOptions {
  AndroidChromeCustomTabsOptions? android;

  IOSSafariOptions? ios;

  ChromeSafariBrowserClassOptions({this.android, this.ios}) {
    this.android = this.android ?? AndroidChromeCustomTabsOptions();
    this.ios = this.ios ?? IOSSafariOptions();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> options = {};
    if (Util.isAndroid)
      options.addAll(this.android?.toMap() ?? {});
    else if (Util.isIOS) options.addAll(this.ios?.toMap() ?? {});

    return options;
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
