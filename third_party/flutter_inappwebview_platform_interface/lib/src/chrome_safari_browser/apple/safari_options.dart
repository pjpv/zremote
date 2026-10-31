import 'dart:ui';

import '../../util.dart';
import '../../types/main.dart';

import '../chrome_safari_browser_settings.dart';
import '../platform_chrome_safari_browser.dart';

import '../../in_app_webview/apple/in_app_webview_options.dart';

@Deprecated('Use ChromeSafariBrowserSettings instead')
class IOSSafariOptions implements ChromeSafariBrowserOptions, IosOptions {
  bool entersReaderIfAvailable;

  bool barCollapsingEnabled;

  IOSSafariDismissButtonStyle dismissButtonStyle;

  Color? preferredBarTintColor;

  Color? preferredControlTintColor;

  IOSUIModalPresentationStyle presentationStyle;

  IOSUIModalTransitionStyle transitionStyle;

  IOSSafariOptions(
      {this.entersReaderIfAvailable = false,
      this.barCollapsingEnabled = false,
      this.dismissButtonStyle = IOSSafariDismissButtonStyle.DONE,
      this.preferredBarTintColor,
      this.preferredControlTintColor,
      this.presentationStyle = IOSUIModalPresentationStyle.FULL_SCREEN,
      this.transitionStyle = IOSUIModalTransitionStyle.COVER_VERTICAL});

  @override
  Map<String, dynamic> toMap() {
    return {
      "entersReaderIfAvailable": entersReaderIfAvailable,
      "barCollapsingEnabled": barCollapsingEnabled,
      "dismissButtonStyle": dismissButtonStyle.toNativeValue(),
      "preferredBarTintColor": preferredBarTintColor?.toHex(),
      "preferredControlTintColor": preferredControlTintColor?.toHex(),
      "presentationStyle": presentationStyle.toNativeValue(),
      "transitionStyle": transitionStyle.toNativeValue()
    };
  }

  static IOSSafariOptions fromMap(Map<String, dynamic> map) {
    IOSSafariOptions options = IOSSafariOptions();
    options.entersReaderIfAvailable = map["entersReaderIfAvailable"];
    options.barCollapsingEnabled = map["barCollapsingEnabled"];
    options.dismissButtonStyle =
        IOSSafariDismissButtonStyle.fromNativeValue(map["dismissButtonStyle"])!;
    options.preferredBarTintColor =
        UtilColor.fromHex(map["preferredBarTintColor"]);
    options.preferredControlTintColor =
        UtilColor.fromHex(map["preferredControlTintColor"]);
    options.presentationStyle =
        IOSUIModalPresentationStyle.fromNativeValue(map["presentationStyle"])!;
    options.transitionStyle =
        IOSUIModalTransitionStyle.fromNativeValue(map["transitionStyle"])!;
    return options;
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
  IOSSafariOptions copy() {
    return IOSSafariOptions.fromMap(this.toMap());
  }
}
