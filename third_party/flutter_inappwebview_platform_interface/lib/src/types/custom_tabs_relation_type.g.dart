
part of 'custom_tabs_relation_type.dart';

class CustomTabsRelationType {
  final int _value;
  final int? _nativeValue;
  const CustomTabsRelationType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory CustomTabsRelationType._internalMultiPlatform(
          int value, Function nativeValue) =>
      CustomTabsRelationType._internal(value, nativeValue());

  static final HANDLE_ALL_URLS =
      CustomTabsRelationType._internalMultiPlatform(2, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final USE_AS_ORIGIN =
      CustomTabsRelationType._internalMultiPlatform(1, () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final Set<CustomTabsRelationType> values = [
    CustomTabsRelationType.HANDLE_ALL_URLS,
    CustomTabsRelationType.USE_AS_ORIGIN,
  ].toSet();

  static CustomTabsRelationType? fromValue(int? value) {
    if (value != null) {
      try {
        return CustomTabsRelationType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static CustomTabsRelationType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return CustomTabsRelationType.values
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
      case 2:
        return 'HANDLE_ALL_URLS';
      case 1:
        return 'USE_AS_ORIGIN';
    }
    return _value.toString();
  }
}
