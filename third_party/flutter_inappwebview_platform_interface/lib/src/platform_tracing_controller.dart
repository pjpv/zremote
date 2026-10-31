import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'inappwebview_platform.dart';
import 'types/tracing_mode.dart';
import 'types/main.dart';

part 'platform_tracing_controller.g.dart';

@immutable
class PlatformTracingControllerCreationParams {
  const PlatformTracingControllerCreationParams();
}

abstract class PlatformTracingController extends PlatformInterface {
  factory PlatformTracingController(
      PlatformTracingControllerCreationParams params) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `flutter_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformTracingController tracingController =
        InAppWebViewPlatform.instance!.createPlatformTracingController(params);
    PlatformInterface.verify(tracingController, _token);
    return tracingController;
  }

  @protected
  PlatformTracingController.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  final PlatformTracingControllerCreationParams params;

  Future<void> start({required TracingSettings settings}) {
    throw UnimplementedError(
        'start is not implemented on the current platform');
  }

  Future<bool> stop({String? filePath}) {
    throw UnimplementedError('stop is not implemented on the current platform');
  }

  Future<bool> isTracing() {
    throw UnimplementedError(
        'isTracing is not implemented on the current platform');
  }
}

List<dynamic> _deserializeCategories(List<dynamic> categories) {
  List<dynamic> deserializedCategories = [];
  for (dynamic category in categories) {
    if (category is String) {
      deserializedCategories.add(category);
    } else if (category is int) {
      final mode = TracingCategory.fromNativeValue(category);
      if (mode != null) {
        deserializedCategories.add(mode);
      }
    }
  }
  return deserializedCategories;
}

List<dynamic> _serializeCategories(List<dynamic> categories) {
  List<dynamic> serializedCategories = [];
  for (dynamic category in categories) {
    if (category is String) {
      serializedCategories.add(category);
    } else if (category is TracingCategory) {
      serializedCategories.add(category.toNativeValue());
    }
  }
  return serializedCategories;
}

@ExchangeableObject(copyMethod: true)
class TracingSettings_ {
  @ExchangeableObjectProperty(
      deserializer: _deserializeCategories, serializer: _serializeCategories)
  List<dynamic> categories;

  TracingMode_? tracingMode;

  @ExchangeableObjectConstructor()
  TracingSettings_({this.categories = const [], this.tracingMode}) {
    assert(
        this
            .categories
            .map((e) =>
                e.runtimeType is String || e.runtimeType is TracingCategory)
            .contains(false),
        "categories must contain only String or TracingCategory items");
  }
}
