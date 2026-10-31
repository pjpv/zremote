import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
part 'geolocation_permission_show_prompt_response.g.dart';

@ExchangeableObject()
class GeolocationPermissionShowPromptResponse_ {
  String origin;

  bool allow;

  bool retain;

  GeolocationPermissionShowPromptResponse_(
      {required this.origin, required this.allow, this.retain = false});
}
