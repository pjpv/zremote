import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'js_prompt_response.dart';

part 'js_prompt_response_action.g.dart';

@ExchangeableEnum()
class JsPromptResponseAction_ {
  // ignore: unused_field
  final int _value;
  const JsPromptResponseAction_._internal(this._value);

  static const CONFIRM = const JsPromptResponseAction_._internal(0);

  static const CANCEL = const JsPromptResponseAction_._internal(1);
}
