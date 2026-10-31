import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'renderer_priority.dart';

part 'render_process_gone_detail.g.dart';

@ExchangeableObject()
class RenderProcessGoneDetail_ {
  bool didCrash;

  RendererPriority_? rendererPriorityAtExit;

  RenderProcessGoneDetail_(
      {required this.didCrash, this.rendererPriorityAtExit});
}
