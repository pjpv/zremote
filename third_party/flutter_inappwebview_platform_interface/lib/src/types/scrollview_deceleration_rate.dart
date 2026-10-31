import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'scrollview_deceleration_rate.g.dart';

@ExchangeableEnum()
class ScrollViewDecelerationRate_ {
  // ignore: unused_field
  final String _value;
  const ScrollViewDecelerationRate_._internal(this._value);

  static const NORMAL = const ScrollViewDecelerationRate_._internal("NORMAL");

  static const FAST = const ScrollViewDecelerationRate_._internal("FAST");
}

@Deprecated("Use ScrollViewDecelerationRate instead")
@ExchangeableEnum()
class IOSUIScrollViewDecelerationRate_ {
  // ignore: unused_field
  final String _value;
  const IOSUIScrollViewDecelerationRate_._internal(this._value);

  static const NORMAL =
      const IOSUIScrollViewDecelerationRate_._internal("NORMAL");

  static const FAST = const IOSUIScrollViewDecelerationRate_._internal("FAST");
}
