
part of 'tracing_mode.dart';

class TracingMode {
  final int _value;
  final int _nativeValue;
  const TracingMode._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory TracingMode._internalMultiPlatform(int value, Function nativeValue) =>
      TracingMode._internal(value, nativeValue());

  static const RECORD_CONTINUOUSLY = TracingMode._internal(1, 1);

  static const RECORD_UNTIL_FULL = TracingMode._internal(0, 0);

  static final Set<TracingMode> values = [
    TracingMode.RECORD_CONTINUOUSLY,
    TracingMode.RECORD_UNTIL_FULL,
  ].toSet();

  static TracingMode? fromValue(int? value) {
    if (value != null) {
      try {
        return TracingMode.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static TracingMode? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return TracingMode.values
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
        return 'RECORD_CONTINUOUSLY';
      case 0:
        return 'RECORD_UNTIL_FULL';
    }
    return _value.toString();
  }
}
