import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'scrollview_content_inset_adjustment_behavior.g.dart';

@ExchangeableEnum()
class ScrollViewContentInsetAdjustmentBehavior_ {
  // ignore: unused_field
  final int _value;
  const ScrollViewContentInsetAdjustmentBehavior_._internal(this._value);

  static const AUTOMATIC =
      const ScrollViewContentInsetAdjustmentBehavior_._internal(0);

  static const SCROLLABLE_AXES =
      const ScrollViewContentInsetAdjustmentBehavior_._internal(1);

  static const NEVER =
      const ScrollViewContentInsetAdjustmentBehavior_._internal(2);

  static const ALWAYS =
      const ScrollViewContentInsetAdjustmentBehavior_._internal(3);
}

@Deprecated("Use ScrollViewContentInsetAdjustmentBehavior instead")
@ExchangeableEnum()
class IOSUIScrollViewContentInsetAdjustmentBehavior_ {
  // ignore: unused_field
  final int _value;
  const IOSUIScrollViewContentInsetAdjustmentBehavior_._internal(this._value);

  static const AUTOMATIC =
      const IOSUIScrollViewContentInsetAdjustmentBehavior_._internal(0);

  static const SCROLLABLE_AXES =
      const IOSUIScrollViewContentInsetAdjustmentBehavior_._internal(1);

  static const NEVER =
      const IOSUIScrollViewContentInsetAdjustmentBehavior_._internal(2);

  static const ALWAYS =
      const IOSUIScrollViewContentInsetAdjustmentBehavior_._internal(3);
}
