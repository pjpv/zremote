import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'search_result_display_style.dart';

part 'find_session.g.dart';

@ExchangeableObject()
class FindSession_ {
  int resultCount;

  int highlightedResultIndex;

  SearchResultDisplayStyle_ searchResultDisplayStyle;

  FindSession_(
      {required this.resultCount,
      required this.highlightedResultIndex,
      required this.searchResultDisplayStyle});
}
