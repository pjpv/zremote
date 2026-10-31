
part of 'server_trust_auth_response_action.dart';

class ServerTrustAuthResponseAction {
  final int _value;
  final int _nativeValue;
  const ServerTrustAuthResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ServerTrustAuthResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      ServerTrustAuthResponseAction._internal(value, nativeValue());

  static const CANCEL = ServerTrustAuthResponseAction._internal(0, 0);

  static const PROCEED = ServerTrustAuthResponseAction._internal(1, 1);

  static final Set<ServerTrustAuthResponseAction> values = [
    ServerTrustAuthResponseAction.CANCEL,
    ServerTrustAuthResponseAction.PROCEED,
  ].toSet();

  static ServerTrustAuthResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return ServerTrustAuthResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ServerTrustAuthResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ServerTrustAuthResponseAction.values
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
    }
    return _value.toString();
  }
}
