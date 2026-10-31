
part of 'proxy_scheme_filter.dart';

class ProxySchemeFilter {
  final String _value;
  final String _nativeValue;
  const ProxySchemeFilter._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ProxySchemeFilter._internalMultiPlatform(
          String value, Function nativeValue) =>
      ProxySchemeFilter._internal(value, nativeValue());

  static const MATCH_ALL_SCHEMES = ProxySchemeFilter._internal('*', '*');

  static const MATCH_HTTP = ProxySchemeFilter._internal('http', 'http');

  static const MATCH_HTTPS = ProxySchemeFilter._internal('https', 'https');

  static final Set<ProxySchemeFilter> values = [
    ProxySchemeFilter.MATCH_ALL_SCHEMES,
    ProxySchemeFilter.MATCH_HTTP,
    ProxySchemeFilter.MATCH_HTTPS,
  ].toSet();

  static ProxySchemeFilter? fromValue(String? value) {
    if (value != null) {
      try {
        return ProxySchemeFilter.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ProxySchemeFilter? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return ProxySchemeFilter.values
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
