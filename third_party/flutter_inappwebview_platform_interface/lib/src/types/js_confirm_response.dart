import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'js_confirm_response_action.dart';

part 'js_confirm_response.g.dart';

@ExchangeableObject()
class JsConfirmResponse_ {
  String message;

  String confirmButtonTitle;

  String cancelButtonTitle;

  bool handledByClient;

  JsConfirmResponseAction_? action;

  JsConfirmResponse_(
      {this.message = "",
      this.handledByClient = false,
      this.confirmButtonTitle = "",
      this.cancelButtonTitle = "",
      this.action = JsConfirmResponseAction_.CANCEL});
}
