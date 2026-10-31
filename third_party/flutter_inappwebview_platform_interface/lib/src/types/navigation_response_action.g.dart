
part of 'navigation_response_action.dart';

class NavigationResponseAction {
  final int _value;
  final int _nativeValue;
  const NavigationResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory NavigationResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      NavigationResponseAction._internal(value, nativeValue());

  static const ALLOW = NavigationResponseAction._internal(1, 1);

  static const CANCEL = NavigationResponseAction._internal(0, 0);

  static const DOWNLOAD = NavigationResponseAction._internal(2, 2);

  static final Set<NavigationResponseAction> values = [
    NavigationResponseAction.ALLOW,
    NavigationResponseAction.CANCEL,
    NavigationResponseAction.DOWNLOAD,
  ].toSet();

  static NavigationResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return NavigationResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static NavigationResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return NavigationResponseAction.values
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
        return 'ALLOW';
      case 0:
        return 'CANCEL';
      case 2:
        return 'DOWNLOAD';
    }
    return _value.toString();
  }
}

@Deprecated('Use NavigationResponseAction instead')
class IOSNavigationResponseAction {
  final int _value;
  final int _nativeValue;
  const IOSNavigationResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSNavigationResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSNavigationResponseAction._internal(value, nativeValue());

  static const ALLOW = IOSNavigationResponseAction._internal(1, 1);

  static const CANCEL = IOSNavigationResponseAction._internal(0, 0);

  static final Set<IOSNavigationResponseAction> values = [
    IOSNavigationResponseAction.ALLOW,
    IOSNavigationResponseAction.CANCEL,
  ].toSet();

  static IOSNavigationResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSNavigationResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSNavigationResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSNavigationResponseAction.values
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
        return 'ALLOW';
      case 0:
        return 'CANCEL';
    }
    return _value.toString();
  }
}
