import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'ajax_request.dart';

part 'ajax_request_action.g.dart';

@ExchangeableEnum()
class AjaxRequestAction_ {
  // ignore: unused_field
  final int _value;
  const AjaxRequestAction_._internal(this._value);

  static const ABORT = const AjaxRequestAction_._internal(0);

  static const PROCEED = const AjaxRequestAction_._internal(1);
}
