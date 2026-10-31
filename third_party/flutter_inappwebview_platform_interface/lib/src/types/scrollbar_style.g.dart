
part of 'scrollbar_style.dart';

class ScrollBarStyle {
  final int _value;
  final int _nativeValue;
  const ScrollBarStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ScrollBarStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      ScrollBarStyle._internal(value, nativeValue());

  static const SCROLLBARS_INSIDE_INSET =
      ScrollBarStyle._internal(16777216, 16777216);

  static const SCROLLBARS_INSIDE_OVERLAY = ScrollBarStyle._internal(0, 0);

  static const SCROLLBARS_OUTSIDE_INSET =
      ScrollBarStyle._internal(50331648, 50331648);

  static const SCROLLBARS_OUTSIDE_OVERLAY =
      ScrollBarStyle._internal(33554432, 33554432);

  static final Set<ScrollBarStyle> values = [
    ScrollBarStyle.SCROLLBARS_INSIDE_INSET,
    ScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY,
    ScrollBarStyle.SCROLLBARS_OUTSIDE_INSET,
    ScrollBarStyle.SCROLLBARS_OUTSIDE_OVERLAY,
  ].toSet();

  static ScrollBarStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return ScrollBarStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ScrollBarStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ScrollBarStyle.values
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
      case 16777216:
        return 'SCROLLBARS_INSIDE_INSET';
      case 0:
        return 'SCROLLBARS_INSIDE_OVERLAY';
      case 50331648:
        return 'SCROLLBARS_OUTSIDE_INSET';
      case 33554432:
        return 'SCROLLBARS_OUTSIDE_OVERLAY';
    }
    return _value.toString();
  }
}

@Deprecated('Use ScrollBarStyle instead')
class AndroidScrollBarStyle {
  final int _value;
  final int _nativeValue;
  const AndroidScrollBarStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidScrollBarStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidScrollBarStyle._internal(value, nativeValue());

  static const SCROLLBARS_INSIDE_INSET =
      AndroidScrollBarStyle._internal(16777216, 16777216);

  static const SCROLLBARS_INSIDE_OVERLAY =
      AndroidScrollBarStyle._internal(0, 0);

  static const SCROLLBARS_OUTSIDE_INSET =
      AndroidScrollBarStyle._internal(50331648, 50331648);

  static const SCROLLBARS_OUTSIDE_OVERLAY =
      AndroidScrollBarStyle._internal(33554432, 33554432);

  static final Set<AndroidScrollBarStyle> values = [
    AndroidScrollBarStyle.SCROLLBARS_INSIDE_INSET,
    AndroidScrollBarStyle.SCROLLBARS_INSIDE_OVERLAY,
    AndroidScrollBarStyle.SCROLLBARS_OUTSIDE_INSET,
    AndroidScrollBarStyle.SCROLLBARS_OUTSIDE_OVERLAY,
  ].toSet();

  static AndroidScrollBarStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidScrollBarStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidScrollBarStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidScrollBarStyle.values
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
      case 16777216:
        return 'SCROLLBARS_INSIDE_INSET';
      case 0:
        return 'SCROLLBARS_INSIDE_OVERLAY';
      case 50331648:
        return 'SCROLLBARS_OUTSIDE_INSET';
      case 33554432:
        return 'SCROLLBARS_OUTSIDE_OVERLAY';
    }
    return _value.toString();
  }
}
