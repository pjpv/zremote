
part of 'context_menu_settings.dart';

class ContextMenuSettings {
  bool hideDefaultSystemContextMenuItems;
  ContextMenuSettings({this.hideDefaultSystemContextMenuItems = false});

  static ContextMenuSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ContextMenuSettings();
    instance.hideDefaultSystemContextMenuItems =
        map['hideDefaultSystemContextMenuItems'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "hideDefaultSystemContextMenuItems": hideDefaultSystemContextMenuItems,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  ContextMenuSettings copy() {
    return ContextMenuSettings.fromMap(toMap()) ?? ContextMenuSettings();
  }

  @override
  String toString() {
    return 'ContextMenuSettings{hideDefaultSystemContextMenuItems: $hideDefaultSystemContextMenuItems}';
  }
}
