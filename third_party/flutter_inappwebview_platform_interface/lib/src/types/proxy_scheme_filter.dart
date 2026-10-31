import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../platform_proxy_controller.dart';

part 'proxy_scheme_filter.g.dart';

@ExchangeableEnum()
class ProxySchemeFilter_ {
  // ignore: unused_field
  final String _value;
  const ProxySchemeFilter_._internal(this._value);

  static const MATCH_ALL_SCHEMES = const ProxySchemeFilter_._internal("*");

  static const MATCH_HTTP = const ProxySchemeFilter_._internal("http");

  static const MATCH_HTTPS = const ProxySchemeFilter_._internal("https");
}
