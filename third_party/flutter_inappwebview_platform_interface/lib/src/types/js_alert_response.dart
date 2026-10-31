import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'js_alert_response_action.dart';

part 'js_alert_response.g.dart';

@ExchangeableObject()
class JsAlertResponse_ {
  String message;

  String confirmButtonTitle;

  bool handledByClient;

  JsAlertResponseAction_? action;

  JsAlertResponse_(
      {this.message = "",
      this.handledByClient = false,
      this.confirmButtonTitle = "",
      this.action = JsAlertResponseAction_.CONFIRM});
}
