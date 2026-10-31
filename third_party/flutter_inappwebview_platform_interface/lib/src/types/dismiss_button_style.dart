import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'dismiss_button_style.g.dart';

@ExchangeableEnum()
class DismissButtonStyle_ {
  // ignore: unused_field
  final int _value;
  const DismissButtonStyle_._internal(this._value);

  static const DONE = const DismissButtonStyle_._internal(0);

  static const CLOSE = const DismissButtonStyle_._internal(1);

  static const CANCEL = const DismissButtonStyle_._internal(2);
}

@Deprecated("Use DismissButtonStyle instead")
@ExchangeableEnum()
class IOSSafariDismissButtonStyle_ {
  // ignore: unused_field
  final int _value;
  const IOSSafariDismissButtonStyle_._internal(this._value);

  static const DONE = const IOSSafariDismissButtonStyle_._internal(0);

  static const CLOSE = const IOSSafariDismissButtonStyle_._internal(1);

  static const CANCEL = const IOSSafariDismissButtonStyle_._internal(2);
}
