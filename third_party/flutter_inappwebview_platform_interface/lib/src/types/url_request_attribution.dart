import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'url_request.dart';

part 'url_request_attribution.g.dart';

@ExchangeableEnum()
class URLRequestAttribution_ {
  // ignore: unused_field
  final int _value;
  const URLRequestAttribution_._internal(this._value);

  static const DEVELOPER = const URLRequestAttribution_._internal(0);

  static const USER = const URLRequestAttribution_._internal(1);
}
