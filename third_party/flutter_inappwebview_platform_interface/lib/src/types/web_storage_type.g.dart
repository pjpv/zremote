
part of 'web_storage_type.dart';

class WebStorageType {
  final String _value;
  final String _nativeValue;
  const WebStorageType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WebStorageType._internalMultiPlatform(
          String value, Function nativeValue) =>
      WebStorageType._internal(value, nativeValue());

  static const LOCAL_STORAGE =
      WebStorageType._internal('localStorage', 'localStorage');

  static const SESSION_STORAGE =
      WebStorageType._internal('sessionStorage', 'sessionStorage');

  static final Set<WebStorageType> values = [
    WebStorageType.LOCAL_STORAGE,
    WebStorageType.SESSION_STORAGE,
  ].toSet();

  static WebStorageType? fromValue(String? value) {
    if (value != null) {
      try {
        return WebStorageType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static WebStorageType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return WebStorageType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
