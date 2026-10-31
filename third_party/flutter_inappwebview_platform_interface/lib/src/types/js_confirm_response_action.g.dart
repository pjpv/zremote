
part of 'js_confirm_response_action.dart';

class JsConfirmResponseAction {
  final int _value;
  final int _nativeValue;
  const JsConfirmResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory JsConfirmResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      JsConfirmResponseAction._internal(value, nativeValue());

  static const CANCEL = JsConfirmResponseAction._internal(1, 1);

  static const CONFIRM = JsConfirmResponseAction._internal(0, 0);

  static final Set<JsConfirmResponseAction> values = [
    JsConfirmResponseAction.CANCEL,
    JsConfirmResponseAction.CONFIRM,
  ].toSet();

  static JsConfirmResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return JsConfirmResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static JsConfirmResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return JsConfirmResponseAction.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
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

  @override
  String toString() {
    switch (_value) {
      case 1:
        return 'CANCEL';
      case 0:
        return 'CONFIRM';
    }
    return _value.toString();
  }
}
