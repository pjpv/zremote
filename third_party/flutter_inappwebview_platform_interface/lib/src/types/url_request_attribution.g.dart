
part of 'url_request_attribution.dart';

class URLRequestAttribution {
  final int _value;
  final int _nativeValue;
  const URLRequestAttribution._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory URLRequestAttribution._internalMultiPlatform(
          int value, Function nativeValue) =>
      URLRequestAttribution._internal(value, nativeValue());

  static const DEVELOPER = URLRequestAttribution._internal(0, 0);

  static const USER = URLRequestAttribution._internal(1, 1);

  static final Set<URLRequestAttribution> values = [
    URLRequestAttribution.DEVELOPER,
    URLRequestAttribution.USER,
  ].toSet();

  static URLRequestAttribution? fromValue(int? value) {
    if (value != null) {
      try {
        return URLRequestAttribution.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static URLRequestAttribution? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return URLRequestAttribution.values
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
        return 'DEVELOPER';
      case 1:
        return 'USER';
    }
    return _value.toString();
  }
}
