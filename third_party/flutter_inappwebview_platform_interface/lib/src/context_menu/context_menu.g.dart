
part of 'context_menu.dart';

class ContextMenu {
  final List<ContextMenuItem> menuItems;

  final void Function(ContextMenuItem)? onContextMenuActionItemClicked;

  final void Function(InAppWebViewHitTestResult)? onCreateContextMenu;

  final void Function()? onHideContextMenu;

  @Deprecated('Use settings instead')
  final ContextMenuOptions? options;

  final ContextMenuSettings? settings;

  ContextMenu(
      {this.menuItems = const [],
      this.onCreateContextMenu,
      this.onHideContextMenu,
      @Deprecated("Use settings instead") this.options,
      this.settings,
      this.onContextMenuActionItemClicked});

  static ContextMenu? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ContextMenu(
      menuItems: List<ContextMenuItem>.from(map['menuItems']
          .map((e) => ContextMenuItem.fromMap(e?.cast<String, dynamic>())!)),
      options: map['settings'],
      settings:
          ContextMenuSettings.fromMap(map['settings']?.cast<String, dynamic>()),
    );
    return instance;
  }

  @ExchangeableObjectMethod(toMapMergeWith: true)
  Map<String, dynamic> _toMapMergeWith() {
    return {
      "settings":
          (settings as ContextMenuSettings?)?.toMap() ?? options?.toMap()
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "menuItems": menuItems.map((e) => e.toMap()).toList(),
      "settings": settings?.toMap(),
      ..._toMapMergeWith(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ContextMenu{menuItems: $menuItems, settings: $settings}';
  }
}
