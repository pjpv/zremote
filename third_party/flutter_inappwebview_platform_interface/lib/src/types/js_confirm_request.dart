import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import '../web_uri.dart';

part 'js_confirm_request.g.dart';

@ExchangeableObject()
class JsConfirmRequest_ {
  WebUri? url;

  String? message;

  @Deprecated("Use isMainFrame instead")
  bool? iosIsMainFrame;

  @SupportedPlatforms(platforms: [IOSPlatform(), MacOSPlatform()])
  bool? isMainFrame;

  JsConfirmRequest_(
      {this.url,
      this.message,
      @Deprecated("Use isMainFrame instead") this.iosIsMainFrame,
      this.isMainFrame});
}
