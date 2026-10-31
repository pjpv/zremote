
part of 'navigation_action_policy.dart';

class NavigationActionPolicy {
  final int _value;
  final int _nativeValue;
  const NavigationActionPolicy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory NavigationActionPolicy._internalMultiPlatform(
          int value, Function nativeValue) =>
      NavigationActionPolicy._internal(value, nativeValue());

  static const ALLOW = NavigationActionPolicy._internal(1, 1);

  static const CANCEL = NavigationActionPolicy._internal(0, 0);

  static const DOWNLOAD = NavigationActionPolicy._internal(2, 2);

  static final Set<NavigationActionPolicy> values = [
    NavigationActionPolicy.ALLOW,
    NavigationActionPolicy.CANCEL,
    NavigationActionPolicy.DOWNLOAD,
  ].toSet();

  static NavigationActionPolicy? fromValue(int? value) {
    if (value != null) {
      try {
        return NavigationActionPolicy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static NavigationActionPolicy? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return NavigationActionPolicy.values
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
