import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../types/android_resource.dart';
import '../web_uri.dart';
import 'platform_chrome_safari_browser.dart';

part 'chrome_safari_browser_secondary_toolbar.g.dart';

@SupportedPlatforms(platforms: [
  AndroidPlatform(note: 'Not available in an Android Trusted Web Activity.')
])
@ExchangeableObject()
class ChromeSafariBrowserSecondaryToolbar_ {
  AndroidResource_ layout;

  List<ChromeSafariBrowserSecondaryToolbarClickableID_> clickableIDs;

  ChromeSafariBrowserSecondaryToolbar_(
      {required this.layout, this.clickableIDs = const []});
}

@SupportedPlatforms(platforms: [
  AndroidPlatform(note: 'Not available in an Android Trusted Web Activity.')
])
@ExchangeableObject()
class ChromeSafariBrowserSecondaryToolbarClickableID_ {
  AndroidResource_ id;

  void Function(WebUri? url)? onClick;

  ChromeSafariBrowserSecondaryToolbarClickableID_(
      {required this.id, this.onClick});
}
