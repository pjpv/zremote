
part of 'in_app_webview_rect.dart';

class InAppWebViewRect {
  double height;

  double width;

  double x;

  double y;
  InAppWebViewRect(
      {required this.x,
      required this.y,
      required this.width,
      required this.height}) {
    assert(this.x >= 0 && this.y >= 0 && this.width >= 0 && this.height >= 0);
  }

  static InAppWebViewRect? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = InAppWebViewRect(
      height: map['height'],
      width: map['width'],
      x: map['x'],
      y: map['y'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "height": height,
      "width": width,
      "x": x,
      "y": y,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'InAppWebViewRect{height: $height, width: $width, x: $x, y: $y}';
  }
}
