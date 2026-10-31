
part of 'js_alert_request.dart';

class JsAlertRequest {
  @Deprecated('Use isMainFrame instead')
  bool? iosIsMainFrame;

  bool? isMainFrame;

  String? message;

  WebUri? url;
  JsAlertRequest(
      {@Deprecated('Use isMainFrame instead') this.iosIsMainFrame,
      this.isMainFrame,
      this.message,
      this.url}) {
    isMainFrame = isMainFrame ?? iosIsMainFrame;
  }

  static JsAlertRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsAlertRequest(
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
    return 'JsAlertRequest{isMainFrame: $isMainFrame, message: $message, url: $url}';
  }
}
