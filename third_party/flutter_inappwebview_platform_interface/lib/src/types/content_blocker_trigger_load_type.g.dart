
part of 'content_blocker_trigger_load_type.dart';

class ContentBlockerTriggerLoadType {
  final String _value;
  final String _nativeValue;
  const ContentBlockerTriggerLoadType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ContentBlockerTriggerLoadType._internalMultiPlatform(
          String value, Function nativeValue) =>
      ContentBlockerTriggerLoadType._internal(value, nativeValue());

  static const FIRST_PARTY =
      ContentBlockerTriggerLoadType._internal('first-party', 'first-party');

  static const THIRD_PARTY =
      ContentBlockerTriggerLoadType._internal('third-party', 'third-party');

  static final Set<ContentBlockerTriggerLoadType> values = [
    ContentBlockerTriggerLoadType.FIRST_PARTY,
    ContentBlockerTriggerLoadType.THIRD_PARTY,
  ].toSet();

  static ContentBlockerTriggerLoadType? fromValue(String? value) {
    if (value != null) {
      try {
        return ContentBlockerTriggerLoadType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ContentBlockerTriggerLoadType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return ContentBlockerTriggerLoadType.values
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
