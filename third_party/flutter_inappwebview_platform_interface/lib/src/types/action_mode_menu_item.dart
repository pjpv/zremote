import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'action_mode_menu_item.g.dart';

@ExchangeableEnum(bitwiseOrOperator: true)
class ActionModeMenuItem_ {
  // ignore: unused_field
  final int _value;
  const ActionModeMenuItem_._internal(this._value);

  static const MENU_ITEM_NONE = ActionModeMenuItem_._internal(0);

  static const MENU_ITEM_SHARE = ActionModeMenuItem_._internal(1);

  static const MENU_ITEM_WEB_SEARCH = ActionModeMenuItem_._internal(2);

  static const MENU_ITEM_PROCESS_TEXT = ActionModeMenuItem_._internal(4);
}

@Deprecated("Use ActionModeMenuItem instead")
@ExchangeableEnum(bitwiseOrOperator: true)
class AndroidActionModeMenuItem_ {
  // ignore: unused_field
  final int _value;
  const AndroidActionModeMenuItem_._internal(this._value);

  static const MENU_ITEM_NONE = const AndroidActionModeMenuItem_._internal(0);

  static const MENU_ITEM_SHARE = const AndroidActionModeMenuItem_._internal(1);

  static const MENU_ITEM_WEB_SEARCH =
      const AndroidActionModeMenuItem_._internal(2);

  static const MENU_ITEM_PROCESS_TEXT =
      const AndroidActionModeMenuItem_._internal(4);
}
