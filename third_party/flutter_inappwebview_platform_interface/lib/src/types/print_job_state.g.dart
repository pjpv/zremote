
part of 'print_job_state.dart';

class PrintJobState {
  final int _value;
  final int? _nativeValue;
  const PrintJobState._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PrintJobState._internalMultiPlatform(
          int value, Function nativeValue) =>
      PrintJobState._internal(value, nativeValue());

  static final BLOCKED = PrintJobState._internalMultiPlatform(4, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 4;
      default:
        break;
    }
    return null;
  });

  static final CANCELED = PrintJobState._internalMultiPlatform(7, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 7;
      case TargetPlatform.iOS:
        return 7;
      case TargetPlatform.macOS:
        return 7;
      default:
        break;
    }
    return null;
  });

  static final COMPLETED = PrintJobState._internalMultiPlatform(5, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 5;
      case TargetPlatform.iOS:
        return 5;
      case TargetPlatform.macOS:
        return 5;
      default:
        break;
    }
    return null;
  });

  static final CREATED = PrintJobState._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 1;
      case TargetPlatform.iOS:
        return 1;
      case TargetPlatform.macOS:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final FAILED = PrintJobState._internalMultiPlatform(6, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 6;
      case TargetPlatform.iOS:
        return 6;
      default:
        break;
    }
    return null;
  });

  static final QUEUED = PrintJobState._internalMultiPlatform(2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final STARTED = PrintJobState._internalMultiPlatform(3, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 3;
      case TargetPlatform.iOS:
        return 3;
      case TargetPlatform.macOS:
        return 3;
      default:
        break;
    }
    return null;
  });

  static final Set<PrintJobState> values = [
    PrintJobState.BLOCKED,
    PrintJobState.CANCELED,
    PrintJobState.COMPLETED,
    PrintJobState.CREATED,
    PrintJobState.FAILED,
    PrintJobState.QUEUED,
    PrintJobState.STARTED,
  ].toSet();

  static PrintJobState? fromValue(int? value) {
    if (value != null) {
      try {
        return PrintJobState.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PrintJobState? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return PrintJobState.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int? toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 4:
        return 'BLOCKED';
      case 7:
        return 'CANCELED';
      case 5:
        return 'COMPLETED';
      case 1:
        return 'CREATED';
      case 6:
        return 'FAILED';
      case 2:
        return 'QUEUED';
      case 3:
        return 'STARTED';
    }
    return _value.toString();
  }
}
