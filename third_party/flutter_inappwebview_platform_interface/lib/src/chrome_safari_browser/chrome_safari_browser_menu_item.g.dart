
part of 'chrome_safari_browser_menu_item.dart';

class ChromeSafariBrowserMenuItem {
  @Deprecated('Use onClick instead')
  void Function(String, String)? action;

  int id;

  UIImage? image;

  String label;

  void Function(WebUri?, String)? onClick;

  ChromeSafariBrowserMenuItem(
      {required this.id,
      required this.label,
      this.image,
      @Deprecated("Use onClick instead") this.action,
      this.onClick});

  static ChromeSafariBrowserMenuItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ChromeSafariBrowserMenuItem(
      id: map['id'],
      image: UIImage.fromMap(map['image']?.cast<String, dynamic>()),
      label: map['label'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "image": image?.toMap(),
      "label": label,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ChromeSafariBrowserMenuItem{id: $id, image: $image, label: $label}';
  }
}
