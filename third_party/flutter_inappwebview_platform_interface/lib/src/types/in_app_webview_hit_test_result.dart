import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'in_app_webview_hit_test_result_type.dart';

part 'in_app_webview_hit_test_result.g.dart';

@ExchangeableObject()
class InAppWebViewHitTestResult_ {
  InAppWebViewHitTestResultType_? type;

  String? extra;

  InAppWebViewHitTestResult_({this.type, this.extra});
}
