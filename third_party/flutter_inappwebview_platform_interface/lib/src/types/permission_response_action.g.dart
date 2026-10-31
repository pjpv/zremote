
part of 'permission_response_action.dart';

class PermissionResponseAction {
  final int _value;
  final int _nativeValue;
  const PermissionResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PermissionResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      PermissionResponseAction._internal(value, nativeValue());

  static const DENY = PermissionResponseAction._internal(0, 0);

  static const GRANT = PermissionResponseAction._internal(1, 1);

  static const PROMPT = PermissionResponseAction._internal(2, 2);

  static final Set<PermissionResponseAction> values = [
    PermissionResponseAction.DENY,
    PermissionResponseAction.GRANT,
    PermissionResponseAction.PROMPT,
  ].toSet();

  static PermissionResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return PermissionResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PermissionResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PermissionResponseAction.values
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
        return 'DENY';
      case 1:
        return 'GRANT';
      case 2:
        return 'PROMPT';
    }
    return _value.toString();
  }
}

@Deprecated('Use PermissionResponseAction instead')
class PermissionRequestResponseAction {
  final int _value;
  final int _nativeValue;
  const PermissionRequestResponseAction._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory PermissionRequestResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      PermissionRequestResponseAction._internal(value, nativeValue());

  static const DENY = PermissionRequestResponseAction._internal(0, 0);

  static const GRANT = PermissionRequestResponseAction._internal(1, 1);

  static final Set<PermissionRequestResponseAction> values = [
    PermissionRequestResponseAction.DENY,
    PermissionRequestResponseAction.GRANT,
  ].toSet();

  static PermissionRequestResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return PermissionRequestResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PermissionRequestResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PermissionRequestResponseAction.values
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
        return 'DENY';
      case 1:
        return 'GRANT';
    }
    return _value.toString();
  }
}
