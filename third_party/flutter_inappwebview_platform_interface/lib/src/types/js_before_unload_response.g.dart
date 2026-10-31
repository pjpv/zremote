
part of 'js_before_unload_response.dart';

class JsBeforeUnloadResponse {
  JsBeforeUnloadResponseAction? action;

  String cancelButtonTitle;

  String confirmButtonTitle;

  bool handledByClient;

  String message;
  JsBeforeUnloadResponse(
      {this.action = JsBeforeUnloadResponseAction.CONFIRM,
      this.cancelButtonTitle = "",
      this.confirmButtonTitle = "",
      this.handledByClient = false,
      this.message = ""});

  static JsBeforeUnloadResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsBeforeUnloadResponse();
    instance.action =
        JsBeforeUnloadResponseAction.fromNativeValue(map['action']);
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
    return 'JsBeforeUnloadResponse{action: $action, cancelButtonTitle: $cancelButtonTitle, confirmButtonTitle: $confirmButtonTitle, handledByClient: $handledByClient, message: $message}';
  }
}
