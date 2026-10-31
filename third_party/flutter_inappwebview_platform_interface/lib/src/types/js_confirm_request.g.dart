
part of 'js_confirm_request.dart';

class JsConfirmRequest {
  @Deprecated('Use isMainFrame instead')
  bool? iosIsMainFrame;

  bool? isMainFrame;

  String? message;

  WebUri? url;
  JsConfirmRequest(
      {@Deprecated('Use isMainFrame instead') this.iosIsMainFrame,
      this.isMainFrame,
      this.message,
      this.url}) {
    isMainFrame = isMainFrame ?? iosIsMainFrame;
  }

  static JsConfirmRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsConfirmRequest(
      iosIsMainFrame: map['isMainFrame'],
      isMainFrame: map['isMainFrame'],
      message: map['message'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
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
    return 'JsConfirmRequest{isMainFrame: $isMainFrame, message: $message, url: $url}';
  }
}
