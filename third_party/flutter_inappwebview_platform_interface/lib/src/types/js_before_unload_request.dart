import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import '../web_uri.dart';

part 'js_before_unload_request.g.dart';

@ExchangeableObject()
class JsBeforeUnloadRequest_ {
  WebUri? url;

  String? message;

  JsBeforeUnloadRequest_({this.url, this.message});
}
