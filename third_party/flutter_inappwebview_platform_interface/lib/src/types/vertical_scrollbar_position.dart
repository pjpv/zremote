import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'vertical_scrollbar_position.g.dart';

@ExchangeableEnum()
class VerticalScrollbarPosition_ {
  // ignore: unused_field
  final int _value;
  const VerticalScrollbarPosition_._internal(this._value);

  static const SCROLLBAR_POSITION_DEFAULT =
      const VerticalScrollbarPosition_._internal(0);

  static const SCROLLBAR_POSITION_LEFT =
      const VerticalScrollbarPosition_._internal(1);

  static const SCROLLBAR_POSITION_RIGHT =
      const VerticalScrollbarPosition_._internal(2);
}

@Deprecated("Use VerticalScrollbarPosition instead")
@ExchangeableEnum()
class AndroidVerticalScrollbarPosition_ {
  // ignore: unused_field
  final int _value;
  const AndroidVerticalScrollbarPosition_._internal(this._value);

  static const SCROLLBAR_POSITION_DEFAULT =
      const AndroidVerticalScrollbarPosition_._internal(0);

  static const SCROLLBAR_POSITION_LEFT =
      const AndroidVerticalScrollbarPosition_._internal(1);

  static const SCROLLBAR_POSITION_RIGHT =
      const AndroidVerticalScrollbarPosition_._internal(2);
}
