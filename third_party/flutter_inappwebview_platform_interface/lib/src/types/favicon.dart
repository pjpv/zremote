import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import '../web_uri.dart';

part 'favicon.g.dart';

@ExchangeableObject()
class Favicon_ {
  WebUri url;

  String? rel;

  int? width;

  int? height;

  Favicon_({required this.url, this.rel, this.width, this.height});
}
