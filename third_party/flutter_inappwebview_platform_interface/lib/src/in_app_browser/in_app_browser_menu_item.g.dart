
part of 'in_app_browser_menu_item.dart';

class InAppBrowserMenuItem {
  dynamic icon;

  Color? iconColor;

  int id;

  void Function()? onClick;

  int? order;

  bool showAsAction;

  String title;

  InAppBrowserMenuItem(
      {this.icon,
      this.iconColor,
      required this.id,
      this.onClick,
      this.order,
      this.showAsAction = false,
      required this.title});

  static InAppBrowserMenuItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = InAppBrowserMenuItem(
      icon: _deserializeIcon(map['icon']),
      iconColor: map['iconColor'] != null
          ? UtilColor.fromStringRepresentation(map['iconColor'])
          : null,
      id: map['id'],
      order: map['order'],
      title: map['title'],
    );
    instance.showAsAction = map['showAsAction'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "icon": _serializeIcon(icon),
      "iconColor": iconColor?.toHex(),
      "id": id,
      "order": order,
      "showAsAction": showAsAction,
      "title": title,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'InAppBrowserMenuItem{icon: $icon, iconColor: $iconColor, id: $id, order: $order, showAsAction: $showAsAction, title: $title}';
  }
}
