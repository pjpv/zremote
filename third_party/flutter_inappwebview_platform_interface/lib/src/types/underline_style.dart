import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'underline_style.g.dart';

@ExchangeableEnum()
class UnderlineStyle_ {
  // ignore: unused_field
  final int _value;
  const UnderlineStyle_._internal(this._value);

  static const STYLE_NONE = const UnderlineStyle_._internal(0);

  static const SINGLE = const UnderlineStyle_._internal(1);

  static const THICK = const UnderlineStyle_._internal(2);

  static const DOUBLE = const UnderlineStyle_._internal(9);

  static const PATTERN_DOT = const UnderlineStyle_._internal(256);

  static const PATTERN_DASH = const UnderlineStyle_._internal(512);

  static const PATTERN_DASH_DOT = const UnderlineStyle_._internal(768);

  static const PATTERN_DASH_DOT_DOT = const UnderlineStyle_._internal(1024);

  static const BY_WORD = const UnderlineStyle_._internal(32768);
}

@Deprecated("Use UnderlineStyle instead")
@ExchangeableEnum()
class IOSNSUnderlineStyle_ {
  // ignore: unused_field
  final int _value;
  const IOSNSUnderlineStyle_._internal(this._value);

  static const STYLE_NONE = const IOSNSUnderlineStyle_._internal(0);

  static const SINGLE = const IOSNSUnderlineStyle_._internal(1);

  static const THICK = const IOSNSUnderlineStyle_._internal(2);

  static const DOUBLE = const IOSNSUnderlineStyle_._internal(9);

  static const PATTERN_DOT = const IOSNSUnderlineStyle_._internal(256);

  static const PATTERN_DASH = const IOSNSUnderlineStyle_._internal(512);

  static const PATTERN_DASH_DOT = const IOSNSUnderlineStyle_._internal(768);

  static const PATTERN_DASH_DOT_DOT =
      const IOSNSUnderlineStyle_._internal(1024);

  static const BY_WORD = const IOSNSUnderlineStyle_._internal(32768);
}
