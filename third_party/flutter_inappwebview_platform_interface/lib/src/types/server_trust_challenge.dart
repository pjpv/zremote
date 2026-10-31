import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'url_authentication_challenge.dart';
import 'url_protection_space.dart';

part 'server_trust_challenge.g.dart';

@ExchangeableObject()
class ServerTrustChallenge_ extends URLAuthenticationChallenge_ {
  ServerTrustChallenge_({required URLProtectionSpace_ protectionSpace})
      : super(protectionSpace: protectionSpace);
}
