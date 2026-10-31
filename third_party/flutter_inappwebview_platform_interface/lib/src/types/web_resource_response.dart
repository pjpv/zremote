import 'dart:typed_data';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'web_resource_response.g.dart';

@ExchangeableObject()
class WebResourceResponse_ {
  String? contentType;

  String? contentEncoding;

  Uint8List? data;

  Map<String, String>? headers;

  int? statusCode;

  String? reasonPhrase;

  WebResourceResponse_(
      {this.contentType = "",
      this.contentEncoding = "utf-8",
      this.data,
      this.headers,
      this.statusCode,
      this.reasonPhrase});
}
