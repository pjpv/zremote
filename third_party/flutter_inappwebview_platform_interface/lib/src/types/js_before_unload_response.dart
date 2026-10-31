import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'js_before_unload_response_action.dart';

part 'js_before_unload_response.g.dart';

@ExchangeableObject()
class JsBeforeUnloadResponse_ {
  String message;

  String confirmButtonTitle;

  String cancelButtonTitle;

  bool handledByClient;

  JsBeforeUnloadResponseAction_? action;

  JsBeforeUnloadResponse_(
      {this.message = "",
      this.handledByClient = false,
      this.confirmButtonTitle = "",
      this.cancelButtonTitle = "",
      this.action = JsBeforeUnloadResponseAction_.CONFIRM});
}
