
part of 'js_before_unload_request.dart';

class JsBeforeUnloadRequest {
  String? message;

  WebUri? url;
  JsBeforeUnloadRequest({this.message, this.url});

  static JsBeforeUnloadRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsBeforeUnloadRequest(
      message: map['message'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'JsBeforeUnloadRequest{message: $message, url: $url}';
  }
}
