
part of 'android_resource.dart';

class AndroidResource {
  String? defPackage;

  String? defType;

  String name;
  AndroidResource({this.defPackage, this.defType, required this.name});

  static AndroidResource? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = AndroidResource(
      defPackage: map['defPackage'],
      defType: map['defType'],
      name: map['name'],
    );
    return instance;
  }

  static AndroidResource anim({required String name, String? defPackage}) {
    return AndroidResource(name: name, defType: "anim", defPackage: defPackage);
  }

  static AndroidResource layout({required String name, String? defPackage}) {
    return AndroidResource(
        name: name, defType: "layout", defPackage: defPackage);
  }

  static AndroidResource id({required String name, String? defPackage}) {
    return AndroidResource(name: name, defType: "id", defPackage: defPackage);
  }

  static AndroidResource drawable({required String name, String? defPackage}) {
    return AndroidResource(
        name: name, defType: "drawable", defPackage: defPackage);
  }

  Map<String, dynamic> toMap() {
    return {
      "defPackage": defPackage,
      "defType": defType,
      "name": name,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AndroidResource{defPackage: $defPackage, defType: $defType, name: $name}';
  }
}
