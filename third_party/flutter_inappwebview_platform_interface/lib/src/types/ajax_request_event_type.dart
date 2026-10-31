import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'ajax_request_event.dart';

part 'ajax_request_event_type.g.dart';

@ExchangeableEnum()
class AjaxRequestEventType_ {
  // ignore: unused_field
  final String _value;
  const AjaxRequestEventType_._internal(this._value);

  static const LOADSTART = const AjaxRequestEventType_._internal("loadstart");

  static const LOAD = const AjaxRequestEventType_._internal("load");

  static const LOADEND = const AjaxRequestEventType_._internal("loadend");

  static const PROGRESS = const AjaxRequestEventType_._internal("progress");

  static const ERROR = const AjaxRequestEventType_._internal("error");

  static const ABORT = const AjaxRequestEventType_._internal("abort");

  static const TIMEOUT = const AjaxRequestEventType_._internal("timeout");
}
