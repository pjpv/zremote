import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'cookie.dart';

part 'http_cookie_same_site_policy.g.dart';

@ExchangeableEnum()
class HTTPCookieSameSitePolicy_ {
  // ignore: unused_field
  final String _value;
  const HTTPCookieSameSitePolicy_._internal(this._value);

  static const LAX = const HTTPCookieSameSitePolicy_._internal("Lax");

  static const STRICT = const HTTPCookieSameSitePolicy_._internal("Strict");

  static const NONE = const HTTPCookieSameSitePolicy_._internal("None");
}
