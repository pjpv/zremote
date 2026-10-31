import '../types/main.dart';
import '../util.dart';
import '../web_message/platform_web_message_channel.dart';
import '../web_message/platform_web_message_listener.dart';
import 'platform_inappwebview_widget.dart';
import 'platform_inappwebview_controller.dart';

class InAppWebViewKeepAlive {
  String _id = IdGenerator.generate();
}

extension InternalInAppWebViewKeepAlive on InAppWebViewKeepAlive {
  String get id => _id;

  set id(String id) {
    _id = id;
  }
}

class InAppWebViewControllerKeepAliveProps {
  Map<String, JavaScriptHandlerCallback> javaScriptHandlersMap;
  Map<UserScriptInjectionTime, List<UserScript>> userScripts;
  Set<String> webMessageListenerObjNames;
  Map<String, ScriptHtmlTagAttributes> injectedScriptsFromURL;
  Set<PlatformWebMessageChannel> webMessageChannels = Set();
  Set<PlatformWebMessageListener> webMessageListeners = Set();
  Map<String, Function(dynamic data)> devToolsProtocolEventListenerMap;

  InAppWebViewControllerKeepAliveProps(
      {this.javaScriptHandlersMap = const {},
      this.userScripts = const {},
      this.webMessageListenerObjNames = const {},
      this.injectedScriptsFromURL = const {},
      this.webMessageChannels = const {},
      this.webMessageListeners = const {},
      this.devToolsProtocolEventListenerMap = const {}});
}
