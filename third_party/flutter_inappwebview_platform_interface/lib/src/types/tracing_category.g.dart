
part of 'tracing_category.dart';

class TracingCategory {
  final int _value;
  final int _nativeValue;
  const TracingCategory._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory TracingCategory._internalMultiPlatform(
          int value, Function nativeValue) =>
      TracingCategory._internal(value, nativeValue());

  static const CATEGORIES_ALL = TracingCategory._internal(1, 1);

  static const CATEGORIES_ANDROID_WEBVIEW = TracingCategory._internal(2, 2);

  static const CATEGORIES_FRAME_VIEWER = TracingCategory._internal(64, 64);

  static const CATEGORIES_INPUT_LATENCY = TracingCategory._internal(8, 8);

  static const CATEGORIES_JAVASCRIPT_AND_RENDERING =
      TracingCategory._internal(32, 32);

  static const CATEGORIES_NONE = TracingCategory._internal(0, 0);

  static const CATEGORIES_RENDERING = TracingCategory._internal(16, 16);

  static const CATEGORIES_WEB_DEVELOPER = TracingCategory._internal(4, 4);

  static final Set<TracingCategory> values = [
    TracingCategory.CATEGORIES_ALL,
    TracingCategory.CATEGORIES_ANDROID_WEBVIEW,
    TracingCategory.CATEGORIES_FRAME_VIEWER,
    TracingCategory.CATEGORIES_INPUT_LATENCY,
    TracingCategory.CATEGORIES_JAVASCRIPT_AND_RENDERING,
    TracingCategory.CATEGORIES_NONE,
    TracingCategory.CATEGORIES_RENDERING,
    TracingCategory.CATEGORIES_WEB_DEVELOPER,
  ].toSet();

  static TracingCategory? fromValue(int? value) {
    if (value != null) {
      try {
        return TracingCategory.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static TracingCategory? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return TracingCategory.values
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
        return 'CATEGORIES_ALL';
      case 2:
        return 'CATEGORIES_ANDROID_WEBVIEW';
      case 64:
        return 'CATEGORIES_FRAME_VIEWER';
      case 8:
        return 'CATEGORIES_INPUT_LATENCY';
      case 32:
        return 'CATEGORIES_JAVASCRIPT_AND_RENDERING';
      case 0:
        return 'CATEGORIES_NONE';
      case 16:
        return 'CATEGORIES_RENDERING';
      case 4:
        return 'CATEGORIES_WEB_DEVELOPER';
    }
    return _value.toString();
  }
}
