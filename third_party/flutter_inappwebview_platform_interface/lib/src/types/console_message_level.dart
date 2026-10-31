import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'console_message_level.g.dart';

@ExchangeableEnum()
class ConsoleMessageLevel_ {
  // ignore: unused_field
  final int _value;
  const ConsoleMessageLevel_._internal(this._value);

  static const TIP = const ConsoleMessageLevel_._internal(0);

  static const LOG = const ConsoleMessageLevel_._internal(1);

  static const WARNING = const ConsoleMessageLevel_._internal(2);

  static const ERROR = const ConsoleMessageLevel_._internal(3);

  static const DEBUG = const ConsoleMessageLevel_._internal(4);
}
