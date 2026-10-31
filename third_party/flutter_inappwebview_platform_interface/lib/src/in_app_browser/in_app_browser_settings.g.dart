
part of 'in_app_browser_settings.dart';

class InAppBrowserSettings
    implements BrowserOptions, AndroidOptions, IosOptions {
  bool? allowGoBackWithBackButton;

  String? closeButtonCaption;

  Color? closeButtonColor;

  bool? closeOnCannotGoBack;

  bool? hidden;

  bool? hideCloseButton;

  bool? hideDefaultMenuItems;

  bool? hideProgressBar;

  bool? hideTitleBar;

  bool? hideToolbarBottom;

  bool? hideToolbarTop;

  bool? hideUrlBar;

  Color? menuButtonColor;

  ModalPresentationStyle? presentationStyle;

  bool? shouldCloseOnBackButtonPressed;

  Color? toolbarBottomBackgroundColor;

  Color? toolbarBottomTintColor;

  bool? toolbarBottomTranslucent;

  Color? toolbarTopBackgroundColor;

  Color? toolbarTopBarTintColor;

  String? toolbarTopFixedTitle;

  Color? toolbarTopTintColor;

  bool? toolbarTopTranslucent;

  ModalTransitionStyle? transitionStyle;

  double? windowAlphaValue;

  InAppWebViewRect? windowFrame;

  WindowStyleMask? windowStyleMask;

  WindowTitlebarSeparatorStyle? windowTitlebarSeparatorStyle;

  WindowType? windowType;
  InAppBrowserSettings(
      {this.allowGoBackWithBackButton = true,
      this.closeButtonCaption,
      this.closeButtonColor,
      this.closeOnCannotGoBack = true,
      this.hidden = false,
      this.hideCloseButton = false,
      this.hideDefaultMenuItems = false,
      this.hideProgressBar = false,
      this.hideTitleBar = false,
      this.hideToolbarBottom = false,
      this.hideToolbarTop = false,
      this.hideUrlBar = false,
      this.menuButtonColor,
      this.presentationStyle = ModalPresentationStyle.FULL_SCREEN,
      this.shouldCloseOnBackButtonPressed = false,
      this.toolbarBottomBackgroundColor,
      this.toolbarBottomTintColor,
      this.toolbarBottomTranslucent = true,
      this.toolbarTopBackgroundColor,
      this.toolbarTopFixedTitle,
      this.toolbarTopTintColor,
      this.toolbarTopTranslucent = true,
      this.transitionStyle = ModalTransitionStyle.COVER_VERTICAL,
      this.windowAlphaValue = 1.0,
      this.windowFrame,
      this.windowStyleMask,
      this.windowTitlebarSeparatorStyle,
      this.windowType});

  static InAppBrowserSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = InAppBrowserSettings(
      closeButtonCaption: map['closeButtonCaption'],
      closeButtonColor: map['closeButtonColor'] != null
          ? UtilColor.fromStringRepresentation(map['closeButtonColor'])
          : null,
      menuButtonColor: map['menuButtonColor'] != null
          ? UtilColor.fromStringRepresentation(map['menuButtonColor'])
          : null,
      toolbarBottomBackgroundColor: map['toolbarBottomBackgroundColor'] != null
          ? UtilColor.fromStringRepresentation(
              map['toolbarBottomBackgroundColor'])
          : null,
      toolbarBottomTintColor: map['toolbarBottomTintColor'] != null
          ? UtilColor.fromStringRepresentation(map['toolbarBottomTintColor'])
          : null,
      toolbarTopBackgroundColor: map['toolbarTopBackgroundColor'] != null
          ? UtilColor.fromStringRepresentation(map['toolbarTopBackgroundColor'])
          : null,
      toolbarTopFixedTitle: map['toolbarTopFixedTitle'],
      toolbarTopTintColor: map['toolbarTopTintColor'] != null
          ? UtilColor.fromStringRepresentation(map['toolbarTopTintColor'])
          : null,
      windowFrame:
          InAppWebViewRect.fromMap(map['windowFrame']?.cast<String, dynamic>()),
      windowStyleMask: WindowStyleMask.fromNativeValue(map['windowStyleMask']),
      windowTitlebarSeparatorStyle:
          WindowTitlebarSeparatorStyle.fromNativeValue(
              map['windowTitlebarSeparatorStyle']),
      windowType: WindowType.fromNativeValue(map['windowType']),
    );
    instance.allowGoBackWithBackButton = map['allowGoBackWithBackButton'];
    instance.closeOnCannotGoBack = map['closeOnCannotGoBack'];
    instance.hidden = map['hidden'];
    instance.hideCloseButton = map['hideCloseButton'];
    instance.hideDefaultMenuItems = map['hideDefaultMenuItems'];
    instance.hideProgressBar = map['hideProgressBar'];
    instance.hideTitleBar = map['hideTitleBar'];
    instance.hideToolbarBottom = map['hideToolbarBottom'];
    instance.hideToolbarTop = map['hideToolbarTop'];
    instance.hideUrlBar = map['hideUrlBar'];
    instance.presentationStyle =
        ModalPresentationStyle.fromNativeValue(map['presentationStyle']);
    instance.shouldCloseOnBackButtonPressed =
        map['shouldCloseOnBackButtonPressed'];
    instance.toolbarBottomTranslucent = map['toolbarBottomTranslucent'];
    instance.toolbarTopBarTintColor = map['toolbarTopBarTintColor'] != null
        ? UtilColor.fromStringRepresentation(map['toolbarTopBarTintColor'])
        : null;
    instance.toolbarTopTranslucent = map['toolbarTopTranslucent'];
    instance.transitionStyle =
        ModalTransitionStyle.fromNativeValue(map['transitionStyle']);
    instance.windowAlphaValue = map['windowAlphaValue'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "allowGoBackWithBackButton": allowGoBackWithBackButton,
      "closeButtonCaption": closeButtonCaption,
      "closeButtonColor": closeButtonColor?.toHex(),
      "closeOnCannotGoBack": closeOnCannotGoBack,
      "hidden": hidden,
      "hideCloseButton": hideCloseButton,
      "hideDefaultMenuItems": hideDefaultMenuItems,
      "hideProgressBar": hideProgressBar,
      "hideTitleBar": hideTitleBar,
      "hideToolbarBottom": hideToolbarBottom,
      "hideToolbarTop": hideToolbarTop,
      "hideUrlBar": hideUrlBar,
      "menuButtonColor": menuButtonColor?.toHex(),
      "presentationStyle": presentationStyle?.toNativeValue(),
      "shouldCloseOnBackButtonPressed": shouldCloseOnBackButtonPressed,
      "toolbarBottomBackgroundColor": toolbarBottomBackgroundColor?.toHex(),
      "toolbarBottomTintColor": toolbarBottomTintColor?.toHex(),
      "toolbarBottomTranslucent": toolbarBottomTranslucent,
      "toolbarTopBackgroundColor": toolbarTopBackgroundColor?.toHex(),
      "toolbarTopBarTintColor": toolbarTopBarTintColor?.toHex(),
      "toolbarTopFixedTitle": toolbarTopFixedTitle,
      "toolbarTopTintColor": toolbarTopTintColor?.toHex(),
      "toolbarTopTranslucent": toolbarTopTranslucent,
      "transitionStyle": transitionStyle?.toNativeValue(),
      "windowAlphaValue": windowAlphaValue,
      "windowFrame": windowFrame?.toMap(),
      "windowStyleMask": windowStyleMask?.toNativeValue(),
      "windowTitlebarSeparatorStyle":
          windowTitlebarSeparatorStyle?.toNativeValue(),
      "windowType": windowType?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  InAppBrowserSettings copy() {
    return InAppBrowserSettings.fromMap(toMap()) ?? InAppBrowserSettings();
  }

  @override
  String toString() {
    return 'InAppBrowserSettings{allowGoBackWithBackButton: $allowGoBackWithBackButton, closeButtonCaption: $closeButtonCaption, closeButtonColor: $closeButtonColor, closeOnCannotGoBack: $closeOnCannotGoBack, hidden: $hidden, hideCloseButton: $hideCloseButton, hideDefaultMenuItems: $hideDefaultMenuItems, hideProgressBar: $hideProgressBar, hideTitleBar: $hideTitleBar, hideToolbarBottom: $hideToolbarBottom, hideToolbarTop: $hideToolbarTop, hideUrlBar: $hideUrlBar, menuButtonColor: $menuButtonColor, presentationStyle: $presentationStyle, shouldCloseOnBackButtonPressed: $shouldCloseOnBackButtonPressed, toolbarBottomBackgroundColor: $toolbarBottomBackgroundColor, toolbarBottomTintColor: $toolbarBottomTintColor, toolbarBottomTranslucent: $toolbarBottomTranslucent, toolbarTopBackgroundColor: $toolbarTopBackgroundColor, toolbarTopBarTintColor: $toolbarTopBarTintColor, toolbarTopFixedTitle: $toolbarTopFixedTitle, toolbarTopTintColor: $toolbarTopTintColor, toolbarTopTranslucent: $toolbarTopTranslucent, transitionStyle: $transitionStyle, windowAlphaValue: $windowAlphaValue, windowFrame: $windowFrame, windowStyleMask: $windowStyleMask, windowTitlebarSeparatorStyle: $windowTitlebarSeparatorStyle, windowType: $windowType}';
  }
}
