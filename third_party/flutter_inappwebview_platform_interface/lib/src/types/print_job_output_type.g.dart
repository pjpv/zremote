
part of 'print_job_output_type.dart';

class PrintJobOutputType {
  final int _value;
  final int _nativeValue;
  const PrintJobOutputType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobOutputType._internalMultiPlatform(
          int value, Function nativeValue) =>
      PrintJobOutputType._internal(value, nativeValue());

  static const GENERAL = PrintJobOutputType._internal(0, 0);

  static const GRAYSCALE = PrintJobOutputType._internal(2, 2);

  static const PHOTO = PrintJobOutputType._internal(1, 1);

  static const PHOTO_GRAYSCALE = PrintJobOutputType._internal(3, 3);

  static final Set<PrintJobOutputType> values = [
    PrintJobOutputType.GENERAL,
    PrintJobOutputType.GRAYSCALE,
    PrintJobOutputType.PHOTO,
    PrintJobOutputType.PHOTO_GRAYSCALE,
  ].toSet();

  static PrintJobOutputType? fromValue(int? value) {
    if (value != null) {
      try {
        return PrintJobOutputType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobOutputType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobOutputType.values
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
        return 'GENERAL';
      case 2:
        return 'GRAYSCALE';
      case 1:
        return 'PHOTO';
      case 3:
        return 'PHOTO_GRAYSCALE';
    }
    return _value.toString();
  }
}
