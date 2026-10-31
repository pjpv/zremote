import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'layout_in_display_cutout_mode.g.dart';

@ExchangeableEnum()
class LayoutInDisplayCutoutMode_ {
  // ignore: unused_field
  final int _value;
  const LayoutInDisplayCutoutMode_._internal(this._value);

  static const DEFAULT = const LayoutInDisplayCutoutMode_._internal(0);

  static const SHORT_EDGES = const LayoutInDisplayCutoutMode_._internal(1);

  static const NEVER = const LayoutInDisplayCutoutMode_._internal(2);

  static const ALWAYS = const LayoutInDisplayCutoutMode_._internal(3);

  @ExchangeableObjectMethod(ignore: true)
  static LayoutInDisplayCutoutMode_? fromNativeValue(int? value) {
    return null;
  }
}

@Deprecated("Use LayoutInDisplayCutoutMode instead")
@ExchangeableEnum()
class AndroidLayoutInDisplayCutoutMode_ {
  // ignore: unused_field
  final int _value;
  const AndroidLayoutInDisplayCutoutMode_._internal(this._value);

  static const DEFAULT = const AndroidLayoutInDisplayCutoutMode_._internal(0);

  static const SHORT_EDGES =
      const AndroidLayoutInDisplayCutoutMode_._internal(1);

  static const NEVER = const AndroidLayoutInDisplayCutoutMode_._internal(2);

  static const ALWAYS = const AndroidLayoutInDisplayCutoutMode_._internal(3);

  @ExchangeableObjectMethod(ignore: true)
  int toNativeValue() => 0;
}
