
part of 'print_job_duplex_mode.dart';

class PrintJobDuplexMode {
  final String _value;
  final int? _nativeValue;
  const PrintJobDuplexMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobDuplexMode._internalMultiPlatform(
          String value, Function nativeValue) =>
      PrintJobDuplexMode._internal(value, nativeValue());

  static final LONG_EDGE =
      PrintJobDuplexMode._internalMultiPlatform('LONG_EDGE', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 2;
      case TargetPlatform.iOS:
        return 1;
      case TargetPlatform.macOS:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final NONE = PrintJobDuplexMode._internalMultiPlatform('NONE', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 1;
      case TargetPlatform.iOS:
        return 0;
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final SHORT_EDGE =
      PrintJobDuplexMode._internalMultiPlatform('SHORT_EDGE', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 4;
      case TargetPlatform.iOS:
        return 2;
      case TargetPlatform.macOS:
        return 3;
      default:
        break;
    }
    return null;
  });

  static final Set<PrintJobDuplexMode> values = [
    PrintJobDuplexMode.LONG_EDGE,
    PrintJobDuplexMode.NONE,
    PrintJobDuplexMode.SHORT_EDGE,
  ].toSet();

  static PrintJobDuplexMode? fromValue(String? value) {
    if (value != null) {
      try {
        return PrintJobDuplexMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobDuplexMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobDuplexMode.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  int? toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
