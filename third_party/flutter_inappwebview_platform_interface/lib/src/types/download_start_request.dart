import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_uri.dart';
import '../in_app_webview/platform_webview.dart';

part 'download_start_request.g.dart';

@ExchangeableObject()
class DownloadStartRequest_ {
  WebUri url;

  String? userAgent;

  String? contentDisposition;

  String? mimeType;

  int contentLength;

  String? suggestedFilename;

  String? textEncodingName;

  DownloadStartRequest_(
      {required this.url,
      this.userAgent,
      this.contentDisposition,
      this.mimeType,
      required this.contentLength,
      this.suggestedFilename,
      this.textEncodingName});
}
