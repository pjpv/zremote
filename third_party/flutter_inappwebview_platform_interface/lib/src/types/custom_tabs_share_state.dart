import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'custom_tabs_share_state.g.dart';

@ExchangeableEnum()
class CustomTabsShareState_ {
  // ignore: unused_field
  final int _value;
  const CustomTabsShareState_._internal(this._value);

  static const SHARE_STATE_DEFAULT = const CustomTabsShareState_._internal(0);

  static const SHARE_STATE_ON = const CustomTabsShareState_._internal(1);

  static const SHARE_STATE_OFF = const CustomTabsShareState_._internal(2);
}
