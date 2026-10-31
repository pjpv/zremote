import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'context_menu.dart';

part 'context_menu_settings.g.dart';

@ExchangeableObject(copyMethod: true)
class ContextMenuSettings_ {
  bool hideDefaultSystemContextMenuItems;

  ContextMenuSettings_({this.hideDefaultSystemContextMenuItems = false});
}

@Deprecated("Use ContextMenuSettings instead")
class ContextMenuOptions {
  bool hideDefaultSystemContextMenuItems;

  ContextMenuOptions({this.hideDefaultSystemContextMenuItems = false});

  Map<String, dynamic> toMap() {
    return {
      "hideDefaultSystemContextMenuItems": hideDefaultSystemContextMenuItems
    };
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
