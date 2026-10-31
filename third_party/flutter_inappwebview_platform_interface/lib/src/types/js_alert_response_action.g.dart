
part of 'js_alert_response_action.dart';

class JsAlertResponseAction {
  final int _value;
  final int _nativeValue;
  const JsAlertResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory JsAlertResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      JsAlertResponseAction._internal(value, nativeValue());

  static const CONFIRM = JsAlertResponseAction._internal(0, 0);

  static final Set<JsAlertResponseAction> values = [
    JsAlertResponseAction.CONFIRM,
  ].toSet();

  static JsAlertResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return JsAlertResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static JsAlertResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return JsAlertResponseAction.values
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
      case 0:
        return 'CONFIRM';
    }
    return _value.toString();
  }
}
