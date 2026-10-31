
part of 'ui_image.dart';

class UIImage {
  Uint8List? data;

  String? name;

  String? systemName;
  UIImage({this.name, this.systemName, this.data}) {
    assert(this.name != null || this.systemName != null || this.data != null);
  }

  static UIImage? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = UIImage(
      data: map['data'] != null
          ? Uint8List.fromList(map['data'].cast<int>())
          : null,
      name: map['name'],
      systemName: map['systemName'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "data": data,
      "name": name,
      "systemName": systemName,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'UIImage{data: $data, name: $name, systemName: $systemName}';
  }
}
