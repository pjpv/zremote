import 'dart:ui';

import '../../util.dart';
import '../../types/main.dart';

import '../chrome_safari_browser_settings.dart';
import '../platform_chrome_safari_browser.dart';

import '../../in_app_webview/android/in_app_webview_options.dart';

@Deprecated('Use ChromeSafariBrowserSettings instead')
class AndroidChromeCustomTabsOptions
    implements ChromeSafariBrowserOptions, AndroidOptions {
  @Deprecated('Use shareState instead')
  bool? addDefaultShareMenuItem;

  CustomTabsShareState shareState;

  bool showTitle;

  Color? toolbarBackgroundColor;

  bool enableUrlBarHiding;

  bool instantAppsEnabled;

  String? packageName;

  bool keepAliveEnabled;

  bool isSingleInstance;

  bool noHistory;

  bool isTrustedWebActivity;

  List<String> additionalTrustedOrigins;

  TrustedWebActivityDisplayMode? displayMode;

  TrustedWebActivityScreenOrientation screenOrientation;

  AndroidChromeCustomTabsOptions(
      {@Deprecated('Use shareState instead') this.addDefaultShareMenuItem,
      this.shareState = CustomTabsShareState.SHARE_STATE_DEFAULT,
      this.showTitle = true,
      this.toolbarBackgroundColor,
      this.enableUrlBarHiding = false,
      this.instantAppsEnabled = false,
      this.packageName,
      this.keepAliveEnabled = false,
      this.isSingleInstance = false,
      this.noHistory = false,
      this.isTrustedWebActivity = false,
      this.additionalTrustedOrigins = const [],
      this.displayMode,
      this.screenOrientation = TrustedWebActivityScreenOrientation.DEFAULT});

  @override
  Map<String, dynamic> toMap() {
    return {
      // ignore: deprecated_member_use_from_same_package
      "addDefaultShareMenuItem": addDefaultShareMenuItem,
      "shareState": shareState.toNativeValue(),
      "showTitle": showTitle,
      "toolbarBackgroundColor": toolbarBackgroundColor?.toHex(),
      "enableUrlBarHiding": enableUrlBarHiding,
      "instantAppsEnabled": instantAppsEnabled,
      "packageName": packageName,
      "keepAliveEnabled": keepAliveEnabled,
      "isSingleInstance": isSingleInstance,
      "noHistory": noHistory,
      "isTrustedWebActivity": isTrustedWebActivity,
      "additionalTrustedOrigins": additionalTrustedOrigins,
      "displayMode": displayMode?.toMap(),
      "screenOrientation": screenOrientation.toNativeValue()
    };
  }

  static AndroidChromeCustomTabsOptions fromMap(Map<String, dynamic> map) {
    AndroidChromeCustomTabsOptions options =
        new AndroidChromeCustomTabsOptions();
    // ignore: deprecated_member_use_from_same_package
    options.addDefaultShareMenuItem = map["addDefaultShareMenuItem"];
    options.shareState = map["shareState"];
    options.showTitle = map["showTitle"];
    options.toolbarBackgroundColor =
        UtilColor.fromHex(map["toolbarBackgroundColor"]);
    options.enableUrlBarHiding = map["enableUrlBarHiding"];
    options.instantAppsEnabled = map["instantAppsEnabled"];
    options.packageName = map["packageName"];
    options.keepAliveEnabled = map["keepAliveEnabled"];
    options.isSingleInstance = map["isSingleInstance"];
    options.noHistory = map["noHistory"];
    options.isTrustedWebActivity = map["isTrustedWebActivity"];
    options.additionalTrustedOrigins = map["additionalTrustedOrigins"];
    switch (map["displayMode"]["type"]) {
      case "IMMERSIVE_MODE":
        options.displayMode =
            TrustedWebActivityImmersiveDisplayMode.fromMap(map["displayMode"]);
        break;
      case "DEFAULT_MODE":
      default:
        options.displayMode = TrustedWebActivityDefaultDisplayMode();
        break;
    }
    options.screenOrientation = map["screenOrientation"];
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
  AndroidChromeCustomTabsOptions copy() {
    return AndroidChromeCustomTabsOptions.fromMap(this.toMap());
  }
}
