
part of 'attributed_string.dart';

class AttributedString {
  Color? backgroundColor;

  double? baselineOffset;

  double? expansion;

  Color? foregroundColor;

  double? kern;

  int? ligature;

  double? obliqueness;

  Color? strikethroughColor;

  UnderlineStyle? strikethroughStyle;

  String string;

  Color? strokeColor;

  double? strokeWidth;

  AttributedStringTextEffectStyle? textEffect;

  Color? underlineColor;

  UnderlineStyle? underlineStyle;
  AttributedString(
      {this.backgroundColor,
      this.baselineOffset,
      this.expansion,
      this.foregroundColor,
      this.kern,
      this.ligature,
      this.obliqueness,
      this.strikethroughColor,
      this.strikethroughStyle,
      required this.string,
      this.strokeColor,
      this.strokeWidth,
      this.textEffect,
      this.underlineColor,
      this.underlineStyle});

  static AttributedString? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = AttributedString(
      backgroundColor: map['backgroundColor'] != null
          ? UtilColor.fromStringRepresentation(map['backgroundColor'])
          : null,
      baselineOffset: map['baselineOffset'],
      expansion: map['expansion'],
      foregroundColor: map['foregroundColor'] != null
          ? UtilColor.fromStringRepresentation(map['foregroundColor'])
          : null,
      kern: map['kern'],
      ligature: map['ligature'],
      obliqueness: map['obliqueness'],
      strikethroughColor: map['strikethroughColor'] != null
          ? UtilColor.fromStringRepresentation(map['strikethroughColor'])
          : null,
      strikethroughStyle:
          UnderlineStyle.fromNativeValue(map['strikethroughStyle']),
      string: map['string'],
      strokeColor: map['strokeColor'] != null
          ? UtilColor.fromStringRepresentation(map['strokeColor'])
          : null,
      strokeWidth: map['strokeWidth'],
      textEffect:
          AttributedStringTextEffectStyle.fromNativeValue(map['textEffect']),
      underlineColor: map['underlineColor'] != null
          ? UtilColor.fromStringRepresentation(map['underlineColor'])
          : null,
      underlineStyle: UnderlineStyle.fromNativeValue(map['underlineStyle']),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "backgroundColor": backgroundColor?.toHex(),
      "baselineOffset": baselineOffset,
      "expansion": expansion,
      "foregroundColor": foregroundColor?.toHex(),
      "kern": kern,
      "ligature": ligature,
      "obliqueness": obliqueness,
      "strikethroughColor": strikethroughColor?.toHex(),
      "strikethroughStyle": strikethroughStyle?.toNativeValue(),
      "string": string,
      "strokeColor": strokeColor?.toHex(),
      "strokeWidth": strokeWidth,
      "textEffect": textEffect?.toNativeValue(),
      "underlineColor": underlineColor?.toHex(),
      "underlineStyle": underlineStyle?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AttributedString{backgroundColor: $backgroundColor, baselineOffset: $baselineOffset, expansion: $expansion, foregroundColor: $foregroundColor, kern: $kern, ligature: $ligature, obliqueness: $obliqueness, strikethroughColor: $strikethroughColor, strikethroughStyle: $strikethroughStyle, string: $string, strokeColor: $strokeColor, strokeWidth: $strokeWidth, textEffect: $textEffect, underlineColor: $underlineColor, underlineStyle: $underlineStyle}';
  }
}

@Deprecated('Use AttributedString instead')
class IOSNSAttributedString {
  Color? backgroundColor;

  double? baselineOffset;

  double? expansion;

  Color? foregroundColor;

  double? kern;

  int? ligature;

  double? obliqueness;

  Color? strikethroughColor;

  IOSNSUnderlineStyle? strikethroughStyle;

  String string;

  Color? strokeColor;

  double? strokeWidth;

  IOSNSAttributedStringTextEffectStyle? textEffect;

  Color? underlineColor;

  IOSNSUnderlineStyle? underlineStyle;
  IOSNSAttributedString(
      {this.backgroundColor,
      this.baselineOffset,
      this.expansion,
      this.foregroundColor,
      this.kern,
      this.ligature,
      this.obliqueness,
      this.strikethroughColor,
      this.strikethroughStyle,
      required this.string,
      this.strokeColor,
      this.strokeWidth,
      this.textEffect,
      this.underlineColor,
      this.underlineStyle});

  static IOSNSAttributedString? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = IOSNSAttributedString(
      backgroundColor: map['backgroundColor'] != null
          ? UtilColor.fromStringRepresentation(map['backgroundColor'])
          : null,
      baselineOffset: map['baselineOffset'],
      expansion: map['expansion'],
      foregroundColor: map['foregroundColor'] != null
          ? UtilColor.fromStringRepresentation(map['foregroundColor'])
          : null,
      kern: map['kern'],
      ligature: map['ligature'],
      obliqueness: map['obliqueness'],
      strikethroughColor: map['strikethroughColor'] != null
          ? UtilColor.fromStringRepresentation(map['strikethroughColor'])
          : null,
      strikethroughStyle:
          IOSNSUnderlineStyle.fromNativeValue(map['strikethroughStyle']),
      string: map['string'],
      strokeColor: map['strokeColor'] != null
          ? UtilColor.fromStringRepresentation(map['strokeColor'])
          : null,
      strokeWidth: map['strokeWidth'],
      textEffect: IOSNSAttributedStringTextEffectStyle.fromNativeValue(
          map['textEffect']),
      underlineColor: map['underlineColor'] != null
          ? UtilColor.fromStringRepresentation(map['underlineColor'])
          : null,
      underlineStyle:
          IOSNSUnderlineStyle.fromNativeValue(map['underlineStyle']),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "backgroundColor": backgroundColor?.toHex(),
      "baselineOffset": baselineOffset,
      "expansion": expansion,
      "foregroundColor": foregroundColor?.toHex(),
      "kern": kern,
      "ligature": ligature,
      "obliqueness": obliqueness,
      "strikethroughColor": strikethroughColor?.toHex(),
      "strikethroughStyle": strikethroughStyle?.toNativeValue(),
      "string": string,
      "strokeColor": strokeColor?.toHex(),
      "strokeWidth": strokeWidth,
      "textEffect": textEffect?.toNativeValue(),
      "underlineColor": underlineColor?.toHex(),
      "underlineStyle": underlineStyle?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'IOSNSAttributedString{backgroundColor: $backgroundColor, baselineOffset: $baselineOffset, expansion: $expansion, foregroundColor: $foregroundColor, kern: $kern, ligature: $ligature, obliqueness: $obliqueness, strikethroughColor: $strikethroughColor, strikethroughStyle: $strikethroughStyle, string: $string, strokeColor: $strokeColor, strokeWidth: $strokeWidth, textEffect: $textEffect, underlineColor: $underlineColor, underlineStyle: $underlineStyle}';
  }
}
