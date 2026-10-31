import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'http_auth_response_action.dart';

part 'http_auth_response.g.dart';

@ExchangeableObject()
class HttpAuthResponse_ {
  String username;

  String password;

  bool permanentPersistence;

  HttpAuthResponseAction_? action;

  HttpAuthResponse_(
      {this.username = "",
      this.password = "",
      this.permanentPersistence = false,
      this.action = HttpAuthResponseAction_.CANCEL});
}
