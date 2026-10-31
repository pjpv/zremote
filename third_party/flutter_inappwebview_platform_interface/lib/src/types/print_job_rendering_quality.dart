import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'print_job_rendering_quality.g.dart';

@ExchangeableEnum()
class PrintJobRenderingQuality_ {
  // ignore: unused_field
  final int _value;
  const PrintJobRenderingQuality_._internal(this._value);

  @EnumSupportedPlatforms(
      platforms: [EnumIOSPlatform(value: 0), EnumMacOSPlatform(value: 0)])
  static const BEST = const PrintJobRenderingQuality_._internal(0);

  @EnumSupportedPlatforms(
      platforms: [EnumIOSPlatform(value: 1), EnumMacOSPlatform(value: 1)])
  static const RESPONSIVE = const PrintJobRenderingQuality_._internal(1);
}
