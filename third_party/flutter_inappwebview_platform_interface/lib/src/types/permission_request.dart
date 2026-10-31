import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import '../web_uri.dart';
import 'permission_resource_type.dart';
import 'permission_response.dart';
import 'frame_info.dart';

part 'permission_request.g.dart';

@ExchangeableObject()
class PermissionRequest_ {
  WebUri origin;

  List<PermissionResourceType_> resources;

  FrameInfo_? frame;

  PermissionRequest_(
      {required this.origin, this.resources = const [], this.frame});
}
