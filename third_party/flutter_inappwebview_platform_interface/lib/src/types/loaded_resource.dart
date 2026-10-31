import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import '../web_uri.dart';

part 'loaded_resource.g.dart';

@ExchangeableObject()
class LoadedResource_ {
  String? initiatorType;

  WebUri? url;

  double? startTime;

  double? duration;

  LoadedResource_(
      {this.initiatorType, this.url, this.startTime, this.duration});
}
