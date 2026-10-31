import 'dart:typed_data';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'platform_chrome_safari_browser.dart';
import 'chrome_safari_browser_menu_item.dart';
import '../web_uri.dart';

part 'chrome_safari_action_button.g.dart';

@SupportedPlatforms(platforms: [
  AndroidPlatform(note: 'Not available in an Android Trusted Web Activity.'),
])
@ExchangeableObject()
class ChromeSafariBrowserActionButton_ {
  int id;

  Uint8List icon;

  String description;

  bool shouldTint;

  @Deprecated("Use onClick instead")
  void Function(String url, String title)? action;

  void Function(WebUri? url, String title)? onClick;

  @ExchangeableObjectConstructor()
  ChromeSafariBrowserActionButton_(
      {required this.id,
      required this.icon,
      required this.description,
      @Deprecated("Use onClick instead") this.action,
      this.onClick,
      this.shouldTint = false});
}
