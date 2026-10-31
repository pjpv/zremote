
part of 'modal_transition_style.dart';

class ModalTransitionStyle {
  final int _value;
  final int _nativeValue;
  const ModalTransitionStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ModalTransitionStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      ModalTransitionStyle._internal(value, nativeValue());

  static const COVER_VERTICAL = ModalTransitionStyle._internal(0, 0);

  static const CROSS_DISSOLVE = ModalTransitionStyle._internal(2, 2);

  static const FLIP_HORIZONTAL = ModalTransitionStyle._internal(1, 1);

  static const PARTIAL_CURL = ModalTransitionStyle._internal(3, 3);

  static final Set<ModalTransitionStyle> values = [
    ModalTransitionStyle.COVER_VERTICAL,
    ModalTransitionStyle.CROSS_DISSOLVE,
    ModalTransitionStyle.FLIP_HORIZONTAL,
    ModalTransitionStyle.PARTIAL_CURL,
  ].toSet();

  static ModalTransitionStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return ModalTransitionStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ModalTransitionStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ModalTransitionStyle.values
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
        return 'COVER_VERTICAL';
      case 2:
        return 'CROSS_DISSOLVE';
      case 1:
        return 'FLIP_HORIZONTAL';
      case 3:
        return 'PARTIAL_CURL';
    }
    return _value.toString();
  }
}

@Deprecated('Use ModalTransitionStyle instead')
class IOSUIModalTransitionStyle {
  final int _value;
  final int _nativeValue;
  const IOSUIModalTransitionStyle._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSUIModalTransitionStyle._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSUIModalTransitionStyle._internal(value, nativeValue());

  static const COVER_VERTICAL = IOSUIModalTransitionStyle._internal(0, 0);

  static const CROSS_DISSOLVE = IOSUIModalTransitionStyle._internal(2, 2);

  static const FLIP_HORIZONTAL = IOSUIModalTransitionStyle._internal(1, 1);

  static const PARTIAL_CURL = IOSUIModalTransitionStyle._internal(3, 3);

  static final Set<IOSUIModalTransitionStyle> values = [
    IOSUIModalTransitionStyle.COVER_VERTICAL,
    IOSUIModalTransitionStyle.CROSS_DISSOLVE,
    IOSUIModalTransitionStyle.FLIP_HORIZONTAL,
    IOSUIModalTransitionStyle.PARTIAL_CURL,
  ].toSet();

  static IOSUIModalTransitionStyle? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSUIModalTransitionStyle.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSUIModalTransitionStyle? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSUIModalTransitionStyle.values
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
        return 'COVER_VERTICAL';
      case 2:
        return 'CROSS_DISSOLVE';
      case 1:
        return 'FLIP_HORIZONTAL';
      case 3:
        return 'PARTIAL_CURL';
    }
    return _value.toString();
  }
}
