import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';
import 'ajax_request_headers.dart';
import 'ajax_request_ready_state.dart';
import 'ajax_request_event.dart';
import 'ajax_request_action.dart';

part 'ajax_request.g.dart';

@ExchangeableObject()
class AjaxRequest_ {
  dynamic data;

  String? method;

  WebUri? url;

  bool? isAsync;

  String? user;

  String? password;

  bool? withCredentials;

  AjaxRequestHeaders_? headers;

  AjaxRequestReadyState_? readyState;

  int? status;

  WebUri? responseURL;

  String? responseType;

  dynamic response;

  String? responseText;

  String? responseXML;

  String? statusText;

  Map<String, dynamic>? responseHeaders;

  AjaxRequestEvent_? event;

  AjaxRequestAction_? action;

  AjaxRequest_(
      {this.data,
      this.method,
      this.url,
      this.isAsync,
      this.user,
      this.password,
      this.withCredentials,
      this.headers,
      this.readyState,
      this.status,
      this.responseURL,
      this.responseType,
      this.response,
      this.responseText,
      this.responseXML,
      this.statusText,
      this.responseHeaders,
      this.event,
      this.action = AjaxRequestAction_.PROCEED});
}
