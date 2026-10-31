import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'in_app_webview_rect.g.dart';

@ExchangeableObject()
class InAppWebViewRect_ {
  double x;

  double y;

  double width;

  double height;

  @ExchangeableObjectConstructor()
  InAppWebViewRect_(
      {required this.x,
      required this.y,
      required this.width,
      required this.height}) {
    assert(this.x >= 0 && this.y >= 0 && this.width >= 0 && this.height >= 0);
  }
}
