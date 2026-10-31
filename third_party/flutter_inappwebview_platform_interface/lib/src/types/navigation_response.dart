import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'url_response.dart';

part 'navigation_response.g.dart';

@ExchangeableObject()
class NavigationResponse_ {
  URLResponse_? response;

  bool isForMainFrame;

  bool canShowMIMEType;

  NavigationResponse_(
      {this.response,
      required this.isForMainFrame,
      required this.canShowMIMEType});
}

@Deprecated("Use NavigationResponse instead")
@ExchangeableObject()
class IOSWKNavigationResponse_ {
  IOSURLResponse_? response;

  bool isForMainFrame;

  bool canShowMIMEType;

  IOSWKNavigationResponse_(
      {this.response,
      required this.isForMainFrame,
      required this.canShowMIMEType});
}
