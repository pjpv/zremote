import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'force_dark.g.dart';

@ExchangeableEnum()
class ForceDark_ {
  // ignore: unused_field
  final int _value;
  const ForceDark_._internal(this._value);

  static const OFF = const ForceDark_._internal(0);

  static const AUTO = const ForceDark_._internal(1);

  static const ON = const ForceDark_._internal(2);
}

@Deprecated("Use ForceDark instead")
@ExchangeableEnum()
class AndroidForceDark_ {
  // ignore: unused_field
  final int _value;
  const AndroidForceDark_._internal(this._value);

  static const FORCE_DARK_OFF = const AndroidForceDark_._internal(0);

  static const FORCE_DARK_AUTO = const AndroidForceDark_._internal(1);

  static const FORCE_DARK_ON = const AndroidForceDark_._internal(2);
}
