
part of 'cross_origin.dart';

class CrossOrigin {
  final String _value;
  final String _nativeValue;
  const CrossOrigin._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory CrossOrigin._internalMultiPlatform(
          String value, Function nativeValue) =>
      CrossOrigin._internal(value, nativeValue());

  static const ANONYMOUS = CrossOrigin._internal('anonymous', 'anonymous');

  static const USE_CREDENTIALS =
      CrossOrigin._internal('use-credentials', 'use-credentials');

  static final Set<CrossOrigin> values = [
    CrossOrigin.ANONYMOUS,
    CrossOrigin.USE_CREDENTIALS,
  ].toSet();

  static CrossOrigin? fromValue(String? value) {
    if (value != null) {
      try {
        return CrossOrigin.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static CrossOrigin? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return CrossOrigin.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
