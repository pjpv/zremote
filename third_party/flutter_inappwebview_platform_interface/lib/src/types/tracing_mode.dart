import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'tracing_mode.g.dart';

@ExchangeableEnum()
class TracingMode_ {
  // ignore: unused_field
  final int _value;
  const TracingMode_._internal(this._value);

  static const RECORD_UNTIL_FULL = const TracingMode_._internal(0);

  static const RECORD_CONTINUOUSLY = const TracingMode_._internal(1);
}
