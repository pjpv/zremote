import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import 'cross_origin.dart';
import 'referrer_policy.dart';

part 'script_html_tag_attributes.g.dart';

@ExchangeableObject()
class ScriptHtmlTagAttributes_ {
  String type;

  String? id;

  bool? async;

  bool? defer;

  CrossOrigin_? crossOrigin;

  String? integrity;

  bool? noModule;

  String? nonce;

  ReferrerPolicy_? referrerPolicy;

  Function? onLoad;

  Function? onError;

  @ExchangeableObjectConstructor()
  ScriptHtmlTagAttributes_(
      {this.type = "text/javascript",
      this.id,
      this.async,
      this.defer,
      this.crossOrigin,
      this.integrity,
      this.noModule,
      this.nonce,
      this.referrerPolicy,
      this.onLoad,
      this.onError}) {
    if (this.onLoad != null || this.onError != null) {
      assert(this.id != null,
          'onLoad and onError callbacks require the id property to be set.');
    }
  }
}
