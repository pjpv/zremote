
part of 'console_message.dart';

class ConsoleMessage {
  String message;

  ConsoleMessageLevel messageLevel;
  ConsoleMessage(
      {this.message = "", this.messageLevel = ConsoleMessageLevel.LOG});

  static ConsoleMessage? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ConsoleMessage();
    instance.message = map['message'];
    instance.messageLevel =
        ConsoleMessageLevel.fromNativeValue(map['messageLevel'])!;
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "messageLevel": messageLevel.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ConsoleMessage{message: $message, messageLevel: $messageLevel}';
  }
}
