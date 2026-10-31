
part of 'user_script_injection_time.dart';

class UserScriptInjectionTime {
  final int _value;
  final int _nativeValue;
  const UserScriptInjectionTime._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory UserScriptInjectionTime._internalMultiPlatform(
          int value, Function nativeValue) =>
      UserScriptInjectionTime._internal(value, nativeValue());

  static const AT_DOCUMENT_END = UserScriptInjectionTime._internal(1, 1);

  static const AT_DOCUMENT_START = UserScriptInjectionTime._internal(0, 0);

  static final Set<UserScriptInjectionTime> values = [
    UserScriptInjectionTime.AT_DOCUMENT_END,
    UserScriptInjectionTime.AT_DOCUMENT_START,
  ].toSet();

  static UserScriptInjectionTime? fromValue(int? value) {
    if (value != null) {
      try {
        return UserScriptInjectionTime.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static UserScriptInjectionTime? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return UserScriptInjectionTime.values
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
        return 'AT_DOCUMENT_END';
      case 0:
        return 'AT_DOCUMENT_START';
    }
    return _value.toString();
  }
}
