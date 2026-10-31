import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'proxy_scheme_filter.dart';

part 'proxy_rule.g.dart';

@ExchangeableObject()
class ProxyRule_ {
  ProxySchemeFilter_? schemeFilter;

  String url;

  ProxyRule_({required this.url, this.schemeFilter});
}
