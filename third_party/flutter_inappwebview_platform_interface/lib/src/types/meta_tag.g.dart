
part of 'meta_tag.dart';

class MetaTag {
  List<MetaTagAttribute>? attrs;

  String? content;

  String? name;
  MetaTag({this.attrs, this.content, this.name});

  static MetaTag? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = MetaTag(
      attrs: map['attrs'] != null
          ? List<MetaTagAttribute>.from(map['attrs'].map(
              (e) => MetaTagAttribute.fromMap(e?.cast<String, dynamic>())!))
          : null,
      content: map['content'],
      name: map['name'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "attrs": attrs?.map((e) => e.toMap()).toList(),
      "content": content,
      "name": name,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'MetaTag{attrs: $attrs, content: $content, name: $name}';
  }
}
