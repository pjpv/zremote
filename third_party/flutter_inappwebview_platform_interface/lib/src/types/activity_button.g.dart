
part of 'activity_button.dart';

class ActivityButton {
  String extensionIdentifier;

  UIImage templateImage;
  ActivityButton(
      {required this.templateImage, required this.extensionIdentifier});

  static ActivityButton? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ActivityButton(
      extensionIdentifier: map['extensionIdentifier'],
      templateImage:
          UIImage.fromMap(map['templateImage']?.cast<String, dynamic>())!,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "extensionIdentifier": extensionIdentifier,
      "templateImage": templateImage.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ActivityButton{extensionIdentifier: $extensionIdentifier, templateImage: $templateImage}';
  }
}
