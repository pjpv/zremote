
part of 'chrome_safari_browser_settings.dart';

class ChromeSafariBrowserSettings implements ChromeSafariBrowserOptions {
  ActivityButton? activityButton;

  List<String>? additionalTrustedOrigins;

  bool? alwaysUseBrowserUI;

  bool? barCollapsingEnabled;

  DismissButtonStyle? dismissButtonStyle;

  TrustedWebActivityDisplayMode? displayMode;

  bool? enableUrlBarHiding;

  bool? entersReaderIfAvailable;

  UIEventAttribution? eventAttribution;

  List<AndroidResource>? exitAnimations;

  bool? instantAppsEnabled;

  bool? isSingleInstance;

  bool? isTrustedWebActivity;

  bool? keepAliveEnabled;

  Color? navigationBarColor;

  Color? navigationBarDividerColor;

  bool? noHistory;

  String? packageName;

  Color? preferredBarTintColor;

  Color? preferredControlTintColor;

  ModalPresentationStyle? presentationStyle;

  TrustedWebActivityScreenOrientation? screenOrientation;

  Color? secondaryToolbarColor;

  CustomTabsShareState? shareState;

  bool? showTitle;

  List<AndroidResource>? startAnimations;

  Color? toolbarBackgroundColor;

  ModalTransitionStyle? transitionStyle;
  ChromeSafariBrowserSettings(
      {this.shareState = CustomTabsShareState.SHARE_STATE_DEFAULT,
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
      this.screenOrientation = TrustedWebActivityScreenOrientation.DEFAULT,
      this.startAnimations,
      this.exitAnimations,
      this.alwaysUseBrowserUI = false,
      this.entersReaderIfAvailable = false,
      this.barCollapsingEnabled = false,
      this.dismissButtonStyle = DismissButtonStyle.DONE,
      this.preferredBarTintColor,
      this.preferredControlTintColor,
      this.presentationStyle = ModalPresentationStyle.FULL_SCREEN,
      this.transitionStyle = ModalTransitionStyle.COVER_VERTICAL,
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

  static ChromeSafariBrowserSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ChromeSafariBrowserSettings(
      activityButton: ActivityButton.fromMap(
          map['activityButton']?.cast<String, dynamic>()),
      displayMode: _deserializeDisplayMode(map['displayMode']),
      eventAttribution: UIEventAttribution.fromMap(
          map['eventAttribution']?.cast<String, dynamic>()),
      exitAnimations: map['exitAnimations'] != null
          ? List<AndroidResource>.from(map['exitAnimations']
              .map((e) => AndroidResource.fromMap(e?.cast<String, dynamic>())!))
          : null,
      navigationBarColor: map['navigationBarColor'] != null
          ? UtilColor.fromStringRepresentation(map['navigationBarColor'])
          : null,
      navigationBarDividerColor: map['navigationBarDividerColor'] != null
          ? UtilColor.fromStringRepresentation(map['navigationBarDividerColor'])
          : null,
      packageName: map['packageName'],
      preferredBarTintColor: map['preferredBarTintColor'] != null
          ? UtilColor.fromStringRepresentation(map['preferredBarTintColor'])
          : null,
      preferredControlTintColor: map['preferredControlTintColor'] != null
          ? UtilColor.fromStringRepresentation(map['preferredControlTintColor'])
          : null,
      secondaryToolbarColor: map['secondaryToolbarColor'] != null
          ? UtilColor.fromStringRepresentation(map['secondaryToolbarColor'])
          : null,
      startAnimations: map['startAnimations'] != null
          ? List<AndroidResource>.from(map['startAnimations']
              .map((e) => AndroidResource.fromMap(e?.cast<String, dynamic>())!))
          : null,
      toolbarBackgroundColor: map['toolbarBackgroundColor'] != null
          ? UtilColor.fromStringRepresentation(map['toolbarBackgroundColor'])
          : null,
    );
    instance.additionalTrustedOrigins = map['additionalTrustedOrigins'] != null
        ? List<String>.from(map['additionalTrustedOrigins']!.cast<String>())
        : null;
    instance.alwaysUseBrowserUI = map['alwaysUseBrowserUI'];
    instance.barCollapsingEnabled = map['barCollapsingEnabled'];
    instance.dismissButtonStyle =
        DismissButtonStyle.fromNativeValue(map['dismissButtonStyle']);
    instance.enableUrlBarHiding = map['enableUrlBarHiding'];
    instance.entersReaderIfAvailable = map['entersReaderIfAvailable'];
    instance.instantAppsEnabled = map['instantAppsEnabled'];
    instance.isSingleInstance = map['isSingleInstance'];
    instance.isTrustedWebActivity = map['isTrustedWebActivity'];
    instance.keepAliveEnabled = map['keepAliveEnabled'];
    instance.noHistory = map['noHistory'];
    instance.presentationStyle =
        ModalPresentationStyle.fromNativeValue(map['presentationStyle']);
    instance.screenOrientation =
        TrustedWebActivityScreenOrientation.fromNativeValue(
            map['screenOrientation']);
    instance.shareState =
        CustomTabsShareState.fromNativeValue(map['shareState']);
    instance.showTitle = map['showTitle'];
    instance.transitionStyle =
        ModalTransitionStyle.fromNativeValue(map['transitionStyle']);
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "activityButton": activityButton?.toMap(),
      "additionalTrustedOrigins": additionalTrustedOrigins,
      "alwaysUseBrowserUI": alwaysUseBrowserUI,
      "barCollapsingEnabled": barCollapsingEnabled,
      "dismissButtonStyle": dismissButtonStyle?.toNativeValue(),
      "displayMode": displayMode?.toMap(),
      "enableUrlBarHiding": enableUrlBarHiding,
      "entersReaderIfAvailable": entersReaderIfAvailable,
      "eventAttribution": eventAttribution?.toMap(),
      "exitAnimations": exitAnimations?.map((e) => e.toMap()).toList(),
      "instantAppsEnabled": instantAppsEnabled,
      "isSingleInstance": isSingleInstance,
      "isTrustedWebActivity": isTrustedWebActivity,
      "keepAliveEnabled": keepAliveEnabled,
      "navigationBarColor": navigationBarColor?.toHex(),
      "navigationBarDividerColor": navigationBarDividerColor?.toHex(),
      "noHistory": noHistory,
      "packageName": packageName,
      "preferredBarTintColor": preferredBarTintColor?.toHex(),
      "preferredControlTintColor": preferredControlTintColor?.toHex(),
      "presentationStyle": presentationStyle?.toNativeValue(),
      "screenOrientation": screenOrientation?.toNativeValue(),
      "secondaryToolbarColor": secondaryToolbarColor?.toHex(),
      "shareState": shareState?.toNativeValue(),
      "showTitle": showTitle,
      "startAnimations": startAnimations?.map((e) => e.toMap()).toList(),
      "toolbarBackgroundColor": toolbarBackgroundColor?.toHex(),
      "transitionStyle": transitionStyle?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  ChromeSafariBrowserSettings copy() {
    return ChromeSafariBrowserSettings.fromMap(toMap()) ??
        ChromeSafariBrowserSettings();
  }

  @override
  String toString() {
    return 'ChromeSafariBrowserSettings{activityButton: $activityButton, additionalTrustedOrigins: $additionalTrustedOrigins, alwaysUseBrowserUI: $alwaysUseBrowserUI, barCollapsingEnabled: $barCollapsingEnabled, dismissButtonStyle: $dismissButtonStyle, displayMode: $displayMode, enableUrlBarHiding: $enableUrlBarHiding, entersReaderIfAvailable: $entersReaderIfAvailable, eventAttribution: $eventAttribution, exitAnimations: $exitAnimations, instantAppsEnabled: $instantAppsEnabled, isSingleInstance: $isSingleInstance, isTrustedWebActivity: $isTrustedWebActivity, keepAliveEnabled: $keepAliveEnabled, navigationBarColor: $navigationBarColor, navigationBarDividerColor: $navigationBarDividerColor, noHistory: $noHistory, packageName: $packageName, preferredBarTintColor: $preferredBarTintColor, preferredControlTintColor: $preferredControlTintColor, presentationStyle: $presentationStyle, screenOrientation: $screenOrientation, secondaryToolbarColor: $secondaryToolbarColor, shareState: $shareState, showTitle: $showTitle, startAnimations: $startAnimations, toolbarBackgroundColor: $toolbarBackgroundColor, transitionStyle: $transitionStyle}';
  }
}
