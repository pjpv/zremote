
part of 'call_async_javascript_result.dart';

class CallAsyncJavaScriptResult {
  String? error;

  dynamic value;
  CallAsyncJavaScriptResult({this.error, this.value});

  static CallAsyncJavaScriptResult? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = CallAsyncJavaScriptResult(
      error: map['error'],
      value: map['value'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "error": error,
      "value": value,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CallAsyncJavaScriptResult{error: $error, value: $value}';
  }
}
