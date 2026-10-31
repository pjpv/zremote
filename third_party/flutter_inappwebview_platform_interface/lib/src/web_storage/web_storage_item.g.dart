
part of 'web_storage_item.dart';

class WebStorageItem {
  String? key;

  dynamic value;
  WebStorageItem({this.key, this.value});

  static WebStorageItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebStorageItem(
      key: map['key'],
      value: map['value'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "key": key,
      "value": value,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebStorageItem{key: $key, value: $value}';
  }
}
