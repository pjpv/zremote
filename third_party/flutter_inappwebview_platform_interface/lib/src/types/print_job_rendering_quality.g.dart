
part of 'print_job_rendering_quality.dart';

class PrintJobRenderingQuality {
  final int _value;
  final int _nativeValue;
  const PrintJobRenderingQuality._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobRenderingQuality._internalMultiPlatform(
          int value, Function nativeValue) =>
      PrintJobRenderingQuality._internal(value, nativeValue());

  static final BEST = PrintJobRenderingQuality._internalMultiPlatform(0, () {
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

  static final RESPONSIVE =
      PrintJobRenderingQuality._internalMultiPlatform(1, () {
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

  static final Set<PrintJobRenderingQuality> values = [
    PrintJobRenderingQuality.BEST,
    PrintJobRenderingQuality.RESPONSIVE,
  ].toSet();

  static PrintJobRenderingQuality? fromValue(int? value) {
    if (value != null) {
      try {
        return PrintJobRenderingQuality.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobRenderingQuality? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobRenderingQuality.values
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
        return 'BEST';
      case 1:
        return 'RESPONSIVE';
    }
    return _value.toString();
  }
}
