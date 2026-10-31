
part of 'compress_format.dart';

class CompressFormat {
  final String _value;
  final String _nativeValue;
  const CompressFormat._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory CompressFormat._internalMultiPlatform(
          String value, Function nativeValue) =>
      CompressFormat._internal(value, nativeValue());

  static const JPEG = CompressFormat._internal('JPEG', 'JPEG');

  static const PNG = CompressFormat._internal('PNG', 'PNG');

  static const WEBP = CompressFormat._internal('WEBP', 'WEBP');

  static const WEBP_LOSSLESS =
      CompressFormat._internal('WEBP_LOSSLESS', 'WEBP_LOSSLESS');

  static const WEBP_LOSSY =
      CompressFormat._internal('WEBP_LOSSY', 'WEBP_LOSSY');

  static final Set<CompressFormat> values = [
    CompressFormat.JPEG,
    CompressFormat.PNG,
    CompressFormat.WEBP,
    CompressFormat.WEBP_LOSSLESS,
    CompressFormat.WEBP_LOSSY,
  ].toSet();

  static CompressFormat? fromValue(String? value) {
    if (value != null) {
      try {
        return CompressFormat.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static CompressFormat? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return CompressFormat.values
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
