import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_webview.dart';
import '../types/in_app_webview_hit_test_result.dart';
import 'context_menu_item.dart';
import 'context_menu_settings.dart';

part 'context_menu.g.dart';

@SupportedPlatforms(platforms: [
  AndroidPlatform(
      note:
          'To make it work properly on Android, JavaScript should be enabled!'),
  IOSPlatform()
])
@ExchangeableObject()
class ContextMenu_ {
  final void Function(InAppWebViewHitTestResult_ hitTestResult)?
      onCreateContextMenu;

  final void Function()? onHideContextMenu;

  final void Function(ContextMenuItem_ contextMenuItemClicked)?
      onContextMenuActionItemClicked;

  @Deprecated("Use settings instead")
  final ContextMenuOptions? options;

  final ContextMenuSettings_? settings;

  final List<ContextMenuItem_> menuItems;

  @ExchangeableObjectConstructor()
  ContextMenu_(
      {this.menuItems = const [],
      this.onCreateContextMenu,
      this.onHideContextMenu,
      @Deprecated("Use settings instead") this.options,
      this.settings,
      this.onContextMenuActionItemClicked});

  @ExchangeableObjectMethod(toMapMergeWith: true)
  // ignore: unused_element
  Map<String, dynamic> _toMapMergeWith() {
    return {
      "settings":
          (settings as ContextMenuSettings?)?.toMap() ?? options?.toMap()
    };
  }
}
