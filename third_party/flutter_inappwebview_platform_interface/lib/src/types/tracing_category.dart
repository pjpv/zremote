import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'tracing_category.g.dart';

@ExchangeableEnum()
class TracingCategory_ {
  // ignore: unused_field
  final int _value;
  const TracingCategory_._internal(this._value);

  static const CATEGORIES_ALL = const TracingCategory_._internal(1);

  static const CATEGORIES_ANDROID_WEBVIEW = const TracingCategory_._internal(2);

  static const CATEGORIES_FRAME_VIEWER = const TracingCategory_._internal(64);

  static const CATEGORIES_INPUT_LATENCY = const TracingCategory_._internal(8);

  static const CATEGORIES_JAVASCRIPT_AND_RENDERING =
      const TracingCategory_._internal(32);

  static const CATEGORIES_NONE = const TracingCategory_._internal(0);

  static const CATEGORIES_RENDERING = const TracingCategory_._internal(16);

  static const CATEGORIES_WEB_DEVELOPER = const TracingCategory_._internal(4);
}
