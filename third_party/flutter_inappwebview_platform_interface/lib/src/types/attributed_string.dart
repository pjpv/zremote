import 'dart:ui';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../pull_to_refresh/main.dart';
import 'underline_style.dart';
import 'attributed_string_text_effect_style.dart';
import '../util.dart';

part 'attributed_string.g.dart';

@ExchangeableObject()
class AttributedString_ {
  String string;

  Color_? backgroundColor;

  double? baselineOffset;

  double? expansion;

  Color_? foregroundColor;

  double? kern;

  int? ligature;

  double? obliqueness;

  Color_? strikethroughColor;

  UnderlineStyle_? strikethroughStyle;

  Color_? strokeColor;

  double? strokeWidth;

  AttributedStringTextEffectStyle_? textEffect;

  Color_? underlineColor;

  UnderlineStyle_? underlineStyle;

  AttributedString_({
    required this.string,
    this.backgroundColor,
    this.baselineOffset,
    this.expansion,
    this.foregroundColor,
    this.kern,
    this.ligature,
    this.obliqueness,
    this.strikethroughColor,
    this.strikethroughStyle,
    this.strokeColor,
    this.strokeWidth,
    this.textEffect,
    this.underlineColor,
    this.underlineStyle,
  });
}

@Deprecated("Use AttributedString instead")
@ExchangeableObject()
class IOSNSAttributedString_ {
  String string;

  Color_? backgroundColor;

  double? baselineOffset;

  double? expansion;

  Color_? foregroundColor;

  double? kern;

  int? ligature;

  double? obliqueness;

  Color_? strikethroughColor;

  IOSNSUnderlineStyle_? strikethroughStyle;

  Color_? strokeColor;

  double? strokeWidth;

  IOSNSAttributedStringTextEffectStyle_? textEffect;

  Color_? underlineColor;

  IOSNSUnderlineStyle_? underlineStyle;

  IOSNSAttributedString_({
    required this.string,
    this.backgroundColor,
    this.baselineOffset,
    this.expansion,
    this.foregroundColor,
    this.kern,
    this.ligature,
    this.obliqueness,
    this.strikethroughColor,
    this.strikethroughStyle,
    this.strokeColor,
    this.strokeWidth,
    this.textEffect,
    this.underlineColor,
    this.underlineStyle,
  });
}
