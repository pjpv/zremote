
part of 'print_job_color_mode.dart';

class PrintJobColorMode {
  final int _value;
  final dynamic _nativeValue;
  const PrintJobColorMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobColorMode._internalMultiPlatform(
          int value, Function nativeValue) =>
      PrintJobColorMode._internal(value, nativeValue());

  static final COLOR = PrintJobColorMode._internalMultiPlatform(2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 1;
      case TargetPlatform.macOS:
        return 'RGB';
      default:
        break;
    }
    return null;
  });

  static final MONOCHROME = PrintJobColorMode._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 1;
      case TargetPlatform.macOS:
        return 'Gray';
      default:
        break;
    }
    return null;
  });

  static final Set<PrintJobColorMode> values = [
    PrintJobColorMode.COLOR,
    PrintJobColorMode.MONOCHROME,
  ].toSet();

  static PrintJobColorMode? fromValue(int? value) {
    if (value != null) {
      try {
        return PrintJobColorMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobColorMode? fromNativeValue(dynamic value) {
    if (value != null) {
      try {
        return PrintJobColorMode.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  dynamic toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 2:
        return 'COLOR';
      case 1:
        return 'MONOCHROME';
    }
    return _value.toString();
  }
}
