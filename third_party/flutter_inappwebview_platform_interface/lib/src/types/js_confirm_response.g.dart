
part of 'js_confirm_response.dart';

class JsConfirmResponse {
  JsConfirmResponseAction? action;

  String cancelButtonTitle;

  String confirmButtonTitle;

  bool handledByClient;

  String message;
  JsConfirmResponse(
      {this.action = JsConfirmResponseAction.CANCEL,
      this.cancelButtonTitle = "",
      this.confirmButtonTitle = "",
      this.handledByClient = false,
      this.message = ""});

  static JsConfirmResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsConfirmResponse();
    instance.action = JsConfirmResponseAction.fromNativeValue(map['action']);
    instance.cancelButtonTitle = map['cancelButtonTitle'];
    instance.confirmButtonTitle = map['confirmButtonTitle'];
    instance.handledByClient = map['handledByClient'];
    instance.message = map['message'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "cancelButtonTitle": cancelButtonTitle,
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
    return 'JsConfirmResponse{action: $action, cancelButtonTitle: $cancelButtonTitle, confirmButtonTitle: $confirmButtonTitle, handledByClient: $handledByClient, message: $message}';
  }
}
