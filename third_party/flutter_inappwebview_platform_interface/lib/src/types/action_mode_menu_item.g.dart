
part of 'action_mode_menu_item.dart';

class ActionModeMenuItem {
  final int _value;
  final int _nativeValue;
  const ActionModeMenuItem._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ActionModeMenuItem._internalMultiPlatform(
          int value, Function nativeValue) =>
      ActionModeMenuItem._internal(value, nativeValue());

  static const MENU_ITEM_NONE = ActionModeMenuItem._internal(0, 0);

  static const MENU_ITEM_PROCESS_TEXT = ActionModeMenuItem._internal(4, 4);

  static const MENU_ITEM_SHARE = ActionModeMenuItem._internal(1, 1);

  static const MENU_ITEM_WEB_SEARCH = ActionModeMenuItem._internal(2, 2);

  static final Set<ActionModeMenuItem> values = [
    ActionModeMenuItem.MENU_ITEM_NONE,
    ActionModeMenuItem.MENU_ITEM_PROCESS_TEXT,
    ActionModeMenuItem.MENU_ITEM_SHARE,
    ActionModeMenuItem.MENU_ITEM_WEB_SEARCH,
  ].toSet();

  static ActionModeMenuItem? fromValue(int? value) {
    if (value != null) {
      try {
        return ActionModeMenuItem.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return ActionModeMenuItem._internal(value, value);
      }
    }
    return null;
  }

  static ActionModeMenuItem? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ActionModeMenuItem.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return ActionModeMenuItem._internal(value, value);
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  ActionModeMenuItem operator |(ActionModeMenuItem value) =>
      ActionModeMenuItem._internal(
          value.toValue() | _value, value.toNativeValue() | _nativeValue);
  @override
  String toString() {
    switch (_value) {
      case 0:
        return 'MENU_ITEM_NONE';
      case 4:
        return 'MENU_ITEM_PROCESS_TEXT';
      case 1:
        return 'MENU_ITEM_SHARE';
      case 2:
        return 'MENU_ITEM_WEB_SEARCH';
    }
    return _value.toString();
  }
}

@Deprecated('Use ActionModeMenuItem instead')
class AndroidActionModeMenuItem {
  final int _value;
  final int _nativeValue;
  const AndroidActionModeMenuItem._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidActionModeMenuItem._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidActionModeMenuItem._internal(value, nativeValue());

  static const MENU_ITEM_NONE = AndroidActionModeMenuItem._internal(0, 0);

  static const MENU_ITEM_PROCESS_TEXT =
      AndroidActionModeMenuItem._internal(4, 4);

  static const MENU_ITEM_SHARE = AndroidActionModeMenuItem._internal(1, 1);

  static const MENU_ITEM_WEB_SEARCH = AndroidActionModeMenuItem._internal(2, 2);

  static final Set<AndroidActionModeMenuItem> values = [
    AndroidActionModeMenuItem.MENU_ITEM_NONE,
    AndroidActionModeMenuItem.MENU_ITEM_PROCESS_TEXT,
    AndroidActionModeMenuItem.MENU_ITEM_SHARE,
    AndroidActionModeMenuItem.MENU_ITEM_WEB_SEARCH,
  ].toSet();

  static AndroidActionModeMenuItem? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidActionModeMenuItem.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return AndroidActionModeMenuItem._internal(value, value);
      }
    }
    return null;
  }

  static AndroidActionModeMenuItem? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidActionModeMenuItem.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return AndroidActionModeMenuItem._internal(value, value);
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  AndroidActionModeMenuItem operator |(AndroidActionModeMenuItem value) =>
      AndroidActionModeMenuItem._internal(
          value.toValue() | _value, value.toNativeValue() | _nativeValue);
  @override
  String toString() {
    switch (_value) {
      case 0:
        return 'MENU_ITEM_NONE';
      case 4:
        return 'MENU_ITEM_PROCESS_TEXT';
      case 1:
        return 'MENU_ITEM_SHARE';
      case 2:
        return 'MENU_ITEM_WEB_SEARCH';
    }
    return _value.toString();
  }
}
