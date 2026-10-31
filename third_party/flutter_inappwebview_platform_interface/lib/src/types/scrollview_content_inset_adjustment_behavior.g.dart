
part of 'scrollview_content_inset_adjustment_behavior.dart';

class ScrollViewContentInsetAdjustmentBehavior {
  final int _value;
  final int _nativeValue;
  const ScrollViewContentInsetAdjustmentBehavior._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory ScrollViewContentInsetAdjustmentBehavior._internalMultiPlatform(
          int value, Function nativeValue) =>
      ScrollViewContentInsetAdjustmentBehavior._internal(value, nativeValue());

  static const ALWAYS =
      ScrollViewContentInsetAdjustmentBehavior._internal(3, 3);

  static const AUTOMATIC =
      ScrollViewContentInsetAdjustmentBehavior._internal(0, 0);

  static const NEVER = ScrollViewContentInsetAdjustmentBehavior._internal(2, 2);

  static const SCROLLABLE_AXES =
      ScrollViewContentInsetAdjustmentBehavior._internal(1, 1);

  static final Set<ScrollViewContentInsetAdjustmentBehavior> values = [
    ScrollViewContentInsetAdjustmentBehavior.ALWAYS,
    ScrollViewContentInsetAdjustmentBehavior.AUTOMATIC,
    ScrollViewContentInsetAdjustmentBehavior.NEVER,
    ScrollViewContentInsetAdjustmentBehavior.SCROLLABLE_AXES,
  ].toSet();

  static ScrollViewContentInsetAdjustmentBehavior? fromValue(int? value) {
    if (value != null) {
      try {
        return ScrollViewContentInsetAdjustmentBehavior.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ScrollViewContentInsetAdjustmentBehavior? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ScrollViewContentInsetAdjustmentBehavior.values
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
      case 3:
        return 'ALWAYS';
      case 0:
        return 'AUTOMATIC';
      case 2:
        return 'NEVER';
      case 1:
        return 'SCROLLABLE_AXES';
    }
    return _value.toString();
  }
}

@Deprecated('Use ScrollViewContentInsetAdjustmentBehavior instead')
class IOSUIScrollViewContentInsetAdjustmentBehavior {
  final int _value;
  final int _nativeValue;
  const IOSUIScrollViewContentInsetAdjustmentBehavior._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSUIScrollViewContentInsetAdjustmentBehavior._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSUIScrollViewContentInsetAdjustmentBehavior._internal(
          value, nativeValue());

  static const ALWAYS =
      IOSUIScrollViewContentInsetAdjustmentBehavior._internal(3, 3);

  static const AUTOMATIC =
      IOSUIScrollViewContentInsetAdjustmentBehavior._internal(0, 0);

  static const NEVER =
      IOSUIScrollViewContentInsetAdjustmentBehavior._internal(2, 2);

  static const SCROLLABLE_AXES =
      IOSUIScrollViewContentInsetAdjustmentBehavior._internal(1, 1);

  static final Set<IOSUIScrollViewContentInsetAdjustmentBehavior> values = [
    IOSUIScrollViewContentInsetAdjustmentBehavior.ALWAYS,
    IOSUIScrollViewContentInsetAdjustmentBehavior.AUTOMATIC,
    IOSUIScrollViewContentInsetAdjustmentBehavior.NEVER,
    IOSUIScrollViewContentInsetAdjustmentBehavior.SCROLLABLE_AXES,
  ].toSet();

  static IOSUIScrollViewContentInsetAdjustmentBehavior? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSUIScrollViewContentInsetAdjustmentBehavior.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSUIScrollViewContentInsetAdjustmentBehavior? fromNativeValue(
      int? value) {
    if (value != null) {
      try {
        return IOSUIScrollViewContentInsetAdjustmentBehavior.values
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
      case 3:
        return 'ALWAYS';
      case 0:
        return 'AUTOMATIC';
      case 2:
        return 'NEVER';
      case 1:
        return 'SCROLLABLE_AXES';
    }
    return _value.toString();
  }
}
