import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';

part 'web_resource_request.g.dart';

@ExchangeableObject()
class WebResourceRequest_ {
  WebUri url;

  Map<String, String>? headers;

  String? method;

  bool? hasGesture;

  bool? isForMainFrame;

  bool? isRedirect;

  WebResourceRequest_(
      {required this.url,
      this.headers,
      this.method,
      this.hasGesture,
      this.isForMainFrame,
      this.isRedirect});
}
