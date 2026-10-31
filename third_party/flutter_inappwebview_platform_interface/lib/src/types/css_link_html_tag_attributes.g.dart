
part of 'css_link_html_tag_attributes.dart';

class CSSLinkHtmlTagAttributes {
  bool? alternate;

  CrossOrigin? crossOrigin;

  bool? disabled;

  String? id;

  String? integrity;

  String? media;

  ReferrerPolicy? referrerPolicy;

  String? title;
  CSSLinkHtmlTagAttributes(
      {this.alternate,
      this.crossOrigin,
      this.disabled,
      this.id,
      this.integrity,
      this.media,
      this.referrerPolicy,
      this.title});

  static CSSLinkHtmlTagAttributes? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = CSSLinkHtmlTagAttributes(
      alternate: map['alternate'],
      crossOrigin: CrossOrigin.fromNativeValue(map['crossOrigin']),
      disabled: map['disabled'],
      id: map['id'],
      integrity: map['integrity'],
      media: map['media'],
      referrerPolicy: ReferrerPolicy.fromNativeValue(map['referrerPolicy']),
      title: map['title'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "alternate": alternate,
      "crossOrigin": crossOrigin?.toNativeValue(),
      "disabled": disabled,
      "id": id,
      "integrity": integrity,
      "media": media,
      "referrerPolicy": referrerPolicy?.toNativeValue(),
      "title": title,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CSSLinkHtmlTagAttributes{alternate: $alternate, crossOrigin: $crossOrigin, disabled: $disabled, id: $id, integrity: $integrity, media: $media, referrerPolicy: $referrerPolicy, title: $title}';
  }
}
