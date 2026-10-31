
part of 'should_allow_deprecated_tls_action.dart';

class ShouldAllowDeprecatedTLSAction {
  final int _value;
  final int _nativeValue;
  const ShouldAllowDeprecatedTLSAction._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory ShouldAllowDeprecatedTLSAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      ShouldAllowDeprecatedTLSAction._internal(value, nativeValue());

  static const ALLOW = ShouldAllowDeprecatedTLSAction._internal(1, 1);

  static const CANCEL = ShouldAllowDeprecatedTLSAction._internal(0, 0);

  static final Set<ShouldAllowDeprecatedTLSAction> values = [
    ShouldAllowDeprecatedTLSAction.ALLOW,
    ShouldAllowDeprecatedTLSAction.CANCEL,
  ].toSet();

  static ShouldAllowDeprecatedTLSAction? fromValue(int? value) {
    if (value != null) {
      try {
        return ShouldAllowDeprecatedTLSAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ShouldAllowDeprecatedTLSAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ShouldAllowDeprecatedTLSAction.values
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

@Deprecated('Use ShouldAllowDeprecatedTLSAction instead')
class IOSShouldAllowDeprecatedTLSAction {
  final int _value;
  final int _nativeValue;
  const IOSShouldAllowDeprecatedTLSAction._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory IOSShouldAllowDeprecatedTLSAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSShouldAllowDeprecatedTLSAction._internal(value, nativeValue());

  static const ALLOW = IOSShouldAllowDeprecatedTLSAction._internal(1, 1);

  static const CANCEL = IOSShouldAllowDeprecatedTLSAction._internal(0, 0);

  static final Set<IOSShouldAllowDeprecatedTLSAction> values = [
    IOSShouldAllowDeprecatedTLSAction.ALLOW,
    IOSShouldAllowDeprecatedTLSAction.CANCEL,
  ].toSet();

  static IOSShouldAllowDeprecatedTLSAction? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSShouldAllowDeprecatedTLSAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSShouldAllowDeprecatedTLSAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSShouldAllowDeprecatedTLSAction.values
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
