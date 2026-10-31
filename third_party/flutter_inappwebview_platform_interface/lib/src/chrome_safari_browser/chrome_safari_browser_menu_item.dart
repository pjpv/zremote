import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../types/ui_image.dart';
import 'platform_chrome_safari_browser.dart';
import '../web_uri.dart';

part 'chrome_safari_browser_menu_item.g.dart';

@SupportedPlatforms(platforms: [
  AndroidPlatform(note: 'Not available in an Android Trusted Web Activity.'),
  IOSPlatform()
])
@ExchangeableObject()
class ChromeSafariBrowserMenuItem_ {
  int id;

  String label;

  UIImage_? image;

  @Deprecated("Use onClick instead")
  void Function(String url, String title)? action;

  void Function(WebUri? url, String title)? onClick;

  @ExchangeableObjectConstructor()
  ChromeSafariBrowserMenuItem_(
      {required this.id,
      required this.label,
      this.image,
      @Deprecated("Use onClick instead") this.action,
      this.onClick});
}
