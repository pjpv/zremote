import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'print_job_duplex_mode.g.dart';

@ExchangeableEnum()
class PrintJobDuplexMode_ {
  // ignore: unused_field
  final String _value;
  // ignore: unused_field
  final int? _nativeValue = null;

  const PrintJobDuplexMode_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(value: 1),
    EnumIOSPlatform(value: 0),
    EnumMacOSPlatform(value: 1)
  ])
  static const NONE = PrintJobDuplexMode_._internal('NONE');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(value: 2),
    EnumIOSPlatform(value: 1),
    EnumMacOSPlatform(value: 2)
  ])
  static const LONG_EDGE = PrintJobDuplexMode_._internal('LONG_EDGE');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(value: 4),
    EnumIOSPlatform(value: 2),
    EnumMacOSPlatform(value: 3)
  ])
  static const SHORT_EDGE = PrintJobDuplexMode_._internal('SHORT_EDGE');
}
