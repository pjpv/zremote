import 'dart:ui';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../types/attributed_string.dart';
import '../types/pull_to_refresh_size.dart';
import '../util.dart';
import '../types/main.dart';

part 'pull_to_refresh_settings.g.dart';

@ExchangeableObject(copyMethod: true)
class PullToRefreshSettings_ {
  bool? enabled;

  Color_? color;

  Color_? backgroundColor;

  int? distanceToTriggerSync;

  int? slingshotDistance;

  PullToRefreshSize_? size;

  AttributedString_? attributedTitle;

  PullToRefreshSettings_(
      {this.enabled = true,
      this.color,
      this.backgroundColor,
      this.distanceToTriggerSync,
      this.slingshotDistance,
      this.size,
      this.attributedTitle});
}

@Deprecated("Use PullToRefreshSettings instead")
class PullToRefreshOptions {
  bool enabled;

  Color? color;

  Color? backgroundColor;

  int? distanceToTriggerSync;

  int? slingshotDistance;

  AndroidPullToRefreshSize? size;

  IOSNSAttributedString? attributedTitle;

  PullToRefreshOptions(
      {this.enabled = true,
      this.color,
      this.backgroundColor,
      this.distanceToTriggerSync,
      this.slingshotDistance,
      this.size,
      this.attributedTitle});

  Map<String, dynamic> toMap() {
    return {
      "enabled": enabled,
      "color": color?.toHex(),
      "backgroundColor": backgroundColor?.toHex(),
      "distanceToTriggerSync": distanceToTriggerSync,
      "slingshotDistance": slingshotDistance,
      "size": size?.toNativeValue(),
      "attributedTitle": attributedTitle?.toMap() ?? {}
    };
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
