
part of 'url_credential_persistence.dart';

class URLCredentialPersistence {
  final int _value;
  final int _nativeValue;
  const URLCredentialPersistence._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory URLCredentialPersistence._internalMultiPlatform(
          int value, Function nativeValue) =>
      URLCredentialPersistence._internal(value, nativeValue());

  static const FOR_SESSION = URLCredentialPersistence._internal(1, 1);

  static const NONE = URLCredentialPersistence._internal(0, 0);

  static const PERMANENT = URLCredentialPersistence._internal(2, 2);

  static const SYNCHRONIZABLE = URLCredentialPersistence._internal(3, 3);

  static final Set<URLCredentialPersistence> values = [
    URLCredentialPersistence.FOR_SESSION,
    URLCredentialPersistence.NONE,
    URLCredentialPersistence.PERMANENT,
    URLCredentialPersistence.SYNCHRONIZABLE,
  ].toSet();

  static URLCredentialPersistence? fromValue(int? value) {
    if (value != null) {
      try {
        return URLCredentialPersistence.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static URLCredentialPersistence? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return URLCredentialPersistence.values
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
        return 'FOR_SESSION';
      case 0:
        return 'NONE';
      case 2:
        return 'PERMANENT';
      case 3:
        return 'SYNCHRONIZABLE';
    }
    return _value.toString();
  }
}

@Deprecated('Use URLCredentialPersistence instead')
class IOSURLCredentialPersistence {
  final int _value;
  final int _nativeValue;
  const IOSURLCredentialPersistence._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSURLCredentialPersistence._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSURLCredentialPersistence._internal(value, nativeValue());

  static const FOR_SESSION = IOSURLCredentialPersistence._internal(1, 1);

  static const NONE = IOSURLCredentialPersistence._internal(0, 0);

  static const PERMANENT = IOSURLCredentialPersistence._internal(2, 2);

  static const SYNCHRONIZABLE = IOSURLCredentialPersistence._internal(3, 3);

  static final Set<IOSURLCredentialPersistence> values = [
    IOSURLCredentialPersistence.FOR_SESSION,
    IOSURLCredentialPersistence.NONE,
    IOSURLCredentialPersistence.PERMANENT,
    IOSURLCredentialPersistence.SYNCHRONIZABLE,
  ].toSet();

  static IOSURLCredentialPersistence? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSURLCredentialPersistence.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSURLCredentialPersistence? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSURLCredentialPersistence.values
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
        return 'FOR_SESSION';
      case 0:
        return 'NONE';
      case 2:
        return 'PERMANENT';
      case 3:
        return 'SYNCHRONIZABLE';
    }
    return _value.toString();
  }
}
