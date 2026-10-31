import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';

part 'call_async_javascript_result.g.dart';

@ExchangeableObject()
class CallAsyncJavaScriptResult_ {
  dynamic value;

  String? error;

  CallAsyncJavaScriptResult_({this.value, this.error});
}
