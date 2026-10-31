
part of 'url_request_cache_policy.dart';

class URLRequestCachePolicy {
  final int _value;
  final int _nativeValue;
  const URLRequestCachePolicy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory URLRequestCachePolicy._internalMultiPlatform(
          int value, Function nativeValue) =>
      URLRequestCachePolicy._internal(value, nativeValue());

  static const RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA =
      URLRequestCachePolicy._internal(4, 4);

  static const RELOAD_IGNORING_LOCAL_CACHE_DATA =
      URLRequestCachePolicy._internal(1, 1);

  static const RELOAD_REVALIDATING_CACHE_DATA =
      URLRequestCachePolicy._internal(5, 5);

  static const RETURN_CACHE_DATA_DONT_LOAD =
      URLRequestCachePolicy._internal(3, 3);

  static const RETURN_CACHE_DATA_ELSE_LOAD =
      URLRequestCachePolicy._internal(2, 2);

  static const USE_PROTOCOL_CACHE_POLICY =
      URLRequestCachePolicy._internal(0, 0);

  static final Set<URLRequestCachePolicy> values = [
    URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA,
    URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA,
    URLRequestCachePolicy.RELOAD_REVALIDATING_CACHE_DATA,
    URLRequestCachePolicy.RETURN_CACHE_DATA_DONT_LOAD,
    URLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD,
    URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY,
  ].toSet();

  static URLRequestCachePolicy? fromValue(int? value) {
    if (value != null) {
      try {
        return URLRequestCachePolicy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static URLRequestCachePolicy? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return URLRequestCachePolicy.values
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
      case 4:
        return 'RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA';
      case 1:
        return 'RELOAD_IGNORING_LOCAL_CACHE_DATA';
      case 5:
        return 'RELOAD_REVALIDATING_CACHE_DATA';
      case 3:
        return 'RETURN_CACHE_DATA_DONT_LOAD';
      case 2:
        return 'RETURN_CACHE_DATA_ELSE_LOAD';
      case 0:
        return 'USE_PROTOCOL_CACHE_POLICY';
    }
    return _value.toString();
  }
}

@Deprecated('Use URLRequestCachePolicy instead')
class IOSURLRequestCachePolicy {
  final int _value;
  final int _nativeValue;
  const IOSURLRequestCachePolicy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSURLRequestCachePolicy._internalMultiPlatform(
          int value, Function nativeValue) =>
      IOSURLRequestCachePolicy._internal(value, nativeValue());

  static const RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA =
      IOSURLRequestCachePolicy._internal(4, 4);

  static const RELOAD_IGNORING_LOCAL_CACHE_DATA =
      IOSURLRequestCachePolicy._internal(1, 1);

  static const RELOAD_REVALIDATING_CACHE_DATA =
      IOSURLRequestCachePolicy._internal(5, 5);

  static const RETURN_CACHE_DATA_DONT_LOAD =
      IOSURLRequestCachePolicy._internal(3, 3);

  static const RETURN_CACHE_DATA_ELSE_LOAD =
      IOSURLRequestCachePolicy._internal(2, 2);

  static const USE_PROTOCOL_CACHE_POLICY =
      IOSURLRequestCachePolicy._internal(0, 0);

  static final Set<IOSURLRequestCachePolicy> values = [
    IOSURLRequestCachePolicy.RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA,
    IOSURLRequestCachePolicy.RELOAD_IGNORING_LOCAL_CACHE_DATA,
    IOSURLRequestCachePolicy.RELOAD_REVALIDATING_CACHE_DATA,
    IOSURLRequestCachePolicy.RETURN_CACHE_DATA_DONT_LOAD,
    IOSURLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD,
    IOSURLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY,
  ].toSet();

  static IOSURLRequestCachePolicy? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSURLRequestCachePolicy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSURLRequestCachePolicy? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSURLRequestCachePolicy.values
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
      case 4:
        return 'RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA';
      case 1:
        return 'RELOAD_IGNORING_LOCAL_CACHE_DATA';
      case 5:
        return 'RELOAD_REVALIDATING_CACHE_DATA';
      case 3:
        return 'RETURN_CACHE_DATA_DONT_LOAD';
      case 2:
        return 'RETURN_CACHE_DATA_ELSE_LOAD';
      case 0:
        return 'USE_PROTOCOL_CACHE_POLICY';
    }
    return _value.toString();
  }
}
