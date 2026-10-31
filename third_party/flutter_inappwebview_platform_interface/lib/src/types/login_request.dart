import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
part 'login_request.g.dart';

@ExchangeableObject()
class LoginRequest_ {
  String realm;

  String? account;

  String args;

  LoginRequest_({required this.realm, this.account, required this.args});
}
