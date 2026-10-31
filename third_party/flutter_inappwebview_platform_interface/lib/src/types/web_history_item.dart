import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';
import 'web_history.dart';

part 'web_history_item.g.dart';

@ExchangeableObject()
class WebHistoryItem_ {
  WebUri? originalUrl;

  String? title;

  WebUri? url;

  int? index;

  int? offset;

  @SupportedPlatforms(platforms: [WindowsPlatform()])
  int? entryId;

  WebHistoryItem_(
      {this.originalUrl,
      this.title,
      this.url,
      this.index,
      this.offset,
      this.entryId});
}
