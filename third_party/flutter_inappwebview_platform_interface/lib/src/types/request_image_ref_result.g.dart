
part of 'request_image_ref_result.dart';

class RequestImageRefResult {
  WebUri? url;
  RequestImageRefResult({this.url});

  static RequestImageRefResult? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = RequestImageRefResult(
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'RequestImageRefResult{url: $url}';
  }
}
