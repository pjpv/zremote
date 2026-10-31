
part of 'chrome_safari_action_button.dart';

class ChromeSafariBrowserActionButton {
  @Deprecated('Use onClick instead')
  void Function(String, String)? action;

  String description;

  Uint8List icon;

  int id;

  void Function(WebUri?, String)? onClick;

  bool shouldTint;

  ChromeSafariBrowserActionButton(
      {required this.id,
      required this.icon,
      required this.description,
      @Deprecated("Use onClick instead") this.action,
      this.onClick,
      this.shouldTint = false});

  static ChromeSafariBrowserActionButton? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ChromeSafariBrowserActionButton(
      description: map['description'],
      icon: Uint8List.fromList(map['icon'].cast<int>()),
      id: map['id'],
    );
    instance.shouldTint = map['shouldTint'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "icon": icon,
      "id": id,
      "shouldTint": shouldTint,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ChromeSafariBrowserActionButton{description: $description, icon: $icon, id: $id, shouldTint: $shouldTint}';
  }
}
