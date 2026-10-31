import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'user_script.dart';

part 'user_script_injection_time.g.dart';

@ExchangeableEnum()
class UserScriptInjectionTime_ {
  // ignore: unused_field
  final int _value;
  const UserScriptInjectionTime_._internal(this._value);

  static const AT_DOCUMENT_START = const UserScriptInjectionTime_._internal(0);

  static const AT_DOCUMENT_END = const UserScriptInjectionTime_._internal(1);
}
