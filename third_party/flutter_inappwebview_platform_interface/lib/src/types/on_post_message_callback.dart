import '../web_message/main.dart';
import '../web_uri.dart';

typedef void OnPostMessageCallback(WebMessage? message, WebUri? sourceOrigin,
    bool isMainFrame, PlatformJavaScriptReplyProxy replyProxy);
