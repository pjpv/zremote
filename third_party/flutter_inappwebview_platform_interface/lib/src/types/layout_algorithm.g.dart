
part of 'layout_algorithm.dart';

class LayoutAlgorithm {
  final String _value;
  final String _nativeValue;
  const LayoutAlgorithm._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory LayoutAlgorithm._internalMultiPlatform(
          String value, Function nativeValue) =>
      LayoutAlgorithm._internal(value, nativeValue());

  static const NARROW_COLUMNS =
      LayoutAlgorithm._internal('NARROW_COLUMNS', 'NARROW_COLUMNS');

  static const NORMAL = LayoutAlgorithm._internal('NORMAL', 'NORMAL');

  static const TEXT_AUTOSIZING =
      LayoutAlgorithm._internal('TEXT_AUTOSIZING', 'TEXT_AUTOSIZING');

  static final Set<LayoutAlgorithm> values = [
    LayoutAlgorithm.NARROW_COLUMNS,
    LayoutAlgorithm.NORMAL,
    LayoutAlgorithm.TEXT_AUTOSIZING,
  ].toSet();

  static LayoutAlgorithm? fromValue(String? value) {
    if (value != null) {
      try {
        return LayoutAlgorithm.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static LayoutAlgorithm? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return LayoutAlgorithm.values
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

@Deprecated('Use LayoutAlgorithm instead')
class AndroidLayoutAlgorithm {
  final String _value;
  final String _nativeValue;
  const AndroidLayoutAlgorithm._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidLayoutAlgorithm._internalMultiPlatform(
          String value, Function nativeValue) =>
      AndroidLayoutAlgorithm._internal(value, nativeValue());

  static const NARROW_COLUMNS =
      AndroidLayoutAlgorithm._internal('NARROW_COLUMNS', 'NARROW_COLUMNS');

  static const NORMAL = AndroidLayoutAlgorithm._internal('NORMAL', 'NORMAL');

  static const TEXT_AUTOSIZING =
      AndroidLayoutAlgorithm._internal('TEXT_AUTOSIZING', 'TEXT_AUTOSIZING');

  static final Set<AndroidLayoutAlgorithm> values = [
    AndroidLayoutAlgorithm.NARROW_COLUMNS,
    AndroidLayoutAlgorithm.NORMAL,
    AndroidLayoutAlgorithm.TEXT_AUTOSIZING,
  ].toSet();

  static AndroidLayoutAlgorithm? fromValue(String? value) {
    if (value != null) {
      try {
        return AndroidLayoutAlgorithm.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidLayoutAlgorithm? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return AndroidLayoutAlgorithm.values
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
