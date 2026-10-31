import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import '../web_uri.dart';

part 'js_prompt_request.g.dart';

@ExchangeableObject()
class JsPromptRequest_ {
  WebUri? url;

  String? message;

  String? defaultValue;

  @Deprecated("Use isMainFrame instead")
  bool? iosIsMainFrame;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  bool? isMainFrame;

  JsPromptRequest_(
      {this.url,
      this.message,
      this.defaultValue,
      @Deprecated("Use isMainFrame instead") this.iosIsMainFrame,
      this.isMainFrame});
}
