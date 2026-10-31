import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../web_storage/platform_web_storage.dart';

part 'web_storage_type.g.dart';

@ExchangeableEnum()
class WebStorageType_ {
  // ignore: unused_field
  final String _value;
  const WebStorageType_._internal(this._value);

  static const LOCAL_STORAGE = const WebStorageType_._internal("localStorage");

  static const SESSION_STORAGE =
      const WebStorageType_._internal("sessionStorage");
}
