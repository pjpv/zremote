
part of 'custom_tabs_navigation_event_type.dart';

class CustomTabsNavigationEventType {
  final int _value;
  final int? _nativeValue;
  const CustomTabsNavigationEventType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory CustomTabsNavigationEventType._internalMultiPlatform(
          int value, Function nativeValue) =>
      CustomTabsNavigationEventType._internal(value, nativeValue());

  static final ABORTED =
      CustomTabsNavigationEventType._internalMultiPlatform(4, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 4;
      default:
        break;
    }
    return null;
  });

  static final FAILED =
      CustomTabsNavigationEventType._internalMultiPlatform(3, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 3;
      default:
        break;
    }
    return null;
  });

  static final FINISHED =
      CustomTabsNavigationEventType._internalMultiPlatform(2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final STARTED =
      CustomTabsNavigationEventType._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final TAB_HIDDEN =
      CustomTabsNavigationEventType._internalMultiPlatform(6, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 6;
      default:
        break;
    }
    return null;
  });

  static final TAB_SHOWN =
      CustomTabsNavigationEventType._internalMultiPlatform(5, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 5;
      default:
        break;
    }
    return null;
  });

  static final Set<CustomTabsNavigationEventType> values = [
    CustomTabsNavigationEventType.ABORTED,
    CustomTabsNavigationEventType.FAILED,
    CustomTabsNavigationEventType.FINISHED,
    CustomTabsNavigationEventType.STARTED,
    CustomTabsNavigationEventType.TAB_HIDDEN,
    CustomTabsNavigationEventType.TAB_SHOWN,
  ].toSet();

  static CustomTabsNavigationEventType? fromValue(int? value) {
    if (value != null) {
      try {
        return CustomTabsNavigationEventType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static CustomTabsNavigationEventType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return CustomTabsNavigationEventType.values
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
        return 'ABORTED';
      case 3:
        return 'FAILED';
      case 2:
        return 'FINISHED';
      case 1:
        return 'STARTED';
      case 6:
        return 'TAB_HIDDEN';
      case 5:
        return 'TAB_SHOWN';
    }
    return _value.toString();
  }
}
