
part of 'print_job_disposition.dart';

class PrintJobDisposition {
  final String _value;
  final String _nativeValue;
  const PrintJobDisposition._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobDisposition._internalMultiPlatform(
          String value, Function nativeValue) =>
      PrintJobDisposition._internal(value, nativeValue());

  static final CANCEL =
      PrintJobDisposition._internalMultiPlatform('CANCEL', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 'cancel';
      default:
        break;
    }
    return null;
  });

  static final PREVIEW =
      PrintJobDisposition._internalMultiPlatform('PREVIEW', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 'preview';
      default:
        break;
    }
    return null;
  });

  static final SAVE = PrintJobDisposition._internalMultiPlatform('SAVE', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 'save';
      default:
        break;
    }
    return null;
  });

  static final SPOOL = PrintJobDisposition._internalMultiPlatform('SPOOL', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 'spool';
      default:
        break;
    }
    return null;
  });

  static final Set<PrintJobDisposition> values = [
    PrintJobDisposition.CANCEL,
    PrintJobDisposition.PREVIEW,
    PrintJobDisposition.SAVE,
    PrintJobDisposition.SPOOL,
  ].toSet();

  static PrintJobDisposition? fromValue(String? value) {
    if (value != null) {
      try {
        return PrintJobDisposition.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobDisposition? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return PrintJobDisposition.values
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
