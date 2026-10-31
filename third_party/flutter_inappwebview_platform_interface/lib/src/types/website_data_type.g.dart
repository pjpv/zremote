
part of 'website_data_type.dart';

class WebsiteDataType {
  final String _value;
  final String _nativeValue;
  const WebsiteDataType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WebsiteDataType._internalMultiPlatform(
          String value, Function nativeValue) =>
      WebsiteDataType._internal(value, nativeValue());

  static final ALL = [
    WebsiteDataType.WKWebsiteDataTypeFetchCache,
    WebsiteDataType.WKWebsiteDataTypeDiskCache,
    WebsiteDataType.WKWebsiteDataTypeMemoryCache,
    WebsiteDataType.WKWebsiteDataTypeOfflineWebApplicationCache,
    WebsiteDataType.WKWebsiteDataTypeCookies,
    WebsiteDataType.WKWebsiteDataTypeSessionStorage,
    WebsiteDataType.WKWebsiteDataTypeLocalStorage,
    WebsiteDataType.WKWebsiteDataTypeWebSQLDatabases,
    WebsiteDataType.WKWebsiteDataTypeIndexedDBDatabases,
    WebsiteDataType.WKWebsiteDataTypeServiceWorkerRegistrations
  ].toSet();

  static const WKWebsiteDataTypeCookies = WebsiteDataType._internal(
      'WKWebsiteDataTypeCookies', 'WKWebsiteDataTypeCookies');

  static const WKWebsiteDataTypeDiskCache = WebsiteDataType._internal(
      'WKWebsiteDataTypeDiskCache', 'WKWebsiteDataTypeDiskCache');

  static const WKWebsiteDataTypeFetchCache = WebsiteDataType._internal(
      'WKWebsiteDataTypeFetchCache', 'WKWebsiteDataTypeFetchCache');

  static const WKWebsiteDataTypeIndexedDBDatabases = WebsiteDataType._internal(
      'WKWebsiteDataTypeIndexedDBDatabases',
      'WKWebsiteDataTypeIndexedDBDatabases');

  static const WKWebsiteDataTypeLocalStorage = WebsiteDataType._internal(
      'WKWebsiteDataTypeLocalStorage', 'WKWebsiteDataTypeLocalStorage');

  static const WKWebsiteDataTypeMemoryCache = WebsiteDataType._internal(
      'WKWebsiteDataTypeMemoryCache', 'WKWebsiteDataTypeMemoryCache');

  static const WKWebsiteDataTypeOfflineWebApplicationCache =
      WebsiteDataType._internal('WKWebsiteDataTypeOfflineWebApplicationCache',
          'WKWebsiteDataTypeOfflineWebApplicationCache');

  static const WKWebsiteDataTypeServiceWorkerRegistrations =
      WebsiteDataType._internal('WKWebsiteDataTypeServiceWorkerRegistrations',
          'WKWebsiteDataTypeServiceWorkerRegistrations');

  static const WKWebsiteDataTypeSessionStorage = WebsiteDataType._internal(
      'WKWebsiteDataTypeSessionStorage', 'WKWebsiteDataTypeSessionStorage');

  static const WKWebsiteDataTypeWebSQLDatabases = WebsiteDataType._internal(
      'WKWebsiteDataTypeWebSQLDatabases', 'WKWebsiteDataTypeWebSQLDatabases');

  static final Set<WebsiteDataType> values = [
    WebsiteDataType.WKWebsiteDataTypeCookies,
    WebsiteDataType.WKWebsiteDataTypeDiskCache,
    WebsiteDataType.WKWebsiteDataTypeFetchCache,
    WebsiteDataType.WKWebsiteDataTypeIndexedDBDatabases,
    WebsiteDataType.WKWebsiteDataTypeLocalStorage,
    WebsiteDataType.WKWebsiteDataTypeMemoryCache,
    WebsiteDataType.WKWebsiteDataTypeOfflineWebApplicationCache,
    WebsiteDataType.WKWebsiteDataTypeServiceWorkerRegistrations,
    WebsiteDataType.WKWebsiteDataTypeSessionStorage,
    WebsiteDataType.WKWebsiteDataTypeWebSQLDatabases,
  ].toSet();

