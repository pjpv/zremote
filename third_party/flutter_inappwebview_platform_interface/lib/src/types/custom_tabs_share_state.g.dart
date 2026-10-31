
part of 'custom_tabs_share_state.dart';

class CustomTabsShareState {
  final int _value;
  final int _nativeValue;
  const CustomTabsShareState._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory CustomTabsShareState._internalMultiPlatform(
          int value, Function nativeValue) =>
      CustomTabsShareState._internal(value, nativeValue());

  static const SHARE_STATE_DEFAULT = CustomTabsShareState._internal(0, 0);

  static const SHARE_STATE_OFF = CustomTabsShareState._internal(2, 2);

  static const SHARE_STATE_ON = CustomTabsShareState._internal(1, 1);

  static final Set<CustomTabsShareState> values = [
    CustomTabsShareState.SHARE_STATE_DEFAULT,
    CustomTabsShareState.SHARE_STATE_OFF,
    CustomTabsShareState.SHARE_STATE_ON,
  ].toSet();

  static CustomTabsShareState? fromValue(int? value) {
    if (value != null) {
      try {
        return CustomTabsShareState.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static CustomTabsShareState? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return CustomTabsShareState.values
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
        return 'SHARE_STATE_DEFAULT';
      case 2:
        return 'SHARE_STATE_OFF';
      case 1:
        return 'SHARE_STATE_ON';
    }
    return _value.toString();
  }
}
