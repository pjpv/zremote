import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'renderer_priority.dart';

part 'renderer_priority_policy.g.dart';

@ExchangeableObject()
class RendererPriorityPolicy_ {
  RendererPriority_? rendererRequestedPriority;

  bool waivedWhenNotVisible;

  RendererPriorityPolicy_(
      {required this.rendererRequestedPriority,
      required this.waivedWhenNotVisible});
}
