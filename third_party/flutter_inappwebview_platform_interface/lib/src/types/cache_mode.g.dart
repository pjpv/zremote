
part of 'cache_mode.dart';

class CacheMode {
  final int _value;
  final int _nativeValue;
  const CacheMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory CacheMode._internalMultiPlatform(int value, Function nativeValue) =>
      CacheMode._internal(value, nativeValue());

  static const LOAD_CACHE_ELSE_NETWORK = CacheMode._internal(1, 1);

  static const LOAD_CACHE_ONLY = CacheMode._internal(3, 3);

  static const LOAD_DEFAULT = CacheMode._internal(-1, -1);

  static const LOAD_NO_CACHE = CacheMode._internal(2, 2);

  static final Set<CacheMode> values = [
    CacheMode.LOAD_CACHE_ELSE_NETWORK,
    CacheMode.LOAD_CACHE_ONLY,
    CacheMode.LOAD_DEFAULT,
    CacheMode.LOAD_NO_CACHE,
  ].toSet();

  static CacheMode? fromValue(int? value) {
    if (value != null) {
      try {
        return CacheMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static CacheMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return CacheMode.values
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
        return 'LOAD_CACHE_ELSE_NETWORK';
      case 3:
        return 'LOAD_CACHE_ONLY';
      case -1:
        return 'LOAD_DEFAULT';
      case 2:
        return 'LOAD_NO_CACHE';
    }
    return _value.toString();
  }
}

@Deprecated('Use CacheMode instead')
class AndroidCacheMode {
  final int _value;
  final int _nativeValue;
  const AndroidCacheMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidCacheMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidCacheMode._internal(value, nativeValue());

  static const LOAD_CACHE_ELSE_NETWORK = AndroidCacheMode._internal(1, 1);

  static const LOAD_CACHE_ONLY = AndroidCacheMode._internal(3, 3);

  static const LOAD_DEFAULT = AndroidCacheMode._internal(-1, -1);

  static const LOAD_NO_CACHE = AndroidCacheMode._internal(2, 2);

  static final Set<AndroidCacheMode> values = [
    AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK,
    AndroidCacheMode.LOAD_CACHE_ONLY,
    AndroidCacheMode.LOAD_DEFAULT,
    AndroidCacheMode.LOAD_NO_CACHE,
  ].toSet();

  static AndroidCacheMode? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidCacheMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidCacheMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidCacheMode.values
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
        return 'LOAD_CACHE_ELSE_NETWORK';
      case 3:
        return 'LOAD_CACHE_ONLY';
      case -1:
        return 'LOAD_DEFAULT';
      case 2:
        return 'LOAD_NO_CACHE';
    }
    return _value.toString();
  }
}
