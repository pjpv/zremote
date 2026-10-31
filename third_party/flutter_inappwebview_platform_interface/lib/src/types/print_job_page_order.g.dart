
part of 'print_job_page_order.dart';

class PrintJobPageOrder {
  final int _value;
  final int _nativeValue;
  const PrintJobPageOrder._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobPageOrder._internalMultiPlatform(
          int value, Function nativeValue) =>
      PrintJobPageOrder._internal(value, nativeValue());

  static final ASCENDING = PrintJobPageOrder._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final DESCENDING = PrintJobPageOrder._internalMultiPlatform(-1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return -1;
      default:
        break;
    }
    return null;
  });

  static final SPECIAL = PrintJobPageOrder._internalMultiPlatform(0, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final UNKNOWN = PrintJobPageOrder._internalMultiPlatform(2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final Set<PrintJobPageOrder> values = [
    PrintJobPageOrder.ASCENDING,
    PrintJobPageOrder.DESCENDING,
    PrintJobPageOrder.SPECIAL,
    PrintJobPageOrder.UNKNOWN,
  ].toSet();

  static PrintJobPageOrder? fromValue(int? value) {
    if (value != null) {
      try {
        return PrintJobPageOrder.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobPageOrder? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobPageOrder.values
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
        return 'ASCENDING';
      case -1:
        return 'DESCENDING';
      case 0:
        return 'SPECIAL';
      case 2:
        return 'UNKNOWN';
    }
    return _value.toString();
  }
}
