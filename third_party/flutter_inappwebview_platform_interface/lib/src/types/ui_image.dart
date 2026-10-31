import 'dart:typed_data';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'ui_image.g.dart';

@ExchangeableObject()
class UIImage_ {
  String? name;

  @SupportedPlatforms(platforms: [
    IOSPlatform(available: "13.0"),
    MacOSPlatform(available: "11.0"),
  ])
  String? systemName;

  Uint8List? data;

  @ExchangeableObjectConstructor()
  UIImage_({this.name, this.systemName, this.data}) {
    assert(this.name != null || this.systemName != null || this.data != null);
  }
}
