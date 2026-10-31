
part of 'meta_tag_attribute.dart';

class MetaTagAttribute {
  String? name;

  String? value;
  MetaTagAttribute({this.name, this.value});

  static MetaTagAttribute? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = MetaTagAttribute(
      name: map['name'],
      value: map['value'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'MetaTagAttribute{name: $name, value: $value}';
  }
}
