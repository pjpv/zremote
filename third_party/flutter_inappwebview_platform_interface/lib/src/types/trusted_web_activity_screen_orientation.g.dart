
part of 'trusted_web_activity_screen_orientation.dart';

class TrustedWebActivityScreenOrientation {
  final int _value;
  final int _nativeValue;
  const TrustedWebActivityScreenOrientation._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory TrustedWebActivityScreenOrientation._internalMultiPlatform(
          int value, Function nativeValue) =>
      TrustedWebActivityScreenOrientation._internal(value, nativeValue());

  static const ANY = TrustedWebActivityScreenOrientation._internal(5, 5);

  static const DEFAULT = TrustedWebActivityScreenOrientation._internal(0, 0);

  static const LANDSCAPE = TrustedWebActivityScreenOrientation._internal(6, 6);

  static const LANDSCAPE_PRIMARY =
      TrustedWebActivityScreenOrientation._internal(3, 3);

  static const LANDSCAPE_SECONDARY =
      TrustedWebActivityScreenOrientation._internal(4, 4);

  static const NATURAL = TrustedWebActivityScreenOrientation._internal(8, 8);

  static const PORTRAIT = TrustedWebActivityScreenOrientation._internal(7, 7);

  static const PORTRAIT_PRIMARY =
      TrustedWebActivityScreenOrientation._internal(1, 1);

  static const PORTRAIT_SECONDARY =
      TrustedWebActivityScreenOrientation._internal(2, 2);

  static final Set<TrustedWebActivityScreenOrientation> values = [
    TrustedWebActivityScreenOrientation.ANY,
    TrustedWebActivityScreenOrientation.DEFAULT,
    TrustedWebActivityScreenOrientation.LANDSCAPE,
    TrustedWebActivityScreenOrientation.LANDSCAPE_PRIMARY,
    TrustedWebActivityScreenOrientation.LANDSCAPE_SECONDARY,
    TrustedWebActivityScreenOrientation.NATURAL,
    TrustedWebActivityScreenOrientation.PORTRAIT,
    TrustedWebActivityScreenOrientation.PORTRAIT_PRIMARY,
    TrustedWebActivityScreenOrientation.PORTRAIT_SECONDARY,
  ].toSet();

  static TrustedWebActivityScreenOrientation? fromValue(int? value) {
    if (value != null) {
      try {
        return TrustedWebActivityScreenOrientation.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static TrustedWebActivityScreenOrientation? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return TrustedWebActivityScreenOrientation.values
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
      case 5:
        return 'ANY';
      case 0:
        return 'DEFAULT';
      case 6:
        return 'LANDSCAPE';
      case 3:
        return 'LANDSCAPE_PRIMARY';
      case 4:
        return 'LANDSCAPE_SECONDARY';
      case 8:
        return 'NATURAL';
      case 7:
        return 'PORTRAIT';
      case 1:
        return 'PORTRAIT_PRIMARY';
      case 2:
        return 'PORTRAIT_SECONDARY';
    }
    return _value.toString();
  }
}
