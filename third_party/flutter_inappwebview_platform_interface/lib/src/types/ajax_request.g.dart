
part of 'ajax_request.dart';

class AjaxRequest {
  AjaxRequestAction? action;

  dynamic data;

  AjaxRequestEvent? event;

  AjaxRequestHeaders? headers;

  bool? isAsync;

  String? method;

  String? password;

  AjaxRequestReadyState? readyState;

  dynamic response;

  Map<String, dynamic>? responseHeaders;

  String? responseText;

  String? responseType;

  WebUri? responseURL;

  String? responseXML;

  int? status;

  String? statusText;

  WebUri? url;

  String? user;

  bool? withCredentials;
  AjaxRequest(
      {this.action = AjaxRequestAction.PROCEED,
      this.data,
      this.event,
      this.headers,
      this.isAsync,
      this.method,
      this.password,
      this.readyState,
      this.response,
      this.responseHeaders,
      this.responseText,
      this.responseType,
      this.responseURL,
      this.responseXML,
      this.status,
      this.statusText,
      this.url,
      this.user,
      this.withCredentials});

  static AjaxRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = AjaxRequest(
      data: map['data'],
      event: AjaxRequestEvent.fromMap(map['event']?.cast<String, dynamic>()),
      headers:
          AjaxRequestHeaders.fromMap(map['headers']?.cast<String, dynamic>()),
      isAsync: map['isAsync'],
      method: map['method'],
      password: map['password'],
      readyState: AjaxRequestReadyState.fromNativeValue(map['readyState']),
      response: map['response'],
      responseHeaders: map['responseHeaders']?.cast<String, dynamic>(),
      responseText: map['responseText'],
      responseType: map['responseType'],
      responseURL:
          map['responseURL'] != null ? WebUri(map['responseURL']) : null,
      responseXML: map['responseXML'],
      status: map['status'],
      statusText: map['statusText'],
      url: map['url'] != null ? WebUri(map['url']) : null,
      user: map['user'],
      withCredentials: map['withCredentials'],
    );
    instance.action = AjaxRequestAction.fromNativeValue(map['action']);
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "data": data,
      "event": event?.toMap(),
      "headers": headers?.toMap(),
      "isAsync": isAsync,
      "method": method,
      "password": password,
      "readyState": readyState?.toNativeValue(),
      "response": response,
      "responseHeaders": responseHeaders,
      "responseText": responseText,
      "responseType": responseType,
      "responseURL": responseURL?.toString(),
      "responseXML": responseXML,
      "status": status,
      "statusText": statusText,
      "url": url?.toString(),
      "user": user,
      "withCredentials": withCredentials,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AjaxRequest{action: $action, data: $data, event: $event, headers: $headers, isAsync: $isAsync, method: $method, password: $password, readyState: $readyState, response: $response, responseHeaders: $responseHeaders, responseText: $responseText, responseType: $responseType, responseURL: $responseURL, responseXML: $responseXML, status: $status, statusText: $statusText, url: $url, user: $user, withCredentials: $withCredentials}';
  }
}
