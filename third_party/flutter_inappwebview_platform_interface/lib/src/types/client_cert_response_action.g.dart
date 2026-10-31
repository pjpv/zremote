
part of 'client_cert_response_action.dart';

class ClientCertResponseAction {
  final int _value;
  final int _nativeValue;
  const ClientCertResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ClientCertResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      ClientCertResponseAction._internal(value, nativeValue());

  static const CANCEL = ClientCertResponseAction._internal(0, 0);

  static const IGNORE = ClientCertResponseAction._internal(2, 2);

  static const PROCEED = ClientCertResponseAction._internal(1, 1);

  static final Set<ClientCertResponseAction> values = [
    ClientCertResponseAction.CANCEL,
    ClientCertResponseAction.IGNORE,
    ClientCertResponseAction.PROCEED,
  ].toSet();

  static ClientCertResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return ClientCertResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ClientCertResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ClientCertResponseAction.values
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
      case 2:
        return 'IGNORE';
      case 1:
        return 'PROCEED';
    }
    return _value.toString();
  }
}
