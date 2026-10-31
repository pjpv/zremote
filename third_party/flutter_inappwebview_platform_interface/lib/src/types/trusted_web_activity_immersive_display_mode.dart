import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'trusted_web_activity_display_mode.dart';
import 'layout_in_display_cutout_mode.dart';

part 'trusted_web_activity_immersive_display_mode.g.dart';

@ExchangeableObject()
class TrustedWebActivityImmersiveDisplayMode_
    implements TrustedWebActivityDisplayMode_ {
  bool isSticky;

  @Deprecated("Use displayCutoutMode instead")
  AndroidLayoutInDisplayCutoutMode_? layoutInDisplayCutoutMode;

  LayoutInDisplayCutoutMode_ displayCutoutMode;

  static final _type = "IMMERSIVE_MODE";

  @ExchangeableObjectConstructor()
  TrustedWebActivityImmersiveDisplayMode_(
      {required this.isSticky,
      this.displayCutoutMode = LayoutInDisplayCutoutMode_.DEFAULT,
      this.layoutInDisplayCutoutMode}) {
    this.displayCutoutMode = this.layoutInDisplayCutoutMode != null
        ? LayoutInDisplayCutoutMode_.fromNativeValue(
            layoutInDisplayCutoutMode?.toNativeValue())!
        : this.displayCutoutMode;
  }

  @ExchangeableObjectMethod(toMapMergeWith: true)
  // ignore: unused_element
  Map<String, dynamic> _toMapMergeWith() {
    return {"type": _type};
  }

  @override
  @ExchangeableObjectMethod(ignore: true)
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
