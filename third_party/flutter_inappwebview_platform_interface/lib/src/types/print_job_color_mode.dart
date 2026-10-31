import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'print_job_color_mode.g.dart';

@ExchangeableEnum()
class PrintJobColorMode_ {
  // ignore: unused_field
  final int _value;
  // ignore: unused_field
  final dynamic _nativeValue = null;
  const PrintJobColorMode_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(value: 1),
    EnumMacOSPlatform(value: "Gray")
  ])
  static const MONOCHROME = const PrintJobColorMode_._internal(1);

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(value: 1),
    EnumMacOSPlatform(value: "RGB")
  ])
  static const COLOR = const PrintJobColorMode_._internal(2);
}
