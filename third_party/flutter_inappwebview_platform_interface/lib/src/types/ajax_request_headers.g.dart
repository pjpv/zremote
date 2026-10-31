
part of 'ajax_request_headers.dart';

class AjaxRequestHeaders {
  Map<String, dynamic> _headers;
  Map<String, dynamic> _newHeaders = {};
  AjaxRequestHeaders(this._headers);

  static AjaxRequestHeaders? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return AjaxRequestHeaders(map);
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

  Map<String, dynamic> toJson() {
    return toMap();
  }
}
