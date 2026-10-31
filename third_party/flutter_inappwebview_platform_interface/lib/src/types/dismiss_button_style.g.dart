
part of 'dismiss_button_style.dart';

class DismissButtonStyle {
  final int _value;
  final int _nativeValue;
  const DismissButtonStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory DismissButtonStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      DismissButtonStyle._internal(value, nativeValue());

  static const CANCEL = DismissButtonStyle._internal(2, 2);

  static const CLOSE = DismissButtonStyle._internal(1, 1);

  static const DONE = DismissButtonStyle._internal(0, 0);

  static final Set<DismissButtonStyle> values = [
    DismissButtonStyle.CANCEL,
    DismissButtonStyle.CLOSE,
    DismissButtonStyle.DONE,
  ].toSet();

  static DismissButtonStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return DismissButtonStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static DismissButtonStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return DismissButtonStyle.values
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
      case 2:
        return 'CANCEL';
      case 1:
        return 'CLOSE';
      case 0:
        return 'DONE';
    }
    return _value.toString();
  }
}

@Deprecated('Use DismissButtonStyle instead')
class IOSSafariDismissButtonStyle {
  final int _value;
  final int _nativeValue;
  const IOSSafariDismissButtonStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSSafariDismissButtonStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSSafariDismissButtonStyle._internal(value, nativeValue());

  static const CANCEL = IOSSafariDismissButtonStyle._internal(2, 2);

  static const CLOSE = IOSSafariDismissButtonStyle._internal(1, 1);

  static const DONE = IOSSafariDismissButtonStyle._internal(0, 0);

  static final Set<IOSSafariDismissButtonStyle> values = [
    IOSSafariDismissButtonStyle.CANCEL,
    IOSSafariDismissButtonStyle.CLOSE,
    IOSSafariDismissButtonStyle.DONE,
  ].toSet();

  static IOSSafariDismissButtonStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSSafariDismissButtonStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSSafariDismissButtonStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSSafariDismissButtonStyle.values
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
      case 2:
        return 'CANCEL';
      case 1:
        return 'CLOSE';
      case 0:
        return 'DONE';
    }
    return _value.toString();
  }
}
