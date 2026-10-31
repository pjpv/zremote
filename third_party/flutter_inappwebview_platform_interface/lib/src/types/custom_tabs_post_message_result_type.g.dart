
part of 'custom_tabs_post_message_result_type.dart';

class CustomTabsPostMessageResultType {
  final int _value;
  final int? _nativeValue;
  const CustomTabsPostMessageResultType._internal(
      this._value, this._nativeValue);
// ignore: unused_element
  factory CustomTabsPostMessageResultType._internalMultiPlatform(
          int value, Function nativeValue) =>
      CustomTabsPostMessageResultType._internal(value, nativeValue());

  static final FAILURE_DISALLOWED =
      CustomTabsPostMessageResultType._internalMultiPlatform(-1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return -1;
      default:
        break;
    }
    return null;
  });

  static final FAILURE_MESSAGING_ERROR =
      CustomTabsPostMessageResultType._internalMultiPlatform(-3, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return -3;
      default:
        break;
    }
    return null;
  });

  static final FAILURE_REMOTE_ERROR =
      CustomTabsPostMessageResultType._internalMultiPlatform(-2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return -2;
      default:
        break;
    }
    return null;
  });

  static final SUCCESS =
      CustomTabsPostMessageResultType._internalMultiPlatform(0, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final Set<CustomTabsPostMessageResultType> values = [
    CustomTabsPostMessageResultType.FAILURE_DISALLOWED,
    CustomTabsPostMessageResultType.FAILURE_MESSAGING_ERROR,
    CustomTabsPostMessageResultType.FAILURE_REMOTE_ERROR,
    CustomTabsPostMessageResultType.SUCCESS,
  ].toSet();

  static CustomTabsPostMessageResultType? fromValue(int? value) {
    if (value != null) {
      try {
        return CustomTabsPostMessageResultType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static CustomTabsPostMessageResultType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return CustomTabsPostMessageResultType.values
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
      case -1:
        return 'FAILURE_DISALLOWED';
      case -3:
        return 'FAILURE_MESSAGING_ERROR';
      case -2:
        return 'FAILURE_REMOTE_ERROR';
      case 0:
        return 'SUCCESS';
    }
    return _value.toString();
  }
}
