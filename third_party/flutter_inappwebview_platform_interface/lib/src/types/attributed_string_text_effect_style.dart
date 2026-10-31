import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'attributed_string_text_effect_style.g.dart';

@ExchangeableEnum()
class AttributedStringTextEffectStyle_ {
  // ignore: unused_field
  final String _value;
  const AttributedStringTextEffectStyle_._internal(this._value);

  static const LETTERPRESS_STYLE =
      const AttributedStringTextEffectStyle_._internal("letterpressStyle");
}

@Deprecated("Use AttributedStringTextEffectStyle instead")
@ExchangeableEnum()
class IOSNSAttributedStringTextEffectStyle_ {
  // ignore: unused_field
  final String _value;
  const IOSNSAttributedStringTextEffectStyle_._internal(this._value);

  static const LETTERPRESS_STYLE =
      const IOSNSAttributedStringTextEffectStyle_._internal("letterpressStyle");
}
