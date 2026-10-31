import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import 'meta_tag_attribute.dart';

part 'meta_tag.g.dart';

@ExchangeableObject()
class MetaTag_ {
  String? name;

  String? content;

  List<MetaTagAttribute_>? attrs;

  MetaTag_({this.name, this.content, this.attrs});
}
