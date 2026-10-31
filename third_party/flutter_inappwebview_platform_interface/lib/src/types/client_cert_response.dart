import '../in_app_webview/platform_webview.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import '../util.dart';
import 'client_cert_response_action.dart';

part 'client_cert_response.g.dart';

@ExchangeableObject()
class ClientCertResponse_ {
  String certificatePath;

  String? certificatePassword;

  @Deprecated('Use keyStoreType instead')
  String? androidKeyStoreType;

  @SupportedPlatforms(platforms: [AndroidPlatform()])
  String? keyStoreType;

  ClientCertResponseAction_? action;

  @ExchangeableObjectConstructor()
  ClientCertResponse_(
      {required this.certificatePath,
      this.certificatePassword = "",
      @Deprecated('Use keyStoreType instead')
      this.androidKeyStoreType = "PKCS12",
      this.keyStoreType = "PKCS12",
      this.action = ClientCertResponseAction_.CANCEL}) {
    if (this.action == ClientCertResponseAction_.PROCEED)
      assert(certificatePath.isNotEmpty);

    this.keyStoreType = this.keyStoreType ?? this.androidKeyStoreType;

    if (Util.isAndroid) assert(this.keyStoreType != null);
  }
}
