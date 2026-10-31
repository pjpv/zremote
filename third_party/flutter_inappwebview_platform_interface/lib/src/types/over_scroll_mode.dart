import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'over_scroll_mode.g.dart';

@ExchangeableEnum()
class OverScrollMode_ {
  // ignore: unused_field
  final int _value;
  const OverScrollMode_._internal(this._value);

  static const ALWAYS = const OverScrollMode_._internal(0);

  static const IF_CONTENT_SCROLLS = const OverScrollMode_._internal(1);

  static const NEVER = const OverScrollMode_._internal(2);
}

@Deprecated("Use OverScrollMode instead")
@ExchangeableEnum()
class AndroidOverScrollMode_ {
  // ignore: unused_field
  final int _value;
  const AndroidOverScrollMode_._internal(this._value);

  static const OVER_SCROLL_ALWAYS = const AndroidOverScrollMode_._internal(0);

  static const OVER_SCROLL_IF_CONTENT_SCROLLS =
      const AndroidOverScrollMode_._internal(1);

  static const OVER_SCROLL_NEVER = const AndroidOverScrollMode_._internal(2);
}
