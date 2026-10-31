
part of 'print_job_pagination_mode.dart';

class PrintJobPaginationMode {
  final String _value;
  final int? _nativeValue;
  const PrintJobPaginationMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobPaginationMode._internalMultiPlatform(
          String value, Function nativeValue) =>
      PrintJobPaginationMode._internal(value, nativeValue());

  static final AUTOMATIC =
      PrintJobPaginationMode._internalMultiPlatform('AUTOMATIC', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final CLIP = PrintJobPaginationMode._internalMultiPlatform('CLIP', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final FIT = PrintJobPaginationMode._internalMultiPlatform('FIT', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final Set<PrintJobPaginationMode> values = [
    PrintJobPaginationMode.AUTOMATIC,
    PrintJobPaginationMode.CLIP,
    PrintJobPaginationMode.FIT,
  ].toSet();

  static PrintJobPaginationMode? fromValue(String? value) {
    if (value != null) {
      try {
        return PrintJobPaginationMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobPaginationMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobPaginationMode.values
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
