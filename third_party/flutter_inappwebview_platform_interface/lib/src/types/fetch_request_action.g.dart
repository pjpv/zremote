
part of 'fetch_request_action.dart';

class FetchRequestAction {
  final int _value;
  final int _nativeValue;
  const FetchRequestAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory FetchRequestAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      FetchRequestAction._internal(value, nativeValue());

  static const ABORT = FetchRequestAction._internal(0, 0);

  static const PROCEED = FetchRequestAction._internal(1, 1);

  static final Set<FetchRequestAction> values = [
    FetchRequestAction.ABORT,
    FetchRequestAction.PROCEED,
  ].toSet();

  static FetchRequestAction? fromValue(int? value) {
    if (value != null) {
      try {
        return FetchRequestAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static FetchRequestAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return FetchRequestAction.values
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
        return 'ABORT';
      case 1:
        return 'PROCEED';
    }
    return _value.toString();
  }
}
