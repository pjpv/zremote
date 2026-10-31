
part of 'js_prompt_response.dart';

class JsPromptResponse {
  JsPromptResponseAction? action;

  String cancelButtonTitle;

  String confirmButtonTitle;

  String defaultValue;

  bool handledByClient;

  String message;

  String? value;
  JsPromptResponse(
      {this.action = JsPromptResponseAction.CANCEL,
      this.cancelButtonTitle = "",
      this.confirmButtonTitle = "",
      this.defaultValue = "",
      this.handledByClient = false,
      this.message = "",
      this.value});

  static JsPromptResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsPromptResponse(
      value: map['value'],
    );
    instance.action = JsPromptResponseAction.fromNativeValue(map['action']);
    instance.cancelButtonTitle = map['cancelButtonTitle'];
    instance.confirmButtonTitle = map['confirmButtonTitle'];
    instance.defaultValue = map['defaultValue'];
    instance.handledByClient = map['handledByClient'];
    instance.message = map['message'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "cancelButtonTitle": cancelButtonTitle,
      "confirmButtonTitle": confirmButtonTitle,
      "defaultValue": defaultValue,
      "handledByClient": handledByClient,
      "message": message,
      "value": value,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'JsPromptResponse{action: $action, cancelButtonTitle: $cancelButtonTitle, confirmButtonTitle: $confirmButtonTitle, defaultValue: $defaultValue, handledByClient: $handledByClient, message: $message, value: $value}';
  }
}
