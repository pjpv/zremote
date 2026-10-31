
part of 'trusted_web_activity_immersive_display_mode.dart';

class TrustedWebActivityImmersiveDisplayMode
    implements TrustedWebActivityDisplayMode {
  static final String _type = "IMMERSIVE_MODE";

  LayoutInDisplayCutoutMode displayCutoutMode;

  bool isSticky;

  @Deprecated('Use displayCutoutMode instead')
  AndroidLayoutInDisplayCutoutMode? layoutInDisplayCutoutMode;
  TrustedWebActivityImmersiveDisplayMode(
      {required this.isSticky,
      this.displayCutoutMode = LayoutInDisplayCutoutMode.DEFAULT,
      this.layoutInDisplayCutoutMode}) {
    this.displayCutoutMode = this.layoutInDisplayCutoutMode != null
        ? LayoutInDisplayCutoutMode.fromNativeValue(
            layoutInDisplayCutoutMode?.toNativeValue())!
        : this.displayCutoutMode;
  }

  static TrustedWebActivityImmersiveDisplayMode? fromMap(
      Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = TrustedWebActivityImmersiveDisplayMode(
      isSticky: map['isSticky'],
      layoutInDisplayCutoutMode:
          AndroidLayoutInDisplayCutoutMode.fromNativeValue(
              map['displayCutoutMode']),
    );
    instance.displayCutoutMode =
        LayoutInDisplayCutoutMode.fromNativeValue(map['displayCutoutMode'])!;
    return instance;
  }

  @ExchangeableObjectMethod(toMapMergeWith: true)
  Map<String, dynamic> _toMapMergeWith() {
    return {"type": _type};
  }

  Map<String, dynamic> toMap() {
    return {
      "displayCutoutMode": displayCutoutMode.toNativeValue(),
      "isSticky": isSticky,
      ..._toMapMergeWith(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'TrustedWebActivityImmersiveDisplayMode{displayCutoutMode: $displayCutoutMode, isSticky: $isSticky}';
  }
}
