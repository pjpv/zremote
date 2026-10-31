
part of 'print_job_orientation.dart';

class PrintJobOrientation {
  final int _value;
  final int _nativeValue;
  const PrintJobOrientation._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobOrientation._internalMultiPlatform(
          int value, Function nativeValue) =>
      PrintJobOrientation._internal(value, nativeValue());

  static final LANDSCAPE = PrintJobOrientation._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 1;
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final PORTRAIT = PrintJobOrientation._internalMultiPlatform(0, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 0;
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final Set<PrintJobOrientation> values = [
    PrintJobOrientation.LANDSCAPE,
    PrintJobOrientation.PORTRAIT,
  ].toSet();

  static PrintJobOrientation? fromValue(int? value) {
    if (value != null) {
      try {
        return PrintJobOrientation.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobOrientation? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobOrientation.values
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
      case 1:
        return 'LANDSCAPE';
      case 0:
        return 'PORTRAIT';
    }
    return _value.toString();
  }
}
