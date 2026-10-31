import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'window_features.g.dart';

@ExchangeableObject()
class WindowFeatures_ {
  bool? allowsResizing;

  double? height;

  bool? menuBarVisibility;

  bool? statusBarVisibility;

  bool? toolbarsVisibility;

  double? width;

  double? x;

  double? y;

  WindowFeatures_(
      {this.allowsResizing,
      this.height,
      this.menuBarVisibility,
      this.statusBarVisibility,
      this.toolbarsVisibility,
      this.width,
      this.x,
      this.y});
}

@Deprecated("Use WindowFeatures instead")
@ExchangeableObject()
class IOSWKWindowFeatures_ {
  bool? allowsResizing;

  double? height;

  bool? menuBarVisibility;

  bool? statusBarVisibility;

  bool? toolbarsVisibility;

  double? width;

  double? x;

  double? y;

  IOSWKWindowFeatures_(
      {this.allowsResizing,
      this.height,
      this.menuBarVisibility,
      this.statusBarVisibility,
      this.toolbarsVisibility,
      this.width,
      this.x,
      this.y});
}
