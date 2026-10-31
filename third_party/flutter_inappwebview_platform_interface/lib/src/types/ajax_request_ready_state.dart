import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'ajax_request.dart';

part 'ajax_request_ready_state.g.dart';

@ExchangeableEnum()
class AjaxRequestReadyState_ {
  // ignore: unused_field
  final int _value;
  const AjaxRequestReadyState_._internal(this._value);

  static const UNSENT = const AjaxRequestReadyState_._internal(0);

  static const OPENED = const AjaxRequestReadyState_._internal(1);

  static const HEADERS_RECEIVED = const AjaxRequestReadyState_._internal(2);

  static const LOADING = const AjaxRequestReadyState_._internal(3);

  static const DONE = const AjaxRequestReadyState_._internal(4);
}
