
part of 'user_preferred_content_mode.dart';

class UserPreferredContentMode {
  final int _value;
  final int _nativeValue;
  const UserPreferredContentMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory UserPreferredContentMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      UserPreferredContentMode._internal(value, nativeValue());

  static const DESKTOP = UserPreferredContentMode._internal(2, 2);

  static const MOBILE = UserPreferredContentMode._internal(1, 1);

  static const RECOMMENDED = UserPreferredContentMode._internal(0, 0);

  static final Set<UserPreferredContentMode> values = [
    UserPreferredContentMode.DESKTOP,
    UserPreferredContentMode.MOBILE,
    UserPreferredContentMode.RECOMMENDED,
  ].toSet();

  static UserPreferredContentMode? fromValue(int? value) {
    if (value != null) {
      try {
        return UserPreferredContentMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static UserPreferredContentMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return UserPreferredContentMode.values
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
        return 'DESKTOP';
      case 1:
        return 'MOBILE';
      case 0:
        return 'RECOMMENDED';
    }
    return _value.toString();
  }
}
