
part of 'find_session.dart';

class FindSession {
  int highlightedResultIndex;

  int resultCount;

  SearchResultDisplayStyle searchResultDisplayStyle;
  FindSession(
      {required this.highlightedResultIndex,
      required this.resultCount,
      required this.searchResultDisplayStyle});

  static FindSession? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FindSession(
      highlightedResultIndex: map['highlightedResultIndex'],
      resultCount: map['resultCount'],
      searchResultDisplayStyle: SearchResultDisplayStyle.fromNativeValue(
          map['searchResultDisplayStyle'])!,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "highlightedResultIndex": highlightedResultIndex,
      "resultCount": resultCount,
      "searchResultDisplayStyle": searchResultDisplayStyle.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FindSession{highlightedResultIndex: $highlightedResultIndex, resultCount: $resultCount, searchResultDisplayStyle: $searchResultDisplayStyle}';
  }
}
