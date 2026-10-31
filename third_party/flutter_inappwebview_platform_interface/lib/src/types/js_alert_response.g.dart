
part of 'js_alert_response.dart';

class JsAlertResponse {
  JsAlertResponseAction? action;

  String confirmButtonTitle;

  bool handledByClient;

  String message;
  JsAlertResponse(
      {this.action = JsAlertResponseAction.CONFIRM,
      this.confirmButtonTitle = "",
      this.handledByClient = false,
      this.message = ""});

  static JsAlertResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsAlertResponse();
    instance.action = JsAlertResponseAction.fromNativeValue(map['action']);
    instance.confirmButtonTitle = map['confirmButtonTitle'];
    instance.handledByClient = map['handledByClient'];
    instance.message = map['message'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "confirmButtonTitle": confirmButtonTitle,
      "handledByClient": handledByClient,
      "message": message,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'JsAlertResponse{action: $action, confirmButtonTitle: $confirmButtonTitle, handledByClient: $handledByClient, message: $message}';
  }
}
