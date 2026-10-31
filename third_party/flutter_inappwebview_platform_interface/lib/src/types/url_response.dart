import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';

part 'url_response.g.dart';

@ExchangeableObject()
class URLResponse_ {
  WebUri? url;

  int expectedContentLength;

  String? mimeType;

  String? suggestedFilename;

  String? textEncodingName;

  Map<String, String>? headers;

  int? statusCode;

  URLResponse_(
      {this.url,
      required this.expectedContentLength,
      this.mimeType,
      this.suggestedFilename,
      this.textEncodingName,
      this.headers,
      this.statusCode});
}

@Deprecated("Use URLResponse instead")
@ExchangeableObject()
class IOSURLResponse_ {
  Uri? url;

  int expectedContentLength;

  String? mimeType;

  String? suggestedFilename;

  String? textEncodingName;

  Map<String, String>? headers;

  int? statusCode;

  IOSURLResponse_(
      {this.url,
      required this.expectedContentLength,
      this.mimeType,
      this.suggestedFilename,
      this.textEncodingName,
      this.headers,
      this.statusCode});
}
