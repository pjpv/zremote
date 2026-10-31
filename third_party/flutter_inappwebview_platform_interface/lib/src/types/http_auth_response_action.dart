import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'http_auth_response.dart';

part 'http_auth_response_action.g.dart';

@ExchangeableEnum()
class HttpAuthResponseAction_ {
  // ignore: unused_field
  final int _value;
  const HttpAuthResponseAction_._internal(this._value);

  static const CANCEL = const HttpAuthResponseAction_._internal(0);

  static const PROCEED = const HttpAuthResponseAction_._internal(1);

  static const USE_SAVED_HTTP_AUTH_CREDENTIALS =
      const HttpAuthResponseAction_._internal(2);
}
