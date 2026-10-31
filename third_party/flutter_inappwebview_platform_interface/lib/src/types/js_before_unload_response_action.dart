import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'js_before_unload_response.dart';

part 'js_before_unload_response_action.g.dart';

@ExchangeableEnum()
class JsBeforeUnloadResponseAction_ {
  // ignore: unused_field
  final int _value;
  const JsBeforeUnloadResponseAction_._internal(this._value);

  static const CONFIRM = const JsBeforeUnloadResponseAction_._internal(0);

  static const CANCEL = const JsBeforeUnloadResponseAction_._internal(1);
}
