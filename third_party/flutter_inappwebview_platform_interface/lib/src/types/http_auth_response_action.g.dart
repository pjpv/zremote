
part of 'http_auth_response_action.dart';

class HttpAuthResponseAction {
  final int _value;
  final int _nativeValue;
  const HttpAuthResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory HttpAuthResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      HttpAuthResponseAction._internal(value, nativeValue());

  static const CANCEL = HttpAuthResponseAction._internal(0, 0);

  static const PROCEED = HttpAuthResponseAction._internal(1, 1);

  static const USE_SAVED_HTTP_AUTH_CREDENTIALS =
      HttpAuthResponseAction._internal(2, 2);

  static final Set<HttpAuthResponseAction> values = [
    HttpAuthResponseAction.CANCEL,
    HttpAuthResponseAction.PROCEED,
    HttpAuthResponseAction.USE_SAVED_HTTP_AUTH_CREDENTIALS,
  ].toSet();

  static HttpAuthResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return HttpAuthResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static HttpAuthResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return HttpAuthResponseAction.values
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
        return 'CANCEL';
      case 1:
        return 'PROCEED';
      case 2:
        return 'USE_SAVED_HTTP_AUTH_CREDENTIALS';
    }
    return _value.toString();
  }
}
