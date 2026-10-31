import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'user_script_injection_time.dart';
import 'content_world.dart';
import '../platform_webview_feature.dart';

part 'user_script.g.dart';

@ExchangeableObject()
class UserScript_ {
  String? groupName;

  String source;

  UserScriptInjectionTime_ injectionTime;

  @Deprecated("Use forMainFrameOnly instead")
  bool? iosForMainFrameOnly;

  bool forMainFrameOnly;

  late Set<String> allowedOriginRules;

  late ContentWorld contentWorld;

  @ExchangeableObjectConstructor()
  UserScript_(
      {this.groupName,
      required this.source,
      required this.injectionTime,
      @Deprecated("Use forMainFrameOnly instead") this.iosForMainFrameOnly,
      this.forMainFrameOnly = true,
      Set<String>? allowedOriginRules,
      ContentWorld? contentWorld}) {
    this.allowedOriginRules =
        allowedOriginRules != null ? allowedOriginRules : Set.from(["*"]);
    this.contentWorld = contentWorld ?? ContentWorld.PAGE;
    // ignore: deprecated_member_use_from_same_package
    this.forMainFrameOnly = this.iosForMainFrameOnly != null
        // ignore: deprecated_member_use_from_same_package
        ? this.iosForMainFrameOnly!
        : this.forMainFrameOnly;
  }
}
