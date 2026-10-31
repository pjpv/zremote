import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'print_job_disposition.g.dart';

@ExchangeableEnum()
class PrintJobDisposition_ {
  // ignore: unused_field
  final String _value;
  const PrintJobDisposition_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [EnumMacOSPlatform(value: 'spool')])
  static const SPOOL = const PrintJobDisposition_._internal('SPOOL');

  @EnumSupportedPlatforms(platforms: [EnumMacOSPlatform(value: 'preview')])
  static const PREVIEW = const PrintJobDisposition_._internal("PREVIEW");

  @EnumSupportedPlatforms(platforms: [EnumMacOSPlatform(value: 'save')])
  static const SAVE = const PrintJobDisposition_._internal("SAVE");

  @EnumSupportedPlatforms(platforms: [EnumMacOSPlatform(value: 'cancel')])
  static const CANCEL = const PrintJobDisposition_._internal("CANCEL");
}
