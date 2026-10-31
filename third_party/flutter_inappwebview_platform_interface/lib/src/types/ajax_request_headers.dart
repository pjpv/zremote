import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'ajax_request.dart';

part 'ajax_request_headers.g.dart';

@ExchangeableObject()
class AjaxRequestHeaders_ {
  Map<String, dynamic> _headers;
  Map<String, dynamic> _newHeaders = {};

  @ExchangeableObjectConstructor()
  AjaxRequestHeaders_(this._headers);

  static AjaxRequestHeaders_? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return AjaxRequestHeaders_(map);
  }

  Map<String, dynamic> getHeaders() {
    return this._headers;
  }

  void setRequestHeader(String header, String value) {
    _newHeaders[header] = value;
  }

  Map<String, dynamic> toMap() {
    return _newHeaders;
  }

  @override
  String toString() {
    return 'AjaxRequestHeaders{headers: $_headers, requestHeaders: $_newHeaders}';
  }
}
