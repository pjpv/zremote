import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'scrollbar_style.g.dart';

@ExchangeableEnum()
class ScrollBarStyle_ {
  // ignore: unused_field
  final int _value;
  const ScrollBarStyle_._internal(this._value);

  static const SCROLLBARS_INSIDE_OVERLAY = const ScrollBarStyle_._internal(0);

  static const SCROLLBARS_INSIDE_INSET =
      const ScrollBarStyle_._internal(16777216);

  static const SCROLLBARS_OUTSIDE_OVERLAY =
      const ScrollBarStyle_._internal(33554432);

  static const SCROLLBARS_OUTSIDE_INSET =
      const ScrollBarStyle_._internal(50331648);
}

@Deprecated("Use ScrollBarStyle instead")
@ExchangeableEnum()
class AndroidScrollBarStyle_ {
  // ignore: unused_field
  final int _value;
  const AndroidScrollBarStyle_._internal(this._value);

  static const SCROLLBARS_INSIDE_OVERLAY =
      const AndroidScrollBarStyle_._internal(0);

  static const SCROLLBARS_INSIDE_INSET =
      const AndroidScrollBarStyle_._internal(16777216);

  static const SCROLLBARS_OUTSIDE_OVERLAY =
      const AndroidScrollBarStyle_._internal(33554432);

  static const SCROLLBARS_OUTSIDE_INSET =
      const AndroidScrollBarStyle_._internal(50331648);
}
