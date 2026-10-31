
part of 'over_scroll_mode.dart';

class OverScrollMode {
  final int _value;
  final int _nativeValue;
  const OverScrollMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory OverScrollMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      OverScrollMode._internal(value, nativeValue());

  static const ALWAYS = OverScrollMode._internal(0, 0);

  static const IF_CONTENT_SCROLLS = OverScrollMode._internal(1, 1);

  static const NEVER = OverScrollMode._internal(2, 2);

  static final Set<OverScrollMode> values = [
    OverScrollMode.ALWAYS,
    OverScrollMode.IF_CONTENT_SCROLLS,
    OverScrollMode.NEVER,
  ].toSet();

  static OverScrollMode? fromValue(int? value) {
    if (value != null) {
      try {
        return OverScrollMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static OverScrollMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return OverScrollMode.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 0:
        return 'ALWAYS';
      case 1:
        return 'IF_CONTENT_SCROLLS';
      case 2:
        return 'NEVER';
    }
    return _value.toString();
  }
}

@Deprecated('Use OverScrollMode instead')
class AndroidOverScrollMode {
  final int _value;
  final int _nativeValue;
  const AndroidOverScrollMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidOverScrollMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidOverScrollMode._internal(value, nativeValue());

  static const OVER_SCROLL_ALWAYS = AndroidOverScrollMode._internal(0, 0);

  static const OVER_SCROLL_IF_CONTENT_SCROLLS =
      AndroidOverScrollMode._internal(1, 1);

  static const OVER_SCROLL_NEVER = AndroidOverScrollMode._internal(2, 2);

  static final Set<AndroidOverScrollMode> values = [
    AndroidOverScrollMode.OVER_SCROLL_ALWAYS,
    AndroidOverScrollMode.OVER_SCROLL_IF_CONTENT_SCROLLS,
    AndroidOverScrollMode.OVER_SCROLL_NEVER,
  ].toSet();

  static AndroidOverScrollMode? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidOverScrollMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidOverScrollMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidOverScrollMode.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 0:
        return 'OVER_SCROLL_ALWAYS';
      case 1:
        return 'OVER_SCROLL_IF_CONTENT_SCROLLS';
      case 2:
        return 'OVER_SCROLL_NEVER';
    }
    return _value.toString();
  }
}
