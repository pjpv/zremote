import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'ui_image.dart';

part 'activity_button.g.dart';

@ExchangeableObject()
class ActivityButton_ {
  UIImage_ templateImage;

  String extensionIdentifier;

  @ExchangeableObjectConstructor()
  ActivityButton_(
      {required this.templateImage, required this.extensionIdentifier});
}
