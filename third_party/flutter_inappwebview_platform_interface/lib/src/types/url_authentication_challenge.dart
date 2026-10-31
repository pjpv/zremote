import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'url_protection_space.dart';

part 'url_authentication_challenge.g.dart';

@ExchangeableObject()
class URLAuthenticationChallenge_ {
  URLProtectionSpace_ protectionSpace;

  URLAuthenticationChallenge_({
    required this.protectionSpace,
  });
}
