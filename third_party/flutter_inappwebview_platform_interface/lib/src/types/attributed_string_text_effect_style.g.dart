
part of 'attributed_string_text_effect_style.dart';

class AttributedStringTextEffectStyle {
  final String _value;
  final String _nativeValue;
  const AttributedStringTextEffectStyle._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory AttributedStringTextEffectStyle._internalMultiPlatform(
          String value, Function nativeValue) =>
      AttributedStringTextEffectStyle._internal(value, nativeValue());

  static const LETTERPRESS_STYLE = AttributedStringTextEffectStyle._internal(
      'letterpressStyle', 'letterpressStyle');

  static final Set<AttributedStringTextEffectStyle> values = [
    AttributedStringTextEffectStyle.LETTERPRESS_STYLE,
  ].toSet();

  static AttributedStringTextEffectStyle? fromValue(String? value) {
    if (value != null) {
      try {
        return AttributedStringTextEffectStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AttributedStringTextEffectStyle? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return AttributedStringTextEffectStyle.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}

@Deprecated('Use AttributedStringTextEffectStyle instead')
class IOSNSAttributedStringTextEffectStyle {
  final String _value;
  final String _nativeValue;
  const IOSNSAttributedStringTextEffectStyle._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSNSAttributedStringTextEffectStyle._internalMultiPlatform(
          String value, Function nativeValue) =>
      IOSNSAttributedStringTextEffectStyle._internal(value, nativeValue());

  static const LETTERPRESS_STYLE =
      IOSNSAttributedStringTextEffectStyle._internal(
          'letterpressStyle', 'letterpressStyle');

  static final Set<IOSNSAttributedStringTextEffectStyle> values = [
    IOSNSAttributedStringTextEffectStyle.LETTERPRESS_STYLE,
  ].toSet();

  static IOSNSAttributedStringTextEffectStyle? fromValue(String? value) {
    if (value != null) {
      try {
        return IOSNSAttributedStringTextEffectStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSNSAttributedStringTextEffectStyle? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return IOSNSAttributedStringTextEffectStyle.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