  static WebsiteDataType? fromValue(String? value) {
    if (value != null) {
      try {
        return WebsiteDataType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static WebsiteDataType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return WebsiteDataType.values
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

@Deprecated('Use WebsiteDataType instead')
class IOSWKWebsiteDataType {
  final String _value;
  final String _nativeValue;
  const IOSWKWebsiteDataType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSWKWebsiteDataType._internalMultiPlatform(
          String value, Function nativeValue) =>
      IOSWKWebsiteDataType._internal(value, nativeValue());

  static final ALL = [
    IOSWKWebsiteDataType.WKWebsiteDataTypeFetchCache,
    IOSWKWebsiteDataType.WKWebsiteDataTypeDiskCache,
    IOSWKWebsiteDataType.WKWebsiteDataTypeMemoryCache,
    IOSWKWebsiteDataType.WKWebsiteDataTypeOfflineWebApplicationCache,
    IOSWKWebsiteDataType.WKWebsiteDataTypeCookies,
    IOSWKWebsiteDataType.WKWebsiteDataTypeSessionStorage,
    IOSWKWebsiteDataType.WKWebsiteDataTypeLocalStorage,
    IOSWKWebsiteDataType.WKWebsiteDataTypeWebSQLDatabases,
    IOSWKWebsiteDataType.WKWebsiteDataTypeIndexedDBDatabases,
    IOSWKWebsiteDataType.WKWebsiteDataTypeServiceWorkerRegistrations
  ].toSet();

  static const WKWebsiteDataTypeCookies = IOSWKWebsiteDataType._internal(
      'WKWebsiteDataTypeCookies', 'WKWebsiteDataTypeCookies');

  static const WKWebsiteDataTypeDiskCache = IOSWKWebsiteDataType._internal(
      'WKWebsiteDataTypeDiskCache', 'WKWebsiteDataTypeDiskCache');

  static const WKWebsiteDataTypeFetchCache = IOSWKWebsiteDataType._internal(
      'WKWebsiteDataTypeFetchCache', 'WKWebsiteDataTypeFetchCache');

  static const WKWebsiteDataTypeIndexedDBDatabases =
      IOSWKWebsiteDataType._internal('WKWebsiteDataTypeIndexedDBDatabases',
          'WKWebsiteDataTypeIndexedDBDatabases');

  static const WKWebsiteDataTypeLocalStorage = IOSWKWebsiteDataType._internal(
      'WKWebsiteDataTypeLocalStorage', 'WKWebsiteDataTypeLocalStorage');

  static const WKWebsiteDataTypeMemoryCache = IOSWKWebsiteDataType._internal(
      'WKWebsiteDataTypeMemoryCache', 'WKWebsiteDataTypeMemoryCache');

  static const WKWebsiteDataTypeOfflineWebApplicationCache =
      IOSWKWebsiteDataType._internal(
          'WKWebsiteDataTypeOfflineWebApplicationCache',
          'WKWebsiteDataTypeOfflineWebApplicationCache');

  static const WKWebsiteDataTypeServiceWorkerRegistrations =
      IOSWKWebsiteDataType._internal(
          'WKWebsiteDataTypeServiceWorkerRegistrations',
          'WKWebsiteDataTypeServiceWorkerRegistrations');

  static const WKWebsiteDataTypeSessionStorage = IOSWKWebsiteDataType._internal(
      'WKWebsiteDataTypeSessionStorage', 'WKWebsiteDataTypeSessionStorage');

  static const WKWebsiteDataTypeWebSQLDatabases =
      IOSWKWebsiteDataType._internal('WKWebsiteDataTypeWebSQLDatabases',
          'WKWebsiteDataTypeWebSQLDatabases');

  static final Set<IOSWKWebsiteDataType> values = [
    IOSWKWebsiteDataType.WKWebsiteDataTypeCookies,
    IOSWKWebsiteDataType.WKWebsiteDataTypeDiskCache,
    IOSWKWebsiteDataType.WKWebsiteDataTypeFetchCache,
    IOSWKWebsiteDataType.WKWebsiteDataTypeIndexedDBDatabases,
    IOSWKWebsiteDataType.WKWebsiteDataTypeLocalStorage,
    IOSWKWebsiteDataType.WKWebsiteDataTypeMemoryCache,
    IOSWKWebsiteDataType.WKWebsiteDataTypeOfflineWebApplicationCache,
    IOSWKWebsiteDataType.WKWebsiteDataTypeServiceWorkerRegistrations,
    IOSWKWebsiteDataType.WKWebsiteDataTypeSessionStorage,
    IOSWKWebsiteDataType.WKWebsiteDataTypeWebSQLDatabases,
  ].toSet();

  static IOSWKWebsiteDataType? fromValue(String? value) {
    if (value != null) {
      try {
        return IOSWKWebsiteDataType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSWKWebsiteDataType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return IOSWKWebsiteDataType.values
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
