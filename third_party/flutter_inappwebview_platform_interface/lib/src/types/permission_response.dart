import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'permission_resource_type.dart';
import 'permission_response_action.dart';

part 'permission_response.g.dart';

@ExchangeableObject()
class PermissionResponse_ {
  List<PermissionResourceType_> resources;

  PermissionResponseAction_? action;

  PermissionResponse_(
      {this.resources = const [],
      this.action = PermissionResponseAction_.DENY});
}

@Deprecated("Use PermissionResponse instead")
@ExchangeableObject()
class PermissionRequestResponse_ {
  List<String> resources;

  PermissionRequestResponseAction_? action;

  PermissionRequestResponse_(
      {this.resources = const [],
      this.action = PermissionRequestResponseAction_.DENY});
}
