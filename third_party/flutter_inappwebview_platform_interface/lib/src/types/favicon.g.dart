
part of 'favicon.dart';

class Favicon {
  int? height;

  String? rel;

  WebUri url;

  int? width;
  Favicon({this.height, this.rel, required this.url, this.width});

  static Favicon? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = Favicon(
      height: map['height'],
      rel: map['rel'],
      url: WebUri(map['url']),
      width: map['width'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "height": height,
      "rel": rel,
      "url": url.toString(),
      "width": width,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'Favicon{height: $height, rel: $rel, url: $url, width: $width}';
  }
}
