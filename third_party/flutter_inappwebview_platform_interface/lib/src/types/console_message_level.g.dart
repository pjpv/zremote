
part of 'console_message_level.dart';

class ConsoleMessageLevel {
  final int _value;
  final int _nativeValue;
  const ConsoleMessageLevel._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ConsoleMessageLevel._internalMultiPlatform(
          int value, Function nativeValue) =>
      ConsoleMessageLevel._internal(value, nativeValue());

  static const DEBUG = ConsoleMessageLevel._internal(4, 4);

  static const ERROR = ConsoleMessageLevel._internal(3, 3);

  static const LOG = ConsoleMessageLevel._internal(1, 1);

  static const TIP = ConsoleMessageLevel._internal(0, 0);

  static const WARNING = ConsoleMessageLevel._internal(2, 2);

  static final Set<ConsoleMessageLevel> values = [
    ConsoleMessageLevel.DEBUG,
    ConsoleMessageLevel.ERROR,
    ConsoleMessageLevel.LOG,
    ConsoleMessageLevel.TIP,
    ConsoleMessageLevel.WARNING,
  ].toSet();

  static ConsoleMessageLevel? fromValue(int? value) {
    if (value != null) {
      try {
        return ConsoleMessageLevel.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ConsoleMessageLevel? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return ConsoleMessageLevel.values
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
      case 4:
        return 'DEBUG';
      case 3:
        return 'ERROR';
      case 1:
        return 'LOG';
      case 0:
        return 'TIP';
      case 2:
        return 'WARNING';
    }
    return _value.toString();
  }
}
