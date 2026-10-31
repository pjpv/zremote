import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'server_trust_auth_response_action.dart';

part 'server_trust_auth_response.g.dart';

@ExchangeableObject()
class ServerTrustAuthResponse_ {
  ServerTrustAuthResponseAction_? action;

  ServerTrustAuthResponse_(
      {this.action = ServerTrustAuthResponseAction_.CANCEL});
}
