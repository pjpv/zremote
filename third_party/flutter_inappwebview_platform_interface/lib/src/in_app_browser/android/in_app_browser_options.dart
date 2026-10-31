import '../../in_app_webview/android/in_app_webview_options.dart';

import '../in_app_browser_settings.dart';
import '../platform_in_app_browser.dart';

@Deprecated('Use InAppBrowserSettings instead')
class AndroidInAppBrowserOptions implements BrowserOptions, AndroidOptions {
  bool hideTitleBar;

  String? toolbarTopFixedTitle;

  bool closeOnCannotGoBack;

  bool allowGoBackWithBackButton;

  bool shouldCloseOnBackButtonPressed;

  AndroidInAppBrowserOptions(
      {this.hideTitleBar = false,
      this.toolbarTopFixedTitle,
      this.closeOnCannotGoBack = true,
      this.allowGoBackWithBackButton = true,
      this.shouldCloseOnBackButtonPressed = false});

  @override
  Map<String, dynamic> toMap() {
    return {
      "hideTitleBar": hideTitleBar,
      "toolbarTopFixedTitle": toolbarTopFixedTitle,
      "closeOnCannotGoBack": closeOnCannotGoBack,
      "allowGoBackWithBackButton": allowGoBackWithBackButton,
      "shouldCloseOnBackButtonPressed": shouldCloseOnBackButtonPressed,
    };
  }

  static AndroidInAppBrowserOptions fromMap(Map<String, dynamic> map) {
    var instance = AndroidInAppBrowserOptions();
    instance.hideTitleBar = map["hideTitleBar"];
    instance.toolbarTopFixedTitle = map["toolbarTopFixedTitle"];
    instance.closeOnCannotGoBack = map["closeOnCannotGoBack"];
    instance.allowGoBackWithBackButton = map["allowGoBackWithBackButton"];
    instance.shouldCloseOnBackButtonPressed =
        map["shouldCloseOnBackButtonPressed"];
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
  AndroidInAppBrowserOptions copy() {
    return AndroidInAppBrowserOptions.fromMap(this.toMap());
  }
}
