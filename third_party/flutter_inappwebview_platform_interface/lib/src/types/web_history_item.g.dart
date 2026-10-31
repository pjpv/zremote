
part of 'web_history_item.dart';

class WebHistoryItem {
  int? entryId;

  int? index;

  int? offset;

  WebUri? originalUrl;

  String? title;

  WebUri? url;
  WebHistoryItem(
      {this.entryId,
      this.index,
      this.offset,
      this.originalUrl,
      this.title,
      this.url});

  static WebHistoryItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebHistoryItem(
      entryId: map['entryId'],
      index: map['index'],
      offset: map['offset'],
      originalUrl:
          map['originalUrl'] != null ? WebUri(map['originalUrl']) : null,
      title: map['title'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "entryId": entryId,
      "index": index,
      "offset": offset,
      "originalUrl": originalUrl?.toString(),
      "title": title,
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebHistoryItem{entryId: $entryId, index: $index, offset: $offset, originalUrl: $originalUrl, title: $title, url: $url}';
  }
}
