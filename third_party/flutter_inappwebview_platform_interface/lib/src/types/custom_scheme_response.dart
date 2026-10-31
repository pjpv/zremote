import 'dart:typed_data';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';

part 'custom_scheme_response.g.dart';

@ExchangeableObject()
class CustomSchemeResponse_ {
  Uint8List data;

  String contentType;

  String contentEncoding;

  CustomSchemeResponse_(
      {required this.data,
      required this.contentType,
      this.contentEncoding = 'utf-8'});
}
