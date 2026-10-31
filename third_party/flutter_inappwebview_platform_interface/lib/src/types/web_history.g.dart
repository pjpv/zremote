
part of 'web_history.dart';

class WebHistory {
  int? currentIndex;

  List<WebHistoryItem>? list;
  WebHistory({this.currentIndex, this.list});

  static WebHistory? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebHistory(
      currentIndex: map['currentIndex'],
      list: map['list'] != null
          ? List<WebHistoryItem>.from(map['list']
              .map((e) => WebHistoryItem.fromMap(e?.cast<String, dynamic>())!))
          : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "currentIndex": currentIndex,
      "list": list?.map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebHistory{currentIndex: $currentIndex, list: $list}';
  }
}
