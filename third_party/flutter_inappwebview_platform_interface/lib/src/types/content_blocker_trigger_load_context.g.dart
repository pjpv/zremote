
part of 'content_blocker_trigger_load_context.dart';

class ContentBlockerTriggerLoadContext {
  final String _value;
  final String _nativeValue;
  const ContentBlockerTriggerLoadContext._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory ContentBlockerTriggerLoadContext._internalMultiPlatform(
          String value, Function nativeValue) =>
      ContentBlockerTriggerLoadContext._internal(value, nativeValue());

  static const CHILD_FRAME =
      ContentBlockerTriggerLoadContext._internal('child-frame', 'child-frame');

  static const TOP_FRAME =
      ContentBlockerTriggerLoadContext._internal('top-frame', 'top-frame');

  static final Set<ContentBlockerTriggerLoadContext> values = [
    ContentBlockerTriggerLoadContext.CHILD_FRAME,
    ContentBlockerTriggerLoadContext.TOP_FRAME,
  ].toSet();

  static ContentBlockerTriggerLoadContext? fromValue(String? value) {
    if (value != null) {
      try {
        return ContentBlockerTriggerLoadContext.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ContentBlockerTriggerLoadContext? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return ContentBlockerTriggerLoadContext.values
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
