import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'web_authentication_session_error.g.dart';

@ExchangeableEnum()
class WebAuthenticationSessionError_ {
  // ignore: unused_field
  final int _value;
  const WebAuthenticationSessionError_._internal(this._value);

  static const CANCELED_LOGIN = WebAuthenticationSessionError_._internal(1);

  static const PRESENTATION_CONTEXT_NOT_PROVIDED =
      WebAuthenticationSessionError_._internal(2);

  static const PRESENTATION_CONTEXT_INVALID =
      WebAuthenticationSessionError_._internal(3);
}
