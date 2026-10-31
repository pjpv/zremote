import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'user_preferred_content_mode.g.dart';

@ExchangeableEnum()
class UserPreferredContentMode_ {
  // ignore: unused_field
  final int _value;
  const UserPreferredContentMode_._internal(this._value);

  static const RECOMMENDED = const UserPreferredContentMode_._internal(0);

  static const MOBILE = const UserPreferredContentMode_._internal(1);

  static const DESKTOP = const UserPreferredContentMode_._internal(2);
}
