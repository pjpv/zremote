
part of 'js_prompt_request.dart';

class JsPromptRequest {
  String? defaultValue;

  @Deprecated('Use isMainFrame instead')
  bool? iosIsMainFrame;

  bool? isMainFrame;

  String? message;

  WebUri? url;
  JsPromptRequest(
      {this.defaultValue,
      @Deprecated('Use isMainFrame instead') this.iosIsMainFrame,
      this.isMainFrame,
      this.message,
      this.url}) {
    isMainFrame = isMainFrame ?? iosIsMainFrame;
  }

  static JsPromptRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsPromptRequest(
      defaultValue: map['defaultValue'],
      iosIsMainFrame: map['isMainFrame'],
      isMainFrame: map['isMainFrame'],
      message: map['message'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "defaultValue": defaultValue,
      "isMainFrame": isMainFrame,
      "message": message,
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'JsPromptRequest{defaultValue: $defaultValue, isMainFrame: $isMainFrame, message: $message, url: $url}';
  }
}
