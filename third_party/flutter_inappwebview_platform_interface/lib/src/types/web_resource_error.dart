import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'web_resource_error_type.dart';

part 'web_resource_error.g.dart';

@ExchangeableObject()
class WebResourceError_ {
  WebResourceErrorType_ type;

  String description;

  WebResourceError_({required this.type, required this.description});
}
