import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';
import 'platform_web_authenticate_session.dart';

part 'web_authenticate_session_settings.g.dart';

@ExchangeableObject(copyMethod: true)
class WebAuthenticationSessionSettings_ {
  bool? prefersEphemeralWebBrowserSession;

  WebAuthenticationSessionSettings_(
      {this.prefersEphemeralWebBrowserSession = false});

  Map<String, dynamic> toMap() {
    return {
      "prefersEphemeralWebBrowserSession": prefersEphemeralWebBrowserSession
    };
  }
}
