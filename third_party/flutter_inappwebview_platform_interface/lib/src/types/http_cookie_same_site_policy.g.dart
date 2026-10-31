
part of 'http_cookie_same_site_policy.dart';

class HTTPCookieSameSitePolicy {
  final String _value;
  final String _nativeValue;
  const HTTPCookieSameSitePolicy._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory HTTPCookieSameSitePolicy._internalMultiPlatform(
          String value, Function nativeValue) =>
      HTTPCookieSameSitePolicy._internal(value, nativeValue());

  static const LAX = HTTPCookieSameSitePolicy._internal('Lax', 'Lax');

  static const NONE = HTTPCookieSameSitePolicy._internal('None', 'None');

  static const STRICT = HTTPCookieSameSitePolicy._internal('Strict', 'Strict');

  static final Set<HTTPCookieSameSitePolicy> values = [
    HTTPCookieSameSitePolicy.LAX,
    HTTPCookieSameSitePolicy.NONE,
    HTTPCookieSameSitePolicy.STRICT,
  ].toSet();

  static HTTPCookieSameSitePolicy? fromValue(String? value) {
    if (value != null) {
      try {
        return HTTPCookieSameSitePolicy.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static HTTPCookieSameSitePolicy? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return HTTPCookieSameSitePolicy.values
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
