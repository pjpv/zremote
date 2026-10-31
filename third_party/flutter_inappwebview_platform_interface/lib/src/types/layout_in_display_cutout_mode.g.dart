
part of 'layout_in_display_cutout_mode.dart';

class LayoutInDisplayCutoutMode {
  final int _value;
  final int _nativeValue;
  const LayoutInDisplayCutoutMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory LayoutInDisplayCutoutMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      LayoutInDisplayCutoutMode._internal(value, nativeValue());

  static const ALWAYS = LayoutInDisplayCutoutMode._internal(3, 3);

  static const DEFAULT = LayoutInDisplayCutoutMode._internal(0, 0);

  static const NEVER = LayoutInDisplayCutoutMode._internal(2, 2);

  static const SHORT_EDGES = LayoutInDisplayCutoutMode._internal(1, 1);

  static final Set<LayoutInDisplayCutoutMode> values = [
    LayoutInDisplayCutoutMode.ALWAYS,
    LayoutInDisplayCutoutMode.DEFAULT,
    LayoutInDisplayCutoutMode.NEVER,
    LayoutInDisplayCutoutMode.SHORT_EDGES,
  ].toSet();

  static LayoutInDisplayCutoutMode? fromValue(int? value) {
    if (value != null) {
      try {
        return LayoutInDisplayCutoutMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static LayoutInDisplayCutoutMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return LayoutInDisplayCutoutMode.values
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
        return 'DEFAULT';
      case 2:
        return 'NEVER';
      case 1:
        return 'SHORT_EDGES';
    }
    return _value.toString();
  }
}

@Deprecated('Use LayoutInDisplayCutoutMode instead')
class AndroidLayoutInDisplayCutoutMode {
  final int _value;
  final int _nativeValue;
  const AndroidLayoutInDisplayCutoutMode._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidLayoutInDisplayCutoutMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidLayoutInDisplayCutoutMode._internal(value, nativeValue());

  static const ALWAYS = AndroidLayoutInDisplayCutoutMode._internal(3, 3);

  static const DEFAULT = AndroidLayoutInDisplayCutoutMode._internal(0, 0);

  static const NEVER = AndroidLayoutInDisplayCutoutMode._internal(2, 2);

  static const SHORT_EDGES = AndroidLayoutInDisplayCutoutMode._internal(1, 1);

  static final Set<AndroidLayoutInDisplayCutoutMode> values = [
    AndroidLayoutInDisplayCutoutMode.ALWAYS,
    AndroidLayoutInDisplayCutoutMode.DEFAULT,
    AndroidLayoutInDisplayCutoutMode.NEVER,
    AndroidLayoutInDisplayCutoutMode.SHORT_EDGES,
  ].toSet();

  static AndroidLayoutInDisplayCutoutMode? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidLayoutInDisplayCutoutMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidLayoutInDisplayCutoutMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidLayoutInDisplayCutoutMode.values
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
        return 'DEFAULT';
      case 2:
        return 'NEVER';
      case 1:
        return 'SHORT_EDGES';
    }
    return _value.toString();
  }
}
