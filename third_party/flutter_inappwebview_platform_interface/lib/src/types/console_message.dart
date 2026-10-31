import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../in_app_webview/platform_webview.dart';
import 'console_message_level.dart';

part 'console_message.g.dart';

@ExchangeableObject()
class ConsoleMessage_ {
  String message;

  ConsoleMessageLevel_ messageLevel;

  ConsoleMessage_(
      {this.message = "", this.messageLevel = ConsoleMessageLevel_.LOG});
}
