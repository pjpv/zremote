
part of 'selection_granularity.dart';

class SelectionGranularity {
  final int _value;
  final int _nativeValue;
  const SelectionGranularity._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory SelectionGranularity._internalMultiPlatform(
          int value, Function nativeValue) =>
      SelectionGranularity._internal(value, nativeValue());

  static const CHARACTER = SelectionGranularity._internal(1, 1);

  static const DYNAMIC = SelectionGranularity._internal(0, 0);

  static final Set<SelectionGranularity> values = [
    SelectionGranularity.CHARACTER,
    SelectionGranularity.DYNAMIC,
  ].toSet();

  static SelectionGranularity? fromValue(int? value) {
    if (value != null) {
      try {
        return SelectionGranularity.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static SelectionGranularity? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return SelectionGranularity.values
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
        return 'CHARACTER';
      case 0:
        return 'DYNAMIC';
    }
    return _value.toString();
  }
}

@Deprecated('Use SelectionGranularity instead')
class IOSWKSelectionGranularity {
  final int _value;
  final int _nativeValue;
  const IOSWKSelectionGranularity._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSWKSelectionGranularity._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSWKSelectionGranularity._internal(value, nativeValue());

  static const CHARACTER = IOSWKSelectionGranularity._internal(1, 1);

  static const DYNAMIC = IOSWKSelectionGranularity._internal(0, 0);

  static final Set<IOSWKSelectionGranularity> values = [
    IOSWKSelectionGranularity.CHARACTER,
    IOSWKSelectionGranularity.DYNAMIC,
  ].toSet();

  static IOSWKSelectionGranularity? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSWKSelectionGranularity.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSWKSelectionGranularity? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSWKSelectionGranularity.values
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
        return 'CHARACTER';
      case 0:
        return 'DYNAMIC';
    }
    return _value.toString();
  }
}
