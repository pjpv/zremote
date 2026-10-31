
part of 'ajax_request_event_type.dart';

class AjaxRequestEventType {
  final String _value;
  final String _nativeValue;
  const AjaxRequestEventType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AjaxRequestEventType._internalMultiPlatform(
          String value, Function nativeValue) =>
      AjaxRequestEventType._internal(value, nativeValue());

  static const ABORT = AjaxRequestEventType._internal('abort', 'abort');

  static const ERROR = AjaxRequestEventType._internal('error', 'error');

  static const LOAD = AjaxRequestEventType._internal('load', 'load');

  static const LOADEND = AjaxRequestEventType._internal('loadend', 'loadend');

  static const LOADSTART =
      AjaxRequestEventType._internal('loadstart', 'loadstart');

  static const PROGRESS =
      AjaxRequestEventType._internal('progress', 'progress');

  static const TIMEOUT = AjaxRequestEventType._internal('timeout', 'timeout');

  static final Set<AjaxRequestEventType> values = [
    AjaxRequestEventType.ABORT,
    AjaxRequestEventType.ERROR,
    AjaxRequestEventType.LOAD,
    AjaxRequestEventType.LOADEND,
    AjaxRequestEventType.LOADSTART,
    AjaxRequestEventType.PROGRESS,
    AjaxRequestEventType.TIMEOUT,
  ].toSet();

  static AjaxRequestEventType? fromValue(String? value) {
    if (value != null) {
      try {
        return AjaxRequestEventType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AjaxRequestEventType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return AjaxRequestEventType.values
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
