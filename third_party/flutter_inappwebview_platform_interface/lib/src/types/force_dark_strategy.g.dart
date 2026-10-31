
part of 'force_dark_strategy.dart';

class ForceDarkStrategy {
  final int _value;
  final int _nativeValue;
  const ForceDarkStrategy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ForceDarkStrategy._internalMultiPlatform(
          int value, Function nativeValue) =>
      ForceDarkStrategy._internal(value, nativeValue());

  static const PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING =
      ForceDarkStrategy._internal(2, 2);

  static const USER_AGENT_DARKENING_ONLY = ForceDarkStrategy._internal(0, 0);

  static const WEB_THEME_DARKENING_ONLY = ForceDarkStrategy._internal(1, 1);

  static final Set<ForceDarkStrategy> values = [
    ForceDarkStrategy.PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING,
    ForceDarkStrategy.USER_AGENT_DARKENING_ONLY,
    ForceDarkStrategy.WEB_THEME_DARKENING_ONLY,
  ].toSet();

  static ForceDarkStrategy? fromValue(int? value) {
    if (value != null) {
      try {
        return ForceDarkStrategy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ForceDarkStrategy? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ForceDarkStrategy.values
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
        return 'PREFER_WEB_THEME_OVER_USER_AGENT_DARKENING';
      case 0:
        return 'USER_AGENT_DARKENING_ONLY';
      case 1:
        return 'WEB_THEME_DARKENING_ONLY';
    }
    return _value.toString();
  }
}
