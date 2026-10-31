
part of 'request_focus_node_href_result.dart';

class RequestFocusNodeHrefResult {
  String? src;

  String? title;

  WebUri? url;
  RequestFocusNodeHrefResult({this.src, this.title, this.url});

  static RequestFocusNodeHrefResult? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = RequestFocusNodeHrefResult(
      src: map['src'],
      title: map['title'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "src": src,
      "title": title,
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'RequestFocusNodeHrefResult{src: $src, title: $title, url: $url}';
  }
}
