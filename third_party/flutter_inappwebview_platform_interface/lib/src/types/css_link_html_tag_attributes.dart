import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import 'cross_origin.dart';
import 'referrer_policy.dart';

part 'css_link_html_tag_attributes.g.dart';

@ExchangeableObject()
class CSSLinkHtmlTagAttributes_ {
  String? id;

  String? media;

  CrossOrigin_? crossOrigin;

  String? integrity;

  ReferrerPolicy_? referrerPolicy;

  bool? disabled;

  bool? alternate;

  String? title;

  CSSLinkHtmlTagAttributes_(
      {this.id,
      this.media,
      this.crossOrigin,
      this.integrity,
      this.referrerPolicy,
      this.disabled,
      this.alternate,
      this.title});
}
