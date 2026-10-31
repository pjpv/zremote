
part of 'vertical_scrollbar_position.dart';

class VerticalScrollbarPosition {
  final int _value;
  final int _nativeValue;
  const VerticalScrollbarPosition._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory VerticalScrollbarPosition._internalMultiPlatform(
          int value, Function nativeValue) =>
      VerticalScrollbarPosition._internal(value, nativeValue());

  static const SCROLLBAR_POSITION_DEFAULT =
      VerticalScrollbarPosition._internal(0, 0);

  static const SCROLLBAR_POSITION_LEFT =
      VerticalScrollbarPosition._internal(1, 1);

  static const SCROLLBAR_POSITION_RIGHT =
      VerticalScrollbarPosition._internal(2, 2);

  static final Set<VerticalScrollbarPosition> values = [
    VerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT,
    VerticalScrollbarPosition.SCROLLBAR_POSITION_LEFT,
    VerticalScrollbarPosition.SCROLLBAR_POSITION_RIGHT,
  ].toSet();

  static VerticalScrollbarPosition? fromValue(int? value) {
    if (value != null) {
      try {
        return VerticalScrollbarPosition.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static VerticalScrollbarPosition? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return VerticalScrollbarPosition.values
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
        return 'SCROLLBAR_POSITION_DEFAULT';
      case 1:
        return 'SCROLLBAR_POSITION_LEFT';
      case 2:
        return 'SCROLLBAR_POSITION_RIGHT';
    }
    return _value.toString();
  }
}

@Deprecated('Use VerticalScrollbarPosition instead')
class AndroidVerticalScrollbarPosition {
  final int _value;
  final int _nativeValue;
  const AndroidVerticalScrollbarPosition._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidVerticalScrollbarPosition._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidVerticalScrollbarPosition._internal(value, nativeValue());

  static const SCROLLBAR_POSITION_DEFAULT =
      AndroidVerticalScrollbarPosition._internal(0, 0);

  static const SCROLLBAR_POSITION_LEFT =
      AndroidVerticalScrollbarPosition._internal(1, 1);

  static const SCROLLBAR_POSITION_RIGHT =
      AndroidVerticalScrollbarPosition._internal(2, 2);

  static final Set<AndroidVerticalScrollbarPosition> values = [
    AndroidVerticalScrollbarPosition.SCROLLBAR_POSITION_DEFAULT,
    AndroidVerticalScrollbarPosition.SCROLLBAR_POSITION_LEFT,
    AndroidVerticalScrollbarPosition.SCROLLBAR_POSITION_RIGHT,
  ].toSet();

  static AndroidVerticalScrollbarPosition? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidVerticalScrollbarPosition.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidVerticalScrollbarPosition? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidVerticalScrollbarPosition.values
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
        return 'SCROLLBAR_POSITION_DEFAULT';
      case 1:
        return 'SCROLLBAR_POSITION_LEFT';
      case 2:
        return 'SCROLLBAR_POSITION_RIGHT';
    }
    return _value.toString();
  }
}
