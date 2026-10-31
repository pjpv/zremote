import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'url_protection_space.dart';
import 'url_credential.dart';
import '../platform_http_auth_credentials_database.dart';

part 'url_protection_space_http_auth_credentials.g.dart';

@ExchangeableObject()
class URLProtectionSpaceHttpAuthCredentials_ {
  URLProtectionSpace_? protectionSpace;

  List<URLCredential_>? credentials;

  URLProtectionSpaceHttpAuthCredentials_(
      {this.protectionSpace, this.credentials});
}
