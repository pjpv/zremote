import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';

part 'in_app_webview_initial_data.g.dart';

@ExchangeableObject()
class InAppWebViewInitialData_ {
  String data;

  String mimeType;

  String encoding;

  WebUri? baseUrl;

  @Deprecated('Use historyUrl instead')
  Uri? androidHistoryUrl;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  WebUri? historyUrl;

  InAppWebViewInitialData_(
      {required this.data,
      this.mimeType = "text/html",
      this.encoding = "utf8",
      this.baseUrl,
      @Deprecated('Use historyUrl instead') this.androidHistoryUrl,
      this.historyUrl});
}
