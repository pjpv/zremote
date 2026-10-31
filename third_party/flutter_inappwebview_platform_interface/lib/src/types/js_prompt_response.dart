import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'js_prompt_response_action.dart';

part 'js_prompt_response.g.dart';

@ExchangeableObject()
class JsPromptResponse_ {
  String message;

  String defaultValue;

  String confirmButtonTitle;

  String cancelButtonTitle;

  bool handledByClient;

  String? value;

  JsPromptResponseAction_? action;

  JsPromptResponse_(
      {this.message = "",
      this.defaultValue = "",
      this.handledByClient = false,
      this.confirmButtonTitle = "",
      this.cancelButtonTitle = "",
      this.value,
      this.action = JsPromptResponseAction_.CANCEL});
}
