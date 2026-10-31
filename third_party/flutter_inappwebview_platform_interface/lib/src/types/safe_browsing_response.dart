import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import '../in_app_webview/platform_webview.dart';
import 'safe_browsing_response_action.dart';

part 'safe_browsing_response.g.dart';

@ExchangeableObject()
class SafeBrowsingResponse_ {
  bool report;

  SafeBrowsingResponseAction_? action;

  SafeBrowsingResponse_(
      {this.report = true,
      this.action = SafeBrowsingResponseAction_.SHOW_INTERSTITIAL});
}
