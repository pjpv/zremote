
part of 'renderer_priority_policy.dart';

class RendererPriorityPolicy {
  RendererPriority? rendererRequestedPriority;

  bool waivedWhenNotVisible;
  RendererPriorityPolicy(
      {this.rendererRequestedPriority, required this.waivedWhenNotVisible});

  static RendererPriorityPolicy? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = RendererPriorityPolicy(
      rendererRequestedPriority:
          RendererPriority.fromNativeValue(map['rendererRequestedPriority']),
      waivedWhenNotVisible: map['waivedWhenNotVisible'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "rendererRequestedPriority": rendererRequestedPriority?.toNativeValue(),
      "waivedWhenNotVisible": waivedWhenNotVisible,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'RendererPriorityPolicy{rendererRequestedPriority: $rendererRequestedPriority, waivedWhenNotVisible: $waivedWhenNotVisible}';
  }
}
