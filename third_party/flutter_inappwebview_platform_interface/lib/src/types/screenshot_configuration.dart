import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_inappwebview_controller.dart';
import 'in_app_webview_rect.dart';
import 'compress_format.dart';

part 'screenshot_configuration.g.dart';

@ExchangeableObject()
class ScreenshotConfiguration_ {
  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(),
    MacOSPlatform(),
    WindowsPlatform()
  ])
  InAppWebViewRect_? rect;

  @SupportedPlatforms(
      platforms: [AndroidPlatform(), IOSPlatform(), MacOSPlatform()])
  double? snapshotWidth;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(),
    MacOSPlatform(),
    WindowsPlatform()
  ])
  CompressFormat_ compressFormat;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(),
    MacOSPlatform(),
    WindowsPlatform()
  ])
  int quality;

  @Deprecated("Use afterScreenUpdates instead")
  bool? iosAfterScreenUpdates;

  @SupportedPlatforms(platforms: [
    IOSPlatform(available: '13.0'),
    MacOSPlatform(available: '10.15'),
  ])
  bool afterScreenUpdates;

  @ExchangeableObjectConstructor()
  ScreenshotConfiguration_(
      {this.rect,
      this.snapshotWidth,
      this.compressFormat = CompressFormat_.PNG,
      this.quality = 100,
      @Deprecated("Use afterScreenUpdates instead") this.iosAfterScreenUpdates,
      this.afterScreenUpdates = true}) {
    assert(this.quality >= 0);
    // ignore: deprecated_member_use_from_same_package
    this.afterScreenUpdates = this.iosAfterScreenUpdates != null
        // ignore: deprecated_member_use_from_same_package
        ? this.iosAfterScreenUpdates!
        : this.afterScreenUpdates;
  }
}
