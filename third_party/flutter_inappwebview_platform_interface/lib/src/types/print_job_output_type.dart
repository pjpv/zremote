import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../print_job/main.dart';

part 'print_job_output_type.g.dart';

@ExchangeableEnum()
class PrintJobOutputType_ {
  // ignore: unused_field
  final int _value;
  const PrintJobOutputType_._internal(this._value);

  static const GENERAL = const PrintJobOutputType_._internal(0);

  static const PHOTO = const PrintJobOutputType_._internal(1);

  static const GRAYSCALE = const PrintJobOutputType_._internal(2);

  static const PHOTO_GRAYSCALE = const PrintJobOutputType_._internal(3);
}
