import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'web_history_item.dart';

part 'web_history.g.dart';

@ExchangeableObject()
class WebHistory_ {
  List<WebHistoryItem_>? list;

  int? currentIndex;

  WebHistory_({this.list, this.currentIndex});
}
