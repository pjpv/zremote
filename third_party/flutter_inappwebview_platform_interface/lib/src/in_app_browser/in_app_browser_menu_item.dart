import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../util.dart';

import 'platform_in_app_browser.dart';
import '../types/main.dart';

part 'in_app_browser_menu_item.g.dart';

dynamic _serializeIcon(dynamic icon) {
  return icon is Uint8List ? icon : icon?.toMap();
}

dynamic _deserializeIcon(dynamic icon) {
  if (icon is Uint8List) {
    return icon;
  }
  if (icon is Map<String, dynamic>) {
    final iconMap = icon as Map<String, dynamic>;
    if (iconMap.containsKey('defType')) {
      return AndroidResource.fromMap(iconMap);
    }
    if (iconMap.containsKey('systemName')) {
      return UIImage.fromMap(iconMap);
    }
  }
  return null;
}

@SupportedPlatforms(platforms: [
  AndroidPlatform(),
  IOSPlatform(),
  MacOSPlatform(),
])
@ExchangeableObject()
class InAppBrowserMenuItem_ {
  int id;

  String title;

  @ExchangeableObjectProperty(
      serializer: _serializeIcon, deserializer: _deserializeIcon)
  dynamic icon;

  @SupportedPlatforms(platforms: [
    AndroidPlatform(),
    IOSPlatform(available: "13.0"),
    MacOSPlatform(),
  ])
  Color_? iconColor;

  int? order;

  bool showAsAction;

  void Function()? onClick;

  InAppBrowserMenuItem_(
      {required this.id,
      required this.title,
      this.icon,
      this.iconColor,
      this.onClick,
      this.order,
      this.showAsAction = false}) {
    assert(this.icon == null ||
        this.icon is Uint8List ||
        this.icon is UIImage ||
        this.icon is AndroidResource);
  }
}
