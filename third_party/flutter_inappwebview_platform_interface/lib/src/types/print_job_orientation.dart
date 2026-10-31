import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'print_job_orientation.g.dart';

@ExchangeableEnum()
class PrintJobOrientation_ {
  // ignore: unused_field
  final int _value;
  const PrintJobOrientation_._internal(this._value);

  @EnumSupportedPlatforms(
      platforms: [EnumIOSPlatform(value: 0), EnumMacOSPlatform(value: 0)])
  static const PORTRAIT = const PrintJobOrientation_._internal(0);

  @EnumSupportedPlatforms(
      platforms: [EnumIOSPlatform(value: 1), EnumMacOSPlatform(value: 1)])
  static const LANDSCAPE = const PrintJobOrientation_._internal(1);
}
