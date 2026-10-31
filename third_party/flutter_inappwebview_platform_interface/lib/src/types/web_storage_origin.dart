import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_storage/platform_web_storage_manager.dart';

part 'web_storage_origin.g.dart';

@ExchangeableObject()
class WebStorageOrigin_ {
  String? origin;

  int? quota;

  int? usage;

  WebStorageOrigin_({this.origin, this.quota, this.usage});
}

@Deprecated("Use WebStorageOrigin instead")
@ExchangeableObject()
class AndroidWebStorageOrigin_ {
  String? origin;

  int? quota;

  int? usage;

  AndroidWebStorageOrigin_({this.origin, this.quota, this.usage});
}
