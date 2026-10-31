
part of 'force_dark.dart';

class ForceDark {
  final int _value;
  final int _nativeValue;
  const ForceDark._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ForceDark._internalMultiPlatform(int value, Function nativeValue) =>
      ForceDark._internal(value, nativeValue());

  static const AUTO = ForceDark._internal(1, 1);

  static const OFF = ForceDark._internal(0, 0);

  static const ON = ForceDark._internal(2, 2);

  static final Set<ForceDark> values = [
    ForceDark.AUTO,
    ForceDark.OFF,
    ForceDark.ON,
  ].toSet();

  static ForceDark? fromValue(int? value) {
    if (value != null) {
      try {
        return ForceDark.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ForceDark? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ForceDark.values
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
      case 1:
        return 'AUTO';
      case 0:
        return 'OFF';
      case 2:
        return 'ON';
    }
    return _value.toString();
  }
}

@Deprecated('Use ForceDark instead')
class AndroidForceDark {
  final int _value;
  final int _nativeValue;
  const AndroidForceDark._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidForceDark._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidForceDark._internal(value, nativeValue());

  static const FORCE_DARK_AUTO = AndroidForceDark._internal(1, 1);

  static const FORCE_DARK_OFF = AndroidForceDark._internal(0, 0);

  static const FORCE_DARK_ON = AndroidForceDark._internal(2, 2);

  static final Set<AndroidForceDark> values = [
    AndroidForceDark.FORCE_DARK_AUTO,
    AndroidForceDark.FORCE_DARK_OFF,
    AndroidForceDark.FORCE_DARK_ON,
  ].toSet();

  static AndroidForceDark? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidForceDark.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidForceDark? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidForceDark.values
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
      case 1:
        return 'FORCE_DARK_AUTO';
      case 0:
        return 'FORCE_DARK_OFF';
      case 2:
        return 'FORCE_DARK_ON';
    }
    return _value.toString();
  }
}
