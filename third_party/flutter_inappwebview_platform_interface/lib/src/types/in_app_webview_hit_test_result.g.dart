
part of 'in_app_webview_hit_test_result.dart';

class InAppWebViewHitTestResult {
  String? extra;

  InAppWebViewHitTestResultType? type;
  InAppWebViewHitTestResult({this.extra, this.type});

  static InAppWebViewHitTestResult? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = InAppWebViewHitTestResult(
      extra: map['extra'],
      type: InAppWebViewHitTestResultType.fromNativeValue(map['type']),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "extra": extra,
      "type": type?.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'InAppWebViewHitTestResult{extra: $extra, type: $type}';
  }
}
