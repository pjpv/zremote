import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import '../web_uri.dart';

part 'request_focus_node_href_result.g.dart';

@ExchangeableObject()
class RequestFocusNodeHrefResult_ {
  WebUri? url;

  String? title;

  String? src;

  RequestFocusNodeHrefResult_({this.url, this.title, this.src});
}
