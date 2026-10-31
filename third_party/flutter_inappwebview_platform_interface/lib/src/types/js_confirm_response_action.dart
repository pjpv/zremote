import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'js_confirm_response.dart';

part 'js_confirm_response_action.g.dart';

@ExchangeableEnum()
class JsConfirmResponseAction_ {
  // ignore: unused_field
  final int _value;
  const JsConfirmResponseAction_._internal(this._value);

  static const CONFIRM = const JsConfirmResponseAction_._internal(0);

  static const CANCEL = const JsConfirmResponseAction_._internal(1);
}
