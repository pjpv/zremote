
part of 'scrollview_deceleration_rate.dart';

class ScrollViewDecelerationRate {
  final String _value;
  final String _nativeValue;
  const ScrollViewDecelerationRate._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ScrollViewDecelerationRate._internalMultiPlatform(
          String value, Function nativeValue) =>
      ScrollViewDecelerationRate._internal(value, nativeValue());

  static const FAST = ScrollViewDecelerationRate._internal('FAST', 'FAST');

  static const NORMAL =
      ScrollViewDecelerationRate._internal('NORMAL', 'NORMAL');

  static final Set<ScrollViewDecelerationRate> values = [
    ScrollViewDecelerationRate.FAST,
    ScrollViewDecelerationRate.NORMAL,
  ].toSet();

  static ScrollViewDecelerationRate? fromValue(String? value) {
    if (value != null) {
      try {
        return ScrollViewDecelerationRate.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ScrollViewDecelerationRate? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return ScrollViewDecelerationRate.values
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

@Deprecated('Use ScrollViewDecelerationRate instead')
class IOSUIScrollViewDecelerationRate {
  final String _value;
  final String _nativeValue;
  const IOSUIScrollViewDecelerationRate._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSUIScrollViewDecelerationRate._internalMultiPlatform(
          String value, Function nativeValue) =>
      IOSUIScrollViewDecelerationRate._internal(value, nativeValue());

  static const FAST = IOSUIScrollViewDecelerationRate._internal('FAST', 'FAST');

  static const NORMAL =
      IOSUIScrollViewDecelerationRate._internal('NORMAL', 'NORMAL');

  static final Set<IOSUIScrollViewDecelerationRate> values = [
    IOSUIScrollViewDecelerationRate.FAST,
    IOSUIScrollViewDecelerationRate.NORMAL,
  ].toSet();

  static IOSUIScrollViewDecelerationRate? fromValue(String? value) {
    if (value != null) {
      try {
        return IOSUIScrollViewDecelerationRate.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSUIScrollViewDecelerationRate? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return IOSUIScrollViewDecelerationRate.values
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
