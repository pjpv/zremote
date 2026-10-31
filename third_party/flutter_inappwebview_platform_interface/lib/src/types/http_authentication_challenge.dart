import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'url_credential.dart';
import 'url_response.dart';
import 'url_authentication_challenge.dart';
import 'url_protection_space.dart';
import '../in_app_webview/platform_webview.dart';

part 'http_authentication_challenge.g.dart';

@ExchangeableObject()
class HttpAuthenticationChallenge_ extends URLAuthenticationChallenge_ {
  int previousFailureCount;

  URLCredential_? proposedCredential;

  @Deprecated("Use failureResponse instead")
  IOSURLResponse_? iosFailureResponse;

  URLResponse_? failureResponse;

  @Deprecated("Use error instead")
  String? iosError;

  String? error;

  HttpAuthenticationChallenge_(
      {required this.previousFailureCount,
      required URLProtectionSpace_ protectionSpace,
      @Deprecated("Use failureResponse instead") this.iosFailureResponse,
      this.failureResponse,
      this.proposedCredential,
      @Deprecated("Use error instead") this.iosError,
      this.error})
      : super(protectionSpace: protectionSpace);
}
