
part of 'web_archive_format.dart';

class WebArchiveFormat {
  final String _value;
  final String _nativeValue;
  const WebArchiveFormat._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WebArchiveFormat._internalMultiPlatform(
          String value, Function nativeValue) =>
      WebArchiveFormat._internal(value, nativeValue());

  static const MHT = WebArchiveFormat._internal('mht', 'mht');

  static const WEBARCHIVE =
      WebArchiveFormat._internal('webarchive', 'webarchive');

  static final Set<WebArchiveFormat> values = [
    WebArchiveFormat.MHT,
    WebArchiveFormat.WEBARCHIVE,
  ].toSet();

  static WebArchiveFormat? fromValue(String? value) {
    if (value != null) {
      try {
        return WebArchiveFormat.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static WebArchiveFormat? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return WebArchiveFormat.values
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
