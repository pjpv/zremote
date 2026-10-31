import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../platform_webview_feature.dart';
import 'platform_web_message_port.dart';

part 'web_message.g.dart';

@ExchangeableObject(fromMapForceAllInline: true)
class WebMessage_ {
  dynamic data;

  WebMessageType_ type;

  List<IWebMessagePort>? ports;

  @ExchangeableObjectConstructor()
  WebMessage_({this.data, this.type = WebMessageType_.STRING, this.ports}) {
    assert(((this.data == null || this.data is String) &&
            this.type == WebMessageType_.STRING) ||
        (this.data != null &&
            this.data is Uint8List &&
            this.type == WebMessageType_.ARRAY_BUFFER));
  }
}

@ExchangeableEnum()
class WebMessageType_ {
  // ignore: unused_field
  final int _value;

  const WebMessageType_._internal(this._value);

  static const STRING = const WebMessageType_._internal(0);

  static const ARRAY_BUFFER = const WebMessageType_._internal(1);
}
