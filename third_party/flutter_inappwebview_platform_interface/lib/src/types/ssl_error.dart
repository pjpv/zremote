import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'ssl_error_type.dart';

part 'ssl_error.g.dart';

@ExchangeableObject()
class SslError_ {
  @Deprecated('Use code instead')
  AndroidSslError_? androidError;

  @Deprecated('Use code instead')
  IOSSslError_? iosError;

  SslErrorType_? code;

  String? message;

  SslError_(
      {@Deprecated('Use code instead') this.androidError,
      @Deprecated('Use code instead') this.iosError,
      this.code,
      this.message}) {}
}
