
part of 'platform_tracing_controller.dart';

class TracingSettings {
  List<dynamic> categories;

  TracingMode? tracingMode;
  TracingSettings({this.categories = const [], this.tracingMode}) {
    assert(
        this
            .categories
            .map((e) =>
                e.runtimeType is String || e.runtimeType is TracingCategory)
            .contains(false),
        "categories must contain only String or TracingCategory items");
  }

  static TracingSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = TracingSettings(
      tracingMode: TracingMode.fromNativeValue(map['tracingMode']),
    );
    instance.categories = _deserializeCategories(map['categories']);
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "categories": _serializeCategories(categories),
      "tracingMode": tracingMode?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  TracingSettings copy() {
    return TracingSettings.fromMap(toMap()) ?? TracingSettings();
  }

  @override
  String toString() {
    return 'TracingSettings{categories: $categories, tracingMode: $tracingMode}';
  }
}
