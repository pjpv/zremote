
part of 'window_features.dart';

class WindowFeatures {
  bool? allowsResizing;

  double? height;

  bool? menuBarVisibility;

  bool? statusBarVisibility;

  bool? toolbarsVisibility;

  double? width;

  double? x;

  double? y;
  WindowFeatures(
      {this.allowsResizing,
      this.height,
      this.menuBarVisibility,
      this.statusBarVisibility,
      this.toolbarsVisibility,
      this.width,
      this.x,
      this.y});

  static WindowFeatures? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WindowFeatures(
      allowsResizing: map['allowsResizing'],
      height: map['height'],
      menuBarVisibility: map['menuBarVisibility'],
      statusBarVisibility: map['statusBarVisibility'],
      toolbarsVisibility: map['toolbarsVisibility'],
      width: map['width'],
      x: map['x'],
      y: map['y'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "allowsResizing": allowsResizing,
      "height": height,
      "menuBarVisibility": menuBarVisibility,
      "statusBarVisibility": statusBarVisibility,
      "toolbarsVisibility": toolbarsVisibility,
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
    return 'WindowFeatures{allowsResizing: $allowsResizing, height: $height, menuBarVisibility: $menuBarVisibility, statusBarVisibility: $statusBarVisibility, toolbarsVisibility: $toolbarsVisibility, width: $width, x: $x, y: $y}';
  }
}

@Deprecated('Use WindowFeatures instead')
class IOSWKWindowFeatures {
  bool? allowsResizing;

  double? height;

  bool? menuBarVisibility;

  bool? statusBarVisibility;

  bool? toolbarsVisibility;

  double? width;

  double? x;

  double? y;
  IOSWKWindowFeatures(
      {this.allowsResizing,
      this.height,
      this.menuBarVisibility,
      this.statusBarVisibility,
      this.toolbarsVisibility,
      this.width,
      this.x,
      this.y});

  static IOSWKWindowFeatures? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = IOSWKWindowFeatures(
      allowsResizing: map['allowsResizing'],
      height: map['height'],
      menuBarVisibility: map['menuBarVisibility'],
      statusBarVisibility: map['statusBarVisibility'],
      toolbarsVisibility: map['toolbarsVisibility'],
      width: map['width'],
      x: map['x'],
      y: map['y'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "allowsResizing": allowsResizing,
      "height": height,
      "menuBarVisibility": menuBarVisibility,
      "statusBarVisibility": statusBarVisibility,
      "toolbarsVisibility": toolbarsVisibility,
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
    return 'IOSWKWindowFeatures{allowsResizing: $allowsResizing, height: $height, menuBarVisibility: $menuBarVisibility, statusBarVisibility: $statusBarVisibility, toolbarsVisibility: $toolbarsVisibility, width: $width, x: $x, y: $y}';
  }
}
