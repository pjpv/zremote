import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'webview_package_info.g.dart';

@ExchangeableObject()
class WebViewPackageInfo_ {
  String? versionName;

  String? packageName;

  WebViewPackageInfo_({this.versionName, this.packageName});
}

@Deprecated("Use WebViewPackageInfo instead")
@ExchangeableObject()
class AndroidWebViewPackageInfo_ {
  String? versionName;

  String? packageName;

  AndroidWebViewPackageInfo_({this.versionName, this.packageName});
}
