
part of 'web_resource_request.dart';

class WebResourceRequest {
  bool? hasGesture;

  Map<String, String>? headers;

  bool? isForMainFrame;

  bool? isRedirect;

  String? method;

  WebUri url;
  WebResourceRequest(
      {this.hasGesture,
      this.headers,
      this.isForMainFrame,
      this.isRedirect,
      this.method,
      required this.url});

  static WebResourceRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebResourceRequest(
      hasGesture: map['hasGesture'],
      headers: map['headers']?.cast<String, String>(),
      isForMainFrame: map['isForMainFrame'],
      isRedirect: map['isRedirect'],
      method: map['method'],
      url: WebUri(map['url']),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "hasGesture": hasGesture,
      "headers": headers,
      "isForMainFrame": isForMainFrame,
      "isRedirect": isRedirect,
      "method": method,
      "url": url.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebResourceRequest{hasGesture: $hasGesture, headers: $headers, isForMainFrame: $isForMainFrame, isRedirect: $isRedirect, method: $method, url: $url}';
  }
}
