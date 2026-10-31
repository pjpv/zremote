
part of 'js_prompt_response_action.dart';

class JsPromptResponseAction {
  final int _value;
  final int _nativeValue;
  const JsPromptResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory JsPromptResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      JsPromptResponseAction._internal(value, nativeValue());

  static const CANCEL = JsPromptResponseAction._internal(1, 1);

  static const CONFIRM = JsPromptResponseAction._internal(0, 0);

  static final Set<JsPromptResponseAction> values = [
    JsPromptResponseAction.CANCEL,
    JsPromptResponseAction.CONFIRM,
  ].toSet();

  static JsPromptResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return JsPromptResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static JsPromptResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return JsPromptResponseAction.values
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
