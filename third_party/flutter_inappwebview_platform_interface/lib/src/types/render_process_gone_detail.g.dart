
part of 'render_process_gone_detail.dart';

class RenderProcessGoneDetail {
  bool didCrash;

  RendererPriority? rendererPriorityAtExit;
  RenderProcessGoneDetail(
      {required this.didCrash, this.rendererPriorityAtExit});

  static RenderProcessGoneDetail? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = RenderProcessGoneDetail(
      didCrash: map['didCrash'],
      rendererPriorityAtExit:
          RendererPriority.fromNativeValue(map['rendererPriorityAtExit']),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "didCrash": didCrash,
      "rendererPriorityAtExit": rendererPriorityAtExit?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'RenderProcessGoneDetail{didCrash: $didCrash, rendererPriorityAtExit: $rendererPriorityAtExit}';
  }
}
