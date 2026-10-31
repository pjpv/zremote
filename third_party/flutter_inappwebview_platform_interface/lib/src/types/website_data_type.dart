import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'website_data_type.g.dart';

@ExchangeableEnum()
class WebsiteDataType_ {
  // ignore: unused_field
  final String _value;
  const WebsiteDataType_._internal(this._value);

  static const WKWebsiteDataTypeFetchCache =
      const WebsiteDataType_._internal("WKWebsiteDataTypeFetchCache");

  static const WKWebsiteDataTypeDiskCache =
      const WebsiteDataType_._internal("WKWebsiteDataTypeDiskCache");

  static const WKWebsiteDataTypeMemoryCache =
      const WebsiteDataType_._internal("WKWebsiteDataTypeMemoryCache");

  static const WKWebsiteDataTypeOfflineWebApplicationCache =
      const WebsiteDataType_._internal(
          "WKWebsiteDataTypeOfflineWebApplicationCache");

  static const WKWebsiteDataTypeCookies =
      const WebsiteDataType_._internal("WKWebsiteDataTypeCookies");

  static const WKWebsiteDataTypeSessionStorage =
      const WebsiteDataType_._internal("WKWebsiteDataTypeSessionStorage");

  static const WKWebsiteDataTypeLocalStorage =
      const WebsiteDataType_._internal("WKWebsiteDataTypeLocalStorage");

  static const WKWebsiteDataTypeWebSQLDatabases =
      const WebsiteDataType_._internal("WKWebsiteDataTypeWebSQLDatabases");

  static const WKWebsiteDataTypeIndexedDBDatabases =
      const WebsiteDataType_._internal("WKWebsiteDataTypeIndexedDBDatabases");

  static const WKWebsiteDataTypeServiceWorkerRegistrations =
      const WebsiteDataType_._internal(
          "WKWebsiteDataTypeServiceWorkerRegistrations");

  @ExchangeableEnumCustomValue()
  // ignore: non_constant_identifier_names
  static final Set<WebsiteDataType_> ALL = [
    WebsiteDataType_.WKWebsiteDataTypeFetchCache,
    WebsiteDataType_.WKWebsiteDataTypeDiskCache,
    WebsiteDataType_.WKWebsiteDataTypeMemoryCache,
    WebsiteDataType_.WKWebsiteDataTypeOfflineWebApplicationCache,
    WebsiteDataType_.WKWebsiteDataTypeCookies,
    WebsiteDataType_.WKWebsiteDataTypeSessionStorage,
    WebsiteDataType_.WKWebsiteDataTypeLocalStorage,
    WebsiteDataType_.WKWebsiteDataTypeWebSQLDatabases,
    WebsiteDataType_.WKWebsiteDataTypeIndexedDBDatabases,
    WebsiteDataType_.WKWebsiteDataTypeServiceWorkerRegistrations
  ].toSet();
}

@Deprecated("Use WebsiteDataType instead")
@ExchangeableEnum()
class IOSWKWebsiteDataType_ {
  // ignore: unused_field
  final String _value;
  const IOSWKWebsiteDataType_._internal(this._value);

  static const WKWebsiteDataTypeFetchCache =
      const IOSWKWebsiteDataType_._internal("WKWebsiteDataTypeFetchCache");

  static const WKWebsiteDataTypeDiskCache =
      const IOSWKWebsiteDataType_._internal("WKWebsiteDataTypeDiskCache");

  static const WKWebsiteDataTypeMemoryCache =
      const IOSWKWebsiteDataType_._internal("WKWebsiteDataTypeMemoryCache");

  static const WKWebsiteDataTypeOfflineWebApplicationCache =
      const IOSWKWebsiteDataType_._internal(
          "WKWebsiteDataTypeOfflineWebApplicationCache");

  static const WKWebsiteDataTypeCookies =
      const IOSWKWebsiteDataType_._internal("WKWebsiteDataTypeCookies");

  static const WKWebsiteDataTypeSessionStorage =
      const IOSWKWebsiteDataType_._internal("WKWebsiteDataTypeSessionStorage");

  static const WKWebsiteDataTypeLocalStorage =
      const IOSWKWebsiteDataType_._internal("WKWebsiteDataTypeLocalStorage");

  static const WKWebsiteDataTypeWebSQLDatabases =
      const IOSWKWebsiteDataType_._internal("WKWebsiteDataTypeWebSQLDatabases");

  static const WKWebsiteDataTypeIndexedDBDatabases =
      const IOSWKWebsiteDataType_._internal(
          "WKWebsiteDataTypeIndexedDBDatabases");

  static const WKWebsiteDataTypeServiceWorkerRegistrations =
      const IOSWKWebsiteDataType_._internal(
          "WKWebsiteDataTypeServiceWorkerRegistrations");

  @ExchangeableEnumCustomValue()
  // ignore: non_constant_identifier_names
  static final Set<IOSWKWebsiteDataType_> ALL = [
    IOSWKWebsiteDataType_.WKWebsiteDataTypeFetchCache,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeDiskCache,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeMemoryCache,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeOfflineWebApplicationCache,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeCookies,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeSessionStorage,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeLocalStorage,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeWebSQLDatabases,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeIndexedDBDatabases,
    IOSWKWebsiteDataType_.WKWebsiteDataTypeServiceWorkerRegistrations
  ].toSet();
}
