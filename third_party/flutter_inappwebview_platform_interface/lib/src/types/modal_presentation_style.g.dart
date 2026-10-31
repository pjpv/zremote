
part of 'modal_presentation_style.dart';

class ModalPresentationStyle {
  final int _value;
  final int _nativeValue;
  const ModalPresentationStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ModalPresentationStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      ModalPresentationStyle._internal(value, nativeValue());

  static const AUTOMATIC = ModalPresentationStyle._internal(9, 9);

  static const CURRENT_CONTEXT = ModalPresentationStyle._internal(3, 3);

  static const CUSTOM = ModalPresentationStyle._internal(4, 4);

  static const FORM_SHEET = ModalPresentationStyle._internal(2, 2);

  static const FULL_SCREEN = ModalPresentationStyle._internal(0, 0);

  static const NONE = ModalPresentationStyle._internal(8, 8);

  static const OVER_CURRENT_CONTEXT = ModalPresentationStyle._internal(6, 6);

  static const OVER_FULL_SCREEN = ModalPresentationStyle._internal(5, 5);

  static const PAGE_SHEET = ModalPresentationStyle._internal(1, 1);

  static const POPOVER = ModalPresentationStyle._internal(7, 7);

  static final Set<ModalPresentationStyle> values = [
    ModalPresentationStyle.AUTOMATIC,
    ModalPresentationStyle.CURRENT_CONTEXT,
    ModalPresentationStyle.CUSTOM,
    ModalPresentationStyle.FORM_SHEET,
    ModalPresentationStyle.FULL_SCREEN,
    ModalPresentationStyle.NONE,
    ModalPresentationStyle.OVER_CURRENT_CONTEXT,
    ModalPresentationStyle.OVER_FULL_SCREEN,
    ModalPresentationStyle.PAGE_SHEET,
    ModalPresentationStyle.POPOVER,
  ].toSet();

  static ModalPresentationStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return ModalPresentationStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ModalPresentationStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ModalPresentationStyle.values
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
      case 9:
        return 'AUTOMATIC';
      case 3:
        return 'CURRENT_CONTEXT';
      case 4:
        return 'CUSTOM';
      case 2:
        return 'FORM_SHEET';
      case 0:
        return 'FULL_SCREEN';
      case 8:
        return 'NONE';
      case 6:
        return 'OVER_CURRENT_CONTEXT';
      case 5:
        return 'OVER_FULL_SCREEN';
      case 1:
        return 'PAGE_SHEET';
      case 7:
        return 'POPOVER';
    }
    return _value.toString();
  }
}

@Deprecated('Use ModalPresentationStyle instead')
class IOSUIModalPresentationStyle {
  final int _value;
  final int _nativeValue;
  const IOSUIModalPresentationStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSUIModalPresentationStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSUIModalPresentationStyle._internal(value, nativeValue());

  static const AUTOMATIC = IOSUIModalPresentationStyle._internal(9, 9);

  static const CURRENT_CONTEXT = IOSUIModalPresentationStyle._internal(3, 3);

  static const CUSTOM = IOSUIModalPresentationStyle._internal(4, 4);

  static const FORM_SHEET = IOSUIModalPresentationStyle._internal(2, 2);

  static const FULL_SCREEN = IOSUIModalPresentationStyle._internal(0, 0);

  static const NONE = IOSUIModalPresentationStyle._internal(8, 8);

  static const OVER_CURRENT_CONTEXT =
      IOSUIModalPresentationStyle._internal(6, 6);

  static const OVER_FULL_SCREEN = IOSUIModalPresentationStyle._internal(5, 5);

  static const PAGE_SHEET = IOSUIModalPresentationStyle._internal(1, 1);

  static const POPOVER = IOSUIModalPresentationStyle._internal(7, 7);

  static final Set<IOSUIModalPresentationStyle> values = [
    IOSUIModalPresentationStyle.AUTOMATIC,
    IOSUIModalPresentationStyle.CURRENT_CONTEXT,
    IOSUIModalPresentationStyle.CUSTOM,
    IOSUIModalPresentationStyle.FORM_SHEET,
    IOSUIModalPresentationStyle.FULL_SCREEN,
    IOSUIModalPresentationStyle.NONE,
    IOSUIModalPresentationStyle.OVER_CURRENT_CONTEXT,
    IOSUIModalPresentationStyle.OVER_FULL_SCREEN,
    IOSUIModalPresentationStyle.PAGE_SHEET,
    IOSUIModalPresentationStyle.POPOVER,
  ].toSet();

  static IOSUIModalPresentationStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSUIModalPresentationStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSUIModalPresentationStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSUIModalPresentationStyle.values
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
      case 9:
        return 'AUTOMATIC';
      case 3:
        return 'CURRENT_CONTEXT';
      case 4:
        return 'CUSTOM';
      case 2:
        return 'FORM_SHEET';
      case 0:
        return 'FULL_SCREEN';
      case 8:
        return 'NONE';
      case 6:
        return 'OVER_CURRENT_CONTEXT';
      case 5:
        return 'OVER_FULL_SCREEN';
      case 1:
        return 'PAGE_SHEET';
      case 7:
        return 'POPOVER';
    }
    return _value.toString();
  }
}
