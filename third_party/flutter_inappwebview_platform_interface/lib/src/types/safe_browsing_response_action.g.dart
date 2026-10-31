
part of 'safe_browsing_response_action.dart';

class SafeBrowsingResponseAction {
  final int _value;
  final int _nativeValue;
  const SafeBrowsingResponseAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory SafeBrowsingResponseAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      SafeBrowsingResponseAction._internal(value, nativeValue());

  static const BACK_TO_SAFETY = SafeBrowsingResponseAction._internal(0, 0);

  static const PROCEED = SafeBrowsingResponseAction._internal(1, 1);

  static const SHOW_INTERSTITIAL = SafeBrowsingResponseAction._internal(2, 2);

  static final Set<SafeBrowsingResponseAction> values = [
    SafeBrowsingResponseAction.BACK_TO_SAFETY,
    SafeBrowsingResponseAction.PROCEED,
    SafeBrowsingResponseAction.SHOW_INTERSTITIAL,
  ].toSet();

  static SafeBrowsingResponseAction? fromValue(int? value) {
    if (value != null) {
      try {
        return SafeBrowsingResponseAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static SafeBrowsingResponseAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return SafeBrowsingResponseAction.values
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
        return 'BACK_TO_SAFETY';
      case 1:
        return 'PROCEED';
      case 2:
        return 'SHOW_INTERSTITIAL';
    }
    return _value.toString();
  }
}
